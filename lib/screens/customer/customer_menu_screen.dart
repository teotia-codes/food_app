import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/menu_provider.dart';
import '../../providers/cart_provider.dart';
import '../../models/menu_item_model.dart';
import '../customer/cart_screen.dart';

class CustomerMenuScreen extends StatefulWidget {
  const CustomerMenuScreen({super.key});

  @override
  State<CustomerMenuScreen> createState() => _CustomerMenuScreenState();
}

class _CustomerMenuScreenState extends State<CustomerMenuScreen> {

  String selectedCategory = "All";

  @override
  Widget build(BuildContext context) {

    final provider = Provider.of<MenuProvider>(context);
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(

      backgroundColor: const Color(0xffF5F5F5),

      appBar: AppBar(
        elevation: 0,
        title: const Text("Delicious Food"),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange, Colors.deepOrange],
            ),
          ),
        ),
      ),

      body: Stack(

        children: [

          Column(
            children: [

              /// CATEGORY CHIPS
              Container(
                height: 60,
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [

                    categoryChip("All"),
                    categoryChip("Burger"),
                    categoryChip("Pizza"),
                    categoryChip("Drinks"),
                    categoryChip("Snacks"),

                  ],
                ),
              ),

              /// MENU LIST
              Expanded(
                child: StreamBuilder<List<MenuItemModel>>(

                  stream: provider.menuStream,

                  builder: (context, snapshot) {

                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    final items = snapshot.data!;

                    final filtered = selectedCategory == "All"
                        ? items
                        : items.where((e) =>
                            e.category.toLowerCase() ==
                            selectedCategory.toLowerCase()).toList();

                    return ListView.builder(

                      padding: const EdgeInsets.only(bottom: 90),

                      itemCount: filtered.length,

                      itemBuilder: (context, index) {

                        final item = filtered[index];

                        if (!item.isAvailable) return const SizedBox();

                        return Container(

                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),

                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 8,
                                color: Colors.grey.withOpacity(0.2),
                              )
                            ],
                          ),

                          child: Padding(

                            padding: const EdgeInsets.all(14),

                            child: Row(

                              children: [

                                /// FOOD IMAGE
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
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
                                          child: const Icon(Icons.fastfood),
                                        ),
                                ),

                                const SizedBox(width: 14),

                                /// DETAILS
                                Expanded(

                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [

                                      Text(
                                        item.name,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),

                                      const SizedBox(height: 5),

                                      Text(
                                        "₹${item.price}",
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),

                                      const SizedBox(height: 6),

                                      Text(
                                        item.description,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      )

                                    ],
                                  ),
                                ),

                                /// ADD BUTTON
                                ElevatedButton(

                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange,
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10),
                                    ),
                                  ),

                                  onPressed: () {

                                    cart.addItem(
                                      item.id,
                                      item.name,
                                      item.price,
                                    );

                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(

                                      const SnackBar(
                                        content: Text("Added to cart"),
                                      ),

                                    );
                                  },

                                  child: const Text("ADD"),

                                )

                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),

          /// FLOATING CART BAR
          if (cart.items.isNotEmpty)
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,

              child: GestureDetector(

                onTap: () {

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CartScreen(),
                    ),
                  );
                },

                child: Container(

                  padding: const EdgeInsets.all(16),

                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 8,
                        color: Colors.black.withOpacity(0.2),
                      )
                    ],
                  ),

                  child: Row(

                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,

                    children: [

                      Text(
                        "${cart.items.length} items | ₹${cart.totalPrice}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const Text(
                        "View Cart →",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      )

                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget categoryChip(String title) {

    final selected = selectedCategory == title;

    return GestureDetector(

      onTap: () {
        setState(() {
          selectedCategory = title;
        });
      },

      child: Container(

        margin: const EdgeInsets.symmetric(horizontal: 8),

        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 8,
        ),

        decoration: BoxDecoration(

          color: selected ? Colors.orange : Colors.white,

          borderRadius: BorderRadius.circular(30),

          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 4,
            )
          ],
        ),

        child: Text(
          title,
          style: TextStyle(
            color: selected ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}