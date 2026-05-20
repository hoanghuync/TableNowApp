import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../providers/booking_provider.dart';
import '../screens/booking_detail_screen.dart';
import '../utils/bistro_theme.dart';
import '../widgets/bistro_bottom_nav.dart';
import '../widgets/booking_card.dart';
import '../widgets/empty_view.dart';
import '../widgets/loading_view.dart';

class BookingHistoryScreen extends StatefulWidget {
  const BookingHistoryScreen({super.key});

  @override
  State<BookingHistoryScreen> createState() => _BookingHistoryScreenState();
}

class _BookingHistoryScreenState extends State<BookingHistoryScreen> {
  int _tabIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = context.read<AuthProvider>().user;
      if (user != null) context.read<BookingProvider>().loadUserBookings(user.uid);
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Align(alignment: Alignment.centerLeft, child: Text('L?ch h?n', style: TextStyle(color: BistroColors.ember, fontSize: 22))),
      actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.search, color: BistroColors.ember))],
    ),
    body: Consumer<BookingProvider>(builder: (context, provider, child) {
      if (provider.isLoading) return const LoadingView();
      final bookings = provider.bookings.where((booking) => _tabIndex == 0 ? booking.status != 'completed' && booking.status != 'cancelled' : booking.status == 'completed' || booking.status == 'cancelled').toList();
      return ListView(
        padding: const EdgeInsets.fromLTRB(28, 28, 28, 24),
        children: [
          Row(
            children: [
              _TabLabel(label: 'S?p t?i', selected: _tabIndex == 0, onTap: () => setState(() => _tabIndex = 0)),
              const SizedBox(width: 30),
              _TabLabel(label: 'L?ch s?', selected: _tabIndex == 1, onTap: () => setState(() => _tabIndex = 1)),
            ],
          ),
          const Divider(height: 1),
          const SizedBox(height: 58),
          if (bookings.isEmpty) const EmptyView(message: 'Chua có l?ch h?n phù h?p') else ...bookings.map((booking) => BookingCard(booking: booking, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => BookingDetailScreen(booking: booking))))),
        ],
      );
    }),
    bottomNavigationBar: const BistroBottomNav(currentIndex: 2),
  );
}

class _TabLabel extends StatelessWidget {
  const _TabLabel({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        children: [
          Text(label, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: selected ? BistroColors.ember : BistroColors.espresso)),
          const SizedBox(height: 8),
          AnimatedContainer(duration: const Duration(milliseconds: 180), width: selected ? 76 : 0, height: 2, color: BistroColors.ember),
        ],
      ),
    ),
  );
}


