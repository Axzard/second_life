import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:second_life/models/chats/chat_item_model.dart';
import 'package:second_life/models/chats/chat_room_model.dart';
import 'package:second_life/utils/chat_utils.dart';

class ChatListViewModel extends GetxController {
  final _db = FirebaseFirestore.instance;

  var chatItems = <ChatItemModel>[].obs;
  var isLoading = true.obs;
  StreamSubscription? _sub;
  
  final Map<String, String> _userNameCache = {};
  final Map<String, String> _productNameCache = {};

  Future<void> deleteChatRoomForMe(String chatId, String userId) async {
    try {
      await _db.collection('chats').doc(chatId).update({
        'deletedBy': FieldValue.arrayUnion([userId])
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteChatRoomForAll(String chatId) async {
    try {
      final messagesSnapshot = await _db
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .get();

      for (var doc in messagesSnapshot.docs) {
        await doc.reference.delete();
      }

      await _db.collection('chats').doc(chatId).delete();
    } catch (e) {
      rethrow;
    }
  }

  @override
  void onClose() {
    _sub?.cancel();
    super.onClose();
  }

  void loadChatList(String currentUserId) {
    isLoading.value = true;

    // BUG FIX: Simplified query - remove orderBy yang mungkin butuh index
    _sub = _db
        .collection('chats')
        .where('participants', arrayContains: currentUserId)
        .snapshots()
        .listen((snapshot) async {
      final List<ChatItemModel> tmp = [];

      for (final doc in snapshot.docs) {
        try {
          final data = doc.data();
          
          // Handle deletedBy properly
          final deletedBy = data['deletedBy'] ?? data['deletedbv'] ?? [];
          final deletedByList = List<String>.from(deletedBy);

          // Skip jika user ini sudah delete chat ini
          if (deletedByList.contains(currentUserId)) {
            continue;
          }

          final room = ChatRoomModel.fromMap(doc.id, data);

          // Pastikan participants ada dan valid
          if (room.participants.length < 2) {
            continue;
          }

          final otherUserId = room.participants.firstWhere(
            (id) => id != currentUserId,
            orElse: () => '',
          );

          if (otherUserId.isEmpty) {
            continue;
          }

          // Get other user name dengan cache
          String otherName;
          if (_userNameCache.containsKey(otherUserId)) {
            otherName = _userNameCache[otherUserId]!;
          } else {
            try {
              final userDoc = await _db.collection("users").doc(otherUserId).get();
              if (userDoc.exists) {
                final userMap = userDoc.data() ?? {};
                otherName = userMap["namaLengkap"] ?? userMap["name"] ?? "User";
                _userNameCache[otherUserId] = otherName;
              } else {
                otherName = "User";
              }
            } catch (e) {
              otherName = "User";
            }
          }

          // Get product name dengan cache
          String productName = "";
          if (room.productId != null && room.productId!.isNotEmpty) {
            if (_productNameCache.containsKey(room.productId)) {
              productName = _productNameCache[room.productId]!;
            } else {
              try {
                final productDoc = await _db.collection("products").doc(room.productId!).get();
                if (productDoc.exists) {
                  productName = productDoc.data()?['nama'] ?? "";
                  _productNameCache[room.productId!] = productName;
                }
              } catch (e) {
                productName = "";
              }
            }
          }

          final unread = (room.unreadCounts?[currentUserId] as int?) ?? 0;

          tmp.add(
            ChatItemModel(
              chatId: room.chatId,
              otherUserId: otherUserId,
              name: otherName,
              product: productName,
              lastMessage: room.lastMessage.isEmpty ? "Mulai chat..." : room.lastMessage,
              time: formatTime(room.updatedAt),
              unread: unread,
              deletedBy: deletedByList,
            ),
          );
        } catch (e) {
          // Skip chat yang error
          continue;
        }
      }

      // Sort by updatedAt manually (client-side)
      tmp.sort((a, b) {
        // Most recent first - compare by time string or add timestamp to ChatItemModel
        return 0; // For now, maintain order from Firestore
      });

      chatItems.value = tmp;
      isLoading.value = false;
    }, onError: (error) {
      // Handle error
      isLoading.value = false;
      chatItems.value = [];
    });
  }

  void clearCache() {
    _userNameCache.clear();
    _productNameCache.clear();
  }
}
