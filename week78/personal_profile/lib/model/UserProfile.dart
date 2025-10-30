import 'package:personal_profile/model/Skill.dart';
import 'package:personal_profile/model/SocialLink.dart';

class UserProfile {
  final String name;
  final String title;
  final String bio;
  final String avatarUrl;
  final List<Skill> skills;
  final List<SocialLink> socialLinks;

  const UserProfile({
    required this.name,
    required this.title,
    required this.bio,
    required this.avatarUrl,
    required this.skills,
    required this.socialLinks,
  });
}