import 'package:flutter/foundation.dart';

import '../models/booking_model.dart';
import '../models/review_model.dart';
import '../services/review_service.dart';

class ReviewProvider extends ChangeNotifier {
  ReviewProvider({ReviewService? service}) : _service = service;

  ReviewService? _service;
  ReviewService get service => _service ??= ReviewService();
  bool isLoading = false;
  String? error;

  Future<bool> submitReview({required BookingModel booking, required int rating, required String comment}) async {
    isLoading = true; notifyListeners();
    try { await service.createReview(ReviewModel(id: '', userId: booking.userId, bookingId: booking.id, restaurantId: booking.restaurantId, rating: rating, comment: comment, createdAt: DateTime.now()), booking); error = null; return true; } catch (e) { error = e.toString(); return false; } finally { isLoading = false; notifyListeners(); }
  }
}


