import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/app_user_model.dart';

class AuthService {
  AuthService({FirebaseAuth? auth, FirebaseFirestore? firestore}) : _auth = auth ?? FirebaseAuth.instance, _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  Stream<User?> get authStateChanges => _auth.authStateChanges();
  User? get currentFirebaseUser => _auth.currentUser;

  Future<AppUserModel?> getCurrentUserProfile() async {
    final user = _auth.currentUser;
    if (user == null) return null;
    return getUserProfile(user.uid);
  }

  Future<AppUserModel?> getUserProfile(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (!doc.exists || doc.data() == null) return null;
    return AppUserModel.fromMap(doc.data()!);
  }

  Future<AppUserModel> login(String email, String password) async {
    final credential = await _auth.signInWithEmailAndPassword(email: email.trim(), password: password);
    final uid = credential.user!.uid;
    final profile = await getUserProfile(uid);
    if (profile == null) throw Exception('Khong tim thay ho so nguoi dung');
    return profile;
  }

  Future<AppUserModel> register({required String fullName, required String email, required String phone, required String password}) async {
    final credential = await _auth.createUserWithEmailAndPassword(email: email.trim(), password: password);
    final uid = credential.user!.uid;
    final user = AppUserModel(uid: uid, fullName: fullName.trim(), email: email.trim(), phone: phone.trim(), role: 'customer', createdAt: DateTime.now());
    await _firestore.collection('users').doc(uid).set(user.toMap());
    return user;
  }

  Future<void> logout() => _auth.signOut();
}
