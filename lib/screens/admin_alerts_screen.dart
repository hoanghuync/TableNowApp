import 'package:flutter/material.dart';

import '../utils/bistro_theme.dart';
import '../widgets/admin_bottom_nav.dart';
import '../widgets/admin_header.dart';

class AdminAlertsScreen extends StatelessWidget {
  const AdminAlertsScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Column(children: [
      const AdminHeader(avatarUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=200&q=80'),
      Expanded(child: ListView(padding: const EdgeInsets.fromLTRB(32, 58, 32, 26), children: [
        Text('Alerts', style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w900)),
        const SizedBox(height: 10),
        const Text("Stay updated on your restaurant's activity.", style: TextStyle(fontSize: 22, color: Color(0xFF586274))),
        const SizedBox(height: 70),
        const _Section('HOM NAY'),
        const SizedBox(height: 32),
        const _AdminAlertCard(icon: Icons.event_available, title: 'New Booking', message: 'Table for 4 at 7:30 PM. Party of Mr. Nguyen.', time: '10:42 AM', iconColor: Color(0xFFFFD4CA)),
        const SizedBox(height: 18),
        const _AdminAlertCard(icon: Icons.cancel_outlined, title: 'Cancellation', message: 'Table for 2 at 8:00 PM has been cancelled.', time: '09:15 AM', iconColor: Color(0xFFFFD7D7), danger: true),
        const SizedBox(height: 72),
        const _Section('TRUOC DO'),
        const SizedBox(height: 32),
        const _AdminAlertCard(icon: Icons.room_service_outlined, title: 'Guest Request', message: 'VIP Guest note added: Severe peanut allergy.', time: 'Yesterday', iconColor: BistroColors.sage),
        const SizedBox(height: 18),
        const _AdminAlertCard(icon: Icons.edit_calendar_outlined, title: 'Booking Updated', message: 'Party size increased from 2 to 4 for 6:00 PM.', time: 'Yesterday', iconColor: Color(0xFFD9E5F6)),
      ])),
    ]),
    bottomNavigationBar: const AdminBottomNav(currentIndex: 3),
  );
}

class _Section extends StatelessWidget { const _Section(this.text); final String text; @override Widget build(BuildContext context) => Text(text, style: const TextStyle(fontSize: 18, letterSpacing: 1.8, fontWeight: FontWeight.w900, color: Color(0xFF586274))); }

class _AdminAlertCard extends StatelessWidget {
  const _AdminAlertCard({required this.icon, required this.title, required this.message, required this.time, required this.iconColor, this.danger = false});
  final IconData icon;
  final String title;
  final String message;
  final String time;
  final Color iconColor;
  final bool danger;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(34),
    decoration: BoxDecoration(color: BistroColors.card, borderRadius: BorderRadius.circular(32), boxShadow: BistroShadows.soft),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [CircleAvatar(radius: 32, backgroundColor: iconColor.withValues(alpha: danger ? .9 : .95), child: Icon(icon, color: danger ? Colors.red : BistroColors.ink)), const SizedBox(width: 34), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, height: 1.1)), const SizedBox(height: 12), Text(message, style: const TextStyle(fontSize: 21, height: 1.35, color: Color(0xFF586274)))])), const SizedBox(width: 12), Text(time, style: const TextStyle(fontSize: 20, color: Color(0xFF586274), fontWeight: FontWeight.w800))]),
  );
}
