class BookingItemModel {
  const BookingItemModel({required this.menuItemId, required this.name, required this.price, required this.quantity});

  final String menuItemId;
  final String name;
  final double price;
  final int quantity;

  double get lineTotal => price * quantity;

  factory BookingItemModel.fromMap(Map<String, dynamic> map) => BookingItemModel(
    menuItemId: map['menuItemId'] as String? ?? '',
    name: map['name'] as String? ?? '',
    price: (map['price'] as num?)?.toDouble() ?? 0,
    quantity: (map['quantity'] as num?)?.toInt() ?? 0,
  );

  Map<String, dynamic> toMap() => {'menuItemId': menuItemId, 'name': name, 'price': price, 'quantity': quantity};
}
