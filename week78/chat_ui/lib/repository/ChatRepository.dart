import 'package:chat_ui/model/ChatConversation.dart';
import 'package:chat_ui/model/Message.dart';

abstract class ChatRepository {
  List<ChatConversation> getConversations();
  List<Message> getMessages(String conversationId);
  Future<void> sendMessage(String conversationId, String content);
  Future<void> markAsRead(String conversationId);
}