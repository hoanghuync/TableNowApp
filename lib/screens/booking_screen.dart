import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/booking_provider.dart';
import '../providers/restaurant_provider.dart';
import '../utils/date_time_utils.dart';
import '../utils/validators.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _guestController = TextEditingController();
  final _noteController = TextEditingController();
  DateTime? _date;
  TimeOfDay? _time;
  String? _tableId;

  @override
  void initState() { super.initState(); WidgetsBinding.instance.addPostFrameCallback((_) => context.read<RestaurantProvider>().loadRestaurant()); }

  @override
  void dispose() { _guestController.dispose(); _noteController.dispose(); super.dispose(); }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final restaurantProvider = context.read<RestaurantProvider>();
    final restaurant = restaurantProvider.restaurant;
    final auth = context.read<AuthProvider>();
    final dateError = validateBookingDate(_date);
    if (dateError != null) return _show(dateError);
    if (_time == null) return _show('Vui long chon gio dat ban');
    if (_tableId == null) return _show('Vui long chon ban');
    if (restaurant == null) return _show('Chua tai duoc thong tin nha hang');
    if (!auth.isLoggedIn) return _show('Ban can dang nhap de dat ban');

    final dateText = DateTimeUtils.formatDate(_date!);
    final timeText = '${_time!.hour.toString().padLeft(2, '0')}:${_time!.minute.toString().padLeft(2, '0')}';
    final ok = await context.read<BookingProvider>().createBooking(
      userId: auth.user!.uid,
      restaurantId: restaurant.id,
      tableId: _tableId!,
      bookingDate: dateText,
      bookingTime: timeText,
      numberOfGuests: int.parse(_guestController.text),
      note: _noteController.text,
      selectedItems: context.read<CartProvider>().items,
      openTime: restaurant.openTime,
      closeTime: restaurant.closeTime,
    );
    if (!mounted) return;
    final bookingProvider = context.read<BookingProvider>();
    _show(ok ? 'Dat ban thanh cong' : bookingProvider.error ?? 'Dat ban that bai');
    if (ok) { context.read<CartProvider>().clear(); Navigator.pop(context); }
  }

  void _show(String message) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));

  @override
  Widget build(BuildContext context) {
    final restaurantProvider = context.watch<RestaurantProvider>();
    final dateText = _date == null ? 'Chon ngay' : DateTimeUtils.formatDate(_date!);
    final timeText = _time == null ? 'Chon gio' : _time!.format(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Dat ban')),
      body: Form(
        key: _formKey,
        child: ListView(padding: const EdgeInsets.all(16), children: [
          DropdownButtonFormField<String>(
            initialValue: _tableId,
            decoration: const InputDecoration(labelText: 'Ban', border: OutlineInputBorder()),
            items: restaurantProvider.tables.map((table) => DropdownMenuItem(value: table.id, child: Text('${table.tableName} - ${table.capacity} khach'))).toList(),
            validator: (v) => v == null ? 'Vui long chon ban' : null,
            onChanged: (v) => setState(() => _tableId = v),
          ),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(child: OutlinedButton.icon(onPressed: () async { final picked = await showDatePicker(context: context, firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 60))); if (picked != null) setState(() => _date = picked); }, icon: const Icon(Icons.calendar_today), label: Text(dateText))),
            const SizedBox(width: 12),
            Expanded(child: OutlinedButton.icon(onPressed: () async { final picked = await showTimePicker(context: context, initialTime: const TimeOfDay(hour: 18, minute: 0)); if (picked != null) setState(() => _time = picked); }, icon: const Icon(Icons.schedule), label: Text(timeText))),
          ]),
          const SizedBox(height: 12),
          CustomTextField(controller: _guestController, label: 'So luong khach', icon: Icons.groups_outlined, keyboardType: TextInputType.number, validator: (v) => validateGuestNumber(int.tryParse(v ?? ''))),
          const SizedBox(height: 12),
          CustomTextField(controller: _noteController, label: 'Ghi chu', icon: Icons.note_alt_outlined, maxLines: 3),
          const SizedBox(height: 18),
          Consumer<BookingProvider>(builder: (context, provider, child) => CustomButton(label: 'Confirm Booking', icon: Icons.event_available, isLoading: provider.isLoading, onPressed: _submit)),
        ]),
      ),
    );
  }
}
