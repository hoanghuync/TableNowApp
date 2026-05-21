import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/widgets/rustic_widgets.dart';
import '../../models/rustic_models.dart';
import '../../providers/app_state.dart';

class TableManagementScreen extends StatelessWidget {
  const TableManagementScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return RusticScaffold(
      isAdmin: true,
      currentIndex: 2,
      child: ListView(padding: const EdgeInsets.all(22), children: [
        Text('Table Management', style: Theme.of(context).textTheme.headlineLarge),
        const SizedBox(height: 16),
        FilledButton.icon(onPressed: () => _showTableEditor(context), icon: const Icon(Icons.add), label: const Text('Them ban')),
        const SizedBox(height: 20),
        ...state.activeTables.map((table) => Card(margin: const EdgeInsets.only(bottom: 12), child: ListTile(title: Text('${table.tableName} - ${table.capacity} khach'), subtitle: Text('${table.area} • x:${table.positionX.round()} y:${table.positionY.round()}'), trailing: DropdownButton<String>(value: table.status, items: const [DropdownMenuItem(value: 'available', child: Text('available')), DropdownMenuItem(value: 'reserved', child: Text('reserved')), DropdownMenuItem(value: 'occupied', child: Text('occupied'))], onChanged: (value) { if (value != null) context.read<AppState>().updateTableStatus(table.id, value); }), onTap: () => _showTableEditor(context, table: table))))
      ]),
    );
  }

  void _showTableEditor(BuildContext context, {RestaurantTableModel2? table}) {
    final name = TextEditingController(text: table?.tableName ?? 'T${DateTime.now().second}');
    final capacity = TextEditingController(text: '${table?.capacity ?? 2}');
    showModalBottomSheet<void>(context: context, builder: (_) => Padding(padding: const EdgeInsets.all(20), child: Column(mainAxisSize: MainAxisSize.min, children: [Text(table == null ? 'Them ban' : 'Sua ban', style: Theme.of(context).textTheme.titleLarge), TextField(controller: name, decoration: const InputDecoration(labelText: 'Ten ban')), const SizedBox(height: 12), TextField(controller: capacity, decoration: const InputDecoration(labelText: 'Suc chua'), keyboardType: TextInputType.number), const SizedBox(height: 18), FilledButton(onPressed: () { final newTable = RestaurantTableModel2(id: table?.id ?? 't-${DateTime.now().millisecondsSinceEpoch}', tableName: name.text, capacity: int.tryParse(capacity.text) ?? 2, positionX: table?.positionX ?? 80, positionY: table?.positionY ?? 80, status: table?.status ?? 'available'); context.read<AppState>().upsertTable(newTable); Navigator.pop(context); }, child: const Text('Luu ban'))])));
  }
}
