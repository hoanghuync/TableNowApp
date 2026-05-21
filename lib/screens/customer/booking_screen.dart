import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/rustic_widgets.dart';
import '../../providers/app_state.dart';

class BookingScreenRustic extends StatefulWidget {
  const BookingScreenRustic({super.key});
  @override
  State<BookingScreenRustic> createState() => _BookingScreenRusticState();
}

class _BookingScreenRusticState extends State<BookingScreenRustic> {
  DateTime selectedDate = DateTime.now();
  String selectedTime = '19:00';
  int guests = 2;
  String? tableId;
  final note = TextEditingController();
  bool includeCart = false;

  @override
  void dispose() { note.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final dates = List.generate(4, (i) => DateTime.now().add(Duration(days: i)));
    final tables = state.availableTablesFor(guests);
    tableId ??= tables.isNotEmpty ? tables.first.id : null;
    return RusticScaffold(
      currentIndex: 2,
      child: ListView(padding: const EdgeInsets.fromLTRB(36, 36, 36, 110), children: [
        Text('Reserve a Table', style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 46)),
        const SizedBox(height: 12),
        const Text('Experience sophisticated warmth. Let us prepare your place.', style: TextStyle(fontSize: 24, height: 1.4)),
        const SizedBox(height: 70),
        Card(child: Padding(padding: const EdgeInsets.all(28), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [const Icon(Icons.calendar_month_outlined, color: AppColors.textBrown), const SizedBox(width: 14), Expanded(child: Text('When are you joining us?', style: Theme.of(context).textTheme.headlineMedium))]),
          const SizedBox(height: 34),
          const Text('SELECT DATE', style: TextStyle(letterSpacing: 1.8, fontSize: 20, fontWeight: FontWeight.w700)),
          const SizedBox(height: 18),
          SizedBox(height: 110, child: ListView(scrollDirection: Axis.horizontal, children: dates.map((date) => _DateBox(date: date, selected: _sameDay(date, selectedDate), onTap: () => setState(() => selectedDate = date))).toList())),
          const SizedBox(height: 30),
          const Text('DINNER SERVICE', style: TextStyle(letterSpacing: 1.8, fontSize: 20, fontWeight: FontWeight.w700)),
          const SizedBox(height: 18),
          Wrap(spacing: 16, runSpacing: 16, children: ['18:00', '18:30', '19:00', '19:30', '20:00'].map((time) => ChoiceChip(label: Padding(padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10), child: Text(time)), selected: selectedTime == time, selectedColor: AppColors.softPink, onSelected: (_) => setState(() => selectedTime = time))).toList()),
          const SizedBox(height: 26),
          const Text('SO LUONG KHACH', style: TextStyle(letterSpacing: 1.8, fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          Wrap(spacing: 12, children: [1, 2, 3, 4, 5, 6].map((n) => ChoiceChip(label: Text(n == 6 ? '6+' : '$n'), selected: guests == n, selectedColor: AppColors.primary, labelStyle: TextStyle(color: guests == n ? Colors.white : AppColors.textDark), onSelected: (_) => setState(() { guests = n; tableId = null; }))).toList()),
          const SizedBox(height: 20),
          DropdownButtonFormField<String>(initialValue: tableId, decoration: const InputDecoration(labelText: 'Ban con trong'), items: tables.map((table) => DropdownMenuItem(value: table.id, child: Text('${table.tableName} - ${table.capacity} khach'))).toList(), onChanged: (value) => setState(() => tableId = value)),
          const SizedBox(height: 12),
          TextField(controller: note, decoration: const InputDecoration(labelText: 'Ghi chu'), maxLines: 2),
          SwitchListTile(contentPadding: EdgeInsets.zero, value: includeCart, onChanged: state.cart.isEmpty ? null : (v) => setState(() => includeCart = v), title: const Text('Them mon trong cart vao pre-order')),
        ]))),
        const SizedBox(height: 32),
        Stack(children: [RusticImage('https://images.unsplash.com/photo-1558030006-450675393462?auto=format&fit=crop&w=1000&q=80', height: 210, width: double.infinity, borderRadius: 14), Positioned(left: 28, bottom: 28, child: Text('Pre-order Menu', style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: Colors.white))), Positioned(right: 28, bottom: 26, child: CircleAvatar(radius: 30, backgroundColor: AppColors.primary, child: IconButton(onPressed: () => context.push('/menu'), icon: const Icon(Icons.arrow_forward, color: Colors.white))))]),
        const SizedBox(height: 32),
        FilledButton(onPressed: tableId == null ? null : () { context.read<AppState>().createBooking(date: selectedDate, time: selectedTime, guests: guests, tableId: tableId!, note: note.text, includeCart: includeCart); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Da tao booking pending'))); }, child: const Text('Xac nhan dat ban'))
      ]),
    );
  }

  static bool _sameDay(DateTime a, DateTime b) => a.year == b.year && a.month == b.month && a.day == b.day;
}

class _DateBox extends StatelessWidget { const _DateBox({required this.date, required this.selected, required this.onTap}); final DateTime date; final bool selected; final VoidCallback onTap; @override Widget build(BuildContext context) => GestureDetector(onTap: onTap, child: Container(width: 130, margin: const EdgeInsets.only(right: 16), decoration: BoxDecoration(color: selected ? AppColors.primary : AppColors.background, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Text(selected ? 'TODAY' : ['MON','TUE','WED','THU','FRI','SAT','SUN'][date.weekday - 1], style: TextStyle(color: selected ? Colors.white : AppColors.textBrown, fontWeight: FontWeight.w700)), Text('${date.day}', style: TextStyle(fontSize: 34, color: selected ? Colors.white : AppColors.textBrown))]))); }


