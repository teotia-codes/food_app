import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/vendor_order_provider.dart';

class TestOrderScreen extends StatelessWidget {
  const TestOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<VendorOrderProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text("Developer Test Panel")),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await provider.addTestOrder();

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Test Order Sent!")),
            );
          },
          child: const Text("CREATE TEST ORDER"),
        ),
      ),
    );
  }
}