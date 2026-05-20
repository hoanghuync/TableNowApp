import 'package:cloud_firestore/cloud_firestore.dart';

class AppUserModel {
  const AppUserModel({required this.uid, required this.fullName, required this.email, required this.phone, required this.role, required this.createdAt});

  final String uid;
  final String fullName;
  final String email;
  final String phone;
  final String role;
  final DateTime createdAt;

  bool get isAdmin => role == 'admin';

  factory AppUserModel.fromMap(Map<String, dynamic> map) => AppUserModel(
    uid: map['uid'] as String? ?? '',
    fullName: map['fullName'] as String? ?? '',
    email: map['email'] as String? ?? '',
    phone: map['phone'] as String? ?? '',
    role: map['role'] as String? ?? 'customer',
    createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
  );

  Map<String, dynamic> toMap() => {
    'uid': uid,
    'fullName': fullName,
    'email': email,
    'phone': phone,
    'role': role,
    'createdAt': Timestamp.fromDate(createdAt),
  };
}


