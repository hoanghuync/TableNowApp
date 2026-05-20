import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/booking_model.dart';
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
    final guestError = validateGuestNumber(booking.numberOfGuests);
    if (guestError != null) throw Exception(guestError);
    final timeError = validateBookingTime(date: booking.bookingDate, time: booking.bookingTime, openTime: openTime, closeTime: closeTime);
    if (timeError != null) throw Exception(timeError);

    final conflict = await _firestore.collection('bookings')
        .where('tableId', isEqualTo: booking.tableId)
        .where('bookingDate', isEqualTo: booking.bookingDate)
        .where('bookingTime', isEqualTo: booking.bookingTime)
        .where('status', whereIn: ['pending', 'confirmed', 'completed'])
        .limit(1)
        .get();
    if (conflict.docs.isNotEmpty) throw Exception('Ban nay da co booking cung ngay gio');

    final doc = booking.id.isEmpty ? _firestore.collection('bookings').doc() : _firestore.collection('bookings').doc(booking.id);
    await doc.set(BookingModel(
      id: doc.id,
      userId: booking.userId,
      restaurantId: booking.restaurantId,
      tableId: booking.tableId,
      bookingDate: booking.bookingDate,
      bookingTime: booking.bookingTime,
      numberOfGuests: booking.numberOfGuests,
      note: booking.note,
      selectedItems: booking.selectedItems,
      totalAmount: booking.totalAmount,
      status: booking.status,
      createdAt: booking.createdAt,
    ).toMap());
  }

  Future<void> updateStatus(String bookingId, String status) => _firestore.collection('bookings').doc(bookingId).update({'status': status});

  Future<void> cancelBooking(BookingModel booking) async {
    if (!booking.canCustomerCancel) throw Exception('Chi co the huy booking pending hoac confirmed');
    await updateStatus(booking.id, 'cancelled');
  }
}
