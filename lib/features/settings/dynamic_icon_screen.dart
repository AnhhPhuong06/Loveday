import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/services/dynamic_icon_service.dart';
import '../../models/app_icon_model.dart';

class DynamicIconScreen extends StatelessWidget {
  final DynamicIconService dynamicIconService;
  final int userStreak;

  const DynamicIconScreen({
    super.key,
    required this.dynamicIconService,
    this.userStreak = 12,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: dynamicIconService,
      builder: (context, _) {
        final currentIconId = dynamicIconService.currentIconId;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Đổi Icon App 🎨', style: TextStyle(fontWeight: FontWeight.bold)),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Info Card (Locket Style)
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient: AppColors.loveGradient,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.35),
                        blurRadius: 16,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Text('✨', style: TextStyle(fontSize: 32)),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Tùy Biến Màn Hình Chính',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Chọn icon bạn thích để hiển thị ngoài màn hình điện thoại như Locket!',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                const Text(
                  'Bộ sưu tập Icon App',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 14),

                // Grid of Icons
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: 0.88,
                  ),
                  itemCount: AppIconModel.defaultIcons.length,
                  itemBuilder: (context, index) {
                    final icon = AppIconModel.defaultIcons[index];
                    final isSelected = icon.id == currentIconId;
                    final isLocked = icon.requiredStreak > userStreak;

                    return GestureDetector(
                      onTap: () async {
                        if (isLocked) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.redAccent,
                              content: Text(
                                '🔒 Cần chuỗi ${icon.requiredStreak} ngày để mở khóa icon này! (Hiện tại: $userStreak ngày)',
                              ),
                            ),
                          );
                          return;
                        }

                        await dynamicIconService.setAppIcon(icon);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: const Color(0xFF00E676),
                              duration: const Duration(seconds: 2),
                              content: Row(
                                children: [
                                  const Icon(Icons.check_circle, color: Colors.white),
                                  const SizedBox(width: 10),
                                  Expanded(child: Text('🎉 Đã chọn icon app: ${icon.name}!')),
                                ],
                              ),
                            ),
                          );
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected ? AppColors.primary : Colors.grey.withOpacity(0.2),
                            width: isSelected ? 3 : 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: isSelected
                                  ? AppColors.primary.withOpacity(0.3)
                                  : Colors.black.withOpacity(0.04),
                              blurRadius: isSelected ? 14 : 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Icon Preview Box
                                  Container(
                                    width: 68,
                                    height: 68,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(18),
                                      boxShadow: [
                                        BoxShadow(
                                          color: isSelected ? AppColors.primary.withOpacity(0.4) : Colors.black12,
                                          blurRadius: 10,
                                          spreadRadius: 2,
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(18),
                                      child: Image.asset(
                                        icon.previewAsset,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) => Container(
                                          decoration: BoxDecoration(gradient: _getIconGradient(icon.id)),
                                          child: Center(
                                            child: Text(_getIconEmoji(icon.id), style: const TextStyle(fontSize: 30)),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    icon.name,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    icon.description,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 11,
                                    ),
                                    maxLines: 2,
                                  ),
                                ],
                              ),
                            ),

                            // Selected Badge
                            if (isSelected)
                              Positioned(
                                top: 8,
                                right: 8,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: AppColors.primary,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.check, color: Colors.white, size: 16),
                                ),
                              ),

                            // Locked Badge
                            if (isLocked)
                              Positioned(
                                top: 8,
                                left: 8,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.7),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.lock, color: AppColors.accent, size: 12),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${icon.requiredStreak} 🔥',
                                        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  LinearGradient _getIconGradient(String id) {
    switch (id) {
      case 'golden_flame':
        return AppColors.flameGradient;
      case 'midnight_dark':
        return const LinearGradient(colors: [Color(0xFF232526), Color(0xFF414345)]);
      case 'retro_pixel':
        return const LinearGradient(colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)]);
      case 'sakura_pastel':
      case 'pastel_bloom':
        return const LinearGradient(colors: [Color(0xFFFFB199), Color(0xFFFF0844)]);
      case 'diamond_love':
        return const LinearGradient(colors: [Color(0xFF00C6FF), Color(0xFF0072FF)]);
      default:
        return AppColors.loveGradient;
    }
  }

  String _getIconEmoji(String id) {
    switch (id) {
      case 'golden_flame':
        return '🔥';
      case 'midnight_dark':
        return '🖤';
      case 'retro_pixel':
      case 'cyberpunk_neon':
        return '⚡';
      case 'sakura_pastel':
      case 'pastel_bloom':
        return '🌸';
      case 'diamond_love':
        return '💎';
      default:
        return '💖';
    }
  }
}
