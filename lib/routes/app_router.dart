import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../providers/app_state.dart';
import '../screens/admin/admin_dashboard_screen.dart';
import '../screens/admin/manage_menu_screen.dart';
import '../screens/admin/reservation_management_screen.dart';
import '../screens/admin/table_management_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/customer/booking_screen.dart';
import '../screens/customer/cart_screen.dart';
import '../screens/customer/customer_home_screen.dart';
import '../screens/customer/menu_screen.dart';
import '../screens/customer/profile_screen.dart';

class AppRouter {
  static GoRouter router(AppState state) => GoRouter(
    initialLocation: '/login',
    refreshListenable: state,
    redirect: (context, routerState) {
      final loggedIn = state.isAuthenticated;
      final atLogin = routerState.matchedLocation == '/login';
      if (!loggedIn && !atLogin) return '/login';
      if (loggedIn && atLogin) return state.isAdmin ? '/admin' : '/home';
      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(path: '/home', builder: (context, state) => const CustomerHomeScreen()),
      GoRoute(path: '/menu', builder: (context, state) => const MenuScreenRustic()),
      GoRoute(path: '/cart', builder: (context, state) => const CartScreen()),
      GoRoute(path: '/booking', builder: (context, state) => const BookingScreenRustic()),
      GoRoute(path: '/profile', builder: (context, state) => const ProfileScreenRustic()),
      GoRoute(path: '/admin', builder: (context, state) => const AdminDashboardScreenRustic()),
      GoRoute(path: '/admin/menu', builder: (context, state) => const ManageMenuScreen()),
      GoRoute(path: '/admin/reservations', builder: (context, state) => const ReservationManagementScreen()),
      GoRoute(path: '/admin/tables', builder: (context, state) => const TableManagementScreen()),
    ],
    errorBuilder: (context, state) => const Scaffold(body: Center(child: Text('Route not found'))),
  );
}
