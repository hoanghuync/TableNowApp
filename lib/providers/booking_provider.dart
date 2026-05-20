import 'package:flutter/foundation.dart';

import '../models/booking_model.dart';
import '../models/booking_item_model.dart';
import '../services/booking_service.dart';
import '../utils/validators.dart';

class BookingProvider extends ChangeNotifier {
  BookingProvider({BookingService? service}) : _service = service;

  BookingService? _service;
  BookingService get service => _service ??= BookingService();
  List<BookingModel> bookings = [];
  bool isLoading = false;
  String? error;

  Future<void> loadUserBookings(String userId) async { isLoading = true; notifyListeners(); try { bookings = await service.getBookingsForUser(userId); error = null; } catch (e) { error = e.toString(); } finally { isLoading = false; notifyListeners(); } }
  Future<void> loadAllBookings() async { isLoading = true; notifyListeners(); try { bookings = await service.getAllBookings(); error = null; } catch (e) { error = e.toString(); } finally { isLoading = false; notifyListeners(); } }

  Future<bool> createBooking({required String userId, required String restaurantId, required String tableId, required String bookingDate, required String bookingTime, required int numberOfGuests, required String note, required List<BookingItemModel> selectedItems, required String openTime, required String closeTime}) async {
    isLoading = true; notifyListeners();
    try {
      final booking = BookingModel(id: '', userId: userId, restaurantId: restaurantId, tableId: tableId, bookingDate: bookingDate, bookingTime: bookingTime, numberOfGuests: numberOfGuests, note: note, selectedItems: selectedItems, totalAmount: calculateTotalAmount(selectedItems), status: 'pending', createdAt: DateTime.now());
      await service.createBooking(booking, openTime: openTime, closeTime: closeTime);
      error = null; return true;
    } catch (e) { error = e.toString(); return false; } finally { isLoading = false; notifyListeners(); }
  }

  Future<bool> cancel(BookingModel booking) async { try { await service.cancelBooking(booking); bookings = bookings.map((e) => e.id == booking.id ? e.copyWith(status: 'cancelled') : e).toList(); notifyListeners(); return true; } catch (e) { error = e.toString(); notifyListeners(); return false; } }
  Future<bool> updateStatus(BookingModel booking, String status) async { try { await service.updateStatus(booking.id, status); bookings = bookings.map((e) => e.id == booking.id ? e.copyWith(status: status) : e).toList(); notifyListeners(); return true; } catch (e) { error = e.toString(); notifyListeners(); return false; } }

  Map<String, int> countByDate() { final result = <String, int>{}; for (final booking in bookings) { result[booking.bookingDate] = (result[booking.bookingDate] ?? 0) + 1; } return result; }
}
