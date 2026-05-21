import '../models/rustic_models.dart';
import '../providers/app_state.dart';

class RestaurantRepository {
  RestaurantRepository(this.state);
  final AppState state;

  List<MenuItemModel2> menu({String categoryId = 'all', String search = ''}) => state.itemsByCategory(categoryId, search);
  List<RestaurantTableModel2> availableTables(int guests) => state.availableTablesFor(guests);
  BookingModel2 createBooking({required DateTime date, required String time, required int guests, required String tableId, String note = '', bool includeCart = false}) => state.createBooking(date: date, time: time, guests: guests, tableId: tableId, note: note, includeCart: includeCart);
  OrderModel2 checkout() => state.checkout();
}
