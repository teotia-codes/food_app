import 'package:cloud_firestore/cloud_firestore.dart';

class OrderChatMessageModel {
  final String id;
  final String senderId;
  final String senderType;
  final String text;
  final String imageBase64;
  final String messageType; // text | image
  final Timestamp? timestamp;

  OrderChatMessageModel({
    required this.id,
    required this.senderId,
    required this.senderType,
    required this.text,
    required this.imageBase64,
    required this.messageType,
    required this.timestamp,
  });

  factory OrderChatMessageModel.fromMap(
    Map<String, dynamic> map,
    String docId,
  ) {
    return OrderChatMessageModel(
      id: docId,
      senderId: map['senderId'] ?? '',
      senderType: map['senderType'] ?? '',
      text: map['text'] ?? '',
      imageBase64: map['imageBase64'] ?? '',
      messageType: map['messageType'] ?? 'text',
      timestamp: map['timestamp'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'senderType': senderType,
      'text': text,
      'imageBase64': imageBase64,
      'messageType': messageType,
      'timestamp': FieldValue.serverTimestamp(),
    };
  }
}