import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:second_life/models/chats/chat_message_model.dart';

class ChatRoomViewModel extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<ChatMessageModel>> getMessages(String chatId, String currentUserId) {
    return _db
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((d) => ChatMessageModel.fromDoc(d))
              .where((msg) => !msg.deletedBy.contains(currentUserId))
              .toList(),
        );
  }

  Stream<String> getUserStatusStream(String userId) {
    return _db.collection("users").doc(userId).snapshots().map((snapshot) {
      if (!snapshot.exists) return 'Offline';

      final data = snapshot.data();
      final isOnline = data?['isOnline'] ?? false;
      final lastSeen = data?['lastSeen'];

      if (isOnline == true) {
        return 'Online';
      } else if (lastSeen != null) {
        final lastSeenTime = lastSeen is Timestamp
            ? lastSeen.toDate()
            : DateTime.parse(lastSeen.toString());
        final now = DateTime.now();
        final difference = now.difference(lastSeenTime);

        if (difference.inMinutes < 1) return 'Baru saja';
        if (difference.inMinutes < 60) return '${difference.inMinutes} menit lalu';
        if (difference.inHours < 24) return '${difference.inHours} jam lalu';
        return '${difference.inDays} hari lalu';
      }

      return 'Offline';
    });
  }

  Future<void> deleteMessageForMe(String chatId, String messageId, String userId) async {
    try {
      final msgRef = _db
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .doc(messageId);

      await msgRef.update({
        'deletedBy': FieldValue.arrayUnion([userId])
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteMessageForAll(String chatId, String messageId) async {
    try {
      await _db
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .doc(messageId)
          .delete();

      final messagesSnapshot = await _db
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();

      if (messagesSnapshot.docs.isNotEmpty) {
        final lastMessage = messagesSnapshot.docs.first.data();
        await _db.collection('chats').doc(chatId).update({
          'lastMessage': lastMessage['text'],
          'lastSenderId': lastMessage['senderId'],
          'updatedAt': Timestamp.now(),
        });
      } else {
        await _db.collection('chats').doc(chatId).update({
          'lastMessage': '',
          'lastSenderId': '',
          'updatedAt': Timestamp.now(),
        });
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String text,
  }) async {
    final msgRef = _db
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc();

    final msg = {
      "senderId": senderId,
      "text": text,
      "timestamp": Timestamp.now(),
      "messageId": msgRef.id,
    };

    final chatRef = _db.collection("chats").doc(chatId);

    final batch = _db.batch();
    batch.set(msgRef, msg);

    batch.update(chatRef, {
      "lastMessage": text,
      "lastSenderId": senderId,
      "updatedAt": Timestamp.now(),
    });

    await batch.commit();

    try {
      await chatRef.update({
        "hiddenFor": FieldValue.arrayRemove([senderId]),
      });
    } catch (_) {}

    await _db.runTransaction((tx) async {
      final snap = await tx.get(chatRef);
      final data = snap.data() ?? {};
      final unread = Map<String, dynamic>.from(data["unreadCounts"] ?? {});

      (data["participants"] as List<dynamic>? ?? []).forEach((uid) {
        if (uid == senderId) {
          unread[uid] = 0;
        } else {
          unread[uid] = (unread[uid] ?? 0) + 1;
        }
      });

      tx.update(chatRef, {"unreadCounts": unread});
    });
  }

  Future<void> markAsRead(String chatId, String userId) async {
    await _db.collection("chats").doc(chatId).update({
      "unreadCounts.$userId": 0,
    });
  }

  Future<void> setUserOnline(String userId) async {
    await _db.collection("users").doc(userId).update({
      "isOnline": true,
      "lastSeen": Timestamp.now(),
    });
  }

  Future<void> setUserOffline(String userId) async {
    await _db.collection("users").doc(userId).update({
      "isOnline": false,
      "lastSeen": Timestamp.now(),
    });
  }

  Future<void> blockUser(String userId, String blockedId) async {
    await _db.collection("users").doc(userId).update({
      "blockedUsers": FieldValue.arrayUnion([blockedId]),
    });
  }

  Future<bool> isBlocked(String userId, String otherId) async {
    final doc = await _db.collection("users").doc(userId).get();
    final data = doc.data() ?? {};
    final blocked = List<String>.from(data["blockedUsers"] ?? []);
    return blocked.contains(otherId);
  }

  Future<void> deleteChatForUser(String chatId, String userId) async {
    final chatRef = _db.collection('chats').doc(chatId);

    try {
      final chatSnap = await chatRef.get();
      if (!chatSnap.exists) return;

      await chatRef.update({
        "hiddenFor": FieldValue.arrayUnion([userId]),
      });

      final updatedSnap = await chatRef.get();
      final data = updatedSnap.data() ?? {};
      final participants = List<String>.from(data['participants'] ?? []);
      final hiddenFor = List<String>.from(data['hiddenFor'] ?? []);

      if (participants.isNotEmpty) {
        final allHidden = participants.every((p) => hiddenFor.contains(p));
        if (allHidden) {
          final msgs = await chatRef.collection('messages').get();
          for (var d in msgs.docs) {
            await d.reference.delete();
          }
          await chatRef.delete();
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteChat(String chatId) async {
    final msgRef = _db.collection('chats').doc(chatId).collection('messages');
    final msgs = await msgRef.get();

    for (var d in msgs.docs) {
      await d.reference.delete();
    }

    await _db.collection('chats').doc(chatId).delete();
  }

  Future<void> reportUser({
    required String pelaporId,
    required String namaDilaporkan,
    required String productName,
    required String deskripsi,
    required String jenisLaporan,
    required String buktiBase64,
  }) async {
    final pelaporDoc = await _db.collection("users").doc(pelaporId).get();
    final namaPelapor = pelaporDoc.data()?["namaLengkap"] ?? "Tidak diketahui";

    await _db.collection("laporan").add({
      "namaDilaporkan": namaDilaporkan,
      "namaPelapor": namaPelapor,
      "productName": productName,
      "jenisLaporan": jenisLaporan,
      "deskripsi": deskripsi,
      "bukti": buktiBase64,
      "timestamp": Timestamp.now(),
      "status": "pending",
    });
  }
}
