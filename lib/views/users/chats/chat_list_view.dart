import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:second_life/viewmodels/users/chats/chat_list_viewmodel.dart';
import 'package:second_life/views/users/chats/chat_room_view.dart';

class ChatListView extends StatelessWidget {
  const ChatListView({super.key});

  Widget _buildSkeletonChatItem() {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 1),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Bone.circle(size: 50),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Bone.text(words: 2),
                const SizedBox(height: 4),
                Bone.text(words: 4, fontSize: 12),
                const SizedBox(height: 4),
                Bone.text(words: 6, fontSize: 12),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Bone.text(words: 1, fontSize: 12),
              const SizedBox(height: 4),
              Bone.circle(size: 20),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Delete old instance dan create new untuk refresh data
    Get.delete<ChatListViewModel>();
    final vm = Get.put(ChatListViewModel());
    final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? "";
    
    if (currentUserId.isNotEmpty) {
      vm.loadChatList(currentUserId);
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: const Color(0xFF00775A),
        foregroundColor: Colors.white,
        title: const Text("Chat", style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              vm.clearCache();
              if (currentUserId.isNotEmpty) {
                vm.loadChatList(currentUserId);
              }
            },
          ),
        ],
      ),
      body: Obx(() {
        // Skeleton loading
        if (vm.isLoading.value) {
          return Skeletonizer(
            enabled: true,
            child: ListView.builder(
              itemCount: 8,
              itemBuilder: (context, index) => _buildSkeletonChatItem(),
            ),
          );
        }

        // Empty state
        if (vm.chatItems.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.chat_bubble_outline, size: 80, color: Colors.grey),
                const SizedBox(height: 16),
                const Text(
                  "Belum ada chat",
                  style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  "Mulai chat dengan penjual dari halaman produk",
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        // Chat list
        return ListView.builder(
          itemCount: vm.chatItems.length,
          itemBuilder: (context, index) {
            final chat = vm.chatItems[index];
            return Dismissible(
              key: Key(chat.chatId),
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20),
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              direction: DismissDirection.endToStart,
              confirmDismiss: (direction) async {
                return await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Hapus Chat"),
                      content: const Text("Apakah Anda yakin ingin menghapus chat ini?"),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text("Batal"),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text("Hapus", style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    );
                  },
                );
              },
              onDismissed: (_) => vm.deleteChatRoomForMe(chat.chatId, currentUserId),
              child: Container(
                color: Colors.white,
                margin: const EdgeInsets.only(bottom: 1),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: CircleAvatar(
                    radius: 28,
                    backgroundColor: const Color(0xFF00775A),
                    child: Text(
                      chat.name.isNotEmpty ? chat.name.substring(0, 1).toUpperCase() : "?",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  title: Row(
                    children: [
                      Expanded(
                        child: Text(
                          chat.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      if (chat.product.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            "📦 ",
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.blue.shade700,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      const SizedBox(height: 4),
                      Text(
                        chat.lastMessage,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: chat.unread > 0 ? Colors.black87 : Colors.grey,
                          fontWeight: chat.unread > 0 ? FontWeight.w600 : FontWeight.normal,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        chat.time,
                        style: TextStyle(
                          fontSize: 11,
                          color: chat.unread > 0 ? const Color(0xFF00775A) : Colors.grey,
                          fontWeight: chat.unread > 0 ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                      if (chat.unread > 0)
                        Container(
                          margin: const EdgeInsets.only(top: 6),
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: Color(0xFF00775A),
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            chat.unread > 9 ? '9+' : chat.unread.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  onTap: () => Get.to(() => ChatRoomView(
                    chatId: chat.chatId,
                    currentUserId: currentUserId,
                    otherUserId: chat.otherUserId,
                    otherUserName: chat.name,
                    productName: chat.product,
                  )),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
