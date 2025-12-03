import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoomModel {
  final String chatId;
  final List<String> participants;
  final String? productId;
  final String? productName;
  final String lastMessage;
  final DateTime updatedAt;
  final Map<String, dynamic>? unreadCounts;
  final List<String> deletedBy;

  ChatRoomModel({
    required this.chatId,
    required this.participants,
    required this.lastMessage,
    required this.updatedAt,
    this.productId,
    this.productName,
    this.unreadCounts,
    required this.deletedBy,
  });

  factory ChatRoomModel.fromMap(String id, Map<String, dynamic> data) {
    // 🔥 HANDLE BOTH FIELD NAMES: deletedBy DAN deletedbv (typo)
    final deletedBy = data['deletedBy'] ?? data['deletedbv'] ?? [];
    
    return ChatRoomModel(
      chatId: id,
      participants: List<String>.from(data['participants'] ?? []),
      productId: data['productId'],
      productName: data['productName'],
      lastMessage: data['lastMessage'] ?? '',
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      unreadCounts: Map<String, dynamic>.from(data['unreadCounts'] ?? {}),
      deletedBy: List<String>.from(deletedBy), // Gunakan field yang benar
    );
  }

  bool isDeletedBy(String userId) {
    return deletedBy.contains(userId);
  }
}