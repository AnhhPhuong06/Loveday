import 'package:flutter/material.dart';

enum WidgetSize { small, medium, large }

class WidgetThemeModel {
  final String id;
  final String name;
  final Color borderColor;
  final double borderWidth;
  final double borderRadius;
  final double glowIntensity;
  final Color backgroundColor;
  final bool showHeartPulse;
  final bool showAvatars;
  final WidgetSize size;

  const WidgetThemeModel({
    required this.id,
    required this.name,
    required this.borderColor,
    this.borderWidth = 2.5,
    this.borderRadius = 22.0,
    this.glowIntensity = 10.0,
    this.backgroundColor = const Color(0xCC1A1A2E),
    this.showHeartPulse = true,
    this.showAvatars = true,
    this.size = WidgetSize.medium,
  });

  WidgetThemeModel copyWith({
    String? id,
    String? name,
    Color? borderColor,
    double? borderWidth,
    double? borderRadius,
    double? glowIntensity,
    Color? backgroundColor,
    bool? showHeartPulse,
    bool? showAvatars,
    WidgetSize? size,
  }) {
    return WidgetThemeModel(
      id: id ?? this.id,
      name: name ?? this.name,
      borderColor: borderColor ?? this.borderColor,
      borderWidth: borderWidth ?? this.borderWidth,
      borderRadius: borderRadius ?? this.borderRadius,
      glowIntensity: glowIntensity ?? this.glowIntensity,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      showHeartPulse: showHeartPulse ?? this.showHeartPulse,
      showAvatars: showAvatars ?? this.showAvatars,
      size: size ?? this.size,
    );
  }

  static const List<Color> presetBorderColors = [
    Color(0xFFFF4B72), // Romantic Rose
    Color(0xFFFFB800), // Royal Gold
    Color(0xFF00E5FF), // Cyber Cyan
    Color(0xFFB388FF), // Lavender Glow
    Color(0xFF00E676), // Mint Emerald
    Color(0xFFFF5252), // Sunset Ruby
    Color(0xFFFFFFFF), // Pure Pearl
  ];
}
