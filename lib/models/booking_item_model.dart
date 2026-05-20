class BookingItemModel {
  const BookingItemModel({required this.menuItemId, required this.restaurantId, required this.name, required this.price, required this.quantity});

  final String menuItemId;
  final String restaurantId;
  final String name;
  final double price;
  final int quantity;

  double get lineTotal => price * quantity;

  factory BookingItemModel.fromMap(Map<String, dynamic> map) => BookingItemModel(
    menuItemId: map['menuItemId'] as String? ?? '',
    restaurantId: map['restaurantId'] as String? ?? '',
    name: map['name'] as String? ?? '',
    price: (map['price'] as num?)?.toDouble() ?? 0,
    quantity: (map['quantity'] as num?)?.toInt() ?? 0,
  );

  Map<String, dynamic> toMap() => {'menuItemId': menuItemId, 'restaurantId': restaurantId, 'name': name, 'price': price, 'quantity': quantity};
}


