import 'package:flutter/foundation.dart';

import '../models/menu_item_model.dart';
import '../services/menu_service.dart';

class MenuProvider extends ChangeNotifier {
  MenuProvider({MenuService? service}) : _service = service;

  MenuService? _service;
  MenuService get service => _service ??= MenuService();
  List<MenuItemModel> items = [];
  bool isLoading = false;
  String? error;

  List<String> get categories => items.map((e) => e.category).toSet().toList();
  List<MenuItemModel> byCategory(String category) => items.where((e) => e.category == category).toList();

  Future<void> loadMenu(String restaurantId, {bool forceRefresh = false}) async {
    if (items.isNotEmpty && !forceRefresh) return;
    isLoading = true; notifyListeners();
    try { items = await service.getMenuItems(restaurantId, forceRefresh: forceRefresh); error = null; } catch (e) { error = e.toString(); } finally { isLoading = false; notifyListeners(); }
  }
}


