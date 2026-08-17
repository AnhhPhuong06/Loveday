class AppIconModel {
  final String id;
  final String name;
  final String iconKey; // Key dùng cho iOS CFBundleAlternateIcons và Android activity-alias
  final String previewAsset;
  final String description;
  final int requiredStreak; // Số ngày streak cần để mở khóa (0 = miễn phí)
  final bool isPremium;

  const AppIconModel({
    required this.id,
    required this.name,
    required this.iconKey,
    required this.previewAsset,
    required this.description,
    this.requiredStreak = 0,
    this.isPremium = false,
  });

  /// Danh sách các bộ Icon có thể đổi (Locket Style)
  static const List<AppIconModel> defaultIcons = [
    AppIconModel(
      id: 'default',
      name: 'Classic Rose 🌹',
      iconKey: 'icon_default',
      previewAsset: 'assets/icons/icon_rose.png',
      description: 'Hồng lãng mạn nguyên bản',
      requiredStreak: 0,
    ),
    AppIconModel(
      id: 'pastel_bloom',
      name: 'Pastel Blossom 🌸',
      iconKey: 'icon_pastel',
      previewAsset: 'assets/icons/icon_pastel.png',
      description: 'Cánh hoa anh đào dịu dàng và ngọc trai',
      requiredStreak: 0,
    ),
    AppIconModel(
      id: 'cyberpunk_neon',
      name: 'Cyberpunk Neon ⚡',
      iconKey: 'icon_cyberpunk',
      previewAsset: 'assets/icons/icon_cyberpunk.png',
      description: 'Trái tim pha lê phát sáng tương lai',
      requiredStreak: 7,
    ),
    AppIconModel(
      id: 'golden_flame',
      name: 'Golden Flame 🔥',
      iconKey: 'icon_golden',
      previewAsset: 'assets/icons/icon_golden.png',
      description: 'Mở khóa khi đạt chuỗi 30 ngày',
      requiredStreak: 30,
    ),
    AppIconModel(
      id: 'midnight_dark',
      name: 'Midnight Dark 🖤',
      iconKey: 'icon_dark',
      previewAsset: 'assets/icons/icon_dark.png',
      description: 'Huyền bí, sang trọng và cá tính',
      requiredStreak: 0,
    ),
    AppIconModel(
      id: 'diamond_love',
      name: 'Diamond Crown 💎',
      iconKey: 'icon_diamond',
      previewAsset: 'assets/icons/icon_diamond.png',
      description: 'Danh hiệu tối thượng: 100 ngày chuỗi',
      requiredStreak: 100,
    ),
  ];
}
