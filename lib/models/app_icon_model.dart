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
      name: 'Classic Rose',
      iconKey: 'icon_default',
      previewAsset: 'assets/icons/icon_rose.png',
      description: 'Hồng lãng mạn nguyên bản',
      requiredStreak: 0,
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
      id: 'retro_pixel',
      name: 'Retro 8-bit 👾',
      iconKey: 'icon_pixel',
      previewAsset: 'assets/icons/icon_pixel.png',
      description: 'Phong cách game retro hoài niệm',
      requiredStreak: 7,
    ),
    AppIconModel(
      id: 'sakura_pastel',
      name: 'Sakura Pastel 🌸',
      iconKey: 'icon_sakura',
      previewAsset: 'assets/icons/icon_sakura.png',
      description: 'Hoa anh đào dịu dàng',
      requiredStreak: 0,
    ),
    AppIconModel(
      id: 'diamond_love',
      name: 'Diamond 100 💎',
      iconKey: 'icon_diamond',
      previewAsset: 'assets/icons/icon_diamond.png',
      description: 'Danh hiệu tối thượng: 100 ngày chuỗi',
      requiredStreak: 100,
    ),
  ];
}
