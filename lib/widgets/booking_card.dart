import 'package:flutter/material.dart';

import '../models/booking_model.dart';
import '../utils/bistro_theme.dart';

class BookingCard extends StatelessWidget {
  const BookingCard({super.key, required this.booking, required this.onTap});

  final BookingModel booking;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final status = _statusMeta(booking.status);
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 28),
        decoration: BoxDecoration(color: BistroColors.card, borderRadius: BorderRadius.circular(16), boxShadow: BistroShadows.soft),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                AspectRatio(aspectRatio: 1.65, child: Image.network(_imageForStatus(booking.status), fit: BoxFit.cover, errorBuilder: (imageContext, error, stackTrace) => Container(color: BistroColors.muted))),
                Positioned(top: 18, right: 18, child: _StatusBadge(label: status.label, color: status.color)),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 26, 28, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('TableNow Bistro', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 10),
                  const Row(children: [Icon(Icons.restaurant, size: 18, color: BistroColors.espresso), SizedBox(width: 8), Text('Am thuc hien dai', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: BistroColors.espresso))]),
                  const Divider(height: 30),
                  _InfoLine(icon: Icons.calendar_today_outlined, text: _formatDate(booking.bookingDate)),
                  const SizedBox(height: 12),
                  _InfoLine(icon: Icons.schedule, text: booking.bookingTime),
                  const SizedBox(height: 12),
                  _InfoLine(icon: Icons.groups_outlined, text: '${booking.numberOfGuests} nguoi'),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(child: OutlinedButton(onPressed: onTap, child: Text(booking.canCustomerCancel ? 'Sua' : 'Chi tiet'))),
                      const SizedBox(width: 14),
                      Expanded(child: FilledButton(onPressed: onTap, child: Text(booking.canCustomerCancel ? 'Chi duong' : 'Xem lai'))),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _formatDate(String value) {
    final date = DateTime.tryParse(value);
    if (date == null) return value;
    final weekdays = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '${weekdays[date.weekday - 1]}, $day/$month/${date.year}';
  }

  static _StatusMeta _statusMeta(String status) => switch (status) {
    'confirmed' => const _StatusMeta('Da xac nhan', BistroColors.sage),
    'cancelled' => const _StatusMeta('Da huy', Colors.redAccent),
    'completed' => const _StatusMeta('Hoan thanh', Colors.blueGrey),
    _ => const _StatusMeta('Cho xac nhan', Color(0xFF8B7D74)),
  };

  static String _imageForStatus(String status) => status == 'pending' ? 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=900&q=80' : 'https://images.unsplash.com/photo-1514933651103-005eec06c04b?auto=format&fit=crop&w=900&q=80';
}

class _InfoLine extends StatelessWidget {
  const _InfoLine({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => Row(children: [Icon(icon, size: 22, color: BistroColors.ember), const SizedBox(width: 14), Text(text, style: const TextStyle(fontSize: 18, color: BistroColors.ink))]);
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
    decoration: BoxDecoration(color: BistroColors.card, borderRadius: BorderRadius.circular(22)),
    child: Row(mainAxisSize: MainAxisSize.min, children: [Container(width: 9, height: 9, decoration: BoxDecoration(color: color, shape: BoxShape.circle)), const SizedBox(width: 7), Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800))]),
  );
}

class _StatusMeta {
  const _StatusMeta(this.label, this.color);
  final String label;
  final Color color;
}


