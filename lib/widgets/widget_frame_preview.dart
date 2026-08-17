import 'package:flutter/material.dart';
import '../models/widget_theme_model.dart';
import 'heart_pulse_widget.dart';

class WidgetFramePreview extends StatelessWidget {
  final WidgetThemeModel theme;
  final int daysTogether;
  final String myName;
  final String partnerName;
  final String? myAvatarPath;
  final String? partnerAvatarPath;

  const WidgetFramePreview({
    super.key,
    required this.theme,
    required this.daysTogether,
    required this.myName,
    required this.partnerName,
    this.myAvatarPath,
    this.partnerAvatarPath,
  });

  @override
  Widget build(BuildContext context) {
    double width;
    double height;

    switch (theme.size) {
      case WidgetSize.small:
        width = 160;
        height = 160;
        break;
      case WidgetSize.medium:
        width = 330;
        height = 165;
        break;
      case WidgetSize.large:
        width = 330;
        height = 330;
        break;
    }

    return Center(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: width,
        height: height,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.backgroundColor,
          borderRadius: BorderRadius.circular(theme.borderRadius),
          border: Border.all(
            color: theme.borderColor,
            width: theme.borderWidth,
          ),
          boxShadow: [
            BoxShadow(
              color: theme.borderColor.withOpacity(0.45),
              blurRadius: theme.glowIntensity,
              spreadRadius: 2,
            ),
          ],
        ),
        child: _buildWidgetContent(context),
      ),
    );
  }

  Widget _buildWidgetContent(BuildContext context) {
    switch (theme.size) {
      case WidgetSize.small:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (theme.showHeartPulse)
              HeartPulseWidget(size: 32, color: theme.borderColor)
            else
              Icon(Icons.favorite, color: theme.borderColor, size: 32),
            const SizedBox(height: 6),
            Text(
              '$daysTogether',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                shadows: [
                  Shadow(color: theme.borderColor.withOpacity(0.8), blurRadius: 10),
                ],
              ),
            ),
            const Text(
              'DAYS OF LOVE',
              style: TextStyle(
                fontSize: 10,
                letterSpacing: 1.5,
                fontWeight: FontWeight.w600,
                color: Colors.white70,
              ),
            ),
          ],
        );

      case WidgetSize.medium:
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left: Avatars & Names
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      _buildMiniAvatar(myAvatarPath, 'assets/images/avatar_boy.png'),
                      const SizedBox(width: 8),
                      HeartPulseWidget(size: 20, color: theme.borderColor),
                      const SizedBox(width: 8),
                      _buildMiniAvatar(partnerAvatarPath, 'assets/images/avatar_girl.png'),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '$myName & $partnerName',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Đang yêu nhau say đắm ❤️',
                    style: TextStyle(fontSize: 11, color: Colors.white60),
                  ),
                ],
              ),
            ),

            // Right: Day Counter
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '$daysTogether',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    shadows: [
                      Shadow(color: theme.borderColor.withOpacity(0.8), blurRadius: 12),
                    ],
                  ),
                ),
                const Text(
                  'NGÀY BÊN NHAU',
                  style: TextStyle(
                    fontSize: 10,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.bold,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ],
        );

      case WidgetSize.large:
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Loveday Widget',
                  style: TextStyle(color: Colors.white60, fontSize: 12, fontWeight: FontWeight.bold),
                ),
                HeartPulseWidget(size: 22, color: theme.borderColor),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLargeAvatar(myAvatarPath, 'assets/images/avatar_boy.png', myName),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text('❤️', style: TextStyle(fontSize: 24, shadows: [
                    Shadow(color: theme.borderColor, blurRadius: 10),
                  ])),
                ),
                _buildLargeAvatar(partnerAvatarPath, 'assets/images/avatar_girl.png', partnerName),
              ],
            ),
            Column(
              children: [
                Text(
                  '$daysTogether',
                  style: TextStyle(
                    fontSize: 54,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    shadows: [
                      Shadow(color: theme.borderColor.withOpacity(0.8), blurRadius: 16),
                    ],
                  ),
                ),
                const Text(
                  'NGÀY YÊU THƯƠNG',
                  style: TextStyle(
                    fontSize: 12,
                    letterSpacing: 2,
                    fontWeight: FontWeight.bold,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
            const Text(
              'Cùng nhau đi hết thanh xuân ✨',
              style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.white60),
            ),
          ],
        );
    }
  }

  Widget _buildMiniAvatar(String? customPath, String defaultAsset) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: theme.borderColor, width: 2),
        boxShadow: [
          BoxShadow(color: theme.borderColor.withOpacity(0.4), blurRadius: 6),
        ],
      ),
      child: ClipOval(
        child: Image.asset(defaultAsset, fit: BoxFit.cover),
      ),
    );
  }

  Widget _buildLargeAvatar(String? customPath, String defaultAsset, String name) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: theme.borderColor, width: 2.5),
            boxShadow: [
              BoxShadow(color: theme.borderColor.withOpacity(0.5), blurRadius: 8),
            ],
          ),
          child: ClipOval(
            child: Image.asset(defaultAsset, fit: BoxFit.cover),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          name,
          style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
