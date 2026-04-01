import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/order_chat_message_model.dart';

class OrderChatService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<OrderChatMessageModel>> getMessages(String orderId) {
    return _db
        .collection('orders')
        .doc(orderId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => OrderChatMessageModel.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  Future<void> sendTextMessage({
    required String orderId,
    required String senderId,
    required String senderType,
    required String text,
  }) async {
    final orderRef = _db.collection('orders').doc(orderId);

    await orderRef.set({
      'lastChatMessage': text,
      'lastChatTimestamp': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    await orderRef.collection('messages').add({
      'senderId': senderId,
      'senderType': senderType,
      'text': text,
      'imageBase64': '',
      'messageType': 'text',
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<void> sendImageMessage({
    required String orderId,
    required String senderId,
    required String senderType,
    required String imageBase64,
  }) async {
    final orderRef = _db.collection('orders').doc(orderId);

    await orderRef.set({
      'lastChatMessage': '📷 Photo',
      'lastChatTimestamp': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    await orderRef.collection('messages').add({
      'senderId': senderId,
      'senderType': senderType,
      'text': '',
      'imageBase64': imageBase64,
      'messageType': 'image',
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}