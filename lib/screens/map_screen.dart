import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../providers/restaurant_provider.dart';
import '../widgets/loading_view.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  void initState() { super.initState(); WidgetsBinding.instance.addPostFrameCallback((_) => context.read<RestaurantProvider>().loadRestaurant()); }

  Future<void> _openMaps(String address) async {
    final uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(address)}');
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Vi tri nha hang')),
    body: Consumer<RestaurantProvider>(builder: (context, provider, child) {
      if (provider.isLoading) return const LoadingView();
      final r = provider.restaurant;
      if (r == null) return const Center(child: Text('Chua co dia chi'));
      return Padding(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Expanded(child: Container(decoration: BoxDecoration(color: Theme.of(context).colorScheme.tertiaryContainer, borderRadius: BorderRadius.circular(28)), child: const Icon(Icons.map, size: 96))),
        const SizedBox(height: 18),
        Text(r.address, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        FilledButton.icon(onPressed: () => _openMaps(r.address), icon: const Icon(Icons.open_in_new), label: const Text('Mo Google Maps')),
      ]));
    }),
  );
}


