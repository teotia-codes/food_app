import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderTrackingScreen extends StatelessWidget {
  final String orderId;

  const OrderTrackingScreen({super.key, required this.orderId});

  int getStep(String status) {
    switch (status) {
      case "placed":
        return 0;
      case "accepted":
        return 1;
      case "preparing":
        return 2;
      case "ready":
        return 3;
      case "completed":
        return 4;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Track Order"),
      ),

      body: StreamBuilder<DocumentSnapshot>(

        stream: FirebaseFirestore.instance
            .collection("orders")
            .doc(orderId)
            .snapshots(),

        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;
          final status = data["status"];

          final step = getStep(status);

          return Padding(

            padding: const EdgeInsets.all(20),

            child: Column(

              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                const Text(
                  "Order Progress",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 30),

                buildStep("Order Placed", 0, step),
                buildStep("Order Accepted", 1, step),
                buildStep("Preparing Food", 2, step),
                buildStep("Ready for Pickup", 3, step),
                buildStep("Completed", 4, step),

              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildStep(String title, int index, int currentStep) {

    bool completed = index <= currentStep;

    return Row(

      children: [

        Icon(
          completed ? Icons.check_circle : Icons.radio_button_unchecked,
          color: completed ? Colors.green : Colors.grey,
        ),

        const SizedBox(width: 12),

        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            color: completed ? Colors.black : Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),

        const SizedBox(height: 50),

      ],
    );
  }
}