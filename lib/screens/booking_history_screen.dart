import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../providers/booking_provider.dart';
import '../screens/booking_detail_screen.dart';
import '../widgets/booking_card.dart';
import '../widgets/empty_view.dart';
import '../widgets/loading_view.dart';

class BookingHistoryScreen extends StatefulWidget {
  const BookingHistoryScreen({super.key});

  @override
  State<BookingHistoryScreen> createState() => _BookingHistoryScreenState();
}

class _BookingHistoryScreenState extends State<BookingHistoryScreen> {
  @override
  void initState() { super.initState(); WidgetsBinding.instance.addPostFrameCallback((_) { final user = context.read<AuthProvider>().user; if (user != null) context.read<BookingProvider>().loadUserBookings(user.uid); }); }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Lich su booking')),
    body: Consumer<BookingProvider>(builder: (context, provider, child) {
      if (provider.isLoading) return const LoadingView();
      if (provider.bookings.isEmpty) return const EmptyView(message: 'Chua co booking nao');
      return ListView.builder(padding: const EdgeInsets.all(12), itemCount: provider.bookings.length, itemBuilder: (_, i) => BookingCard(booking: provider.bookings[i], onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => BookingDetailScreen(booking: provider.bookings[i])))));
    }),
  );
}
