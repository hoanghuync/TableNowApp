import 'package:flutter/material.dart';

import '../utils/bistro_theme.dart';

class AdminHeader extends StatelessWidget {
  const AdminHeader({super.key, this.title = "L'Essence Admin", this.avatarUrl = 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=200&q=80'});

  final String title;
  final String avatarUrl;

  @override
  Widget build(BuildContext context) => SafeArea(
    bottom: false,
    child: Padding(
      padding: const EdgeInsets.fromLTRB(26, 18, 26, 10),
      child: Row(
        children: [
          const Icon(Icons.restaurant_menu, color: BistroColors.ember, size: 30),
          const SizedBox(width: 18),
          Expanded(child: Text(title, textAlign: TextAlign.center, style: const TextStyle(color: BistroColors.ember, fontSize: 22, fontWeight: FontWeight.w800))),
          CircleAvatar(radius: 24, backgroundImage: NetworkImage(avatarUrl)),
        ],
      ),
    ),
  );
}
