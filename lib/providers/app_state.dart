import 'package:flutter/foundation.dart';

import '../core/constants/mock_data.dart';
import '../models/rustic_models.dart';

class AppState extends ChangeNotifier {
  RusticUser? currentUser = MockData.currentUser;
  bool get isAuthenticated => currentUser != null;
  bool get isAdmin => currentUser?.isAdmin ?? false;

  final List<CategoryModel> categories = List.of(MockData.categories);
  final List<MenuItemModel2> menuItems = List.of(MockData.menuItems);
  final List<PromotionModel> promotions = List.of(MockData.promotions);
  final List<RestaurantTableModel2> tables = List.of(MockData.tables);
  final List<BookingModel2> bookings = List.of(MockData.bookings);
  final List<OrderModel2> orders = List.of(MockData.orders);
  final Map<String, CartItemModel> cart = {};
  final Set<String> favorites = {};

  bool loading = false;
  String? error;

  void loginAsCustomer() {
    currentUser = MockData.currentUser;
    notifyListeners();
  }

  void loginAsAdmin() {
    currentUser = MockData.adminUser;
    notifyListeners();
  }

  void logout() {
    currentUser = null;
    cart.clear();
    notifyListeners();
  }

  List<MenuItemModel2> itemsByCategory(String categoryId, String search) {
    final query = search.trim().toLowerCase();
    return menuItems.where((item) {
      final matchCategory = categoryId == 'all' || item.categoryId == categoryId;
      final matchSearch = query.isEmpty || item.name.toLowerCase().contains(query) || item.description.toLowerCase().contains(query);
      return item.isActive && matchCategory && matchSearch;
    }).toList();
  }

  MenuItemModel2? get signature => menuItems.where((e) => e.isSignature).firstOrNull;
  List<MenuItemModel2> get recommended => menuItems.where((e) => e.isRecommended && e.isActive).toList();
  List<BookingModel2> get myBookings => bookings.where((b) => b.userId == currentUser?.uid).toList();
  List<OrderModel2> get myOrders => orders.where((o) => o.userId == currentUser?.uid).toList();
  List<BookingModel2> get pendingBookings => bookings.where((b) => b.status == 'pending').toList();
  List<RestaurantTableModel2> get activeTables => tables.where((t) => t.isActive).toList();

  double get cartSubtotal => cart.values.fold(0, (total, item) => total + item.lineTotal);
  double get cartDiscount => cartSubtotal >= 500000 ? cartSubtotal * .1 : 0;
  double get cartTotal => cartSubtotal - cartDiscount;
  int get cartCount => cart.values.fold(0, (total, item) => total + item.quantity);

  double get todayRevenue => orders.where((o) => o.status == 'completed' && _isToday(o.completedAt ?? o.createdAt)).fold(0, (total, order) => total + order.totalAmount);
  int get todayBookings => bookings.where((b) => _isToday(b.bookingDate)).length;
  double get occupancyRate {
    final active = activeTables.length;
    if (active == 0) return 0;
    return activeTables.where((t) => t.status == 'occupied').length / active;
  }

  void toggleFavorite(String itemId) {
    favorites.contains(itemId) ? favorites.remove(itemId) : favorites.add(itemId);
    notifyListeners();
  }

  void addToCart(MenuItemModel2 item) {
    if (!item.isAvailable || !item.isActive) return;
    final existing = cart[item.id];
    cart[item.id] = CartItemModel(itemId: item.id, name: item.name, price: item.price, quantity: (existing?.quantity ?? 0) + 1, imageUrl: item.imageUrl, addedAt: DateTime.now());
    notifyListeners();
  }

  void decreaseCart(String itemId) {
    final existing = cart[itemId];
    if (existing == null) return;
    if (existing.quantity <= 1) {
      cart.remove(itemId);
    } else {
      cart[itemId] = existing.copyWith(quantity: existing.quantity - 1);
    }
    notifyListeners();
  }

  void clearCart() {
    cart.clear();
    notifyListeners();
  }

  OrderModel2 checkout() {
    final order = OrderModel2(id: 'order-${DateTime.now().millisecondsSinceEpoch}', userId: currentUser?.uid ?? 'guest', items: cart.values.toList(), subtotal: cartSubtotal, discount: cartDiscount, totalAmount: cartTotal, status: 'pending', paymentStatus: 'unpaid', createdAt: DateTime.now());
    orders.insert(0, order);
    cart.clear();
    notifyListeners();
    return order;
  }

  List<RestaurantTableModel2> availableTablesFor(int guests) => activeTables.where((table) => table.status == 'available' && table.capacity >= guests).toList();

  BookingModel2 createBooking({required DateTime date, required String time, required int guests, required String tableId, String note = '', bool includeCart = false}) {
    final items = includeCart ? cart.values.toList() : <CartItemModel>[];
    final booking = BookingModel2(id: 'booking-${DateTime.now().millisecondsSinceEpoch}', userId: currentUser?.uid ?? 'guest', customerName: currentUser?.fullName ?? 'Guest', customerPhone: currentUser?.phone ?? '', tableId: tableId, numberOfGuests: guests, bookingDate: date, bookingTime: time, note: note, status: 'pending', preOrderItems: items, totalPreOrderAmount: items.fold(0, (total, item) => total + item.lineTotal), createdAt: DateTime.now(), updatedAt: DateTime.now());
    bookings.insert(0, booking);
    if (includeCart) cart.clear();
    notifyListeners();
    return booking;
  }

  void updateBookingStatus(BookingModel2 booking, String status) {
    final index = bookings.indexWhere((b) => b.id == booking.id);
    if (index == -1) return;
    bookings[index] = booking.copyWith(status: status, updatedAt: DateTime.now());
    if (status == 'confirmed') updateTableStatus(booking.tableId, 'reserved');
    if (status == 'declined' || status == 'cancelled') updateTableStatus(booking.tableId, 'available');
    notifyListeners();
  }

  void updateTableStatus(String tableId, String status) {
    final index = tables.indexWhere((t) => t.id == tableId);
    if (index == -1) return;
    tables[index] = tables[index].copyWith(status: status);
    notifyListeners();
  }

  void upsertMenuItem(MenuItemModel2 item) {
    final index = menuItems.indexWhere((e) => e.id == item.id);
    if (index == -1) {
      menuItems.insert(0, item);
    } else {
      menuItems[index] = item.copyWith(updatedAt: DateTime.now());
    }
    notifyListeners();
  }

  void softDeleteMenuItem(String itemId) {
    final index = menuItems.indexWhere((e) => e.id == itemId);
    if (index == -1) return;
    menuItems[index] = menuItems[index].copyWith(isActive: false, updatedAt: DateTime.now());
    notifyListeners();
  }

  void toggleMenuAvailability(String itemId) {
    final index = menuItems.indexWhere((e) => e.id == itemId);
    if (index == -1) return;
    menuItems[index] = menuItems[index].copyWith(isAvailable: !menuItems[index].isAvailable, updatedAt: DateTime.now());
    notifyListeners();
  }

  void upsertTable(RestaurantTableModel2 table) {
    final index = tables.indexWhere((e) => e.id == table.id);
    if (index == -1) {
      tables.add(table);
    } else {
      tables[index] = table;
    }
    notifyListeners();
  }

  static bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }
}
