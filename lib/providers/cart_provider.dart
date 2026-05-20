import 'package:flutter/foundation.dart';

import '../models/booking_item_model.dart';
import '../models/menu_item_model.dart';
import '../utils/validators.dart';

class CartProvider extends ChangeNotifier {
  final Map<String, BookingItemModel> _items = {};

  List<BookingItemModel> get items => _items.values.toList();
  double get totalAmount => calculateTotalAmount(items);
  int get totalQuantity => items.fold<int>(0, (total, item) => total + item.quantity);

  void add(MenuItemModel item) {
    if (!item.isAvailable) return;
    final current = _items[item.id];
    _items[item.id] = BookingItemModel(
      menuItemId: item.id,
      restaurantId: item.restaurantId,
      name: item.name,
      price: item.price,
      quantity: (current?.quantity ?? 0) + 1,
    );
    notifyListeners();
  }

  void decrease(String menuItemId) {
    final current = _items[menuItemId];
    if (current == null) return;
    if (current.quantity <= 1) {
      _items.remove(menuItemId);
    } else {
      _items[menuItemId] = BookingItemModel(
        menuItemId: current.menuItemId,
        restaurantId: current.restaurantId,
        name: current.name,
        price: current.price,
        quantity: current.quantity - 1,
      );
    }
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}


