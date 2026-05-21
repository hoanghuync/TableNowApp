import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/rustic_widgets.dart';
import '../../providers/app_state.dart';

class CustomerHomeScreen extends StatelessWidget {
  const CustomerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final user = state.currentUser;
    final signature = state.signature;
    return RusticScaffold(
      currentIndex: 0,
      child: ListView(padding: const EdgeInsets.fromLTRB(22, 28, 22, 100), children: [
        Text('Xin chao, ${user?.fullName.split(' ').last ?? 'Thuc khach'}!', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 23)),
        const SizedBox(height: 8),
        const Text('San sang cho mot trai nghiem am thuc tinh te?', style: TextStyle(fontSize: 16)),
        const SizedBox(height: 42),
        if (signature != null) _SignatureCard(item: signature),
        const SizedBox(height: 42),
        SectionHeader(title: 'Mon an de cu', action: 'Xem tat ca', onAction: () => context.go('/menu')),
        const SizedBox(height: 18),
        SizedBox(height: 365, child: ListView(scrollDirection: Axis.horizontal, children: state.recommended.map((item) => MenuFoodCard(item: item, compact: true)).toList())),
        const SizedBox(height: 42),
        const SectionHeader(title: 'Khuyen mai hom nay'),
        const SizedBox(height: 18),
        ...state.promotions.map((promo) => _PromotionTile(title: promo.title, description: promo.description, icon: promo.iconType == 'cake' ? Icons.cake_outlined : Icons.local_bar_outlined, highlighted: promo.iconType != 'cake')),
      ]),
    );
  }
}

class _SignatureCard extends StatelessWidget {
  const _SignatureCard({required this.item});
  final dynamic item;
  @override
  Widget build(BuildContext context) => Container(
    height: 348,
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(24), boxShadow: const [BoxShadow(color: Color(0x22000000), blurRadius: 18, offset: Offset(0, 8))]),
    clipBehavior: Clip.antiAlias,
    child: Stack(children: [
      RusticImage(item.imageUrl as String, height: 348, width: double.infinity, borderRadius: 24),
      Container(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Colors.black.withValues(alpha: .75)]))),
      Positioned(left: 28, right: 28, bottom: 26, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8), decoration: BoxDecoration(color: Colors.white.withValues(alpha: .28), borderRadius: BorderRadius.circular(22)), child: const Text("Chef's Signature", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700))), const SizedBox(height: 22), Text(item.name as String, style: Theme.of(context).textTheme.displayLarge?.copyWith(color: Colors.white, fontSize: 48)), const SizedBox(height: 12), Text(item.description as String, maxLines: 3, style: const TextStyle(color: Colors.white, fontSize: 17, height: 1.45))])),
      Positioned(right: 26, bottom: 26, child: CircleAvatar(radius: 28, backgroundColor: AppColors.secondary, child: IconButton(onPressed: () => context.go('/menu'), icon: const Icon(Icons.arrow_forward, color: Colors.white))))
    ]),
  );
}

class _PromotionTile extends StatelessWidget {
  const _PromotionTile({required this.title, required this.description, required this.icon, required this.highlighted});
  final String title;
  final String description;
  final IconData icon;
  final bool highlighted;
  @override
  Widget build(BuildContext context) => Container(margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(22), decoration: BoxDecoration(color: highlighted ? AppColors.softPink.withValues(alpha: .6) : AppColors.muted, borderRadius: BorderRadius.circular(14), border: Border.all(color: highlighted ? AppColors.softPink : AppColors.border)), child: Row(children: [CircleAvatar(radius: 30, backgroundColor: Colors.white, child: Icon(icon, color: AppColors.primary)), const SizedBox(width: 22), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.w700)), Text(description)])), const Icon(Icons.chevron_right, color: AppColors.textBrown)]));
}
