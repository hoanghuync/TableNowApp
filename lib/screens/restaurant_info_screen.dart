import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/menu_provider.dart';
import '../providers/restaurant_provider.dart';
import '../utils/app_routes.dart';
import '../utils/bistro_theme.dart';
import '../utils/money_utils.dart';
import '../widgets/loading_view.dart';

class RestaurantInfoScreen extends StatefulWidget {
  const RestaurantInfoScreen({super.key});

  @override
  State<RestaurantInfoScreen> createState() => _RestaurantInfoScreenState();
}

class _RestaurantInfoScreenState extends State<RestaurantInfoScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final restaurantProvider = context.read<RestaurantProvider>();
      await restaurantProvider.loadRestaurant();
      if (mounted && restaurantProvider.restaurant != null) {
        context.read<MenuProvider>().loadMenu(restaurantProvider.restaurant!.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Consumer<RestaurantProvider>(builder: (context, provider, child) {
      if (provider.isLoading) return const LoadingView();
      final restaurant = provider.restaurant;
      if (restaurant == null) return const Center(child: Text('Chua có thông tin nhà hàng'));
      final imageUrl = restaurant.imageUrl.isNotEmpty ? restaurant.imageUrl : _heroImage;
      return Stack(
        children: [
          ListView(
            padding: EdgeInsets.zero,
            children: [
              Stack(
                children: [
                  SizedBox(
                    height: 330,
                    width: double.infinity,
                    child: Image.network(imageUrl, fit: BoxFit.cover, errorBuilder: (imageContext, error, stackTrace) => Container(color: BistroColors.muted)),
                  ),
                  Container(height: 330, decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.white.withValues(alpha: .35), BistroColors.cream.withValues(alpha: .9)]))),
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _CircleIcon(icon: Icons.arrow_back, onTap: () => Navigator.pop(context)),
                          Row(children: const [_CircleIcon(icon: Icons.share_outlined), SizedBox(width: 10), _CircleIcon(icon: Icons.favorite_border)]),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Transform.translate(
                offset: const Offset(0, -76),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _RestaurantInfoCard(restaurantName: restaurant.name, address: restaurant.address, openTime: restaurant.openTime, closeTime: restaurant.closeTime),
                      const SizedBox(height: 38),
                      Text('V? chúng tôi', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
                      const SizedBox(height: 24),
                      Text(
                        restaurant.description.isEmpty ? 'Trai nghiem am thuc tinh te trong khong gian toi gian nhung am cung. TableNow mang den su giao thoa hai hoa giua ky thuat nau an hien dai va nguyen lieu tuoi ngon ban dia.' : restaurant.description,
                        style: const TextStyle(fontSize: 18, height: 1.55, color: BistroColors.espresso),
                      ),
                      const SizedBox(height: 58),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Th?c don n?i b?t', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
                          TextButton(onPressed: () => Navigator.pushNamed(context, AppRoutes.menu), child: const Text('Xem t?t c?')),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Consumer<MenuProvider>(builder: (context, menu, child) {
                        final items = menu.items.take(2).toList();
                        if (items.isEmpty) return const SizedBox.shrink();
                        return Column(
                          children: items.map((item) => _FeaturedDish(title: item.name, price: MoneyUtils.format(item.price), imageUrl: item.imageUrl.isNotEmpty ? item.imageUrl : _dishImage)).toList(),
                        );
                      }),
                      const SizedBox(height: 96),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            left: 28,
            right: 28,
            bottom: 20,
            child: SafeArea(top: false, child: FilledButton(onPressed: () => Navigator.pushNamed(context, AppRoutes.booking), child: const Text('Ð?t bàn ngay'))),
          ),
        ],
      );
    }),
  );
}

class _RestaurantInfoCard extends StatelessWidget {
  const _RestaurantInfoCard({required this.restaurantName, required this.address, required this.openTime, required this.closeTime});

  final String restaurantName;
  final String address;
  final String openTime;
  final String closeTime;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(28),
    decoration: BoxDecoration(color: BistroColors.card, borderRadius: BorderRadius.circular(32), boxShadow: BistroShadows.soft),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(restaurantName, style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.w900, color: BistroColors.ink)),
        const SizedBox(height: 10),
        Row(children: [const Icon(Icons.location_on_outlined, color: BistroColors.ember), const SizedBox(width: 8), Expanded(child: Text(address, style: const TextStyle(fontSize: 18, color: BistroColors.espresso)))]),
        const SizedBox(height: 20),
        Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8), decoration: BoxDecoration(color: BistroColors.cream, borderRadius: BorderRadius.circular(18)), child: const Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.star_border, color: BistroColors.ember, size: 18), SizedBox(width: 6), Text('4.8 (124)', style: TextStyle(fontWeight: FontWeight.w800))])),
        const Divider(height: 32),
        const Row(children: [Icon(Icons.payments_outlined, color: BistroColors.espresso), SizedBox(width: 8), Text(r'$$$', style: TextStyle(fontSize: 17)), SizedBox(width: 18), SizedBox(height: 20, child: VerticalDivider())]),
        const SizedBox(height: 14),
        Row(children: [const Icon(Icons.schedule, color: BistroColors.espresso), const SizedBox(width: 8), const Text('Ðang m? c?a', style: TextStyle(color: BistroColors.sage, fontSize: 17)), Text(' • Ðóng lúc $closeTime', style: const TextStyle(fontSize: 17, color: BistroColors.espresso))]),
        const SizedBox(height: 14),
        const Row(children: [Icon(Icons.restaurant, color: BistroColors.espresso), SizedBox(width: 8), Text('Pháp, Fusion', style: TextStyle(fontSize: 17, color: BistroColors.espresso))]),
      ],
    ),
  );
}

class _FeaturedDish extends StatelessWidget {
  const _FeaturedDish({required this.title, required this.price, required this.imageUrl});

  final String title;
  final String price;
  final String imageUrl;

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 22),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(color: BistroColors.card, borderRadius: BorderRadius.circular(24)),
    child: Row(
      children: [
        ClipRRect(borderRadius: BorderRadius.circular(14), child: Image.network(imageUrl, width: 112, height: 112, fit: BoxFit.cover, errorBuilder: (imageContext, error, stackTrace) => Container(width: 112, height: 112, color: BistroColors.muted, child: const Icon(Icons.restaurant_menu)))),
        const SizedBox(width: 24),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)), const SizedBox(height: 8), Text(price, style: const TextStyle(fontSize: 20, color: BistroColors.ember, fontWeight: FontWeight.w900))])),
      ],
    ),
  );
}

class _CircleIcon extends StatelessWidget {
  const _CircleIcon({required this.icon, this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => InkWell(onTap: onTap, customBorder: const CircleBorder(), child: Container(width: 44, height: 44, decoration: BoxDecoration(color: BistroColors.card.withValues(alpha: .88), shape: BoxShape.circle), child: Icon(icon, color: BistroColors.ink)));
}

const _heroImage = 'https://images.unsplash.com/photo-1514933651103-005eec06c04b?auto=format&fit=crop&w=1000&q=80';
const _dishImage = 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=500&q=80';



