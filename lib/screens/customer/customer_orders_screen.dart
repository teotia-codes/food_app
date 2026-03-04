import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CustomerOrdersScreen extends StatelessWidget {
  const CustomerOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final db = FirebaseFirestore.instance;

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Orders"),
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: db
            .collection("orders")
            .where("userId", isEqualTo: "customer_1")
            .orderBy("timestamp", descending: true)
            .snapshots(),

        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final orders = snapshot.data!.docs;

          if (orders.isEmpty) {
            return const Center(child: Text("No Orders Yet"));
          }

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {

              final order = orders[index];

              return Card(
                margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10),

                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text(
                        "Order ID: ${order.id}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text("Total: ₹${order["totalAmount"]}"),

                      const SizedBox(height: 10),

                      Chip(
                        label: Text(order["status"]),
                        backgroundColor: Colors.orange.shade100,
                      ),

                      const SizedBox(height: 10),

                      const Text(
                        "Items",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 5),

                      ...List.generate(
                        order["items"].length,
                        (i) {
                          final item = order["items"][i];

                          return Text(
                            "${item["name"]} x${item["qty"]}",
                          );
                        },
                      )

                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}