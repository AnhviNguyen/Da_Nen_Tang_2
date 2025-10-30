import 'dart:math';

import 'package:chat_ui/enum/status.dart';
import 'package:chat_ui/model/ChatConversation.dart';
import 'package:chat_ui/model/ChatUser.dart';
import 'package:chat_ui/model/Message.dart';
import 'package:chat_ui/repository/ChatRepository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final String _currentUserId = 'current_user';
  final List<ChatConversation> _conversations = [];
  final Map<String, List<Message>> _messagesMap = {};

  ChatRepositoryImpl() {
    _initializeMockData();
  }

  void _initializeMockData() {
    // Mock conversations
    _conversations.addAll([
      ChatConversation(
        id: 'conv_1',
        user: const ChatUser(
          id: 'user_1',
          name: 'Sarah Johnson',
          avatarUrl: 'https://ui-avatars.com/api/?name=Sarah+Johnson&background=FF6B6B&color=fff',
          isOnline: true,
        ),
        lastMessage: Message(
          id: 'msg_1',
          senderId: 'user_1',
          content: 'Hey! How are you doing?',
          timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
          status: MessageStatus.read,
        ),
        unreadCount: 0,
      ),
      ChatConversation(
        id: 'conv_2',
        user: const ChatUser(
          id: 'user_2',
          name: 'Mike Chen',
          avatarUrl: 'https://ui-avatars.com/api/?name=Mike+Chen&background=4ECDC4&color=fff',
          isOnline: false,
          lastSeen: '2 hours ago',
        ),
        lastMessage: Message(
          id: 'msg_2',
          senderId: 'user_2',
          content: 'Can we meet tomorrow?',
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          status: MessageStatus.delivered,
        ),
        unreadCount: 3,
      ),
      ChatConversation(
        id: 'conv_3',
        user: const ChatUser(
          id: 'user_3',
          name: 'Emma Wilson',
          avatarUrl: 'https://ui-avatars.com/api/?name=Emma+Wilson&background=95E1D3&color=fff',
          isOnline: true,
        ),
        lastMessage: Message(
          id: 'msg_3',
          senderId: _currentUserId,
          content: 'Great! See you then 👋',
          timestamp: DateTime.now().subtract(const Duration(hours: 5)),
          status: MessageStatus.read,
        ),
        unreadCount: 0,
        isPinned: true,
      ),
      ChatConversation(
        id: 'conv_4',
        user: const ChatUser(
          id: 'user_4',
          name: 'David Lee',
          avatarUrl: 'https://ui-avatars.com/api/?name=David+Lee&background=F38181&color=fff',
          isOnline: false,
          lastSeen: 'yesterday',
        ),
        lastMessage: Message(
          id: 'msg_4',
          senderId: 'user_4',
          content: 'Thanks for your help!',
          timestamp: DateTime.now().subtract(const Duration(days: 1)),
          status: MessageStatus.read,
        ),
        unreadCount: 0,
      ),
    ]);

    // Mock messages for conv_1
    _messagesMap['conv_1'] = [
      Message(
        id: 'm1',
        senderId: 'user_1',
        content: 'Hi there! 👋',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        status: MessageStatus.read,
      ),
      Message(
        id: 'm2',
        senderId: _currentUserId,
        content: 'Hey! How are you?',
        timestamp: DateTime.now().subtract(const Duration(hours: 2, minutes: -5)),
        status: MessageStatus.read,
      ),
      Message(
        id: 'm3',
        senderId: 'user_1',
        content: 'I\'m doing great! Just finished my Flutter project',
        timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 50)),
        status: MessageStatus.read,
      ),
      Message(
        id: 'm4',
        senderId: _currentUserId,
        content: 'That\'s awesome! What did you build?',
        timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 45)),
        status: MessageStatus.read,
      ),
      Message(
        id: 'm5',
        senderId: 'user_1',
        content: 'A chat UI clone with SOLID architecture',
        timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 40)),
        status: MessageStatus.read,
      ),
      Message(
        id: 'm6',
        senderId: 'user_1',
        content: 'It has message bubbles, online status, and everything!',
        timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 39)),
        status: MessageStatus.read,
      ),
      Message(
        id: 'm7',
        senderId: _currentUserId,
        content: 'Sounds impressive! Can I see it?',
        timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 30)),
        status: MessageStatus.read,
      ),
      Message(
        id: 'm8',
        senderId: 'user_1',
        content: 'Sure! I\'ll send you the link',
        timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
        status: MessageStatus.read,
      ),
      Message(
        id: 'm9',
        senderId: 'user_1',
        content: 'Hey! How are you doing?',
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        status: MessageStatus.read,
      ),
    ];
  }

  @override
  List<ChatConversation> getConversations() {
    return List.from(_conversations)
      ..sort((a, b) {
        if (a.isPinned && !b.isPinned) return -1;
        if (!a.isPinned && b.isPinned) return 1;

        final aTime = a.lastMessage?.timestamp ?? DateTime(2000);
        final bTime = b.lastMessage?.timestamp ?? DateTime(2000);
        return bTime.compareTo(aTime);
      });
  }

  @override
  List<Message> getMessages(String conversationId) {
    return _messagesMap[conversationId] ?? [];
  }

  @override
  Future<void> sendMessage(String conversationId, String content) async {
    final newMessage = Message(
      id: 'msg_${Random().nextInt(10000)}',
      senderId: _currentUserId,
      content: content,
      timestamp: DateTime.now(),
      status: MessageStatus.sent,
    );

    _messagesMap[conversationId] = [
      ...(_messagesMap[conversationId] ?? []),
      newMessage,
    ];

    // Update last message in conversation
    final convIndex = _conversations.indexWhere((c) => c.id == conversationId);
    if (convIndex != -1) {
      final conv = _conversations[convIndex];
      _conversations[convIndex] = ChatConversation(
        id: conv.id,
        user: conv.user,
        lastMessage: newMessage,
        unreadCount: conv.unreadCount,
        isMuted: conv.isMuted,
        isPinned: conv.isPinned,
      );
    }
  }

  @override
  Future<void> markAsRead(String conversationId) async {
    // Implementation for marking messages as read
  }
}

