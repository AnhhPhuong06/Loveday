import 'package:flutter/foundation.dart';
import 'package:home_widget/home_widget.dart';

class WidgetService {
  static const String appGroupId = 'group.com.loveday.app';
  static const String iOSWidgetName = 'LoveDayWidget';
  static const String androidWidgetName = 'LoveDayAppWidgetProvider';

  /// Cập nhật dữ liệu đếm ngày ra màn hình chính (đầy đủ)
  static Future<void> updateLoveDayWidget({
    required int totalDays,
    required String coupleNames,
    required int currentStreak,
    String? latestPhotoUrl,
  }) async {
    try {
      await HomeWidget.saveWidgetData<int>('total_days', totalDays);
      await HomeWidget.saveWidgetData<String>('couple_names', coupleNames);
      await HomeWidget.saveWidgetData<int>('current_streak', currentStreak);
      if (latestPhotoUrl != null) {
        await HomeWidget.saveWidgetData<String>('latest_photo_url', latestPhotoUrl);
      }

      await HomeWidget.updateWidget(
        name: iOSWidgetName,
        iOSName: iOSWidgetName,
        androidName: androidWidgetName,
      );
    } catch (e) {
      debugPrint('Update Home Widget Error: $e');
    }
  }

  /// Cập nhật nhanh số ngày và tên cặp đôi ra Widget
  static Future<void> updateLoveDays(int days, String coupleNames) async {
    await updateLoveDayWidget(
      totalDays: days,
      coupleNames: coupleNames,
      currentStreak: 1,
    );
  }
}
