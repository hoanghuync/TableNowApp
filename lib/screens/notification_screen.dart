import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../providers/notification_provider.dart';
import '../widgets/empty_view.dart';
import '../widgets/loading_view.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() { super.initState(); WidgetsBinding.instance.addPostFrameCallback((_) { final user = context.read<AuthProvider>().user; if (user != null) context.read<NotificationProvider>().loadNotifications(user.uid); }); }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Thong bao')),
    body: Consumer<NotificationProvider>(builder: (context, provider, child) {
      if (provider.isLoading) return const LoadingView();
      if (provider.notifications.isEmpty) return const EmptyView(message: 'Chua co thong bao moi', icon: Icons.notifications_none);
      return ListView.builder(itemCount: provider.notifications.length, itemBuilder: (_, i) { final n = provider.notifications[i]; return ListTile(leading: Icon(n.isRead ? Icons.mark_email_read_outlined : Icons.mark_email_unread_outlined), title: Text(n.title), subtitle: Text(n.message)); });
    }),
  );
}
