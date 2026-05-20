import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/restaurant_provider.dart';
import '../utils/bistro_theme.dart';
import '../widgets/admin_bottom_nav.dart';
import '../widgets/admin_header.dart';

class AdminFloorPlanScreen extends StatefulWidget {
  const AdminFloorPlanScreen({super.key});

  @override
  State<AdminFloorPlanScreen> createState() => _AdminFloorPlanScreenState();
}

class _AdminFloorPlanScreenState extends State<AdminFloorPlanScreen> {
  @override
  void initState() { super.initState(); WidgetsBinding.instance.addPostFrameCallback((_) => context.read<RestaurantProvider>().loadRestaurant()); }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Column(children: [
      const AdminHeader(title: "L'Essence Admin", avatarUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=200&q=80'),
      Expanded(child: ListView(padding: const EdgeInsets.fromLTRB(38, 46, 38, 26), children: [
        const Text('FLOOR PLAN', style: TextStyle(fontSize: 21, letterSpacing: 2, color: Color(0xFF586274), fontWeight: FontWeight.w900)),
        const SizedBox(height: 12),
        Row(children: [Expanded(child: Text('Main Dining', style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w900))), Container(padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16), decoration: BoxDecoration(color: BistroColors.muted, borderRadius: BorderRadius.circular(30)), child: const Row(children: [Icon(Icons.calendar_today_outlined), SizedBox(width: 12), Text('Today, 7:00 PM', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900))]))]),
        const SizedBox(height: 42),
        const Row(children: [_Legend(color: BistroColors.sage, label: 'Available'), SizedBox(width: 18), _Legend(color: Colors.red, label: 'Occupied'), SizedBox(width: 18), _Legend(color: Color(0xFFE37B58), label: 'Reserved')]),
        const SizedBox(height: 40),
        Container(height: 760, decoration: BoxDecoration(color: BistroColors.card.withValues(alpha: .45), borderRadius: BorderRadius.circular(48), border: Border.all(color: BistroColors.muted)), child: Stack(children: [
          for (final table in _tables) Positioned(left: table.dx, top: table.dy, child: _TableDot(label: table.label, color: table.color)),
          Positioned(right: 34, bottom: 34, child: Column(children: const [_ZoomButton(icon: Icons.add), SizedBox(height: 18), _ZoomButton(icon: Icons.remove), SizedBox(height: 18), _ZoomButton(icon: Icons.center_focus_strong)])),
        ])),
      ])),
    ]),
    bottomNavigationBar: const AdminBottomNav(currentIndex: 2),
  );
}

class _Legend extends StatelessWidget { const _Legend({required this.color, required this.label}); final Color color; final String label; @override Widget build(BuildContext context) => Row(children: [Container(width: 18, height: 18, decoration: BoxDecoration(shape: BoxShape.circle, color: color)), const SizedBox(width: 8), Text(label, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF586274)))]); }
class _TableDot extends StatelessWidget { const _TableDot({required this.label, required this.color}); final String label; final Color color; @override Widget build(BuildContext context) => Column(children: [Container(width: 28, height: 28, decoration: BoxDecoration(shape: BoxShape.circle, color: color.withValues(alpha: .18), border: Border.all(color: color, width: 2))), const SizedBox(height: 8), Text(label, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600))]); }
class _ZoomButton extends StatelessWidget { const _ZoomButton({required this.icon}); final IconData icon; @override Widget build(BuildContext context) => CircleAvatar(radius: 34, backgroundColor: BistroColors.card, child: Icon(icon, color: BistroColors.ink, size: 30)); }
class _TablePoint { const _TablePoint(this.label, this.dx, this.dy, this.color); final String label; final double dx; final double dy; final Color color; }
const _tables = [_TablePoint('11', 26, 30, BistroColors.sage), _TablePoint('12', 110, 30, BistroColors.sage), _TablePoint('13', 194, 30, Colors.red), _TablePoint('21', 306, 30, Color(0xFFE37B58)), _TablePoint('22', 438, 30, Color(0xFFE37B58)), _TablePoint('30', 60, 160, BistroColors.sage), _TablePoint('B1', 200, 160, BistroColors.sage), _TablePoint('B2', 290, 160, Colors.red), _TablePoint('B3', 380, 160, BistroColors.sage)];
