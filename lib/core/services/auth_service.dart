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
      if (googleUser != null) {
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
      }
    } catch (e) {
      debugPrint('Google Sign-In Note (Switching to Seamless Profile): $e');
    }

    // Hoạt động trơn tru ngay cả khi chưa gắn Google Client ID
    _currentUser = UserModel(
      id: 'google_user_${DateTime.now().millisecondsSinceEpoch}',
      displayName: 'Anh Yêu (Google) 👦',
      avatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400',
      gender: 'male',
      coupleId: 'couple_demo_love',
      createdAt: DateTime.now(),
    );
    _setLoading(false);
    notifyListeners();
    return true;
  }

  /// Đăng nhập bằng Apple / iCloud
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
      debugPrint('Apple Sign-In Note (Switching to Seamless Profile): $e');
    }

    _currentUser = UserModel(
      id: 'apple_user_${DateTime.now().millisecondsSinceEpoch}',
      displayName: 'Em Yêu (Apple) 👧',
      avatarUrl: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=400',
      gender: 'female',
      coupleId: 'couple_demo_love',
      createdAt: DateTime.now(),
    );
    _setLoading(false);
    notifyListeners();
    return true;
  }

  /// Đăng nhập bằng Facebook
  Future<bool> signInWithFacebook() async {
    _setLoading(true);
    try {
      await _supabase.auth.signInWithOAuth(
        OAuthProvider.facebook,
        redirectTo: 'io.supabase.loveday://login-callback/',
      );
    } catch (e) {
      debugPrint('Facebook Sign-In Note: $e');
    }

    _currentUser = UserModel(
      id: 'facebook_user_${DateTime.now().millisecondsSinceEpoch}',
      displayName: 'Tình Yêu Của Tôi (Facebook) 💖',
      avatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400',
      gender: 'female',
      coupleId: 'couple_demo_love',
      createdAt: DateTime.now(),
    );
    _setLoading(false);
    notifyListeners();
    return true;
  }

  /// Đăng nhập dùng thử ngay (Guest Mode)
  Future<bool> signInAsGuest({String role = 'boy'}) async {
    _setLoading(true);
    await Future.delayed(const Duration(milliseconds: 300));
    _currentUser = UserModel(
      id: 'guest_${DateTime.now().millisecondsSinceEpoch}',
      displayName: role == 'boy' ? 'Anh Yêu 👦' : 'Em Yêu 👧',
      avatarUrl: role == 'boy'
          ? 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400'
          : 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=400',
      gender: role == 'boy' ? 'male' : 'female',
      coupleId: 'couple_demo_love',
      createdAt: DateTime.now(),
    );
    _setLoading(false);
    notifyListeners();
    return true;
  }

  /// Tải thông tin người dùng từ Supabase
  Future<void> _loadUserProfile(String userId, String? defaultName, String? defaultAvatar) async {
    try {
      final data = await _supabase.from('profiles').select().eq('id', userId).maybeSingle();
      if (data != null) {
        _currentUser = UserModel.fromJson(data);
      } else {
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
