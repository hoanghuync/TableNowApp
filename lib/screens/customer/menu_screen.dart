import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/rustic_widgets.dart';
import '../../providers/app_state.dart';

class MenuScreenRustic extends StatefulWidget {
  const MenuScreenRustic({super.key});
  @override
  State<MenuScreenRustic> createState() => _MenuScreenRusticState();
}

class _MenuScreenRusticState extends State<MenuScreenRustic> {
  String categoryId = 'all';
  String search = '';

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final items = state.itemsByCategory(categoryId, search);
    return RusticScaffold(
      currentIndex: 1,
      child: ListView(padding: const EdgeInsets.fromLTRB(16, 30, 16, 100), children: [
        TextField(onChanged: (v) => setState(() => search = v), decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Tim kiem mon an...')),
        const SizedBox(height: 28),
        SizedBox(height: 42, child: ListView(scrollDirection: Axis.horizontal, children: state.categories.map((category) => Padding(padding: const EdgeInsets.only(right: 12), child: ChoiceChip(label: Text(category.name), selected: categoryId == category.id, selectedColor: AppColors.primary, labelStyle: TextStyle(color: categoryId == category.id ? Colors.white : AppColors.textBrown), onSelected: (_) => setState(() => categoryId = category.id)))).toList())),
        const SizedBox(height: 32),
        if (items.isEmpty) const EmptyState(message: 'Khong tim thay mon phu hop') else ...items.map((item) => MenuFoodCard(item: item)),
      ]),
    );
  }
}
