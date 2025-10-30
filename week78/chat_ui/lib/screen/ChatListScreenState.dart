import 'package:chat_ui/implement/ChatRepositoryImpl.dart';
import 'package:chat_ui/implement/UserRepositoryImpl.dart';
import 'package:chat_ui/model/ChatConversation.dart';
import 'package:chat_ui/repository/ChatRepository.dart';
import 'package:chat_ui/repository/UserRepository.dart';
import 'package:chat_ui/screen/ChatListScreen.dart';
import 'package:chat_ui/screen/ChatScreen.dart';
import 'package:chat_ui/screen/ConversationTile.dart';
import 'package:flutter/material.dart';

class ChatListScreenState extends State<ChatListScreen> {
  late final ChatRepository _chatRepository;
  late final UserRepository _userRepository;
  late List<ChatConversation> _conversations;

  @override
  void initState() {
    super.initState();
    _chatRepository = ChatRepositoryImpl();
    _userRepository = UserRepositoryImpl();
    _conversations = _chatRepository.getConversations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
        actions: [
          IconButton(
            icon: const Icon(Icons.camera_alt_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.edit_square),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: ListView.builder(
              itemCount: _conversations.length,
              itemBuilder: (context, index) {
                return ConversationTile(
                  conversation: _conversations[index],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(
                          conversation: _conversations[index],
                          chatRepository: _chatRepository,
                          currentUser: _userRepository.getCurrentUser(),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.message),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search',
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: Theme.of(context).colorScheme.surfaceVariant,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
        ),
      ),
    );
  }
}