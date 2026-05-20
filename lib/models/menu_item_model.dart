class MenuItemModel {
  const MenuItemModel({required this.id, required this.restaurantId, required this.name, required this.category, required this.price, required this.description, required this.imageUrl, required this.isAvailable});

  final String id;
  final String restaurantId;
  final String name;
  final String category;
  final double price;
  final String description;
  final String imageUrl;
  final bool isAvailable;

  factory MenuItemModel.fromMap(Map<String, dynamic> map, String id) => MenuItemModel(
    id: map['id'] as String? ?? id,
    restaurantId: map['restaurantId'] as String? ?? '',
    name: map['name'] as String? ?? '',
    category: map['category'] as String? ?? 'Khac',
    price: (map['price'] as num?)?.toDouble() ?? 0,
    description: map['description'] as String? ?? '',
    imageUrl: map['imageUrl'] as String? ?? '',
    isAvailable: map['isAvailable'] as bool? ?? true,
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'restaurantId': restaurantId,
    'name': name,
    'category': category,
    'price': price,
    'description': description,
    'imageUrl': imageUrl,
    'isAvailable': isAvailable,
  };
}


