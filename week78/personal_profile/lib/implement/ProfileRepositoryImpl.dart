import 'package:flutter/material.dart';
import 'package:personal_profile/model/Skill.dart';
import 'package:personal_profile/model/SocialLink.dart';
import 'package:personal_profile/model/UserProfile.dart';
import 'package:personal_profile/repository/ProfileRepository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  @override
  UserProfile getUserProfile() {
    return const UserProfile(
      name: 'Nguyễn Ngọc Ánh Vi',
      title: 'Flutter Developer',
      bio: 'Passionate mobile developer with expertise in Flutter and Dart. '
          'Love creating beautiful and functional applications.',
      avatarUrl: 'https://ui-avatars.com/api/?name=Nguyen+Ngoc+Anh+Vi&size=200&background=2196F3&color=fff&bold=true',
      skills: [
        Skill(name: 'Flutter', icon: Icons.phone_android, proficiency: 0.9),
        Skill(name: 'Dart', icon: Icons.code, proficiency: 0.85),
        Skill(name: 'Firebase', icon: Icons.cloud, proficiency: 0.75),
        Skill(name: 'UI/UX', icon: Icons.design_services, proficiency: 0.8),
        Skill(name: 'Git', icon: Icons.source, proficiency: 0.8),
      ],
      socialLinks: [
        SocialLink(platform: 'GitHub', url: 'https://github.com/AnhviNguyen', icon: Icons.code),
        SocialLink(platform: 'LinkedIn', url: 'https://www.linkedin.com/', icon: Icons.work),
        SocialLink(platform: 'Email', url: 'anhvinguyen85@gmail.com', icon: Icons.email),
        SocialLink(platform: 'Portfolio', url: 'portfolio.com', icon: Icons.web),
      ],
    );
  }
}