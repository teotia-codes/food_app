import 'package:cloud_firestore/cloud_firestore.dart';
import 'cart_item_model.dart';

class OrderModel {
  final String orderId;
  final String userId;
  final List<CartItemModel> items;
  final double totalAmount;
  final String status;
  final Timestamp timestamp;

  OrderModel({
    required this.orderId,
    required this.userId,
    required this.items,
    required this.totalAmount,
    required this.status,
    required this.timestamp,
  });

  factory OrderModel.fromMap(Map<String, dynamic> map, String id) {
    List<CartItemModel> itemList =
        (map['items'] as List).map((e) => CartItemModel.fromMap(e)).toList();

    return OrderModel(
      orderId: id,
      userId: map['userId'],
      items: itemList,
      totalAmount: (map['totalAmount'] as num).toDouble(),
      status: map['status'],
      timestamp: map['timestamp'],
    );
  }
}