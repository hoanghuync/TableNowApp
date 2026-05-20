import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/booking_model.dart';
import '../providers/booking_provider.dart';
import '../screens/review_screen.dart';
import '../utils/money_utils.dart';

class BookingDetailScreen extends StatelessWidget {
  const BookingDetailScreen({super.key, required this.booking});

  final BookingModel booking;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Chi tiet booking')),
    body: ListView(padding: const EdgeInsets.all(16), children: [
      Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('${booking.bookingDate} - ${booking.bookingTime}', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Text('Trang thai: ${booking.status}'),
        Text('So khach: ${booking.numberOfGuests}'),
        Text('Ghi chu: ${booking.note.isEmpty ? 'Khong co' : booking.note}'),
        Text('Tong tien dat mon: ${MoneyUtils.format(booking.totalAmount)}'),
      ]))),
      const SizedBox(height: 12),
      Text('Mon da chon', style: Theme.of(context).textTheme.titleMedium),
      ...booking.selectedItems.map((item) => ListTile(title: Text(item.name), subtitle: Text('x${item.quantity}'), trailing: Text(MoneyUtils.format(item.lineTotal)))),
      if (booking.canCustomerCancel) FilledButton.tonalIcon(onPressed: () async { final ok = await context.read<BookingProvider>().cancel(booking); if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(ok ? 'Da huy booking' : 'Khong the huy booking'))); }, icon: const Icon(Icons.cancel_outlined), label: const Text('Huy booking')),
      if (booking.canReview) FilledButton.icon(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ReviewScreen(booking: booking))), icon: const Icon(Icons.star_outline), label: const Text('Danh gia dich vu')),
    ]),
  );
}


