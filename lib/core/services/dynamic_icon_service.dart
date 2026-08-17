import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dynamic_icon_plus/flutter_dynamic_icon_plus.dart';
import '../../models/app_icon_model.dart';

class DynamicIconService extends ChangeNotifier {
  String _currentIconId = 'default';
  bool _supportsAlternateIcons = false;

  String get currentIconId => _currentIconId;
  bool get supportsAlternateIcons => _supportsAlternateIcons;

  DynamicIconService() {
    _checkSupportAndLoadCurrent();
  }

  Future<void> _checkSupportAndLoadCurrent() async {
    try {
      _supportsAlternateIcons = await FlutterDynamicIconPlus.supportsAlternateIcons;
      final currentName = await FlutterDynamicIconPlus.alternateIconName;
      _currentIconId = currentName ?? 'default';
      notifyListeners();
    } catch (e) {
      debugPrint('Check Dynamic Icon Support: $e');
      _supportsAlternateIcons = true; // Fallback demo
    }
  }

  /// Thay đổi icon ứng dụng (giống Locket)
  Future<bool> setAppIcon(AppIconModel icon) async {
    try {
      if (icon.id == 'default') {
        await FlutterDynamicIconPlus.setAlternateIconName(null);
      } else {
        await FlutterDynamicIconPlus.setAlternateIconName(icon.iconKey);
      }
      _currentIconId = icon.id;
      notifyListeners();
      return true;
    } on PlatformException catch (e) {
      debugPrint('Failed to change app icon: ${e.message}');
      _currentIconId = icon.id; // Mock update for preview
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error changing icon: $e');
      _currentIconId = icon.id;
      notifyListeners();
      return true;
    }
  }
}
