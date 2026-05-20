import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/booking_model.dart';
import '../models/restaurant_table_model.dart';
import '../utils/validators.dart';

class BookingService {
  BookingService({FirebaseFirestore? firestore}) : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  Future<List<BookingModel>> getBookingsForUser(String userId) async {
    final snapshot = await _firestore.collection('bookings').where('userId', isEqualTo: userId).orderBy('createdAt', descending: true).get();
    return snapshot.docs.map((doc) => BookingModel.fromMap(doc.data(), doc.id)).toList();
  }

  Future<List<BookingModel>> getAllBookings() async {
    final snapshot = await _firestore.collection('bookings').orderBy('bookingDate', descending: true).orderBy('bookingTime').get();
    return snapshot.docs.map((doc) => BookingModel.fromMap(doc.data(), doc.id)).toList();
  }

  Future<void> createBooking(BookingModel booking, {required String openTime, required String closeTime}) async {
    if (booking.userId.isEmpty) throw Exception('Ban can dang nhap de dat ban');
    if (booking.restaurantId.isEmpty) throw Exception('Thieu thong tin nha hang');
    if (booking.tableId.isEmpty) throw Exception('Vui long chon ban');

    final guestError = validateGuestNumber(booking.numberOfGuests);
    if (guestError != null) throw Exception(guestError);

    final timeError = validateBookingTime(date: booking.bookingDate, time: booking.bookingTime, openTime: openTime, closeTime: closeTime);
    if (timeError != null) throw Exception(timeError);

    final itemError = validatePreOrderItems(booking.selectedItems, booking.restaurantId);
    if (itemError != null) throw Exception(itemError);

    final table = await _getTable(booking.tableId);
    if (table.restaurantId != booking.restaurantId) throw Exception('Ban khong thuoc nha hang nay');
    if (table.status != 'available') throw Exception('Ban hien khong san sang nhan booking');
    if (table.capacity < booking.numberOfGuests) throw Exception('Ban da chon khong du suc chua so khach');

    final conflict = await _firestore.collection('bookings')
        .where('restaurantId', isEqualTo: booking.restaurantId)
        .where('tableId', isEqualTo: booking.tableId)
        .where('bookingDate', isEqualTo: booking.bookingDate)
        .where('bookingTime', isEqualTo: booking.bookingTime)
        .get();
    final hasActiveConflict = conflict.docs.any((doc) => (doc.data()['status'] as String? ?? 'pending') != 'cancelled');
    if (hasActiveConflict) throw Exception('Ban nay da co booking cung ngay gio');

    final doc = booking.id.isEmpty ? _firestore.collection('bookings').doc() : _firestore.collection('bookings').doc(booking.id);
    final cleanItems = booking.selectedItems.where((item) => item.quantity > 0).toList(growable: false);
    await doc.set(BookingModel(
      id: doc.id,
      userId: booking.userId,
      restaurantId: booking.restaurantId,
      tableId: booking.tableId,
      bookingDate: booking.bookingDate,
      bookingTime: booking.bookingTime,
      numberOfGuests: booking.numberOfGuests,
      note: booking.note.trim(),
      selectedItems: cleanItems,
      totalAmount: calculateTotalAmount(cleanItems),
      status: 'pending',
      createdAt: booking.createdAt,
    ).toMap());
  }

  Future<void> updateStatus(String bookingId, String status) async {
    if (!['pending', 'confirmed', 'cancelled', 'completed'].contains(status)) throw Exception('Trang thai booking khong hop le');
    await _firestore.collection('bookings').doc(bookingId).update({'status': status});
  }

  Future<void> cancelBooking(BookingModel booking) async {
    if (!booking.canCustomerCancel) throw Exception('Chi co the huy booking pending hoac confirmed');
    await updateStatus(booking.id, 'cancelled');
  }

  Future<RestaurantTableModel> _getTable(String tableId) async {
    final doc = await _firestore.collection('restaurant_tables').doc(tableId).get();
    if (!doc.exists || doc.data() == null) throw Exception('Khong tim thay ban da chon');
    return RestaurantTableModel.fromMap(doc.data()!, doc.id);
  }
}


