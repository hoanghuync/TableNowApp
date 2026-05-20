import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:tablenowapp/models/app_user_model.dart';
import 'package:tablenowapp/models/booking_item_model.dart';
import 'package:tablenowapp/models/restaurant_model.dart';
import 'package:tablenowapp/models/restaurant_table_model.dart';
import 'package:tablenowapp/providers/auth_provider.dart';
import 'package:tablenowapp/providers/booking_provider.dart';
import 'package:tablenowapp/providers/cart_provider.dart';
import 'package:tablenowapp/providers/restaurant_provider.dart';
import 'package:tablenowapp/screens/booking_screen.dart';
import 'package:tablenowapp/screens/login_screen.dart';
import 'package:tablenowapp/utils/validators.dart';

void main() {
  group('business rules', () {
    test('calculateTotalAmount()', () {
      final total = calculateTotalAmount(const [
        BookingItemModel(menuItemId: 'a', restaurantId: 'main-restaurant', name: 'Pho', price: 50000, quantity: 2),
        BookingItemModel(menuItemId: 'b', restaurantId: 'main-restaurant', name: 'Tra', price: 20000, quantity: 3),
      ]);
      expect(total, 160000);
    });

    test('validateBookingDate()', () {
      final now = DateTime(2026, 5, 20, 10);
      expect(validateBookingDate(DateTime(2026, 5, 21), now: now), isNull);
      expect(validateBookingDate(DateTime(2026, 5, 19), now: now), isNotNull);
    });

    test('validateGuestNumber()', () {
      expect(validateGuestNumber(1), isNull);
      expect(validateGuestNumber(0), isNotNull);
      expect(validateGuestNumber(null), isNotNull);
    });

    test('validatePreOrderItems() requires same restaurant', () {
      expect(
        validatePreOrderItems(const [BookingItemModel(menuItemId: 'a', restaurantId: 'other', name: 'Pho', price: 50000, quantity: 1)], 'main-restaurant'),
        isNotNull,
      );
    });
  });

  testWidgets('LoginScreen has email field, password field, login button', (tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AuthProvider(),
        child: const MaterialApp(home: LoginScreen()),
      ),
    );

    expect(find.widgetWithText(TextFormField, 'Email'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Password'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
  });

  testWidgets('BookingScreen shows Confirm Booking and validates missing info', (tester) async {
    final restaurantProvider = RestaurantProvider()
      ..restaurant = const RestaurantModel(id: 'main-restaurant', name: 'TableNow Bistro', address: 'HCMC', phone: '0909', openTime: '08:00', closeTime: '22:00', description: 'Demo', imageUrl: '', latitude: 0, longitude: 0)
      ..tables = const [RestaurantTableModel(id: 'table-1', restaurantId: 'main-restaurant', tableName: 'Ban 1', capacity: 4, status: 'available')];
    final authProvider = AuthProvider()
      ..user = AppUserModel(uid: 'u1', fullName: 'Customer', email: 'c@test.com', phone: '0909', role: 'customer', createdAt: DateTime(2026, 5, 20));

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthProvider>.value(value: authProvider),
          ChangeNotifierProvider<RestaurantProvider>.value(value: restaurantProvider),
          ChangeNotifierProvider(create: (_) => BookingProvider()),
          ChangeNotifierProvider(create: (_) => CartProvider()),
        ],
        child: const MaterialApp(home: BookingScreen()),
      ),
    );

    expect(find.textContaining('Xac nhan dat ban'), findsOneWidget);
    await tester.ensureVisible(find.textContaining('Xac nhan dat ban'));
    await tester.pumpAndSettle();
    await tester.tap(find.textContaining('Xac nhan dat ban'));
    await tester.pump();
    expect(find.text('Vui long chon ngay dat ban'), findsOneWidget);
  });
}

