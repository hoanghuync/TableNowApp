import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/booking_model.dart';
import '../providers/review_provider.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key, required this.booking});

  final BookingModel booking;

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  int _rating = 5;
  final _commentController = TextEditingController();

  @override
  void dispose() { _commentController.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Danh gia')),
    body: Padding(padding: const EdgeInsets.all(16), child: Column(children: [
      DropdownButtonFormField<int>(initialValue: _rating, decoration: const InputDecoration(labelText: 'So sao', border: OutlineInputBorder()), items: [1, 2, 3, 4, 5].map((e) => DropdownMenuItem(value: e, child: Text('$e sao'))).toList(), onChanged: (v) => setState(() => _rating = v ?? 5)),
      const SizedBox(height: 12),
      CustomTextField(controller: _commentController, label: 'Nhan xet', maxLines: 4),
      const SizedBox(height: 20),
      Consumer<ReviewProvider>(builder: (context, provider, child) => CustomButton(label: 'Gui danh gia', isLoading: provider.isLoading, onPressed: () async { final ok = await provider.submitReview(booking: widget.booking, rating: _rating, comment: _commentController.text); if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(ok ? 'Cam on ban da danh gia' : provider.error ?? 'Gui danh gia that bai'))); })),
    ])),
  );
}
