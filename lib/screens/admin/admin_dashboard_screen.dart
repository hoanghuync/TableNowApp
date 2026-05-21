import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/money_formatter.dart';
import '../../core/widgets/rustic_widgets.dart';
import '../../providers/app_state.dart';

class AdminDashboardScreenRustic extends StatelessWidget {
  const AdminDashboardScreenRustic({super.key});
  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return RusticScaffold(
      isAdmin: true,
      currentIndex: 0,
      child: ListView(padding: const EdgeInsets.all(36), children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Overview', style: Theme.of(context).textTheme.displayLarge), const Icon(Icons.menu, color: AppColors.primary, size: 34)]),
        const SizedBox(height: 10),
        const Text("Here's what's happening in the kitchen today.", style: TextStyle(fontSize: 24, height: 1.4)),
        const SizedBox(height: 28),
        OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.calendar_today), label: const Text('Oct 24, 2023')),
        const SizedBox(height: 46),
        Container(padding: const EdgeInsets.all(36), decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border), gradient: LinearGradient(colors: [Colors.white, AppColors.softPink.withValues(alpha: .25)])), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children: [Container(padding: const EdgeInsets.all(18), decoration: BoxDecoration(color: AppColors.secondary, borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.payments_outlined, color: Colors.white)), const SizedBox(width: 18), const Expanded(child: Text("Today's Revenue", style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700))), const Chip(label: Text('+12%'))]), const SizedBox(height: 50), Text(MoneyFormatter.vnd(state.todayRevenue), style: Theme.of(context).textTheme.displayLarge?.copyWith(color: AppColors.primary)), const Text('vs. 4,320,000d yesterday', style: TextStyle(fontWeight: FontWeight.w700))])),
        const SizedBox(height: 30),
        _AdminMetric(title: 'New Bookings', value: '${state.todayBookings}', subtitle: "For tonight's service", icon: Icons.book_online_outlined),
        const SizedBox(height: 30),
        _OccupancyCard(rate: state.occupancyRate, occupied: state.activeTables.where((t) => t.status == 'occupied').length, total: state.activeTables.length),
      ]),
    );
  }
}

class _AdminMetric extends StatelessWidget { const _AdminMetric({required this.title, required this.value, required this.subtitle, required this.icon}); final String title; final String value; final String subtitle; final IconData icon; @override Widget build(BuildContext context) => Card(child: Padding(padding: const EdgeInsets.all(36), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [CircleAvatar(radius: 28, backgroundColor: AppColors.softPink, child: Icon(icon, color: AppColors.primary)), const SizedBox(height: 34), Text(title, style: const TextStyle(fontSize: 24)), Text(value, style: Theme.of(context).textTheme.displayLarge), Text(subtitle, style: const TextStyle(fontWeight: FontWeight.w700))]))); }
class _OccupancyCard extends StatelessWidget { const _OccupancyCard({required this.rate, required this.occupied, required this.total}); final double rate; final int occupied; final int total; @override Widget build(BuildContext context) => Card(child: Padding(padding: const EdgeInsets.all(36), child: Row(children: [Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Table Occupancy', style: TextStyle(fontSize: 24)), Text('${(rate * 100).round()}%', style: Theme.of(context).textTheme.displayLarge), Text('$occupied/$total Tables seated', style: const TextStyle(fontWeight: FontWeight.w700))])), SizedBox(width: 120, height: 120, child: CircularProgressIndicator(value: rate, strokeWidth: 14, color: AppColors.textBrown, backgroundColor: AppColors.muted))]))); }
