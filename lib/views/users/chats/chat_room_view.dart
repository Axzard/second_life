import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:second_life/models/chats/chat_message_model.dart';
import 'package:second_life/viewmodels/users/chats/chat_room_viewmodel.dart';

class ChatRoomView extends StatefulWidget {
  final String chatId;
  final String currentUserId;
  final String otherUserId;
  final String otherUserName;
  final String productName;

  const ChatRoomView({
    super.key,
    required this.chatId,
    required this.currentUserId,
    required this.otherUserId,
    required this.otherUserName,
    required this.productName,
  });

  @override
  State<ChatRoomView> createState() => _ChatRoomViewState();
}

class _ChatRoomViewState extends State<ChatRoomView> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late ChatRoomViewModel vm;

  @override
  void initState() {
    super.initState();
    vm = ChatRoomViewModel();
    vm.markAsRead(widget.chatId, widget.currentUserId);
  }

  void _showDeleteDialog(ChatMessageModel message) {
    final isMyMessage = message.senderId == widget.currentUserId;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Hapus Pesan"),
        content: const Text("Pilih opsi penghapusan:"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await vm.deleteMessageForMe(
                  widget.chatId,
                  message.messageId,
                  widget.currentUserId,
                );
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Pesan dihapus untuk Anda')),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
              }
            },
            child: const Text("Hapus untuk Saya"),
          ),
          if (isMyMessage)
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                // Confirm delete for everyone
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Hapus untuk Semua Orang?"),
                    content: const Text(
                      "Pesan ini akan dihapus untuk semua orang dalam chat ini.",
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text("Batal"),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text(
                          "Hapus",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                );

                if (confirm == true) {
                  try {
                    await vm.deleteMessageForAll(
                      widget.chatId,
                      message.messageId,
                    );
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Pesan dihapus untuk semua orang'),
                        ),
                      );
                    }
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: $e')),
                      );
                    }
                  }
                }
              },
              child: const Text(
                "Hapus untuk Semua Orang",
                style: TextStyle(color: Colors.red),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMessageItem(ChatMessageModel msg, bool isMe) {
    return Dismissible(
      key: Key(
          msg.messageId),
      direction:
          isMe ? DismissDirection.endToStart : DismissDirection.startToEnd,
      background: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            if (!isMe) Icon(Icons.delete, color: Colors.white),
            if (!isMe) SizedBox(width: 8),
            Text(
              "Hapus",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (isMe) SizedBox(width: 8),
            if (isMe) Icon(Icons.delete, color: Colors.white),
          ],
        ),
      ),
      confirmDismiss: (direction) async {
        if (isMe) {
          return await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Hapus Pesan"),
              content: const Text("Apakah Anda yakin ingin menghapus pesan ini?"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text("Batal"),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text(
                    "Hapus",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Anda hanya dapat menghapus pesan sendiri"),
              duration: Duration(seconds: 2),
            ),
          );
          return false;
        }
      },
      onDismissed: (direction) {
        if (isMe) {
          final messageId = msg.messageId;

          if (messageId.isNotEmpty) {
            vm.deleteMessageForMe(widget.chatId, messageId, widget.currentUserId);
          }
        }
      },
      child: GestureDetector(
        onLongPress: () => _showDeleteDialog(msg),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            mainAxisAlignment:
                isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!isMe)
                CircleAvatar(
                  radius: 14,
                  backgroundColor: Colors.grey[300],
                  child: Text(
                    widget.otherUserName.isNotEmpty
                        ? widget.otherUserName[0].toUpperCase()
                        : '?',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              if (!isMe) const SizedBox(width: 8),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isMe ? Color(0xFF00775A) : Colors.grey[100],
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft:
                          isMe ? const Radius.circular(16) : const Radius.circular(4),
                      bottomRight:
                          isMe ? const Radius.circular(4) : const Radius.circular(16),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment:
                        isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                    children: [
                      Text(
                        msg.text,
                        style: TextStyle(
                          color: isMe ? Colors.white : Colors.black87,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatTime(msg.timestamp),
                        style: TextStyle(
                          color: isMe ? Colors.white70 : Colors.grey[600],
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (isMe) const SizedBox(width: 8),
              if (isMe)
                CircleAvatar(
                  radius: 14,
                  backgroundColor: Color(0xFF00775A),
                  child: Text(
                    'You',
                    style: TextStyle(
                      fontSize: 8,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }



  // =======================
  //        LAPOR USER
  // =======================

 void _showReportDialog() {
  TextEditingController laporanController = TextEditingController();
  String selectedJenis = "Penipuan";
  String? buktiBase64;
  File? selectedImage;

  final ImagePicker picker = ImagePicker();

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          Future<void> pickImage() async {
            final XFile? photo =
                await picker.pickImage(source: ImageSource.gallery);

            if (photo != null) {
              final bytes = await File(photo.path).readAsBytes();
              setState(() {
                selectedImage = File(photo.path);
                buktiBase64 = base64Encode(bytes);
              });
            }
          }

          return AlertDialog(
            title: const Text("Laporkan Pengguna"),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // PILIH JENIS LAPORAN
                  DropdownButtonFormField<String>(
                    value: selectedJenis,
                    items: const [
                      DropdownMenuItem(value: "Penipuan", child: Text("Penipuan")),
                      DropdownMenuItem(value: "Chat Tidak Pantas", child: Text("Chat Tidak Pantas")),
                      DropdownMenuItem(value: "Pelecehan / Ancaman", child: Text("Pelecehan / Ancaman")),
                      DropdownMenuItem(value: "Spam / Iklan Berlebihan", child: Text("Spam / Iklan Berlebihan")),
                      DropdownMenuItem(value: "Pelanggaran Aturan", child: Text("Pelanggaran Aturan")),
                      DropdownMenuItem(value: "Lainnya", child: Text("Lainnya")),
                    ],
                    onChanged: (value) => setState(() => selectedJenis = value!),
                    decoration: const InputDecoration(
                      labelText: "Jenis Laporan",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // DESKRIPSI LAPORAN
                  TextField(
                    controller: laporanController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      hintText: "Tuliskan alasan laporan...",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // UPLOAD BUKTI GAMBAR
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: pickImage,
                        child: const Text("Upload Bukti"),
                      ),
                      const SizedBox(width: 10),
                      selectedImage != null
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : const Text("Belum ada file"),
                    ],
                  ),

                  if (selectedImage != null) ...[
                    const SizedBox(height: 10),
                    Image.file(selectedImage!, height: 120),
                  ],
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Batal"),
              ),
              TextButton(
                onPressed: () async {
                  final deskripsi = laporanController.text.trim();
                  if (deskripsi.isEmpty) return;

                  await vm.reportUser(
                    pelaporId: widget.currentUserId,
                    namaDilaporkan: widget.otherUserName,
                    productName: widget.productName,
                    deskripsi: deskripsi,
                    jenisLaporan: selectedJenis,
                    buktiBase64: buktiBase64 ?? "",
                  );

                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Laporan berhasil dikirim"),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                child: const Text(
                  "Kirim",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          );
        },
      );
    },
  );
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 1,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black87),
                onPressed: () => Navigator.pop(context),
              ),
              title: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Color(0xFF00775A),
                    child: Text(
                      widget.otherUserName.isNotEmpty
                          ? widget.otherUserName[0].toUpperCase()
                          : '?',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.otherUserName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 2),
                        StreamBuilder<String>(
                            stream: vm.getUserStatusStream(widget.otherUserId),
                            builder: (context, snapshot) {
                              final status = snapshot.data ?? 'Offline';
                              final isOnline = status == 'Online';
                              return Row(
                                children: [
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: isOnline ? Colors.green : Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    status,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isOnline ? Colors.green : Colors.grey[600],
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                ],
              ),

              // >>> MENU ACTION + LAPOR <<<
              actions: [
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'report') {
                      _showReportDialog();
                    }
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(
                      value: 'report',
                      child: Text('Laporkan pengguna'),
                    ),
                  ],
                ),
              ],
            ),

            body: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    border: Border(
                      bottom: BorderSide(color: Colors.grey[300]!),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Color(0xFF00775A),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.shopping_bag,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.productName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              'Chat tentang produk ini',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: StreamBuilder<List<ChatMessageModel>>(
                    stream: vm.getMessages(widget.chatId, widget.currentUserId),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                            child: CircularProgressIndicator());
                      }

                      final messages = snapshot.data!;

                      WidgetsBinding.instance
                          .addPostFrameCallback((_) {
                        if (_scrollController.hasClients) {
                          _scrollController.animateTo(
                            _scrollController.position.maxScrollExtent,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOut,
                          );
                        }
                      });

                      return ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 16,
                        ),
                        itemCount: messages.length,
                        itemBuilder: (_, i) {
                          final msg = messages[i];
                          final isMe =
                              msg.senderId == widget.currentUserId;

                          return _buildMessageItem(msg, isMe);
                        },
                      );
                    },
                  ),
                ),

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(25),
                            border:
                                Border.all(color: Colors.grey[300]!),
                          ),
                          child: Row(
                            children: [
                              const SizedBox(width: 16),
                              Expanded(
                                child: TextField(
                                  controller: _controller,
                                  decoration:
                                      const InputDecoration(
                                    hintText: 'Ketik pesan...',
                                    border: InputBorder.none,
                                    contentPadding:
                                        EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                  ),
                                  maxLines: null,
                                  textInputAction:
                                      TextInputAction.send,
                                  onSubmitted: (text) {
                                    _sendMessage();
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Color(0xFF00775A),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          onPressed: _sendMessage,
                          icon: const Icon(
                            Icons.send,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  void _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    await vm.sendMessage(
      chatId: widget.chatId,
      senderId: widget.currentUserId,
      text: text,
    );

    _controller.clear();
  }

  String _formatTime(dynamic timestamp) {
    if (timestamp == null) return '';

    try {
      DateTime time;
      if (timestamp is DateTime) {
        time = timestamp;
      } else if (timestamp is String) {
        time = DateTime.parse(timestamp);
      } else if (timestamp is int) {
        time = DateTime.fromMillisecondsSinceEpoch(timestamp);
      } else if (timestamp is Timestamp) {
        time = timestamp.toDate();
      } else {
        return '';
      }

      return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return '';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}



