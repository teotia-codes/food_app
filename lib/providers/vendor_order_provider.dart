import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../services/firestore_service.dart';

class VendorOrderProvider extends ChangeNotifier {
  final FirestoreService _service = FirestoreService();

  Stream<List<OrderModel>> get ordersStream => _service.getOrdersStream();

  Future<void> changeOrderStatus(String orderId, String status) async {
    await _service.updateOrderStatus(orderId, status);
  }
}