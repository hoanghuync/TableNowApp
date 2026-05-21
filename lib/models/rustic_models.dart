import 'package:cloud_firestore/cloud_firestore.dart';

DateTime _readDate(dynamic value) => value is Timestamp ? value.toDate() : value is DateTime ? value : DateTime.now();
Timestamp _writeDate(DateTime value) => Timestamp.fromDate(value);

class RusticUser {
  const RusticUser({required this.uid, required this.fullName, required this.email, required this.phone, this.avatarUrl = '', this.role = 'customer', this.membershipLevel = 'Thanh vien Bac', this.points = 0, required this.createdAt, required this.updatedAt});

  final String uid;
  final String fullName;
  final String email;
  final String phone;
  final String avatarUrl;
  final String role;
  final String membershipLevel;
  final int points;
  final DateTime createdAt;
  final DateTime updatedAt;

  bool get isAdmin => role == 'admin' || role == 'staff';

  factory RusticUser.fromMap(String uid, Map<String, dynamic> map) => RusticUser(uid: uid, fullName: map['fullName'] as String? ?? '', email: map['email'] as String? ?? '', phone: map['phone'] as String? ?? '', avatarUrl: map['avatarUrl'] as String? ?? '', role: map['role'] as String? ?? 'customer', membershipLevel: map['membershipLevel'] as String? ?? 'Thanh vien Bac', points: (map['points'] as num?)?.toInt() ?? 0, createdAt: _readDate(map['createdAt']), updatedAt: _readDate(map['updatedAt']));
  Map<String, dynamic> toMap() => {'fullName': fullName, 'email': email, 'phone': phone, 'avatarUrl': avatarUrl, 'role': role, 'membershipLevel': membershipLevel, 'points': points, 'createdAt': _writeDate(createdAt), 'updatedAt': _writeDate(updatedAt)};
  RusticUser copyWith({String? fullName, String? email, String? phone, String? avatarUrl, String? role, String? membershipLevel, int? points, DateTime? updatedAt}) => RusticUser(uid: uid, fullName: fullName ?? this.fullName, email: email ?? this.email, phone: phone ?? this.phone, avatarUrl: avatarUrl ?? this.avatarUrl, role: role ?? this.role, membershipLevel: membershipLevel ?? this.membershipLevel, points: points ?? this.points, createdAt: createdAt, updatedAt: updatedAt ?? this.updatedAt);
}

class CategoryModel {
  const CategoryModel({required this.id, required this.name, required this.slug, this.imageUrl = '', this.sortOrder = 0, this.isActive = true});
  final String id;
  final String name;
  final String slug;
  final String imageUrl;
  final int sortOrder;
  final bool isActive;
  factory CategoryModel.fromMap(String id, Map<String, dynamic> map) => CategoryModel(id: id, name: map['name'] as String? ?? '', slug: map['slug'] as String? ?? '', imageUrl: map['imageUrl'] as String? ?? '', sortOrder: (map['sortOrder'] as num?)?.toInt() ?? 0, isActive: map['isActive'] as bool? ?? true);
  Map<String, dynamic> toMap() => {'name': name, 'slug': slug, 'imageUrl': imageUrl, 'sortOrder': sortOrder, 'isActive': isActive};
  CategoryModel copyWith({String? name, String? slug, String? imageUrl, int? sortOrder, bool? isActive}) => CategoryModel(id: id, name: name ?? this.name, slug: slug ?? this.slug, imageUrl: imageUrl ?? this.imageUrl, sortOrder: sortOrder ?? this.sortOrder, isActive: isActive ?? this.isActive);
}

class MenuItemModel2 {
  const MenuItemModel2({required this.id, required this.name, required this.description, required this.price, required this.categoryId, required this.imageUrl, this.rating = 4.8, this.totalReviews = 0, this.isAvailable = true, this.isActive = true, this.isRecommended = false, this.isSignature = false, this.tags = const [], required this.createdAt, required this.updatedAt});
  final String id;
  final String name;
  final String description;
  final double price;
  final String categoryId;
  final String imageUrl;
  final double rating;
  final int totalReviews;
  final bool isAvailable;
  final bool isActive;
  final bool isRecommended;
  final bool isSignature;
  final List<String> tags;
  final DateTime createdAt;
  final DateTime updatedAt;
  factory MenuItemModel2.fromMap(String id, Map<String, dynamic> map) => MenuItemModel2(id: id, name: map['name'] as String? ?? '', description: map['description'] as String? ?? '', price: (map['price'] as num?)?.toDouble() ?? 0, categoryId: map['categoryId'] as String? ?? '', imageUrl: map['imageUrl'] as String? ?? '', rating: (map['rating'] as num?)?.toDouble() ?? 4.8, totalReviews: (map['totalReviews'] as num?)?.toInt() ?? 0, isAvailable: map['isAvailable'] as bool? ?? true, isActive: map['isActive'] as bool? ?? true, isRecommended: map['isRecommended'] as bool? ?? false, isSignature: map['isSignature'] as bool? ?? false, tags: List<String>.from(map['tags'] as List? ?? const []), createdAt: _readDate(map['createdAt']), updatedAt: _readDate(map['updatedAt']));
  Map<String, dynamic> toMap() => {'name': name, 'description': description, 'price': price, 'categoryId': categoryId, 'imageUrl': imageUrl, 'rating': rating, 'totalReviews': totalReviews, 'isAvailable': isAvailable, 'isActive': isActive, 'isRecommended': isRecommended, 'isSignature': isSignature, 'tags': tags, 'createdAt': _writeDate(createdAt), 'updatedAt': _writeDate(updatedAt)};
  MenuItemModel2 copyWith({String? name, String? description, double? price, String? categoryId, String? imageUrl, double? rating, int? totalReviews, bool? isAvailable, bool? isActive, bool? isRecommended, bool? isSignature, List<String>? tags, DateTime? updatedAt}) => MenuItemModel2(id: id, name: name ?? this.name, description: description ?? this.description, price: price ?? this.price, categoryId: categoryId ?? this.categoryId, imageUrl: imageUrl ?? this.imageUrl, rating: rating ?? this.rating, totalReviews: totalReviews ?? this.totalReviews, isAvailable: isAvailable ?? this.isAvailable, isActive: isActive ?? this.isActive, isRecommended: isRecommended ?? this.isRecommended, isSignature: isSignature ?? this.isSignature, tags: tags ?? this.tags, createdAt: createdAt, updatedAt: updatedAt ?? this.updatedAt);
}

class PromotionModel {
  const PromotionModel({required this.id, required this.title, required this.description, required this.discountType, required this.discountValue, required this.startTime, required this.endTime, this.isActive = true, this.iconType = 'gift'});
  final String id;
  final String title;
  final String description;
  final String discountType;
  final double discountValue;
  final DateTime startTime;
  final DateTime endTime;
  final bool isActive;
  final String iconType;
  factory PromotionModel.fromMap(String id, Map<String, dynamic> map) => PromotionModel(id: id, title: map['title'] as String? ?? '', description: map['description'] as String? ?? '', discountType: map['discountType'] as String? ?? 'percent', discountValue: (map['discountValue'] as num?)?.toDouble() ?? 0, startTime: _readDate(map['startTime']), endTime: _readDate(map['endTime']), isActive: map['isActive'] as bool? ?? true, iconType: map['iconType'] as String? ?? 'gift');
  Map<String, dynamic> toMap() => {'title': title, 'description': description, 'discountType': discountType, 'discountValue': discountValue, 'startTime': _writeDate(startTime), 'endTime': _writeDate(endTime), 'isActive': isActive, 'iconType': iconType};
  PromotionModel copyWith({String? title, String? description, String? discountType, double? discountValue, DateTime? startTime, DateTime? endTime, bool? isActive, String? iconType}) => PromotionModel(id: id, title: title ?? this.title, description: description ?? this.description, discountType: discountType ?? this.discountType, discountValue: discountValue ?? this.discountValue, startTime: startTime ?? this.startTime, endTime: endTime ?? this.endTime, isActive: isActive ?? this.isActive, iconType: iconType ?? this.iconType);
}

class RestaurantTableModel2 {
  const RestaurantTableModel2({required this.id, required this.tableName, required this.capacity, this.area = 'Main Dining', this.status = 'available', this.positionX = 0, this.positionY = 0, this.shape = 'circle', this.isActive = true});
  final String id;
  final String tableName;
  final int capacity;
  final String area;
  final String status;
  final double positionX;
  final double positionY;
  final String shape;
  final bool isActive;
  factory RestaurantTableModel2.fromMap(String id, Map<String, dynamic> map) => RestaurantTableModel2(id: id, tableName: map['tableName'] as String? ?? '', capacity: (map['capacity'] as num?)?.toInt() ?? 2, area: map['area'] as String? ?? 'Main Dining', status: map['status'] as String? ?? 'available', positionX: (map['positionX'] as num?)?.toDouble() ?? 0, positionY: (map['positionY'] as num?)?.toDouble() ?? 0, shape: map['shape'] as String? ?? 'circle', isActive: map['isActive'] as bool? ?? true);
  Map<String, dynamic> toMap() => {'tableName': tableName, 'capacity': capacity, 'area': area, 'status': status, 'positionX': positionX, 'positionY': positionY, 'shape': shape, 'isActive': isActive};
  RestaurantTableModel2 copyWith({String? tableName, int? capacity, String? area, String? status, double? positionX, double? positionY, String? shape, bool? isActive}) => RestaurantTableModel2(id: id, tableName: tableName ?? this.tableName, capacity: capacity ?? this.capacity, area: area ?? this.area, status: status ?? this.status, positionX: positionX ?? this.positionX, positionY: positionY ?? this.positionY, shape: shape ?? this.shape, isActive: isActive ?? this.isActive);
}

class CartItemModel {
  const CartItemModel({required this.itemId, required this.name, required this.price, required this.quantity, required this.imageUrl, required this.addedAt});
  final String itemId;
  final String name;
  final double price;
  final int quantity;
  final String imageUrl;
  final DateTime addedAt;
  double get lineTotal => price * quantity;
  factory CartItemModel.fromMap(String id, Map<String, dynamic> map) => CartItemModel(itemId: map['itemId'] as String? ?? id, name: map['name'] as String? ?? '', price: (map['price'] as num?)?.toDouble() ?? 0, quantity: (map['quantity'] as num?)?.toInt() ?? 1, imageUrl: map['imageUrl'] as String? ?? '', addedAt: _readDate(map['addedAt']));
  Map<String, dynamic> toMap() => {'itemId': itemId, 'name': name, 'price': price, 'quantity': quantity, 'imageUrl': imageUrl, 'addedAt': _writeDate(addedAt)};
  CartItemModel copyWith({String? name, double? price, int? quantity, String? imageUrl, DateTime? addedAt}) => CartItemModel(itemId: itemId, name: name ?? this.name, price: price ?? this.price, quantity: quantity ?? this.quantity, imageUrl: imageUrl ?? this.imageUrl, addedAt: addedAt ?? this.addedAt);
}

class BookingModel2 {
  const BookingModel2({required this.id, required this.userId, required this.customerName, required this.customerPhone, required this.tableId, required this.numberOfGuests, required this.bookingDate, required this.bookingTime, this.note = '', this.status = 'pending', this.preOrderItems = const [], this.totalPreOrderAmount = 0, required this.createdAt, required this.updatedAt});
  final String id;
  final String userId;
  final String customerName;
  final String customerPhone;
  final String tableId;
  final int numberOfGuests;
  final DateTime bookingDate;
  final String bookingTime;
  final String note;
  final String status;
  final List<CartItemModel> preOrderItems;
  final double totalPreOrderAmount;
  final DateTime createdAt;
  final DateTime updatedAt;
  factory BookingModel2.fromMap(String id, Map<String, dynamic> map) => BookingModel2(id: id, userId: map['userId'] as String? ?? '', customerName: map['customerName'] as String? ?? '', customerPhone: map['customerPhone'] as String? ?? '', tableId: map['tableId'] as String? ?? '', numberOfGuests: (map['numberOfGuests'] as num?)?.toInt() ?? 1, bookingDate: _readDate(map['bookingDate']), bookingTime: map['bookingTime'] as String? ?? '', note: map['note'] as String? ?? '', status: map['status'] as String? ?? 'pending', preOrderItems: (map['preOrderItems'] as List? ?? const []).whereType<Map>().map((e) => CartItemModel.fromMap(e['itemId'] as String? ?? '', Map<String, dynamic>.from(e))).toList(), totalPreOrderAmount: (map['totalPreOrderAmount'] as num?)?.toDouble() ?? 0, createdAt: _readDate(map['createdAt']), updatedAt: _readDate(map['updatedAt']));
  Map<String, dynamic> toMap() => {'userId': userId, 'customerName': customerName, 'customerPhone': customerPhone, 'tableId': tableId, 'numberOfGuests': numberOfGuests, 'bookingDate': _writeDate(bookingDate), 'bookingTime': bookingTime, 'note': note, 'status': status, 'preOrderItems': preOrderItems.map((e) => e.toMap()).toList(), 'totalPreOrderAmount': totalPreOrderAmount, 'createdAt': _writeDate(createdAt), 'updatedAt': _writeDate(updatedAt)};
  BookingModel2 copyWith({String? tableId, int? numberOfGuests, DateTime? bookingDate, String? bookingTime, String? note, String? status, List<CartItemModel>? preOrderItems, double? totalPreOrderAmount, DateTime? updatedAt}) => BookingModel2(id: id, userId: userId, customerName: customerName, customerPhone: customerPhone, tableId: tableId ?? this.tableId, numberOfGuests: numberOfGuests ?? this.numberOfGuests, bookingDate: bookingDate ?? this.bookingDate, bookingTime: bookingTime ?? this.bookingTime, note: note ?? this.note, status: status ?? this.status, preOrderItems: preOrderItems ?? this.preOrderItems, totalPreOrderAmount: totalPreOrderAmount ?? this.totalPreOrderAmount, createdAt: createdAt, updatedAt: updatedAt ?? this.updatedAt);
}

class OrderModel2 {
  const OrderModel2({required this.id, required this.userId, this.bookingId = '', this.tableId = '', required this.items, required this.subtotal, required this.discount, required this.totalAmount, this.status = 'pending', this.paymentStatus = 'unpaid', this.paymentMethod = 'cash', required this.createdAt, this.completedAt});
  final String id;
  final String userId;
  final String bookingId;
  final String tableId;
  final List<CartItemModel> items;
  final double subtotal;
  final double discount;
  final double totalAmount;
  final String status;
  final String paymentStatus;
  final String paymentMethod;
  final DateTime createdAt;
  final DateTime? completedAt;
  factory OrderModel2.fromMap(String id, Map<String, dynamic> map) => OrderModel2(id: id, userId: map['userId'] as String? ?? '', bookingId: map['bookingId'] as String? ?? '', tableId: map['tableId'] as String? ?? '', items: (map['items'] as List? ?? const []).whereType<Map>().map((e) => CartItemModel.fromMap(e['itemId'] as String? ?? '', Map<String, dynamic>.from(e))).toList(), subtotal: (map['subtotal'] as num?)?.toDouble() ?? 0, discount: (map['discount'] as num?)?.toDouble() ?? 0, totalAmount: (map['totalAmount'] as num?)?.toDouble() ?? 0, status: map['status'] as String? ?? 'pending', paymentStatus: map['paymentStatus'] as String? ?? 'unpaid', paymentMethod: map['paymentMethod'] as String? ?? 'cash', createdAt: _readDate(map['createdAt']), completedAt: map['completedAt'] == null ? null : _readDate(map['completedAt']));
  Map<String, dynamic> toMap() => {'userId': userId, 'bookingId': bookingId, 'tableId': tableId, 'items': items.map((e) => e.toMap()).toList(), 'subtotal': subtotal, 'discount': discount, 'totalAmount': totalAmount, 'status': status, 'paymentStatus': paymentStatus, 'paymentMethod': paymentMethod, 'createdAt': _writeDate(createdAt), 'completedAt': completedAt == null ? null : _writeDate(completedAt!)};
  OrderModel2 copyWith({String? status, String? paymentStatus, String? paymentMethod, DateTime? completedAt}) => OrderModel2(id: id, userId: userId, bookingId: bookingId, tableId: tableId, items: items, subtotal: subtotal, discount: discount, totalAmount: totalAmount, status: status ?? this.status, paymentStatus: paymentStatus ?? this.paymentStatus, paymentMethod: paymentMethod ?? this.paymentMethod, createdAt: createdAt, completedAt: completedAt ?? this.completedAt);
}
