import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/cart_item_model.dart';

class CartProvider extends ChangeNotifier {

  final List<CartItemModel> _items = [];

  List<CartItemModel> get items => _items;

  /// TOTAL PRICE
  double get totalPrice {
    double total = 0;
    for (var item in _items) {
      total += item.price * item.qty;
    }
    return total;
  }

  /// ADD ITEM TO CART
  void addItem(String id, String name, double price) {

    final index = _items.indexWhere((e) => e.itemId == id);

    if (index >= 0) {

      final existing = _items[index];

      _items[index] = CartItemModel(
        itemId: existing.itemId,
        name: existing.name,
        price: existing.price,
        qty: existing.qty + 1,
      );

    } else {

      _items.add(
        CartItemModel(
          itemId: id,
          name: name,
          price: price,
          qty: 1,
        ),
      );
    }

    notifyListeners();
  }

  /// INCREASE QUANTITY
  void increaseQty(String id) {

    final index = _items.indexWhere((e) => e.itemId == id);

    if (index >= 0) {

      final item = _items[index];

      _items[index] = CartItemModel(
        itemId: item.itemId,
        name: item.name,
        price: item.price,
        qty: item.qty + 1,
      );

      notifyListeners();
    }
  }

  /// DECREASE QUANTITY
  void decreaseQty(String id) {

    final index = _items.indexWhere((e) => e.itemId == id);

    if (index >= 0) {

      final item = _items[index];

      if (item.qty > 1) {

        _items[index] = CartItemModel(
          itemId: item.itemId,
          name: item.name,
          price: item.price,
          qty: item.qty - 1,
        );

      } else {

        /// REMOVE IF QTY BECOMES 0
        _items.removeAt(index);
      }

      notifyListeners();
    }
  }

  /// REMOVE ITEM
  void removeItem(String id) {

    _items.removeWhere((e) => e.itemId == id);

    notifyListeners();
  }

  /// CLEAR CART
  void clearCart() {

    _items.clear();

    notifyListeners();
  }

  /// PLACE ORDER TO FIRESTORE
  Future<void> placeOrder() async {

    if (_items.isEmpty) return;

    final db = FirebaseFirestore.instance;

    await db.collection("orders").add({

      "userId": "customer_1",

      "items": _items.map((e) => e.toMap()).toList(),

      "totalAmount": totalPrice,

      "status": "placed",

      "timestamp": FieldValue.serverTimestamp(),

    });

    clearCart();
  }
}