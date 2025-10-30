import 'package:chat_ui/model/ChatUser.dart';
import 'package:chat_ui/repository/UserRepository.dart';

class UserRepositoryImpl implements UserRepository {
  @override
  ChatUser getCurrentUser() {
    return const ChatUser(
      id: 'current_user',
      name: 'Nguyễn Ngọc Ánh Vi',
      avatarUrl: 'https://ui-avatars.com/api/?name=Nguyen+Ngoc+Anh+Vi&background=2196F3&color=fff',
      isOnline: true,
    );
  }

  @override
  ChatUser? getUserById(String id) {
    // Mock implementation
    return null;
  }
}