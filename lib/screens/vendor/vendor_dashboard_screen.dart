import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VendorDashboardScreen extends StatelessWidget {
  const VendorDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Vendor Dashboard"),
      ),

      body: StreamBuilder<QuerySnapshot>(

        stream: FirebaseFirestore.instance
            .collection("orders")
            .snapshots(),

        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final orders = snapshot.data!.docs;

          int totalOrders = orders.length;
          int completed = 0;
          int active = 0;
          double revenue = 0;

          for (var order in orders) {

            final data = order.data() as Map<String, dynamic>;

            if (data["status"] == "completed") {
              completed++;
              revenue += data["totalAmount"];
            } else {
              active++;
            }
          }

          return Padding(

            padding: const EdgeInsets.all(16),

            child: GridView.count(

              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,

              children: [

                statCard("Total Orders", totalOrders.toString(), Icons.receipt),

                statCard("Completed", completed.toString(), Icons.check),

                statCard("Active Orders", active.toString(), Icons.timer),

                statCard("Revenue", "₹${revenue.toStringAsFixed(0)}", Icons.currency_rupee),

              ],
            ),
          );
        },
      ),
    );
  }

  Widget statCard(String title, String value, IconData icon) {

    return Container(

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 6,
          )
        ],
      ),

      child: Padding(

        padding: const EdgeInsets.all(16),

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,

          children: [

            Icon(icon, size: 40, color: Colors.orange),

            const SizedBox(height: 10),

            Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              title,
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),

          ],
        ),
      ),
    );
  }
}