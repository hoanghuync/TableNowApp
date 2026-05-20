import 'package:flutter/foundation.dart';

import '../models/restaurant_model.dart';
import '../models/restaurant_table_model.dart';
import '../services/restaurant_service.dart';

class RestaurantProvider extends ChangeNotifier {
  RestaurantProvider({RestaurantService? service}) : _service = service;

  RestaurantService? _service;
  RestaurantService get service => _service ??= RestaurantService();
  RestaurantModel? restaurant;
  List<RestaurantTableModel> tables = [];
  bool isLoading = false;
  String? error;

  List<RestaurantTableModel> availableTablesForGuests(int guests) {
    if (guests <= 0) return const [];
    return tables.where((table) => table.status == 'available' && table.capacity >= guests).toList()..sort((a, b) => a.capacity.compareTo(b.capacity));
  }

  Future<void> loadRestaurant() async {
    if (restaurant != null && tables.isNotEmpty) return;
    isLoading = true;
    notifyListeners();
    try {
      restaurant = await service.getMainRestaurant();
      if (restaurant != null) tables = await service.getTables(restaurant!.id);
      error = null;
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}


