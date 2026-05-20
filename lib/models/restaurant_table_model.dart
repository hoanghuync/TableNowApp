class RestaurantTableModel {
  const RestaurantTableModel({required this.id, required this.restaurantId, required this.tableName, required this.capacity, required this.status});

  final String id;
  final String restaurantId;
  final String tableName;
  final int capacity;
  final String status;

  factory RestaurantTableModel.fromMap(Map<String, dynamic> map, String id) => RestaurantTableModel(
    id: map['id'] as String? ?? id,
    restaurantId: map['restaurantId'] as String? ?? '',
    tableName: map['tableName'] as String? ?? '',
    capacity: (map['capacity'] as num?)?.toInt() ?? 0,
    status: map['status'] as String? ?? 'available',
  );

  Map<String, dynamic> toMap() => {'id': id, 'restaurantId': restaurantId, 'tableName': tableName, 'capacity': capacity, 'status': status};
}


