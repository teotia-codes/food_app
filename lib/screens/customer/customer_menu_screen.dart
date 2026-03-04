import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/menu_provider.dart';
import '../../providers/cart_provider.dart';
import '../../models/menu_item_model.dart';

class CustomerMenuScreen extends StatelessWidget {
  const CustomerMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final provider = Provider.of<MenuProvider>(context);
    final cart = Provider.of<CartProvider>(context, listen: false);

    return Scaffold(

      backgroundColor: const Color(0xffF5F5F5),

      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Restaurant Menu",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: StreamBuilder<List<MenuItemModel>>(

        stream: provider.menuStream,

        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final items = snapshot.data!;

          if (items.isEmpty) {
            return const Center(
              child: Text(
                "No food available",
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          return ListView.builder(

            padding: const EdgeInsets.only(top: 10, bottom: 20),

            itemCount: items.length,

            itemBuilder: (context, index) {

              final item = items[index];

              if (!item.isAvailable) return const SizedBox();

              return Container(

                margin: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.15),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),

                child: Padding(

                  padding: const EdgeInsets.all(14),

                  child: Row(

                    children: [

                      /// FOOD IMAGE
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: item.imageBase64.isNotEmpty
                            ? Image.memory(
                                base64Decode(item.imageBase64),
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                width: 80,
                                height: 80,
                                color: Colors.orange.shade100,
                                child: const Icon(
                                  Icons.fastfood,
                                  color: Colors.orange,
                                  size: 35,
                                ),
                              ),
                      ),

                      const SizedBox(width: 16),

                      /// FOOD DETAILS
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Text(
                              item.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                            ),

                            const SizedBox(height: 6),

                            Text(
                              item.category,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.grey,
                              ),
                            ),

                            const SizedBox(height: 8),

                            Text(
                              "₹${item.price}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.orange,
                              ),
                            ),

                          ],
                        ),
                      ),

                      /// ADD BUTTON
                      ElevatedButton(

                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0,
                        ),

                        onPressed: () {

                          cart.addItem(
                            item.id,
                            item.name,
                            item.price,
                          );

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.green,
                              behavior: SnackBarBehavior.floating,
                              content: Text("${item.name} added to cart"),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },

                        child: const Text(
                          "ADD",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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