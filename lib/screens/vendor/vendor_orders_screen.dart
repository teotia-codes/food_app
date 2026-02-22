import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/vendor_order_provider.dart';
import '../../models/order_model.dart';

class VendorOrdersScreen extends StatelessWidget {
  const VendorOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<VendorOrderProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Incoming Orders"),
      ),
      body: StreamBuilder<List<OrderModel>>(
        stream: provider.ordersStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final orders = snapshot.data!;

          if (orders.isEmpty) {
            return const Center(child: Text("No Orders Yet"));
          }

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];

              return Card(
                margin: const EdgeInsets.all(10),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Order ID: ${order.orderId}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text("Total: ₹${order.totalAmount}"),
                      Text("Status: ${order.status}"),
                      const SizedBox(height: 10),

                      // 🔥 Accept / Reject Buttons
                      if (order.status == "placed")
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                provider.changeOrderStatus(
                                    order.orderId, "accepted");
                              },
                              child: const Text("Accept"),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red),
                              onPressed: () {
                                provider.changeOrderStatus(
                                    order.orderId, "cancelled");
                              },
                              child: const Text("Reject"),
                            ),
                          ],
                        ),
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