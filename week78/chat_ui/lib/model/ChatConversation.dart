import 'package:chat_ui/model/ChatUser.dart';
import 'package:chat_ui/model/Message.dart';

class ChatConversation {
  final String id;
  final ChatUser user;
  final Message? lastMessage;
  final int unreadCount;
  final bool isMuted;
  final bool isPinned;

  const ChatConversation({
    required this.id,
    required this.user,
    this.lastMessage,
    this.unreadCount = 0,
    this.isMuted = false,
    this.isPinned = false,
  });
}
