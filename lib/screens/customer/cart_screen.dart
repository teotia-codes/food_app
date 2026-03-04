import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final cart = Provider.of<CartProvider>(context);

    return Scaffold(

      backgroundColor: const Color(0xffF5F5F5),

      appBar: AppBar(
        title: const Text("Your Cart"),
        centerTitle: true,
      ),

      body: cart.items.isEmpty
          ? const Center(
              child: Text(
                "Cart is empty",
                style: TextStyle(fontSize: 16),
              ),
            )
          : Column(
              children: [

                Expanded(
                  child: ListView.builder(

                    padding: const EdgeInsets.only(top: 10),

                    itemCount: cart.items.length,

                    itemBuilder: (context, index) {

                      final item = cart.items[index];

                      return Container(

                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),

                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.15),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            )
                          ],
                        ),

                        child: Padding(

                          padding: const EdgeInsets.all(14),

                          child: Row(

                            children: [

                              const Icon(
                                Icons.fastfood,
                                color: Colors.orange,
                                size: 30,
                              ),

                              const SizedBox(width: 16),

                              Expanded(

                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [

                                    Text(
                                      item.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),

                                    const SizedBox(height: 5),

                                    Text(
                                      "₹${item.price}",
                                      style: const TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),

                                  ],
                                ),
                              ),

                              /// QUANTITY CONTROLS
                              Row(

                                children: [

                                  IconButton(

                                    icon: const Icon(Icons.remove_circle),

                                    onPressed: () {
                                      cart.decreaseQty(item.itemId);
                                    },

                                  ),

                                  Text(
                                    item.qty.toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),

                                  IconButton(

                                    icon: const Icon(Icons.add_circle,
                                        color: Colors.orange),

                                    onPressed: () {
                                      cart.increaseQty(item.itemId);
                                    },

                                  ),

                                ],
                              ),

                              /// REMOVE BUTTON
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  cart.removeItem(item.itemId);
                                },
                              ),

                              /// PRICE
                              Text(
                                "₹${item.price * item.qty}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              )

                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                /// TOTAL + CHECKOUT

                Container(

                  padding: const EdgeInsets.all(16),

                  decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 6,
                        color: Colors.black12,
                      )
                    ],
                  ),

                  child: Column(
                    children: [

                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [

                          const Text(
                            "Total",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),

                          Text(
                            "₹${cart.totalPrice}",
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),

                        ],
                      ),

                      const SizedBox(height: 12),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(

                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            padding: const EdgeInsets.symmetric(
                                vertical: 14),
                          ),

                          onPressed: () async {

                            await cart.placeOrder();

                            ScaffoldMessenger.of(context)
                                .showSnackBar(

                              const SnackBar(
                                content:
                                    Text("Order Placed Successfully"),
                              ),

                            );
                          },

                          child: const Text(
                            "Place Order",
                            style: TextStyle(fontSize: 16),
                          ),

                        ),
                      ),

                    ],
                  ),
                )

              ],
            ),
    );
  }
}