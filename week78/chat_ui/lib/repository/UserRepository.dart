import 'package:chat_ui/model/ChatUser.dart';

abstract class UserRepository {
  ChatUser getCurrentUser();
  ChatUser? getUserById(String id);
}