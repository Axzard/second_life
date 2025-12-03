class ChatItemModel {
  final String chatId;
  final String otherUserId;
  final String name;
  final String product;
  final String lastMessage;
  final String time;
  final int unread;
  final List<String> deletedBy;

  ChatItemModel({
    required this.chatId,
    required this.otherUserId,
    required this.name,
    required this.product,
    required this.lastMessage,
    required this.time,
    required this.unread,
    this.deletedBy = const [],
  });

  get isOnline => null;
  get isTyping => null;

  // Method untuk cek apakah chat dihapus oleh user tertentu
  bool isDeletedBy(String userId) {
    return deletedBy.contains(userId);
  }
}