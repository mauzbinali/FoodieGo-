class BannerModel {
  final String id;
  final String title;
  final String subtitle;
  final String colorHex;
  final String? imageUrl;
  final String? actionRoute;
  final bool isActive;

  const BannerModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.colorHex,
    this.imageUrl,
    this.actionRoute,
    this.isActive = true,
  });

  factory BannerModel.fromMap(Map<String, dynamic> map) {
    return BannerModel(
      id: (map['id'] ?? '').toString(),
      title: (map['title'] ?? '').toString(),
      subtitle: (map['subtitle'] ?? '').toString(),
      colorHex: (map['color'] ?? map['colorHex'] ?? 'FF6B35').toString(),
      imageUrl: map['imageUrl']?.toString(),
      actionRoute: map['actionRoute']?.toString(),
      isActive: map['isActive'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'color': colorHex,
      'imageUrl': imageUrl,
      'actionRoute': actionRoute,
      'isActive': isActive,
    };
  }

  static List<BannerModel> get defaults => const [
    BannerModel(
      id: 'welcome',
      title: '50% Off First Order',
      subtitle: 'Use code WELCOME20',
      colorHex: 'FF6B35',
    ),
    BannerModel(
      id: 'delivery',
      title: 'Free Delivery',
      subtitle: 'On orders above Rs. 2000',
      colorHex: '2EC4B6',
    ),
    BannerModel(
      id: 'pizza',
      title: 'Pizza Night',
      subtitle: "Save 30% at Pizza Hut and Domino's",
      colorHex: 'E71D36',
    ),
  ];
}
