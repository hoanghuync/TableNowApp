import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../utils/app_routes.dart';
import '../utils/bistro_theme.dart';
import '../widgets/bistro_bottom_nav.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.user;
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(28, 42, 28, 24),
          children: [
            Center(
              child: Stack(
                children: [
                  const CircleAvatar(radius: 76, backgroundImage: NetworkImage('https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=400&q=80')),
                  Positioned(right: 0, bottom: 8, child: Container(width: 50, height: 50, decoration: const BoxDecoration(color: BistroColors.ember, shape: BoxShape.circle), child: const Icon(Icons.edit, color: Colors.white))),
                ],
              ),
            ),
            const SizedBox(height: 28),
            Text(user?.fullName.isNotEmpty == true ? user!.fullName : 'Elena Rossi', textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.w900)),
            const SizedBox(height: 8),
            const Text('Food Enthusiast & Explorer', textAlign: TextAlign.center, style: TextStyle(fontSize: 22, color: BistroColors.espresso)),
            const SizedBox(height: 86),
            _ProfileTile(icon: Icons.person_outline, title: 'Thong tin ca nhan', subtitle: 'Cap nhat email, so dien thoai & dia chi', onTap: () {}),
            _ProfileTile(icon: Icons.local_offer_outlined, title: 'Uu dai cua toi', subtitle: 'Voucher va khuyen mai danh rieng', accent: BistroColors.sage, onTap: () {}),
            _ProfileTile(icon: Icons.notifications_none, title: 'Cai dat thong bao', subtitle: 'Quan ly canh bao va email', onTap: () => Navigator.pushNamed(context, AppRoutes.notifications)),
            _ProfileTile(icon: Icons.help_outline, title: 'Tro giup & Ho tro', subtitle: 'FAQ va lien he cham soc khach hang', onTap: () {}),
            const SizedBox(height: 34),
            OutlinedButton.icon(
              onPressed: () async {
                await context.read<AuthProvider>().logout();
                if (context.mounted) Navigator.pushReplacementNamed(context, AppRoutes.login);
              },
              icon: const Icon(Icons.logout, color: Colors.red),
              label: const Text('Dang xuat', style: TextStyle(color: Colors.red, fontWeight: FontWeight.w800)),
              style: OutlinedButton.styleFrom(minimumSize: const Size(190, 54), side: BorderSide(color: BistroColors.espresso.withValues(alpha: .12)), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28))),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BistroBottomNav(currentIndex: 3),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  const _ProfileTile({required this.icon, required this.title, required this.subtitle, required this.onTap, this.accent = BistroColors.ember});

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Color accent;

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 28),
    padding: const EdgeInsets.all(28),
    decoration: BoxDecoration(color: BistroColors.card, borderRadius: BorderRadius.circular(16), boxShadow: BistroShadows.soft),
    child: InkWell(
      onTap: onTap,
      child: Row(
        children: [
          CircleAvatar(radius: 30, backgroundColor: BistroColors.muted, child: Icon(icon, color: accent)),
          const SizedBox(width: 20),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)), const SizedBox(height: 6), Text(subtitle, style: const TextStyle(fontSize: 18, height: 1.28, color: BistroColors.espresso))])),
          const Icon(Icons.chevron_right, color: BistroColors.espresso),
        ],
      ),
    ),
  );
}
