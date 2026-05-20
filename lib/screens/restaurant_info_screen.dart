import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/restaurant_provider.dart';
import '../widgets/loading_view.dart';

class RestaurantInfoScreen extends StatefulWidget {
  const RestaurantInfoScreen({super.key});

  @override
  State<RestaurantInfoScreen> createState() => _RestaurantInfoScreenState();
}

class _RestaurantInfoScreenState extends State<RestaurantInfoScreen> {
  @override
  void initState() { super.initState(); WidgetsBinding.instance.addPostFrameCallback((_) => context.read<RestaurantProvider>().loadRestaurant()); }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Thong tin nha hang')),
    body: Consumer<RestaurantProvider>(builder: (context, provider, child) {
      if (provider.isLoading) return const LoadingView();
      final r = provider.restaurant;
      if (r == null) return const Center(child: Text('Chua co thong tin nha hang'));
      return ListView(padding: const EdgeInsets.all(16), children: [
        Container(height: 180, decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryContainer, borderRadius: BorderRadius.circular(24)), child: const Icon(Icons.storefront, size: 72)),
        const SizedBox(height: 18),
        Text(r.name, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
        const SizedBox(height: 8),
        Text(r.description),
        const Divider(height: 32),
        ListTile(leading: const Icon(Icons.location_on_outlined), title: Text(r.address)),
        ListTile(leading: const Icon(Icons.phone_outlined), title: Text(r.phone)),
        ListTile(leading: const Icon(Icons.schedule), title: Text('${r.openTime} - ${r.closeTime}')),
      ]);
    }),
  );
}
