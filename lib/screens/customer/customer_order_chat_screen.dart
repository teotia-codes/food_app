import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/order_chat_message_model.dart';
import '../../services/order_chat_service.dart';

class CustomerOrderChatScreen extends StatefulWidget {
  final String orderId;

  const CustomerOrderChatScreen({
    super.key,
    required this.orderId,
  });

  @override
  State<CustomerOrderChatScreen> createState() => _CustomerOrderChatScreenState();
}

class _CustomerOrderChatScreenState extends State<CustomerOrderChatScreen> {
  final OrderChatService chatService = OrderChatService();
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final ImagePicker picker = ImagePicker();

  final String customerId = "customer_1";

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 200), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _pickAndSendImage() async {
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 25, // compress strongly
    );

    if (image == null) return;

    final bytes = await File(image.path).readAsBytes();
    final base64String = base64Encode(bytes);

    if (base64String.length > 700000) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Image too large. Please choose a smaller image."),
        ),
      );
      return;
    }

    await chatService.sendImageMessage(
      orderId: widget.orderId,
      senderId: customerId,
      senderType: "customer",
      imageBase64: base64String,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat with Vendor"),
        backgroundColor: Colors.orange,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<OrderChatMessageModel>>(
              stream: chatService.getMessages(widget.orderId),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final messages = snapshot.data!;

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _scrollToBottom();
                });

                if (messages.isEmpty) {
                  return const Center(
                    child: Text("Start chatting about this order 🍔"),
                  );
                }

                return ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    final isMe = msg.senderType == "customer";

                    return Align(
                      alignment:
                          isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        padding: const EdgeInsets.all(10),
                        constraints: const BoxConstraints(maxWidth: 280),
                        decoration: BoxDecoration(
                          color: isMe ? Colors.orange : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: msg.messageType == "image"
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.memory(
                                  base64Decode(msg.imageBase64),
                                  width: 220,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Text(
                                msg.text,
                                style: TextStyle(
                                  color: isMe ? Colors.white : Colors.black87,
                                  fontSize: 15,
                                ),
                              ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          SafeArea(
            child: Container(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 12),
              color: Colors.white,
              child: Row(
                children: [
                  IconButton(
                    onPressed: _pickAndSendImage,
                    icon: const Icon(Icons.image, color: Colors.orange),
                  ),
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      decoration: InputDecoration(
                        hintText: "Type a message...",
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: Colors.orange,
                    child: IconButton(
                      onPressed: () async {
                        final text = messageController.text.trim();
                        if (text.isEmpty) return;

                        await chatService.sendTextMessage(
                          orderId: widget.orderId,
                          senderId: customerId,
                          senderType: "customer",
                          text: text,
                        );

                        messageController.clear();
                      },
                      icon: const Icon(Icons.send, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}