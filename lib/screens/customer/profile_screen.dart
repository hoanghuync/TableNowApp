import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/money_formatter.dart';
import '../../core/widgets/rustic_widgets.dart';
import '../../providers/app_state.dart';

class ProfileScreenRustic extends StatelessWidget {
  const ProfileScreenRustic({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final user = state.currentUser;
    final orderItems = state.myOrders.expand((order) => order.items).toList();
    return RusticScaffold(
      currentIndex: 3,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 100),
        children: [
          Center(
            child: Column(
              children: [
                Stack(children: [RusticImage(user?.avatarUrl ?? '', width: 120, height: 120, borderRadius: 60), Positioned(right: 0, bottom: 8, child: CircleAvatar(backgroundColor: AppColors.primary, child: IconButton(onPressed: () {}, icon: const Icon(Icons.edit, color: Colors.white, size: 18))))]),
                const SizedBox(height: 12),
                Text(user?.fullName ?? 'Guest', style: Theme.of(context).textTheme.titleLarge),
                Text(user?.phone ?? ''),
                const SizedBox(height: 8),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [Chip(label: Text(user?.membershipLevel ?? 'Thanh vien')), const SizedBox(width: 8), Chip(backgroundColor: AppColors.softPink, label: Text('${user?.points ?? 0} Diem'))]),
              ],
            ),
          ),
          const SizedBox(height: 24),
          FilledButton(onPressed: () {}, child: const Text('Chinh sua ho so')),
          OutlinedButton(onPressed: () {}, child: const Text('Cai dat')),
          const SizedBox(height: 26),
          Text('Lich su dat ban', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          ...state.myBookings.map((booking) => Card(margin: const EdgeInsets.only(bottom: 12), child: ListTile(title: Text('${booking.bookingTime} - ${booking.numberOfGuests} nguoi'), subtitle: Text(booking.note.isEmpty ? booking.tableId : booking.note), trailing: Chip(label: Text(booking.status)), onTap: () {}))),
          const SizedBox(height: 22),
          Text('Lich su goi mon', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          ...orderItems.map((item) => Card(
            margin: const EdgeInsets.only(bottom: 14),
            clipBehavior: Clip.antiAlias,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              RusticImage(item.imageUrl, height: 150, width: double.infinity, borderRadius: 0),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(item.name, style: const TextStyle(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 6),
                  Text(MoneyFormatter.vnd(item.price), style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w800)),
                  Align(alignment: Alignment.centerRight, child: TextButton.icon(onPressed: () { final menu = state.menuItems.firstWhere((m) => m.id == item.itemId); context.read<AppState>().addToCart(menu); }, icon: const Icon(Icons.refresh), label: const Text('Dat lai'))),
                ]),
              ),
            ]),
          )),
          const SizedBox(height: 18),
          OutlinedButton(onPressed: () => context.read<AppState>().logout(), child: const Text('Dang xuat')),
        ],
      ),
    );
  }
}
