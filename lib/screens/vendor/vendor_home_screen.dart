import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/vendor_order_provider.dart';
import 'vendor_dashboard_screen.dart';
import 'vendor_orders_screen.dart';
import 'vendor_menu_screen.dart';

class VendorHomeScreen extends StatefulWidget {
  const VendorHomeScreen({super.key});

  @override
  State<VendorHomeScreen> createState() => _VendorHomeScreenState();
}

class _VendorHomeScreenState extends State<VendorHomeScreen> {

  int currentIndex = 0;

  final screens = const [
    VendorDashboardScreen(),
    VendorOrdersScreen(),
    VendorMenuScreen(),
  ];

  @override
  void initState() {
    super.initState();

    /// Start listening to new orders
    Future.microtask(() {
      Provider.of<VendorOrderProvider>(context, listen: false)
          .listenOrders();
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: screens[currentIndex],

      bottomNavigationBar: BottomNavigationBar(

        currentIndex: currentIndex,

        selectedItemColor: Colors.orange,

        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },

        items: const [

          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: "Dashboard",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: "Orders",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu),
            label: "Menu",
          ),

        ],
      ),
    );
  }
}