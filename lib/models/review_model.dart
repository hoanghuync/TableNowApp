import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  const ReviewModel({required this.id, required this.userId, required this.bookingId, required this.restaurantId, required this.rating, required this.comment, required this.createdAt});

  final String id;
  final String userId;
  final String bookingId;
  final String restaurantId;
  final int rating;
  final String comment;
  final DateTime createdAt;

  factory ReviewModel.fromMap(Map<String, dynamic> map, String id) => ReviewModel(
    id: map['id'] as String? ?? id,
    userId: map['userId'] as String? ?? '',
    bookingId: map['bookingId'] as String? ?? '',
    restaurantId: map['restaurantId'] as String? ?? '',
    rating: (map['rating'] as num?)?.toInt() ?? 0,
    comment: map['comment'] as String? ?? '',
    createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
  );

  Map<String, dynamic> toMap() => {'id': id, 'userId': userId, 'bookingId': bookingId, 'restaurantId': restaurantId, 'rating': rating, 'comment': comment, 'createdAt': Timestamp.fromDate(createdAt)};
}
