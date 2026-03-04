import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:food_app/screens/vendor/add_menu_item_screen.dart';
import 'package:provider/provider.dart';

import '../../providers/menu_provider.dart';
import '../../models/menu_item_model.dart';

class VendorMenuScreen extends StatelessWidget {
  const VendorMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final provider = Provider.of<MenuProvider>(context);

    return Scaffold(

      appBar: AppBar(
        title: const Text("Restaurant Menu"),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: () {

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddMenuItemScreen(),
            ),
          );

        },
        child: const Icon(Icons.add),
      ),

      body: StreamBuilder<List<MenuItemModel>>(

        stream: provider.menuStream,

        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final items = snapshot.data!;

          if (items.isEmpty) {
            return const Center(
              child: Text("No food items added"),
            );
          }

          return ListView.builder(

            itemCount: items.length,

            itemBuilder: (context, index) {

              final item = items[index];

              return Card(

                elevation: 3,

                margin: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),

                child: ListTile(

                  contentPadding: const EdgeInsets.all(12),

                  // FOOD IMAGE
                  leading: ClipRRect(

                    borderRadius: BorderRadius.circular(8),

                    child: item.imageBase64.isNotEmpty
                        ? Image.memory(
                            base64Decode(item.imageBase64),
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            width: 60,
                            height: 60,
                            color: Colors.orange.shade100,
                            child: const Icon(
                              Icons.fastfood,
                              color: Colors.orange,
                            ),
                          ),
                  ),

                  title: Text(
                    item.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),

                  subtitle: Text(
                    "₹${item.price} • ${item.category}",
                    style: const TextStyle(fontSize: 13),
                  ),

                  trailing: Switch(
                    activeColor: Colors.orange,
                    value: item.isAvailable,
                    onChanged: (val) {
                      provider.toggleItem(item.id, val);
                    },
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