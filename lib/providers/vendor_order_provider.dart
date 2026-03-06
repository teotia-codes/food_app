import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_app/services/notification_service.dart';
import '../models/order_model.dart';
import '../services/firestore_service.dart';

class VendorOrderProvider extends ChangeNotifier {
  final FirestoreService _service = FirestoreService();
  
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  List<OrderModel> _orders = [];
  List<OrderModel> get orders => _orders;

  void listenOrders() {

    _db.collection("orders")
        .orderBy("timestamp", descending: true)
        .snapshots()
        .listen((snapshot) {

      final newOrders = snapshot.docs
          .map((doc) => OrderModel.fromMap(doc.data(), doc.id))
          .toList();

      /// Detect new order
      if (_orders.isNotEmpty && newOrders.length > _orders.length) {

        NotificationService.showNotification(
          "New Order Received",
          "Customer placed a new order",
        );

      }

      _orders = newOrders;

      notifyListeners();
    });
  }
  Stream<List<OrderModel>> get ordersStream => _service.getOrdersStream();

  Future<void> changeOrderStatus(String orderId, String status) async {
    await _service.updateOrderStatus(orderId, status);
  }

  // NEW
  Future<void> addTestOrder() async {
    await _service.createTestOrder();
  }
}