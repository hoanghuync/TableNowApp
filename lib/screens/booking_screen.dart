import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../providers/booking_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/restaurant_provider.dart';
import '../utils/bistro_theme.dart';
import '../utils/date_time_utils.dart';
import '../utils/money_utils.dart';
import '../utils/validators.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _noteController = TextEditingController();
  DateTime? _date;
  String? _time;
  int _guestCount = 0;
  String? _tableId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => context.read<RestaurantProvider>().loadRestaurant());
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final restaurantProvider = context.read<RestaurantProvider>();
    final restaurant = restaurantProvider.restaurant;
    final auth = context.read<AuthProvider>();
    final dateError = validateBookingDate(_date);
    if (dateError != null) return _show(dateError);
    if (_time == null) return _show('Vui lòng ch?n th?i gian');
    final guestError = validateGuestNumber(_guestCount);
    if (guestError != null) return _show('Vui lòng ch?n s? lu?ng khách');
    if (_tableId == null) return _show('Vui lòng ch?n Ban phu hop');
    if (restaurant == null) return _show('Chua t?i du?c thông tin nhà hàng');
    if (!auth.isLoggedIn) return _show('Ban can dang nhap de dat ban');

    final dateText = DateTimeUtils.formatDate(_date!);
    final timeError = validateBookingTime(date: dateText, time: _time, openTime: restaurant.openTime, closeTime: restaurant.closeTime);
    if (timeError != null) return _show(timeError);

    final cart = context.read<CartProvider>();
    final ok = await context.read<BookingProvider>().createBooking(
      userId: auth.user!.uid,
      restaurantId: restaurant.id,
      tableId: _tableId!,
      bookingDate: dateText,
      bookingTime: _time!,
      numberOfGuests: _guestCount,
      note: _noteController.text,
      selectedItems: cart.items,
      openTime: restaurant.openTime,
      closeTime: restaurant.closeTime,
    );
    if (!mounted) return;
    final bookingProvider = context.read<BookingProvider>();
    _show(ok ? 'Ð?t bàn thành công' : bookingProvider.error ?? 'Ð?t bàn th?t b?i');
    if (ok) {
      cart.clear();
      Navigator.pop(context);
    }
  }

  void _show(String message) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));

  void _selectGuest(int guests) {
    final tables = context.read<RestaurantProvider>().availableTablesForGuests(guests);
    setState(() {
      _guestCount = guests;
      if (_tableId != null && !tables.any((table) => table.id == _tableId)) _tableId = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final restaurantProvider = context.watch<RestaurantProvider>();
    final cart = context.watch<CartProvider>();
    final restaurant = restaurantProvider.restaurant;
    final availableTables = restaurantProvider.availableTablesForGuests(_guestCount);
    final dates = List.generate(12, (index) => DateTime.now().add(Duration(days: index)));
    final timeSlots = const ['18:00', '18:30', '19:00', '19:30', '20:00', '20:30'];

    return Scaffold(
      body: Stack(
        children: [
          ListView(
            padding: EdgeInsets.zero,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(height: 250, width: double.infinity, child: Image.network(_bookingHero, fit: BoxFit.cover, errorBuilder: (imageContext, error, stackTrace) => Container(color: BistroColors.muted))),
                  Container(height: 250, decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [BistroColors.cream.withValues(alpha: .15), BistroColors.cream]))),
                  SafeArea(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.location_on_outlined, color: BistroColors.ember)), const Text('BistroFlow', style: TextStyle(color: BistroColors.ember, fontSize: 17, fontWeight: FontWeight.w800)), IconButton(onPressed: () {}, icon: const Icon(Icons.search, color: BistroColors.ember))]),
                        ),
                        const SizedBox(height: 58),
                        Text('Ð?t Bàn', style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.w900, color: BistroColors.ink)),
                        const SizedBox(height: 6),
                        const Text('Trai nghiem am thuc tinh te va tron ven.', style: TextStyle(fontSize: 17, color: BistroColors.espresso)),
                      ],
                    ),
                  ),
                ],
              ),
              Transform.translate(
                offset: const Offset(0, -18),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  padding: const EdgeInsets.fromLTRB(26, 26, 26, 30),
                  decoration: BoxDecoration(color: BistroColors.card, borderRadius: BorderRadius.circular(18), boxShadow: BistroShadows.soft),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Ngày', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)), Text(_monthLabel(_date ?? DateTime.now()), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, letterSpacing: 1.2))]),
                      const SizedBox(height: 18),
                      Wrap(
                        spacing: 13,
                        runSpacing: 14,
                        children: [for (final date in dates) _DayChip(date: date, selected: _isSameDay(date, _date), onTap: () => setState(() => _date = date))],
                      ),
                      const Divider(height: 54),
                      const Text('Th?i gian', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                      const SizedBox(height: 18),
                      Wrap(
                        spacing: 12,
                        runSpacing: 14,
                        children: [for (final slot in timeSlots) _ChoicePill(label: slot, selected: _time == slot, onTap: () => setState(() => _time = slot))],
                      ),
                      const Divider(height: 54),
                      const Text('S? lu?ng khách', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                      const SizedBox(height: 18),
                      Wrap(
                        spacing: 14,
                        runSpacing: 14,
                        children: [for (final guests in const [1, 2, 3, 4, 5, 6]) _RoundGuest(label: guests == 6 ? '6+' : '$guests', selected: _guestCount == guests, onTap: () => _selectGuest(guests))],
                      ),
                      const SizedBox(height: 18),
                      DropdownButtonFormField<String>(
                        initialValue: availableTables.any((table) => table.id == _tableId) ? _tableId : null,
                        decoration: InputDecoration(labelText: 'Ban phu hop', helperText: _guestCount == 0 ? 'Chon so khach de xem ban trong' : 'Chi hien ban available va du suc chua'),
                        items: availableTables.map((table) => DropdownMenuItem(value: table.id, child: Text('${table.tableName} · t?i da ${table.capacity} khách'))).toList(),
                        onChanged: _guestCount == 0 ? null : (value) => setState(() => _tableId = value),
                      ),
                      const Divider(height: 54),
                      const Text('Ghi chú d?c bi?t', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                      const SizedBox(height: 14),
                      TextField(controller: _noteController, maxLines: 4, decoration: const InputDecoration(hintText: 'Di ung thuc pham, ky niem, yeu cau vi tri ngoi...')),
                      const SizedBox(height: 18),
                      Card(
                        color: BistroColors.cream,
                        child: ListTile(
                          title: Text(restaurant?.name ?? 'TableNow Bistro'),
                          subtitle: Text('${cart.totalQuantity} mon dat truoc · ${MoneyUtils.format(cart.totalAmount)}'),
                          trailing: const Icon(Icons.restaurant_menu, color: BistroColors.ember),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 90),
            ],
          ),
          Positioned(
            left: 24,
            right: 24,
            bottom: 18,
            child: SafeArea(top: false, child: Consumer<BookingProvider>(builder: (context, provider, child) => FilledButton.icon(onPressed: provider.isLoading ? null : _submit, icon: provider.isLoading ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const SizedBox.shrink(), label: const Text('Xac nhan dat ban ->')))),
          ),
        ],
      ),
    );
  }

  static bool _isSameDay(DateTime a, DateTime? b) => b != null && a.year == b.year && a.month == b.month && a.day == b.day;
  static String _monthLabel(DateTime date) => 'THÁNG ${date.month}, ${date.year}';
}

class _DayChip extends StatelessWidget {
  const _DayChip({required this.date, required this.selected, required this.onTap});

  final DateTime date;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    customBorder: const CircleBorder(),
    onTap: onTap,
    child: Container(
      width: 44,
      height: 54,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: selected ? BistroColors.ember : Colors.transparent, shape: BoxShape.circle, boxShadow: selected ? BistroShadows.soft : null),
      child: Text('${date.day}', style: TextStyle(fontSize: 17, color: selected ? Colors.white : BistroColors.ink, fontWeight: selected ? FontWeight.w900 : FontWeight.w500)),
    ),
  );
}

class _ChoicePill extends StatelessWidget {
  const _ChoicePill({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => OutlinedButton(
    onPressed: onTap,
    style: OutlinedButton.styleFrom(fixedSize: const Size(94, 54), foregroundColor: selected ? BistroColors.ember : BistroColors.espresso, side: BorderSide(color: selected ? BistroColors.ember : BistroColors.muted, width: selected ? 2 : 1), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
    child: Text(label, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
  );
}

class _RoundGuest extends StatelessWidget {
  const _RoundGuest({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    customBorder: const CircleBorder(),
    onTap: onTap,
    child: Container(width: 52, height: 52, alignment: Alignment.center, decoration: BoxDecoration(shape: BoxShape.circle, color: selected ? BistroColors.ember : BistroColors.muted), child: Text(label, style: TextStyle(fontSize: 17, color: selected ? Colors.white : BistroColors.ink, fontWeight: FontWeight.w700))),
  );
}

const _bookingHero = 'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?auto=format&fit=crop&w=1000&q=80';



