import 'package:personal_profile/model/UserProfile.dart';

abstract class ProfileRepository {
  UserProfile getUserProfile();
}