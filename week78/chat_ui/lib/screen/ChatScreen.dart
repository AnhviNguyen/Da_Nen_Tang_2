import 'package:chat_ui/model/ChatConversation.dart';
import 'package:chat_ui/model/ChatUser.dart';
import 'package:chat_ui/repository/ChatRepository.dart';
import 'package:chat_ui/screen/ChatScreenState.dart';
import 'package:flutter/cupertino.dart';

class ChatScreen extends StatefulWidget {
  final ChatConversation conversation;
  final ChatRepository chatRepository;
  final ChatUser currentUser;

  const ChatScreen({
    super.key,
    required this.conversation,
    required this.chatRepository,
    required this.currentUser,
  });

  @override
  State<ChatScreen> createState() => ChatScreenState();
}