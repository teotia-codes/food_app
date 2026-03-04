import 'package:flutter/material.dart';
import 'package:food_app/providers/cart_provider.dart';
import 'package:food_app/providers/menu_provider.dart';
import 'package:food_app/screens/customer/customer_dashboard_screen.dart';
import 'package:food_app/screens/customer/customer_home_screen.dart';
import 'package:food_app/screens/vendor/test_order_screen.dart';
import 'package:food_app/screens/vendor/vendor_dashboard_screen.dart';
import 'package:food_app/screens/vendor/vendor_menu_screen.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'firebase_options.dart';
import 'providers/vendor_order_provider.dart';
import 'screens/vendor/vendor_orders_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Register Vendor Provider
        ChangeNotifierProvider(
  create: (_) => CartProvider(),
),
        ChangeNotifierProvider(
          create: (_) => VendorOrderProvider(),
        ),
        ChangeNotifierProvider(create: (_) => MenuProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Food Vendor App',
        theme: ThemeData(
  primaryColor: Colors.orange,
  scaffoldBackgroundColor: const Color(0xffF5F5F5),

  textTheme: GoogleFonts.poppinsTextTheme(),

  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.orange,
    elevation: 0,
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.orange,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  ),
),

        // For now directly open Vendor Panel
        home: const CustomerHomeScreen(),
      ),
    );
  }
}