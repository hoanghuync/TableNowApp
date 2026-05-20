import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'providers/auth_provider.dart';
import 'providers/booking_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/menu_provider.dart';
import 'providers/notification_provider.dart';
import 'providers/restaurant_provider.dart';
import 'providers/review_provider.dart';
import 'screens/admin_booking_screen.dart';
import 'screens/booking_history_screen.dart';
import 'screens/booking_screen.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/map_screen.dart';
import 'screens/menu_screen.dart';
import 'screens/notification_screen.dart';
import 'screens/pre_order_screen.dart';
import 'screens/register_screen.dart';
import 'screens/restaurant_info_screen.dart';
import 'screens/splash_screen.dart';
import 'utils/app_constants.dart';
import 'utils/app_routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const TableNowApp());
}

class TableNowApp extends StatelessWidget {
  const TableNowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => RestaurantProvider()),
        ChangeNotifierProvider(create: (_) => MenuProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => BookingProvider()),
        ChangeNotifierProvider(create: (_) => ReviewProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: AppConstants.appName,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0F766E), brightness: Brightness.light),
          inputDecorationTheme: const InputDecorationTheme(filled: true),
          cardTheme: CardThemeData(elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18))),
        ),
        initialRoute: AppRoutes.splash,
        routes: {
          AppRoutes.splash: (_) => const SplashScreen(),
          AppRoutes.login: (_) => const LoginScreen(),
          AppRoutes.register: (_) => const RegisterScreen(),
          AppRoutes.home: (_) => const HomeScreen(),
          AppRoutes.restaurantInfo: (_) => const RestaurantInfoScreen(),
          AppRoutes.menu: (_) => const MenuScreen(),
          AppRoutes.booking: (_) => const BookingScreen(),
          AppRoutes.preOrder: (_) => const PreOrderScreen(),
          AppRoutes.bookingHistory: (_) => const BookingHistoryScreen(),
          AppRoutes.notifications: (_) => const NotificationScreen(),
          AppRoutes.map: (_) => const MapScreen(),
          AppRoutes.adminBookings: (_) => const AdminBookingScreen(),
        },
      ),
    );
  }
}
