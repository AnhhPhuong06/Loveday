import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dynamic_icon_plus/flutter_dynamic_icon_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
      final prefs = await SharedPreferences.getInstance();
      final savedIcon = prefs.getString('saved_app_icon_id');
      if (savedIcon != null) {
        _currentIconId = savedIcon;
      }

      _supportsAlternateIcons = await FlutterDynamicIconPlus.supportsAlternateIcons;
      final currentName = await FlutterDynamicIconPlus.alternateIconName;
      if (currentName != null && currentName.isNotEmpty) {
        _currentIconId = currentName;
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Check Dynamic Icon Support: $e');
      _supportsAlternateIcons = true;
    }
  }

  /// Thay đổi icon ứng dụng (giống Locket)
  Future<bool> setAppIcon(AppIconModel icon) async {
    _currentIconId = icon.id;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('saved_app_icon_id', icon.id);

      if (icon.id == 'default') {
        await FlutterDynamicIconPlus.setAlternateIconName(iconName: null);
      } else {
        await FlutterDynamicIconPlus.setAlternateIconName(iconName: icon.iconKey);
      }
      return true;
    } on PlatformException catch (e) {
      debugPrint('Dynamic icon platform notice: ${e.message}');
      return true;
    } catch (e) {
      debugPrint('Error changing icon: $e');
      return true;
    }
  }
}
