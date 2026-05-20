import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../providers/notification_provider.dart';
import '../utils/bistro_theme.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = context.read<AuthProvider>().user;
      if (user != null) context.read<NotificationProvider>().loadNotifications(user.uid);
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(28, 20, 28, 28),
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            _CircleButton(icon: Icons.arrow_back, onTap: () => Navigator.pop(context)),
            Text('Thong bao', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900)),
            const _CircleButton(icon: Icons.done_all),
          ]),
          const SizedBox(height: 42),
          const _SectionLabel('HOM NAY'),
          const SizedBox(height: 28),
          const _NotificationCard(icon: Icons.check_circle_outline, iconColor: Color(0xFFFFCFC8), title: 'Dat ban thanh cong', message: 'Ban 2 nguoi tai The French Laundry vao luc 19:00 toi nay da duoc xac nhan. Vui long den truoc 10 phut.', time: 'Vua xong'),
          const SizedBox(height: 18),
          const _NotificationCard(icon: Icons.local_offer_outlined, iconColor: Color(0xFF71E9D9), title: 'Uu dai doc quyen', message: 'Giam 20% cho thuc don Tasting Menu tai Le Bernardin danh rieng cho hang the Vang. Dat ngay truoc khi het cho!', time: '2 gio truoc', imageUrl: 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&w=800&q=80'),
          const SizedBox(height: 46),
          const _SectionLabel('TRUOC DO'),
          const SizedBox(height: 28),
          Consumer<NotificationProvider>(builder: (context, provider, child) {
            final firestoreItems = provider.notifications.take(2).toList();
            if (firestoreItems.isEmpty) {
              return const Column(children: [
                _CompactNotification(icon: Icons.calendar_today_outlined, title: 'Nhac nho lich hen', message: 'Ban co lich an toi tai Noma vao ngay mai luc 18:30. Dung quen nhe!', time: 'Hom qua'),
                SizedBox(height: 18),
                _CompactNotification(icon: Icons.info_outline, title: 'Cap nhat chinh sach', message: 'Chung toi da cap nhat Dieu khoan dich vu va Chinh sach bao mat moi.', time: '3 ngay truoc'),
              ]);
            }
            return Column(children: firestoreItems.map((item) => Padding(padding: const EdgeInsets.only(bottom: 18), child: _CompactNotification(icon: item.isRead ? Icons.mark_email_read_outlined : Icons.mark_email_unread_outlined, title: item.title, message: item.message, time: 'Gan day'))).toList());
          }),
        ],
      ),
    ),
  );
}

class _CircleButton extends StatelessWidget {
  const _CircleButton({required this.icon, this.onTap});
  final IconData icon;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => InkWell(onTap: onTap, customBorder: const CircleBorder(), child: Container(width: 56, height: 56, decoration: const BoxDecoration(color: BistroColors.card, shape: BoxShape.circle, boxShadow: BistroShadows.soft), child: Icon(icon, color: BistroColors.ink)));
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Text(text, style: const TextStyle(fontSize: 16, letterSpacing: 1.8, color: Color(0xFF4A5568), fontWeight: FontWeight.w900));
}

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({required this.icon, required this.iconColor, required this.title, required this.message, required this.time, this.imageUrl});
  final IconData icon;
  final Color iconColor;
  final String title;
  final String message;
  final String time;
  final String? imageUrl;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(28),
    decoration: BoxDecoration(color: BistroColors.card, borderRadius: BorderRadius.circular(14), boxShadow: BistroShadows.soft, border: const Border(left: BorderSide(color: BistroColors.ember, width: 3))),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [CircleAvatar(radius: 28, backgroundColor: iconColor, child: Icon(icon, color: BistroColors.ink)), const SizedBox(width: 26), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontSize: 29, fontWeight: FontWeight.w900, height: 1.05)), const SizedBox(height: 12), Text(message, style: const TextStyle(fontSize: 18, height: 1.4, color: BistroColors.espresso)), const SizedBox(height: 16), Text(time, style: const TextStyle(fontSize: 16, color: BistroColors.ember, fontWeight: FontWeight.w900))]))]),
      if (imageUrl != null) ...[const SizedBox(height: 28), ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.network(imageUrl!, height: 146, width: double.infinity, fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) => Container(height: 146, color: BistroColors.muted)))],
    ]),
  );
}

class _CompactNotification extends StatelessWidget {
  const _CompactNotification({required this.icon, required this.title, required this.message, required this.time});
  final IconData icon;
  final String title;
  final String message;
  final String time;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(28),
    decoration: BoxDecoration(color: BistroColors.card, borderRadius: BorderRadius.circular(14), boxShadow: BistroShadows.soft),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [CircleAvatar(radius: 28, backgroundColor: BistroColors.muted, child: Icon(icon, color: Color(0xFF596579))), const SizedBox(width: 26), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500)), const SizedBox(height: 10), Text(message, style: const TextStyle(fontSize: 18, height: 1.35, color: Color(0xFF5C4B46))), const SizedBox(height: 16), Text(time, style: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF718096)))]))]),
  );
}
