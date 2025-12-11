import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:second_life/models/products/product_model.dart';
import 'package:second_life/services/chat_service.dart';
import 'package:second_life/views/users/chats/chat_room_view.dart';

class ProductActionButtons extends StatelessWidget {
  final ProductModel product;
  final String sellerName;

  const ProductActionButtons({
    super.key,
    required this.product,
    required this.sellerName,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    final buttonHeight = screenHeight * 0.06;
    final containerPadding = screenWidth * 0.04;
    final fontSize = screenWidth * 0.042;
    final iconSize = screenWidth * 0.052;
    
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: containerPadding,
        vertical: screenHeight * 0.015,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: SizedBox(
                height: buttonHeight,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(color: Colors.grey),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () async {
                    final currentUserId = FirebaseAuth.instance.currentUser!.uid;

                    // BUG FIX: CREATE CHAT ROOM dulu
                    final chatId = await ChatService().createChatRoom(
                      user1: currentUserId,
                      user2: product.userId,
                      productId: product.id,
                    );

                    // BUG FIX: SEND AUTO MESSAGE dulu SEBELUM buka chat room
                    // Ini penting agar message sudah ada di database sebelum UI dibuka
                    await ChatService().sendAutoProductMessage(
                      chatId: chatId,
                      senderId: currentUserId,
                      product: product,
                    );

                    // Tunggu sebentar untuk memastikan data tersimpan
                    await Future.delayed(const Duration(milliseconds: 300));

                    // BARU OPEN CHAT ROOM setelah message tersimpan
                    if (context.mounted) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatRoomView(
                            chatId: chatId,
                            currentUserId: currentUserId,
                            otherUserId: product.userId,
                            otherUserName: sellerName,
                            productName: product.nama,
                          ),
                        ),
                      );
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.chat_bubble_outline,
                        color: Colors.black,
                        size: iconSize,
                      ),
                      SizedBox(width: screenWidth * 0.025),
                      Text(
                        "Chat",
                        style: TextStyle(
                          fontSize: fontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
