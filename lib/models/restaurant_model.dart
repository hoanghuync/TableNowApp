class RestaurantModel {
  const RestaurantModel({required this.id, required this.name, required this.address, required this.phone, required this.openTime, required this.closeTime, required this.description, required this.imageUrl, required this.latitude, required this.longitude});

  final String id;
  final String name;
  final String address;
  final String phone;
  final String openTime;
  final String closeTime;
  final String description;
  final String imageUrl;
  final double latitude;
  final double longitude;

  factory RestaurantModel.fromMap(Map<String, dynamic> map, String id) => RestaurantModel(
    id: map['id'] as String? ?? id,
    name: map['name'] as String? ?? '',
    address: map['address'] as String? ?? '',
    phone: map['phone'] as String? ?? '',
    openTime: map['openTime'] as String? ?? '08:00',
    closeTime: map['closeTime'] as String? ?? '22:00',
    description: map['description'] as String? ?? '',
    imageUrl: map['imageUrl'] as String? ?? '',
    latitude: (map['latitude'] as num?)?.toDouble() ?? 0,
    longitude: (map['longitude'] as num?)?.toDouble() ?? 0,
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'address': address,
    'phone': phone,
    'openTime': openTime,
    'closeTime': closeTime,
    'description': description,
    'imageUrl': imageUrl,
    'latitude': latitude,
    'longitude': longitude,
  };
}


