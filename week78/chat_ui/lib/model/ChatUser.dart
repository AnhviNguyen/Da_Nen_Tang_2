class ChatUser {
  final String id;
  final String name;
  final String avatarUrl;
  final bool isOnline;
  final String? lastSeen;

  const ChatUser({
    required this.id,
    required this.name,
    required this.avatarUrl,
    this.isOnline = false,
    this.lastSeen,
  });
}
