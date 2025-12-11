import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:second_life/models/products/product_model.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// CREATE CHAT ROOM (Jika sudah ada, return existing)
  Future<String> createChatRoom({
    required String user1,
    required String user2,
    required String productId,
  }) async {
    // Cek apakah chat antara user1-user2-product sudah ada
    final existing = await _firestore
        .collection('chats')
        .where('participants', arrayContains: user1)
        .get();

    for (var d in existing.docs) {
      final data = d.data();
      final participants = List<String>.from(data['participants'] ?? []);
      final existingProductId = data['productId'] ?? '';
      
      if (participants.contains(user2) && existingProductId == productId) {
        // Chat sudah ada untuk produk yang sama, return ID
        return d.id;
      }
    }

    // Buat chat baru
    final chatId = _firestore.collection('chats').doc().id;
    final chatRef = _firestore.collection('chats').doc(chatId);

    await chatRef.set({
      'participants': [user1, user2],
      'productId': productId,
      'productName': '',
      'lastMessage': '',
      'updatedAt': FieldValue.serverTimestamp(),
      'unreadCounts': {
        user1: 0,
        user2: 0,
      },
      'deletedBy': [], // Array kosong untuk awal
    });

    return chatId;
  }

  /// AUTO PRODUCT MESSAGE - BUG FIX: Cek apakah sudah pernah kirim auto message
  Future<void> sendAutoProductMessage({
    required String chatId,
    required String senderId,
    required ProductModel product,
  }) async {
    // BUG FIX: Cek apakah sudah ada auto message untuk produk ini
    final existingMessages = await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .where('isAuto', isEqualTo: true)
        .where('senderId', isEqualTo: senderId)
        .limit(1)
        .get();

    // Jika sudah pernah kirim auto message, skip
    if (existingMessages.docs.isNotEmpty) {
      return;
    }

    // Kirim auto message
    final msgRef = _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc();

    await msgRef.set({
      'senderId': senderId,
      'text': "Halo! Saya tertarik dengan produk ${product.nama}",
      'timestamp': FieldValue.serverTimestamp(),
      'isAuto': true,
      'productId': product.id, // Tambahkan productId untuk tracking
    });

    // Update summary chat
    await _firestore.collection('chats').doc(chatId).update({
      'lastMessage': "Tertarik: ",
      'productName': product.nama,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}
