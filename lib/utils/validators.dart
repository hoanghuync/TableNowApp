import '../models/booking_item_model.dart';
import 'date_time_utils.dart';

double calculateTotalAmount(List<BookingItemModel> items) => items.fold<double>(0, (total, item) => total + item.price * item.quantity);

String? validateEmail(String? value) {
  final text = value?.trim() ?? '';
  if (text.isEmpty) return 'Vui long nhap email';
  if (!text.contains('@')) return 'Email khong hop le';
  return null;
}

String? validatePassword(String? value) {
  if ((value ?? '').length < 6) return 'Mat khau toi thieu 6 ky tu';
  return null;
}

String? validateRequired(String? value, String label) {
  if ((value ?? '').trim().isEmpty) return 'Vui long nhap $label';
  return null;
}

String? validateGuestNumber(int? guests) {
  if (guests == null || guests <= 0) return 'So luong khach phai lon hon 0';
  return null;
}

String? validateBookingDate(DateTime? date, {DateTime? now}) {
  if (date == null) return 'Vui long chon ngay dat ban';
  final today = now ?? DateTime.now();
  final selected = DateTime(date.year, date.month, date.day);
  final current = DateTime(today.year, today.month, today.day);
  if (selected.isBefore(current)) return 'Khong duoc dat ban trong qua khu';
  return null;
}

String? validateBookingTime({required String? date, required String? time, required String openTime, required String closeTime, DateTime? now}) {
  if (date == null || date.isEmpty) return 'Vui long chon ngay dat ban';
  if (time == null || time.isEmpty) return 'Vui long chon gio dat ban';
  if (!DateTimeUtils.isTimeInsideRange(time, openTime, closeTime)) return 'Gio dat ban phai nam trong gio mo cua';
  final selectedDateTime = DateTimeUtils.parseDateAndTime(date, time);
  if (selectedDateTime.isBefore(now ?? DateTime.now())) return 'Khong duoc dat ban trong qua khu';
  return null;
}
