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
import 'screens/admin_alerts_screen.dart';
import 'screens/admin_booking_screen.dart';
import 'screens/admin_dashboard_screen.dart';
import 'screens/admin_floor_plan_screen.dart';
import 'screens/booking_history_screen.dart';
import 'screens/booking_screen.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/map_screen.dart';
import 'screens/menu_screen.dart';
import 'screens/notification_screen.dart';
import 'screens/pre_order_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/register_screen.dart';
import 'screens/restaurant_info_screen.dart';
import 'screens/splash_screen.dart';
import 'utils/app_constants.dart';
import 'utils/app_routes.dart';
import 'utils/bistro_theme.dart';

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
          scaffoldBackgroundColor: BistroColors.cream,
          fontFamily: 'Times New Roman',
          colorScheme: ColorScheme.fromSeed(
            seedColor: BistroColors.ember,
            brightness: Brightness.light,
            primary: BistroColors.ember,
            secondary: BistroColors.clay,
            surface: BistroColors.card,
          ),
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            elevation: 0,
            scrolledUnderElevation: 0,
            backgroundColor: BistroColors.cream,
            foregroundColor: BistroColors.espresso,
            titleTextStyle: TextStyle(color: BistroColors.ember, fontSize: 18, fontWeight: FontWeight.w700),
          ),
          filledButtonTheme: FilledButtonThemeData(
            style: FilledButton.styleFrom(
              backgroundColor: BistroColors.ember,
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(56),
              textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, letterSpacing: .2),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: BistroColors.muted.withValues(alpha: .72),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide.none),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide.none),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: const BorderSide(color: BistroColors.ember)),
          ),
          cardTheme: CardThemeData(
            elevation: 0,
            color: BistroColors.card,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            margin: EdgeInsets.zero,
          ),
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
          AppRoutes.profile: (_) => const ProfileScreen(),
          AppRoutes.map: (_) => const MapScreen(),
          AppRoutes.adminDashboard: (_) => const AdminDashboardScreen(),
          AppRoutes.adminBookings: (_) => const AdminBookingScreen(),
          AppRoutes.adminFloorPlan: (_) => const AdminFloorPlanScreen(),
          AppRoutes.adminAlerts: (_) => const AdminAlertsScreen(),
        },
      ),
    );
  }
}



