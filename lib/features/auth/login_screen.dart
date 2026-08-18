import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/services/auth_service.dart';
import '../../core/services/couple_service.dart';
import '../home_shell_screen.dart';

class LoginScreen extends StatefulWidget {
  final AuthService authService;

  const LoginScreen({super.key, required this.authService});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final CoupleService _coupleService = CoupleService();
  bool _isLoading = false;

  Future<void> _handleLogin(Future<bool> Function() loginMethod) async {
    setState(() => _isLoading = true);
    final success = await loginMethod();
    setState(() => _isLoading = false);

    if (success && mounted) {
      // Tự động khởi tạo và vào thẳng không gian tình yêu
      final userId = widget.authService.currentUser?.id ?? 'user_demo';
      await _coupleService.loadCoupleData(userId);

      if (mounted) {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Romantic Dark Gradient Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1A0B14), Color(0xFF0C0C12)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // Glowing romantic background blur
          Positioned(
            top: -60,
            left: -60,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withOpacity(0.3),
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),

                  // App Logo & Heart Icon
                  Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      gradient: AppColors.loveGradient,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.5),
                          blurRadius: 25,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.favorite_rounded,
                      color: Colors.white,
                      size: 52,
                    ),
                  ),
                  const SizedBox(height: 20),

                  const Text(
                    'LoveDay 💕',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Không gian riêng tư & gắn kết tình yêu trọn vẹn',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white.withOpacity(0.75),
                    ),
                  ),

                  const Spacer(),

                  if (_isLoading)
                    const CircularProgressIndicator(color: AppColors.primary)
                  else
                    Column(
                      children: [
                        // Apple Login Button (iCloud)
                        _SocialButton(
                          icon: Icons.apple,
                          label: 'Đăng nhập với Apple (iCloud)',
                          backgroundColor: Colors.white,
                          textColor: Colors.black,
                          onPressed: () => _handleLogin(widget.authService.signInWithApple),
                        ),
                        const SizedBox(height: 12),

                        // Google Login Button
                        _SocialButton(
                          icon: Icons.g_mobiledata_rounded,
                          label: 'Tiếp tục với Google',
                          backgroundColor: const Color(0xFF2E2E38),
                          textColor: Colors.white,
                          onPressed: () => _handleLogin(widget.authService.signInWithGoogle),
                        ),
                        const SizedBox(height: 12),

                        // Facebook Login Button
                        _SocialButton(
                          icon: Icons.facebook,
                          label: 'Đăng nhập với Facebook',
                          backgroundColor: const Color(0xFF1877F2),
                          textColor: Colors.white,
                          onPressed: () => _handleLogin(widget.authService.signInWithFacebook),
                        ),
                        const SizedBox(height: 12),

                        // Quick Guest Trial Button
                        OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.pinkAccent,
                            side: const BorderSide(color: Colors.pinkAccent, width: 1.5),
                            minimumSize: const Size(double.infinity, 52),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          icon: const Icon(Icons.favorite, size: 20),
                          label: const Text(
                            'Trải Nghiệm Dùng Thử Ngay 💕',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          onPressed: () => _handleLogin(widget.authService.signInAsGuest),
                        ),
                      ],
                    ),

                  const SizedBox(height: 20),
                  Text(
                    'Bằng việc đăng nhập, bạn đồng ý với Điều khoản & Bảo mật của LoveDay',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.white.withOpacity(0.4),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback onPressed;

  const _SocialButton({
    required this.icon,
    required this.label,
    required this.backgroundColor,
    required this.textColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 2,
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 26, color: textColor),
            const SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
