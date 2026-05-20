import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/booking_model.dart';
import '../providers/booking_provider.dart';
import '../utils/bistro_theme.dart';
import '../widgets/admin_bottom_nav.dart';
import '../widgets/admin_header.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => context.read<BookingProvider>().loadAllBookings());
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Column(
      children: [
        const AdminHeader(),
        Expanded(
          child: Consumer<BookingProvider>(builder: (context, provider, child) {
            final bookings = provider.bookings;
            final pending = bookings.where((booking) => booking.status == 'pending').toList();
            final guests = bookings.fold<int>(0, (total, booking) => total + booking.numberOfGuests);
            return ListView(
              padding: const EdgeInsets.fromLTRB(26, 24, 26, 26),
              children: [
                Text('Tong quan hom nay', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900)),
                const SizedBox(height: 6),
                const Text('Thu Sau, 24 Thang 10', style: TextStyle(fontSize: 18, color: Color(0xFF586274))),
                const SizedBox(height: 56),
                Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(color: BistroColors.ember, borderRadius: BorderRadius.circular(12), boxShadow: BistroShadows.soft),
                  child: const Row(children: [Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('↗  Doanh thu uoc tinh', style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w800, letterSpacing: 1.2)), SizedBox(height: 18), Text('32.5M VND', style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.w900))])), Icon(Icons.payments_outlined, color: Color(0x44FFFFFF), size: 86)]),
                ),
                const SizedBox(height: 20),
                Row(children: [Expanded(child: _MetricCard(icon: Icons.groups_outlined, value: '$guests', label: 'So khach du kien')), const SizedBox(width: 14), Expanded(child: _MetricCard(icon: Icons.table_restaurant_outlined, value: '${bookings.length}', label: 'Ban da dat'))]),
                const SizedBox(height: 34),
                Container(height: 180, padding: const EdgeInsets.all(28), decoration: BoxDecoration(color: BistroColors.card, borderRadius: BorderRadius.circular(16), boxShadow: BistroShadows.soft), child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('GIO CAO DIEM', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.3)), Icon(Icons.bar_chart, color: Color(0xFF586274))]), Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: const [Text('17:00'), Text('18:00'), Text('19:00', style: TextStyle(color: BistroColors.ember, fontWeight: FontWeight.w900)), Text('20:00'), Text('21:00')])])),
                const SizedBox(height: 34),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Yeu cau moi', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)), CircleAvatar(radius: 14, backgroundColor: Colors.red, child: Text('${pending.length}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900)))]),
                const SizedBox(height: 20),
                if (pending.isEmpty) const _RequestCard(name: 'Minh Tran', note: 'VIP • Ky niem ngay cuoi', time: '19:30, Toi nay', guests: '2 Nguoi') else ...pending.take(2).map((booking) => _BookingRequestCard(booking: booking)),
                if (pending.length < 2) const _RequestCard(name: 'Hoang Nguyen', note: 'Khach vang lai', time: '20:00, Toi nay', guests: '4 Nguoi'),
              ],
            );
          }),
        ),
      ],
    ),
    bottomNavigationBar: const AdminBottomNav(currentIndex: 0),
  );
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.icon, required this.value, required this.label});
  final IconData icon;
  final String value;
  final String label;
  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(28), decoration: BoxDecoration(color: BistroColors.card, borderRadius: BorderRadius.circular(14), boxShadow: BistroShadows.soft), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [CircleAvatar(backgroundColor: BistroColors.muted, child: Icon(icon, color: BistroColors.ember)), const SizedBox(height: 18), Text(value, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900)), Text(label, style: const TextStyle(fontSize: 16, color: Color(0xFF586274), height: 1.2))]));
}

class _BookingRequestCard extends StatelessWidget {
  const _BookingRequestCard({required this.booking});
  final BookingModel booking;
  @override
  Widget build(BuildContext context) => _RequestCard(name: booking.userId.isEmpty ? 'Guest' : booking.userId, note: booking.note.isEmpty ? 'Khach dat ban' : booking.note, time: '${booking.bookingTime}, ${booking.bookingDate}', guests: '${booking.numberOfGuests} Nguoi', booking: booking);
}

class _RequestCard extends StatelessWidget {
  const _RequestCard({required this.name, required this.note, required this.time, required this.guests, this.booking});
  final String name;
  final String note;
  final String time;
  final String guests;
  final BookingModel? booking;
  @override
  Widget build(BuildContext context) => Container(margin: const EdgeInsets.only(bottom: 18), padding: const EdgeInsets.all(28), decoration: BoxDecoration(color: BistroColors.card, borderRadius: BorderRadius.circular(14), boxShadow: BistroShadows.soft), child: Column(children: [Row(children: [CircleAvatar(radius: 28, backgroundColor: BistroColors.muted, child: Text(name.characters.first, style: const TextStyle(fontSize: 20))), const SizedBox(width: 16), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900)), Text(note, style: const TextStyle(fontSize: 16, color: Color(0xFF586274)))]))]), const Divider(height: 34), Row(children: [Expanded(child: Text('◷ $time   ♨ $guests', style: const TextStyle(fontWeight: FontWeight.w800, color: BistroColors.espresso)))]), const SizedBox(height: 22), Row(children: [Expanded(child: FilledButton(onPressed: booking == null ? null : () => context.read<BookingProvider>().updateStatus(booking!, 'confirmed'), child: const Text('Chap nhan'))), const SizedBox(width: 14), Expanded(child: OutlinedButton(onPressed: booking == null ? null : () => context.read<BookingProvider>().updateStatus(booking!, 'cancelled'), child: const Text('Tu choi')))])]));
}
