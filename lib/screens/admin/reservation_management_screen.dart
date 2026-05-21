import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/rustic_widgets.dart';
import '../../models/rustic_models.dart';
import '../../providers/app_state.dart';

class ReservationManagementScreen extends StatelessWidget {
  const ReservationManagementScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return RusticScaffold(
      isAdmin: true,
      currentIndex: 2,
      child: ListView(padding: const EdgeInsets.fromLTRB(22, 24, 22, 110), children: [
        Text('Reservation Management', style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontFamily: null)),
        const SizedBox(height: 10),
        const Text('Approve requests and monitor live floor status.', style: TextStyle(fontSize: 18)),
        const SizedBox(height: 36),
        Row(children: [const Icon(Icons.event_note, color: AppColors.primary), const SizedBox(width: 10), Text('Pending Requests', style: Theme.of(context).textTheme.titleLarge), const Spacer(), Chip(backgroundColor: AppColors.softPink, label: Text('${state.pendingBookings.length} New'))]),
        const SizedBox(height: 18),
        ...state.pendingBookings.map((booking) => _PendingBookingCard(booking: booking)),
        const SizedBox(height: 44),
        Row(children: [const Icon(Icons.map_outlined, color: AppColors.textBrown), const SizedBox(width: 10), Text('Live Floor Plan', style: Theme.of(context).textTheme.titleLarge)]),
        const SizedBox(height: 14),
        const Row(children: [_Legend(color: Colors.white, label: 'Available'), SizedBox(width: 14), _Legend(color: AppColors.softPink, label: 'Reserved'), SizedBox(width: 14), _Legend(color: AppColors.primary, label: 'Occupied')]),
        const SizedBox(height: 18),
        Row(children: [Expanded(child: OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.filter_alt_outlined), label: const Text('Filter'))), const SizedBox(width: 12), Expanded(child: OutlinedButton.icon(onPressed: () => context.push('/admin/tables'), icon: const Icon(Icons.table_restaurant), label: const Text('Quan ly ban')))]),
        const SizedBox(height: 26),
        _FloorPlan(tables: state.activeTables),
      ]),
    );
  }
}

class _PendingBookingCard extends StatelessWidget { const _PendingBookingCard({required this.booking}); final BookingModel2 booking; @override Widget build(BuildContext context) => Card(margin: const EdgeInsets.only(bottom: 28), child: Padding(padding: const EdgeInsets.all(28), child: Column(children: [Row(children: [Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(booking.customerName, style: Theme.of(context).textTheme.titleLarge), Text('◷ ${booking.bookingTime}'), if (booking.note.isNotEmpty) Text('☆ ${booking.note}') ])), Container(width: 56, padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.muted, borderRadius: BorderRadius.circular(8)), child: Column(children: [Text('${booking.numberOfGuests}', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800)), const Text('PAX')]))]), const Divider(height: 28), Row(children: [Expanded(child: FilledButton(onPressed: () => context.read<AppState>().updateBookingStatus(booking, 'confirmed'), child: const Text('✓ Confirm'))), const SizedBox(width: 10), Expanded(child: OutlinedButton(onPressed: () => context.read<AppState>().updateBookingStatus(booking, 'declined'), child: const Text('Decline')))])]))); }

class _Legend extends StatelessWidget { const _Legend({required this.color, required this.label}); final Color color; final String label; @override Widget build(BuildContext context) => Row(children: [Container(width: 16, height: 16, decoration: BoxDecoration(shape: BoxShape.circle, color: color, border: Border.all(color: AppColors.border))), const SizedBox(width: 6), Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700))]); }

class _FloorPlan extends StatelessWidget { const _FloorPlan({required this.tables}); final List<RestaurantTableModel2> tables; @override Widget build(BuildContext context) => Container(height: 560, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)), child: Stack(children: [Positioned(top: 0, left: 155, child: Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppColors.muted, borderRadius: BorderRadius.circular(8)), child: const Text('BAR\nAREA'))), Positioned(right: 0, bottom: 0, child: Container(width: 140, height: 140, alignment: Alignment.center, decoration: BoxDecoration(color: AppColors.background, borderRadius: const BorderRadius.only(topLeft: Radius.circular(34))), child: const RotatedBox(quarterTurns: 3, child: Text('Kitchen')))), ...tables.map((table) => Positioned(left: table.positionX, top: table.positionY, child: _TableMarker(table: table)))])); }

class _TableMarker extends StatelessWidget { const _TableMarker({required this.table}); final RestaurantTableModel2 table; @override Widget build(BuildContext context) { final color = switch (table.status) { 'occupied' => AppColors.primary, 'reserved' => AppColors.softPink, _ => Colors.white }; final textColor = table.status == 'occupied' ? Colors.white : AppColors.textBrown; final shape = table.shape == 'rect' ? RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: const BorderSide(color: AppColors.border)) : const CircleBorder(side: BorderSide(color: AppColors.border)); return Material(color: color, shape: shape, elevation: table.status == 'occupied' ? 5 : 0, child: InkWell(onTap: () => _changeStatus(context), customBorder: shape, child: SizedBox(width: table.shape == 'rect' ? 86 : 72, height: table.shape == 'rect' ? 72 : 72, child: Center(child: Text(table.tableName, style: TextStyle(color: textColor, fontSize: 22, fontWeight: FontWeight.w800)))))); }
  void _changeStatus(BuildContext context) { final next = table.status == 'available' ? 'reserved' : table.status == 'reserved' ? 'occupied' : 'available'; context.read<AppState>().updateTableStatus(table.id, next); }
}

