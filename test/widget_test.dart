import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:tablenowapp/providers/app_state.dart';
import 'package:tablenowapp/screens/auth/login_screen.dart';
import 'package:tablenowapp/screens/customer/booking_screen.dart';

void main() {
  group('Rustic Kitchen business rules', () {
    test('cart calculates subtotal, discount, and total', () {
      final state = AppState();
      state.addToCart(state.menuItems.firstWhere((item) => item.id == 'combo-fuji'));
      expect(state.cartSubtotal, 549000);
      expect(state.cartDiscount, 54900);
      expect(state.cartTotal, 494100);
    });

    test('admin confirm booking reserves table', () {
      final state = AppState();
      final booking = state.pendingBookings.first;
      state.updateBookingStatus(booking, 'confirmed');
      expect(state.bookings.firstWhere((item) => item.id == booking.id).status, 'confirmed');
      expect(state.tables.firstWhere((table) => table.id == booking.tableId).status, 'reserved');
    });

    test('availableTablesFor filters by capacity and status', () {
      final state = AppState();
      final tables = state.availableTablesFor(4);
      expect(tables.every((table) => table.status == 'available' && table.capacity >= 4), isTrue);
    });
  });

  testWidgets('LoginScreen shows customer and admin demo actions', (tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AppState(),
        child: const MaterialApp(home: LoginScreen()),
      ),
    );

    expect(find.text('Rustic Kitchen'), findsOneWidget);
    expect(find.text('Dang nhap'), findsOneWidget);
    expect(find.text('Vao che do Admin demo'), findsOneWidget);
  });

  testWidgets('BookingScreen shows reservation CTA', (tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AppState(),
        child: const MaterialApp(home: BookingScreenRustic()),
      ),
    );

    expect(find.text('Reserve a Table'), findsOneWidget);
    expect(find.text('When are you joining us?'), findsOneWidget);
    expect(find.text('SELECT DATE'), findsOneWidget);
    expect(find.text('DINNER SERVICE'), findsOneWidget);
  });
}


