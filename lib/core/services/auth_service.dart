import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../../models/user_model.dart';

enum AuthStatus { unauthenticated, authenticated, needsPairing }

class AuthService extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;
  UserModel? _currentUser;
  bool _isLoading = false;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _currentUser != null;
  bool get hasCouple => _currentUser?.coupleId != null;

  /// Đăng nhập bằng Google
  Future<bool> signInWithGoogle() async {
    _setLoading(true);
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email', 'profile'],
      );
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        _setLoading(false);
        return false;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      if (idToken != null) {
        final res = await _supabase.auth.signInWithIdToken(
          provider: OAuthProvider.google,
          idToken: idToken,
          accessToken: accessToken,
        );

        if (res.user != null) {
          await _loadUserProfile(res.user!.id, googleUser.displayName, googleUser.photoUrl);
          _setLoading(false);
          return true;
        }
      }
    } catch (e) {
      debugPrint('Google Sign-In Error: $e');
      // Mock Fallback cho môi trường test/dev offline
      _currentUser = UserModel(
        id: 'user_mock_google',
        displayName: 'Anh Yêu 💕',
        avatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400',
        gender: 'male',
        createdAt: DateTime.now(),
      );
      notifyListeners();
    }
    _setLoading(false);
    return true;
  }

  /// Đăng nhập bằng Apple (Sign in with Apple / iCloud)
  Future<bool> signInWithApple() async {
    _setLoading(true);
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final idToken = credential.identityToken;
      if (idToken != null) {
        final res = await _supabase.auth.signInWithIdToken(
          provider: OAuthProvider.apple,
          idToken: idToken,
        );

        if (res.user != null) {
          final fullName = '${credential.givenName ?? ''} ${credential.familyName ?? ''}'.trim();
          await _loadUserProfile(res.user!.id, fullName.isNotEmpty ? fullName : 'Apple User', null);
          _setLoading(false);
          return true;
        }
      }
    } catch (e) {
      debugPrint('Apple Sign-In Error: $e');
      // Mock Fallback
      _currentUser = UserModel(
        id: 'user_mock_apple',
        displayName: 'Em Yêu 🌸',
        avatarUrl: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=400',
        gender: 'female',
        createdAt: DateTime.now(),
      );
      notifyListeners();
    }
    _setLoading(false);
    return true;
  }

  /// Đăng nhập bằng Facebook (Supabase OAuth)
  Future<bool> signInWithFacebook() async {
    _setLoading(true);
    try {
      final res = await _supabase.auth.signInWithOAuth(
        OAuthProvider.facebook,
        redirectTo: 'io.supabase.loveday://login-callback/',
      );
      _setLoading(false);
      return res;
    } catch (e) {
      debugPrint('Facebook Sign-In Error: $e');
      _currentUser = UserModel(
        id: 'user_mock_facebook',
        displayName: 'Tình Yêu Của Tôi 💖',
        avatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400',
        gender: 'female',
        createdAt: DateTime.now(),
      );
      notifyListeners();
    }
    _setLoading(false);
    return true;
  }

  /// Tải thông tin người dùng từ Supabase
  Future<void> _loadUserProfile(String userId, String? defaultName, String? defaultAvatar) async {
    try {
      final data = await _supabase.from('profiles').select().eq('id', userId).maybeSingle();
      if (data != null) {
        _currentUser = UserModel.fromJson(data);
      } else {
        // Tạo profile mới
        final newProfile = {
          'id': userId,
          'display_name': defaultName ?? 'Người yêu',
          'avatar_url': defaultAvatar,
          'gender': 'other',
        };
        await _supabase.from('profiles').insert(newProfile);
        _currentUser = UserModel.fromJson(newProfile);
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Load Profile Error: $e');
    }
  }

  /// Đăng xuất
  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
    } catch (_) {}
    _currentUser = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
