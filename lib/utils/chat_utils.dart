String generateChatId(String uid1, String uid2) {
  final u = [uid1, uid2]..sort();
  return '${u[0]}_${u[1]}';
}

String formatTime(DateTime time) {
  final now = DateTime.now();
  final diff = now.difference(time);

  if (diff.inMinutes < 1) return 'Baru saja';
  if (diff.inHours < 1) return '${diff.inMinutes} menit';
  if (diff.inHours < 24) return '${diff.inHours} jam';
  if (diff.inDays == 1) return 'Kemarin';
  if (diff.inDays < 7) return '${diff.inDays} hari lalu';

  return '${time.day}/${time.month}/${time.year}';
}
