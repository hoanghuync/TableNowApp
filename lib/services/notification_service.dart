import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/notification_model.dart';

class NotificationService {
  NotificationService({FirebaseFirestore? firestore}) : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  Future<List<NotificationModel>> getNotifications(String userId) async {
    final snapshot = await _firestore.collection('notifications').where('userId', isEqualTo: userId).orderBy('createdAt', descending: true).get();
    return snapshot.docs.map((doc) => NotificationModel.fromMap(doc.data(), doc.id)).toList();
  }

  Future<void> markRead(String id) => _firestore.collection('notifications').doc(id).update({'isRead': true});
}


