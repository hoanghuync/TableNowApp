import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/booking_model.dart';
import '../providers/booking_provider.dart';
import '../utils/app_constants.dart';
import '../widgets/booking_card.dart';
import '../widgets/empty_view.dart';
import '../widgets/loading_view.dart';

class AdminBookingScreen extends StatefulWidget {
  const AdminBookingScreen({super.key});

  @override
  State<AdminBookingScreen> createState() => _AdminBookingScreenState();
}

class _AdminBookingScreenState extends State<AdminBookingScreen> {
  @override
  void initState() { super.initState(); WidgetsBinding.instance.addPostFrameCallback((_) => context.read<BookingProvider>().loadAllBookings()); }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Admin booking')),
    body: Consumer<BookingProvider>(builder: (context, provider, child) {
      if (provider.isLoading) return const LoadingView();
      if (provider.bookings.isEmpty) return const EmptyView(message: 'Chua co booking nao');
      final stats = provider.countByDate();
      return ListView(padding: const EdgeInsets.all(12), children: [
        Card(child: Padding(padding: const EdgeInsets.all(16), child: Text('Thong ke: ${stats.entries.map((e) => '${e.key}: ${e.value}').join(' | ')}'))),
        ...provider.bookings.map((booking) => BookingCard(booking: booking, onTap: () => _showStatusSheet(context, booking))),
      ]);
    }),
  );

  void _showStatusSheet(BuildContext context, BookingModel booking) {
    showModalBottomSheet<void>(context: context, builder: (_) => SafeArea(child: Column(mainAxisSize: MainAxisSize.min, children: AppConstants.bookingStatuses.map((status) => ListTile(title: Text('Cap nhat: $status'), onTap: () async { Navigator.pop(context); final ok = await context.read<BookingProvider>().updateStatus(booking, status); if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(ok ? 'Da cap nhat booking' : 'Cap nhat that bai'))); })).toList())));
  }
}
