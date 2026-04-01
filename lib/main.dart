import 'package:flutter/material.dart';
import 'package:food_app/screens/customer/customer_home_screen.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_fonts/google_fonts.dart';

import 'firebase_options.dart';

import 'providers/cart_provider.dart';
import 'providers/menu_provider.dart';
import 'providers/vendor_order_provider.dart';

import 'screens/vendor/vendor_home_screen.dart';

import 'services/notification_service.dart';


/// Background notification handler
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  print("🔔 Background Notification: ${message.notification?.title}");
}

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  /// Initialize local notification system
  await NotificationService.init();

  /// Register background notification handler
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    setupFCM();
  }

  /// Setup Firebase Messaging
  void setupFCM() async {

    FirebaseMessaging messaging = FirebaseMessaging.instance;

    /// Request notification permission
    await messaging.requestPermission();

    /// Get device token
    String? token = await messaging.getToken();

    print("=====================================");
    print("📱 FCM TOKEN:");
    print(token);
    print("=====================================");

    /// Foreground notification listener
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {

      if (message.notification != null) {

        NotificationService.showNotification(
          message.notification!.title ?? "New Notification",
          message.notification!.body ?? "",
        );

      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return MultiProvider(

      providers: [

        ChangeNotifierProvider(
          create: (_) => CartProvider(),
        ),

        ChangeNotifierProvider(
          create: (_) => VendorOrderProvider(),
        ),

        ChangeNotifierProvider(
          create: (_) => MenuProvider(),
        ),

      ],

      child: MaterialApp(

        debugShowCheckedModeBanner: false,

        title: 'Food Vendor App',

        theme: ThemeData(
          primaryColor: Colors.orange,
          scaffoldBackgroundColor: const Color(0xffF5F5F5),
          textTheme: GoogleFonts.poppinsTextTheme(),
        ),

        home: const VendorHomeScreen(),
      ),
    );
  }
}