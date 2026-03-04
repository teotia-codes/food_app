import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_app/models/menu_item_model.dart';
import '../models/order_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  // ➕ Add Menu Item
Future<void> addMenuItem(MenuItemModel item) async {
  final doc = _db.collection('menu').doc();
  await doc.set(item.toMap());
}

// 📡 Get Menu Stream (Realtime)
Stream<List<MenuItemModel>> getMenuStream() {
  return _db.collection('menu').snapshots().map((snapshot) {
    return snapshot.docs
        .map((doc) => MenuItemModel.fromMap(doc.data(), doc.id))
        .toList();
  });
}

// 🔄 Toggle Availability
Future<void> toggleAvailability(String id, bool value) async {
  await _db.collection('menu').doc(id).update({
    "isAvailable": value,
  });
}
  // 🔥 Stream all orders (Realtime)
  Stream<List<OrderModel>> getOrdersStream() {
    return _db
        .collection('orders')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => OrderModel.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  // ✅ Update Order Status
  Future<void> updateOrderStatus(String orderId, String status) async {
    await _db.collection('orders').doc(orderId).update({
      'status': status,
    });
  }

  // 🧪 CREATE TEST ORDER (Fake Customer)
  Future<void> createTestOrder() async {
    final orderRef = _db.collection('orders').doc();

    await orderRef.set({
      "userId": "test_customer_001",
      "items": [
        {
          "itemId": "101",
          "name": "Veg Burger",
          "qty": 2,
          "price": 80
        },
        {
          "itemId": "102",
          "name": "French Fries",
          "qty": 1,
          "price": 120
        },
        {
          "itemId": "103",
          "name": "Cold Coffee",
          "qty": 1,
          "price": 140
        }
      ],
      "totalAmount": 420,
      "status": "placed",
      "timestamp": FieldValue.serverTimestamp(),
    });
  }
}