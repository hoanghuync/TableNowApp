import 'package:flutter/material.dart';

class EmptyView extends StatelessWidget {
  const EmptyView({super.key, required this.message, this.icon = Icons.inbox_outlined});

  final String message;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Center(child: Padding(padding: const EdgeInsets.all(32), child: Column(mainAxisSize: MainAxisSize.min, children: [Icon(icon, size: 64, color: Theme.of(context).colorScheme.outline), const SizedBox(height: 12), Text(message, textAlign: TextAlign.center)])));
}
