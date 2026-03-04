import 'package:flutter/material.dart';
import 'package:food_app/screens/vendor/vendor_order_detail_screen.dart';
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

              return  
              InkWell(
                onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => VendorOrderDetailScreen(order: order),
      ),
    );
  },
                child: Card(
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(16),
  ),
  elevation: 3,
  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  child: Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Text(
          "Order ID: ${order.orderId}",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 8),

        Text("Total: ₹${order.totalAmount}"),

        const SizedBox(height: 8),

        Chip(
          label: Text(order.status),
          backgroundColor: Colors.orange.shade100,
        ),

        const SizedBox(height: 12),

        if (order.status == "placed")
          Row(
            children: [

              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    provider.changeOrderStatus(order.orderId, "accepted");
                  },
                  child: const Text("Accept"),
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  onPressed: () {
                    provider.changeOrderStatus(order.orderId, "cancelled");
                  },
                  child: const Text("Reject"),
                ),
              ),
            ],
          ),
      ],
    ),
  ),
)
              );
            },
          );
        },
      ),
    );
  }
}