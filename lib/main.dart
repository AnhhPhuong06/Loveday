import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/theme/app_theme.dart';
import 'core/services/auth_service.dart';
import 'features/auth/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Khởi tạo Supabase Client (0đ Serverless)
  // Thay thế URL & Anon Key của bạn từ Supabase Dashboard
  try {
    await Supabase.initialize(
      url: 'https://xyzcompany.supabase.co', // Thay bằng Project URL của bạn
      anonKey: 'public-anon-key',           // Thay bằng Anon Key của bạn
    );
  } catch (e) {
    debugPrint('Supabase init notice (Running in offline demo mode): $e');
  }

  runApp(
    const ProviderScope(
      child: LoveDayApp(),
    ),
  );
}

class LoveDayApp extends StatelessWidget {
  const LoveDayApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    return MaterialApp(
      title: 'LoveDay - Tình Yêu & Kỷ Niệm',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      home: LoginScreen(authService: authService),
    );
  }
}
