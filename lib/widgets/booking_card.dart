import 'package:flutter/material.dart';

import '../models/booking_model.dart';
import '../utils/money_utils.dart';

class BookingCard extends StatelessWidget {
  const BookingCard({super.key, required this.booking, required this.onTap});

  final BookingModel booking;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = switch (booking.status) { 'confirmed' => Colors.green, 'cancelled' => Colors.red, 'completed' => Colors.blueGrey, _ => Colors.orange };
    return Card(
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(backgroundColor: color.withValues(alpha: .12), child: Icon(Icons.event_seat, color: color)),
        title: Text('${booking.bookingDate} - ${booking.bookingTime}'),
        subtitle: Text('${booking.numberOfGuests} khach - ${MoneyUtils.format(booking.totalAmount)}'),
        trailing: Chip(label: Text(booking.status), visualDensity: VisualDensity.compact),
      ),
    );
  }
}
