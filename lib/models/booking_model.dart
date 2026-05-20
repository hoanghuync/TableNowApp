import 'package:cloud_firestore/cloud_firestore.dart';
import 'booking_item_model.dart';

class BookingModel {
  const BookingModel({required this.id, required this.userId, required this.restaurantId, required this.tableId, required this.bookingDate, required this.bookingTime, required this.numberOfGuests, required this.note, required this.selectedItems, required this.totalAmount, required this.status, required this.createdAt});

  final String id;
  final String userId;
  final String restaurantId;
  final String tableId;
  final String bookingDate;
  final String bookingTime;
  final int numberOfGuests;
  final String note;
  final List<BookingItemModel> selectedItems;
  final double totalAmount;
  final String status;
  final DateTime createdAt;

  bool get canCustomerCancel => status == 'pending' || status == 'confirmed';
  bool get canReview => status == 'completed';

  BookingModel copyWith({String? status}) => BookingModel(
    id: id,
    userId: userId,
    restaurantId: restaurantId,
    tableId: tableId,
    bookingDate: bookingDate,
    bookingTime: bookingTime,
    numberOfGuests: numberOfGuests,
    note: note,
    selectedItems: selectedItems,
    totalAmount: totalAmount,
    status: status ?? this.status,
    createdAt: createdAt,
  );

  factory BookingModel.fromMap(Map<String, dynamic> map, String id) => BookingModel(
    id: map['id'] as String? ?? id,
    userId: map['userId'] as String? ?? '',
    restaurantId: map['restaurantId'] as String? ?? '',
    tableId: map['tableId'] as String? ?? '',
    bookingDate: map['bookingDate'] as String? ?? '',
    bookingTime: map['bookingTime'] as String? ?? '',
    numberOfGuests: (map['numberOfGuests'] as num?)?.toInt() ?? 0,
    note: map['note'] as String? ?? '',
    selectedItems: ((map['selectedItems'] as List?) ?? const []).whereType<Map>().map((e) => BookingItemModel.fromMap(Map<String, dynamic>.from(e))).toList(),
    totalAmount: (map['totalAmount'] as num?)?.toDouble() ?? 0,
    status: map['status'] as String? ?? 'pending',
    createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'userId': userId,
    'restaurantId': restaurantId,
    'tableId': tableId,
    'bookingDate': bookingDate,
    'bookingTime': bookingTime,
    'numberOfGuests': numberOfGuests,
    'note': note,
    'selectedItems': selectedItems.map((e) => e.toMap()).toList(),
    'totalAmount': totalAmount,
    'status': status,
    'createdAt': Timestamp.fromDate(createdAt),
  };
}


