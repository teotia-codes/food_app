import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/order_model.dart';
import '../../providers/vendor_order_provider.dart';

class VendorOrderDetailScreen extends StatelessWidget {
  final OrderModel order;

  const VendorOrderDetailScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<VendorOrderProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Order ID: ${order.orderId}",
                style: const TextStyle(fontWeight: FontWeight.bold)),

            const SizedBox(height: 10),
            Text("Customer ID: ${order.userId}"),

            const SizedBox(height: 20),
            const Text("Items",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

            const Divider(),

            // 🔥 Item List
            Expanded(
              child: ListView.builder(
                itemCount: order.items.length,
                itemBuilder: (context, index) {
                  final item = order.items[index];

                  return Card(
  elevation: 2,
  margin: const EdgeInsets.symmetric(vertical: 6),
  child: ListTile(
    title: Text(item.name),
    subtitle: Text("Quantity: ${item.qty}"),
    trailing: Text(
      "₹${item.price * item.qty}",
      style: const TextStyle(fontWeight: FontWeight.bold),
    ),
  ),
);
                },
              ),
            ),

            const Divider(),

            Text("Total: ₹${order.totalAmount}",
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold)),

            const SizedBox(height: 20),

            // 🔥 Status Buttons
            if (order.status == "accepted")
              ElevatedButton(
                onPressed: () {
                  provider.changeOrderStatus(order.orderId, "preparing");
                  Navigator.pop(context);
                },
                child: const Text("Start Preparing"),
              ),

            if (order.status == "preparing")
              ElevatedButton(
                onPressed: () {
                  provider.changeOrderStatus(order.orderId, "ready");
                  Navigator.pop(context);
                },
                child: const Text("Mark as Ready"),
              ),

            if (order.status == "ready")
              ElevatedButton(
                onPressed: () {
                  provider.changeOrderStatus(order.orderId, "completed");
                  Navigator.pop(context);
                },
                child: const Text("Order Completed"),
              ),
          ],
        ),
      ),
    );
  }
}