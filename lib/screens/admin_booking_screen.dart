import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/booking_model.dart';
import '../providers/booking_provider.dart';
import '../utils/bistro_theme.dart';
import '../widgets/admin_bottom_nav.dart';
import '../widgets/admin_header.dart';

class AdminBookingScreen extends StatefulWidget {
  const AdminBookingScreen({super.key});

  @override
  State<AdminBookingScreen> createState() => _AdminBookingScreenState();
}

class _AdminBookingScreenState extends State<AdminBookingScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => context.read<BookingProvider>().loadAllBookings());
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Column(
      children: [
        const AdminHeader(avatarUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=200&q=80'),
        Expanded(
          child: Consumer<BookingProvider>(builder: (context, provider, child) {
            final bookings = provider.bookings;
            return ListView(
              padding: const EdgeInsets.fromLTRB(42, 58, 42, 32),
              children: [
                Container(height: 84, padding: const EdgeInsets.symmetric(horizontal: 24), decoration: BoxDecoration(color: BistroColors.muted, borderRadius: BorderRadius.circular(18)), child: const Row(children: [Icon(Icons.search, size: 34, color: Color(0xFF586274)), SizedBox(width: 20), Text('Search reservations...', style: TextStyle(fontSize: 24, color: Color(0xFF586274)))])),
                const SizedBox(height: 28),
                SizedBox(height: 80, child: ListView(scrollDirection: Axis.horizontal, children: const [_AdminFilter(label: 'All', selected: true), _AdminFilter(label: 'Trang thai: Confirmed'), _AdminFilter(label: 'Pending')])),
                const SizedBox(height: 42),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Today', style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.w900)), const Text('Oct 24, 2023', style: TextStyle(fontSize: 24, color: Color(0xFF586274)))]),
                const SizedBox(height: 32),
                if (bookings.isEmpty) const _ReservationCard(name: 'Elena Rostova', time: '19:30', table: 'Table for 4', note: 'Table 12 (Main Dining)', status: 'confirmed') else ...bookings.map((booking) => _ReservationFromBooking(booking: booking)),
                if (bookings.length < 2) const _ReservationCard(name: 'Marcus Vance', time: '20:00', table: 'Table for 2', note: 'VIP - Birthday Note', status: 'pending'),
                if (bookings.length < 3) const _ReservationCard(name: 'Sarah Jenkins', time: '18:45', table: 'Table for 6', note: 'Window Seat', status: 'completed'),
              ],
            );
          }),
        ),
      ],
    ),
    bottomNavigationBar: const AdminBottomNav(currentIndex: 1),
  );
}

class _AdminFilter extends StatelessWidget {
  const _AdminFilter({required this.label, this.selected = false});
  final String label;
  final bool selected;
  @override
  Widget build(BuildContext context) => Container(margin: const EdgeInsets.only(right: 20), padding: const EdgeInsets.symmetric(horizontal: 40), alignment: Alignment.center, decoration: BoxDecoration(color: selected ? BistroColors.ember : BistroColors.muted, borderRadius: BorderRadius.circular(42)), child: Text(label, style: TextStyle(fontSize: 21, fontWeight: FontWeight.w900, color: selected ? Colors.white : BistroColors.espresso)));
}

class _ReservationFromBooking extends StatelessWidget {
  const _ReservationFromBooking({required this.booking});
  final BookingModel booking;
  @override
  Widget build(BuildContext context) => _ReservationCard(name: booking.userId.isEmpty ? 'Guest' : booking.userId, time: booking.bookingTime, table: 'Table for ${booking.numberOfGuests}', note: booking.note.isEmpty ? booking.tableId : booking.note, status: booking.status, booking: booking);
}

class _ReservationCard extends StatelessWidget {
  const _ReservationCard({required this.name, required this.time, required this.table, required this.note, required this.status, this.booking});
  final String name;
  final String time;
  final String table;
  final String note;
  final String status;
  final BookingModel? booking;
  @override
  Widget build(BuildContext context) {
    final statusColor = status == 'confirmed' ? BistroColors.sage : status == 'pending' ? const Color(0xFFE37B58) : const Color(0xFF8B939E);
    return Container(
      margin: const EdgeInsets.only(bottom: 40),
      padding: const EdgeInsets.all(42),
      decoration: BoxDecoration(color: BistroColors.card, borderRadius: BorderRadius.circular(34), boxShadow: BistroShadows.soft, border: Border(left: BorderSide(width: 5, color: statusColor))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [Expanded(child: Text(name, style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w900))), Container(padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12), decoration: BoxDecoration(color: statusColor.withValues(alpha: .12), borderRadius: BorderRadius.circular(24)), child: Text(status, style: TextStyle(fontSize: 20, color: statusColor, fontWeight: FontWeight.w900)))]),
        const SizedBox(height: 12),
        Text('◷ $time  •  ♨ $table', style: const TextStyle(fontSize: 22, color: Color(0xFF586274), fontWeight: FontWeight.w800)),
        const Divider(height: 44),
        Row(children: [Expanded(child: Text(note, style: const TextStyle(fontSize: 21, color: BistroColors.espresso))), OutlinedButton(onPressed: () {}, style: OutlinedButton.styleFrom(shape: const CircleBorder(), fixedSize: const Size(68, 68)), child: const Icon(Icons.edit, size: 30)), const SizedBox(width: 16), FilledButton(onPressed: booking == null ? null : () => context.read<BookingProvider>().updateStatus(booking!, 'confirmed'), style: FilledButton.styleFrom(shape: const CircleBorder(), fixedSize: const Size(68, 68)), child: const Icon(Icons.check, size: 34))]),
      ]),
    );
  }
}
