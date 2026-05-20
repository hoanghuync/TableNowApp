import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/booking_model.dart';
import '../models/review_model.dart';

class ReviewService {
  ReviewService({FirebaseFirestore? firestore}) : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  Future<void> createReview(ReviewModel review, BookingModel booking) async {
    if (!booking.canReview) throw Exception('Chi duoc review booking da completed');
    final doc = review.id.isEmpty ? _firestore.collection('reviews').doc() : _firestore.collection('reviews').doc(review.id);
    await doc.set(ReviewModel(id: doc.id, userId: review.userId, bookingId: review.bookingId, restaurantId: review.restaurantId, rating: review.rating, comment: review.comment, createdAt: review.createdAt).toMap());
  }
}


