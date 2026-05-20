import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/restaurant_model.dart';
import '../models/restaurant_table_model.dart';
import '../utils/app_constants.dart';

class RestaurantService {
  RestaurantService({FirebaseFirestore? firestore}) : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  Future<RestaurantModel?> getMainRestaurant() async {
    final doc = await _firestore.collection('restaurants').doc(AppConstants.restaurantId).get();
    if (!doc.exists || doc.data() == null) return null;
    return RestaurantModel.fromMap(doc.data()!, doc.id);
  }

  Future<List<RestaurantTableModel>> getTables(String restaurantId) async {
    final snapshot = await _firestore.collection('restaurant_tables').where('restaurantId', isEqualTo: restaurantId).get();
    return snapshot.docs.map((doc) => RestaurantTableModel.fromMap(doc.data(), doc.id)).toList();
  }
}


