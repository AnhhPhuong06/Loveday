import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../core/services/auth_service.dart';
import '../../core/services/couple_service.dart';
import '../home_shell_screen.dart';

class CouplePairingScreen extends StatefulWidget {
  final AuthService authService;

  const CouplePairingScreen({super.key, required this.authService});

  @override
  State<CouplePairingScreen> createState() => _CouplePairingScreenState();
}

class _CouplePairingScreenState extends State<CouplePairingScreen> {
  final CoupleService _coupleService = CoupleService();
  final TextEditingController _codeController = TextEditingController();
  DateTime _selectedAnniversary = DateTime.now().subtract(const Duration(days: 100));
  String? _generatedCode;
  bool _isCreating = true;

  @override
  Widget build(BuildContext context) {
    final user = widget.authService.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ghép Đôi Tình Yêu 💍'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Avatar & Name Preview
            CircleAvatar(
              radius: 45,
              backgroundImage: NetworkImage(
                user?.avatarUrl ?? 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400',
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Xin chào, ${user?.displayName ?? "Bạn"}!',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              'Hãy kết nối với nửa kia để bắt đầu đếm ngày và giữ chuỗi nhé!',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 32),

            // Tab switch: Tạo mã vs Nhập mã
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(4),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _isCreating = true),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: _isCreating ? AppColors.primary : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '1. Tạo mã mời',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: _isCreating ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _isCreating = false),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: !_isCreating ? AppColors.primary : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '2. Nhập mã của người ấy',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: !_isCreating ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            if (_isCreating) ...[
              // Chọn ngày yêu nhau
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.pink.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Ngày bắt đầu yêu nhau ❤️',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          DateFormat('dd/MM/yyyy').format(_selectedAnniversary),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: _pickAnniversaryDate,
                      child: const Text('Chọn ngày'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              if (_generatedCode != null) ...[
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'MÃ GHÉP ĐÔI CỦA BẠN',
                        style: TextStyle(color: Colors.grey, fontSize: 12, letterSpacing: 1.5),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _generatedCode!,
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w900,
                          color: AppColors.accent,
                          letterSpacing: 4,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Gửi mã này cho người yêu để hoàn tất kết nối',
                        style: TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    icon: const Icon(Icons.favorite),
                    label: const Text('Vào Không Gian Tình Yêu', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    onPressed: _goToHome,
                  ),
                ),
              ] else ...[
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    onPressed: _handleCreateCode,
                    child: const Text('Tạo Mã Ghép Đôi', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ),
              ],
            ] else ...[
              // Nhập mã từ đối phương
              TextField(
                controller: _codeController,
                textCapitalization: TextCapitalization.characters,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 4),
                decoration: InputDecoration(
                  hintText: 'Nhập mã ví dụ LOVE99',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: _handleJoinCode,
                  child: const Text('Kết Nối Ngay', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _pickAnniversaryDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedAnniversary,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _selectedAnniversary = picked);
    }
  }

  Future<void> _handleCreateCode() async {
    final code = await _coupleService.createCoupleRoom(
      widget.authService.currentUser?.id ?? 'user_1',
      _selectedAnniversary,
    );
    setState(() => _generatedCode = code);
  }

  Future<void> _handleJoinCode() async {
    if (_codeController.text.isEmpty) return;
    final success = await _coupleService.joinCoupleWithCode(
      widget.authService.currentUser?.id ?? 'user_2',
      _codeController.text,
    );
    if (success && mounted) {
      _goToHome();
    }
  }

  void _goToHome() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => HomeShellScreen(
          authService: widget.authService,
          coupleService: _coupleService,
        ),
      ),
    );
  }
}
