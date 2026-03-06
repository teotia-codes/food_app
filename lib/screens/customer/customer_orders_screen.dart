import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'order_tracking_screen.dart';

class CustomerOrdersScreen extends StatelessWidget {
  const CustomerOrdersScreen({super.key});

  Color getStatusColor(String status) {
    switch (status) {
      case "placed":
        return Colors.orange;
      case "accepted":
        return Colors.blue;
      case "preparing":
        return Colors.deepOrange;
      case "ready":
        return Colors.green;
      case "completed":
        return Colors.grey;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {

    final db = FirebaseFirestore.instance;

    return Scaffold(

      backgroundColor: const Color(0xffF5F5F5),

      appBar: AppBar(
        title: const Text("My Orders"),
        centerTitle: true,
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
            return const Center(
              child: Text(
                "No Orders Yet",
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          return ListView.builder(

            padding: const EdgeInsets.all(12),

            itemCount: orders.length,

            itemBuilder: (context, index) {

              final order = orders[index];
              final status = order["status"];

              return GestureDetector(

                onTap: () {

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => OrderTrackingScreen(
                        orderId: order.id,
                      ),
                    ),
                  );
                },

                child: Container(

                  margin: const EdgeInsets.symmetric(vertical: 8),

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 6,
                        color: Colors.grey.withOpacity(0.2),
                      )
                    ],
                  ),

                  child: Padding(

                    padding: const EdgeInsets.all(16),

                    child: Column(

                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [

                        /// ORDER HEADER
                        Row(

                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,

                          children: [

                            Text(
                              "Order #${order.id.substring(0, 6)}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),

                            Chip(
                              label: Text(status),
                              backgroundColor:
                                  getStatusColor(status).withOpacity(0.2),
                              labelStyle: TextStyle(
                                color: getStatusColor(status),
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                          ],
                        ),

                        const SizedBox(height: 10),

                        /// TOTAL
                        Text(
                          "Total: ₹${order["totalAmount"]}",
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        const SizedBox(height: 10),

                        const Divider(),

                        const Text(
                          "Items",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 6),

                        /// ITEMS
                        ...List.generate(
                          order["items"].length,
                          (i) {

                            final item = order["items"][i];

                            return Padding(

                              padding:
                                  const EdgeInsets.symmetric(vertical: 2),

                              child: Row(

                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,

                                children: [

                                  Text("${item["name"]}"),

                                  Text("x${item["qty"]}"),

                                ],
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 10),

                        /// TRACK BUTTON
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(

                            onPressed: () {

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => OrderTrackingScreen(
                                    orderId: order.id,
                                  ),
                                ),
                              );
                            },

                            child: const Text("Track Order →"),
                          ),
                        )

                      ],
                    ),
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