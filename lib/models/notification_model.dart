import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  const NotificationModel({required this.id, required this.userId, required this.title, required this.message, required this.isRead, required this.createdAt});

  final String id;
  final String userId;
  final String title;
  final String message;
  final bool isRead;
  final DateTime createdAt;

  factory NotificationModel.fromMap(Map<String, dynamic> map, String id) => NotificationModel(
    id: map['id'] as String? ?? id,
    userId: map['userId'] as String? ?? '',
    title: map['title'] as String? ?? '',
    message: map['message'] as String? ?? '',
    isRead: map['isRead'] as bool? ?? false,
    createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
  );

  Map<String, dynamic> toMap() => {'id': id, 'userId': userId, 'title': title, 'message': message, 'isRead': isRead, 'createdAt': Timestamp.fromDate(createdAt)};
}
