import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/rustic_models.dart';

class FirebaseService {
  FirebaseService({FirebaseAuth? auth, FirebaseFirestore? firestore, FirebaseStorage? storage}) : auth = auth ?? FirebaseAuth.instance, firestore = firestore ?? FirebaseFirestore.instance, storage = storage ?? FirebaseStorage.instance;
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;

  Future<RusticUser?> signIn(String email, String password) async {
    final credential = await auth.signInWithEmailAndPassword(email: email.trim(), password: password);
    final uid = credential.user!.uid;
    final doc = await firestore.collection('users').doc(uid).get();
    return doc.exists && doc.data() != null ? RusticUser.fromMap(uid, doc.data()!) : null;
  }

  Future<RusticUser> register({required String fullName, required String email, required String phone, required String password}) async {
    final credential = await auth.createUserWithEmailAndPassword(email: email.trim(), password: password);
    final uid = credential.user!.uid;
    final now = DateTime.now();
    final user = RusticUser(uid: uid, fullName: fullName, email: email, phone: phone, createdAt: now, updatedAt: now);
    await firestore.collection('users').doc(uid).set(user.toMap());
    return user;
  }

  Future<void> signOut() => auth.signOut();

  Future<String> uploadMenuImage(File file, String itemId) async {
    final ref = storage.ref('menu_items/$itemId-${DateTime.now().millisecondsSinceEpoch}.jpg');
    await ref.putFile(file);
    return ref.getDownloadURL();
  }

  Future<void> seedData({required List<CategoryModel> categories, required List<MenuItemModel2> menuItems, required List<RestaurantTableModel2> tables}) async {
    final batch = firestore.batch();
    for (final category in categories) {
      batch.set(firestore.collection('categories').doc(category.id), category.toMap(), SetOptions(merge: true));
    }
    for (final item in menuItems) {
      batch.set(firestore.collection('menu_items').doc(item.id), item.toMap(), SetOptions(merge: true));
    }
    for (final table in tables) {
      batch.set(firestore.collection('tables').doc(table.id), table.toMap(), SetOptions(merge: true));
    }
    await batch.commit();
  }
}
