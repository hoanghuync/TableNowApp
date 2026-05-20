import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/menu_item_model.dart';

class MenuService {
  MenuService({FirebaseFirestore? firestore}) : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;
  List<MenuItemModel>? _cache;

  Future<List<MenuItemModel>> getMenuItems(String restaurantId, {bool forceRefresh = false}) async {
    if (_cache != null && !forceRefresh) return _cache!;
    final snapshot = await _firestore.collection('menu_items').where('restaurantId', isEqualTo: restaurantId).where('isAvailable', isEqualTo: true).get();
    final items = snapshot.docs.map((doc) => MenuItemModel.fromMap(doc.data(), doc.id)).toList()..sort((a, b) => a.category.compareTo(b.category));
    _cache = items;
    return items;
  }
}


