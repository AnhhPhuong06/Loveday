import 'package:flutter/material.dart';
import '../../models/widget_theme_model.dart';
import '../../widgets/widget_frame_preview.dart';
import '../../core/services/widget_service.dart';

class WidgetCustomizerScreen extends StatefulWidget {
  final int daysTogether;
  final String myName;
  final String partnerName;

  const WidgetCustomizerScreen({
    super.key,
    required this.daysTogether,
    required this.myName,
    required this.partnerName,
  });

  @override
  State<WidgetCustomizerScreen> createState() => _WidgetCustomizerScreenState();
}

class _WidgetCustomizerScreenState extends State<WidgetCustomizerScreen> {
  WidgetThemeModel _theme = const WidgetThemeModel(
    id: 'default',
    name: 'Romantic Pink',
    borderColor: Color(0xFFFF4B72),
    borderWidth: 2.5,
    borderRadius: 24.0,
    glowIntensity: 12.0,
  );

  bool _isSaving = false;

  void _syncWidget() async {
    setState(() => _isSaving = true);
    await WidgetService.updateLoveDays(widget.daysTogether, '${widget.myName} & ${widget.partnerName}');
    setState(() => _isSaving = false);

    if (mounted) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: const Color(0xFF1E1E2E),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: const Row(
            children: [
              Text('✨ ', style: TextStyle(fontSize: 24)),
              Text('Đã Lưu Widget!', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Khung viền và màu sắc của bạn đã được cập nhật thành công!',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.touch_app, color: Colors.pinkAccent, size: 20),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Ra màn hình chính iPhone / Android, nhấn giữ và chọn thêm tiện ích Loveday để thưởng thức!',
                        style: TextStyle(color: Colors.white60, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _theme.borderColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Tuyệt vời', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1A),
      appBar: AppBar(
        title: const Text('Widget Studio & Khung Viền', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Interactive Live Preview Container
            Container(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.04),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white12),
              ),
              child: Column(
                children: [
                  const Text(
                    'XEM TRƯỚC MÀN HÌNH CHÍNH (LIVE PREVIEW)',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),
                  WidgetFramePreview(
                    theme: _theme,
                    daysTogether: widget.daysTogether,
                    myName: widget.myName,
                    partnerName: widget.partnerName,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Size Selector
            const Text(
              'Kích thước tiện ích (Widget Size)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildSizeTab('Nhỏ (2x2)', WidgetSize.small),
                const SizedBox(width: 10),
                _buildSizeTab('Vừa (4x2)', WidgetSize.medium),
                const SizedBox(width: 10),
                _buildSizeTab('Lớn (4x4)', WidgetSize.large),
              ],
            ),
            const SizedBox(height: 24),

            // Border Color Palette
            const Text(
              'Màu khung viền phát sáng (Border Color)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 14),
            SizedBox(
              height: 52,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: WidgetThemeModel.presetBorderColors.length,
                separatorBuilder: (context, index) => const SizedBox(width: 14),
                itemBuilder: (context, index) {
                  final color = WidgetThemeModel.presetBorderColors[index];
                  final isSelected = color.value == _theme.borderColor.value;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _theme = _theme.copyWith(borderColor: color);
                      });
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: color,
                        border: isSelected ? Border.all(color: Colors.white, width: 3.5) : null,
                        boxShadow: [
                          BoxShadow(
                            color: color.withOpacity(isSelected ? 0.8 : 0.3),
                            blurRadius: isSelected ? 14 : 6,
                            spreadRadius: isSelected ? 2 : 0,
                          ),
                        ],
                      ),
                      child: isSelected ? const Icon(Icons.check, color: Colors.white, size: 24) : null,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),

            // Sliders: Border Width, Corner Radius, Glow
            _buildSlider(
              title: 'Độ dày khung viền',
              value: _theme.borderWidth,
              min: 1.0,
              max: 6.0,
              unit: 'px',
              onChanged: (val) => setState(() => _theme = _theme.copyWith(borderWidth: val)),
            ),
            _buildSlider(
              title: 'Độ bo góc khung (Radius)',
              value: _theme.borderRadius,
              min: 12.0,
              max: 36.0,
              unit: 'px',
              onChanged: (val) => setState(() => _theme = _theme.copyWith(borderRadius: val)),
            ),
            _buildSlider(
              title: 'Cường độ phát sáng (Glow)',
              value: _theme.glowIntensity,
              min: 0.0,
              max: 25.0,
              unit: '',
              onChanged: (val) => setState(() => _theme = _theme.copyWith(glowIntensity: val)),
            ),
            const SizedBox(height: 24),

            // Save and Sync Button
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _theme.borderColor,
                  elevation: 8,
                  shadowColor: _theme.borderColor.withOpacity(0.5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                ),
                icon: _isSaving
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Icon(Icons.sync, color: Colors.white),
                label: Text(
                  _isSaving ? 'Đang cập nhật...' : 'Áp Dụng Ra Màn Hình Chính',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                onPressed: _isSaving ? null : _syncWidget,
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildSizeTab(String title, WidgetSize size) {
    final isSelected = _theme.size == size;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _theme = _theme.copyWith(size: size)),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? _theme.borderColor : Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected ? Colors.white70 : Colors.transparent,
              width: 1.5,
            ),
            boxShadow: isSelected
                ? [BoxShadow(color: _theme.borderColor.withOpacity(0.4), blurRadius: 10)]
                : null,
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white70,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 13,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSlider({
    required String title,
    required double value,
    required double min,
    required double max,
    required String unit,
    required Function(double) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontSize: 14, color: Colors.white70, fontWeight: FontWeight.w500)),
            Text('${value.toStringAsFixed(1)}$unit', style: TextStyle(fontSize: 14, color: _theme.borderColor, fontWeight: FontWeight.bold)),
          ],
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: _theme.borderColor,
            inactiveTrackColor: Colors.white12,
            thumbColor: Colors.white,
            overlayColor: _theme.borderColor.withOpacity(0.2),
            trackHeight: 4,
          ),
          child: Slider(
            value: value,
            min: min,
            max: max,
            onChanged: onChanged,
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
