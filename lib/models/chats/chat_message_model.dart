import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessageModel {
  final String messageId;
  final String senderId;
  final String text;
  final Timestamp timestamp;
  final String? type;
  final String? productName;
  final String? productBase64;
  final String? productPrice;
  final String? productId;
  final List<String> deletedBy;

  ChatMessageModel({
    required this.messageId,
    required this.senderId,
    required this.text,
    required this.timestamp,
    this.type,
    this.productName,
    this.productBase64,
    this.productPrice,
    this.productId,
    this.deletedBy = const [],
  });

  factory ChatMessageModel.fromDoc(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;

    return ChatMessageModel(
      messageId: doc.id,
      senderId: d['senderId'] ?? '',
      text: d['text'] ?? '',
      timestamp: d['timestamp'] ?? Timestamp.now(),
      type: d['type'],
      productName: d['productName'],
      productBase64: d['productBase64'],
      productPrice: d['productPrice'],
      productId: d['productId'],
      deletedBy: List<String>.from(d['deletedBy'] ?? []),
    );
  }
}