import 'package:flutter/cupertino.dart';
import 'package:personal_profile/model/UserProfile.dart';
import 'package:personal_profile/screen/BioCard.dart';
import 'package:personal_profile/screen/ProfileHeader.dart';
import 'package:personal_profile/screen/SkillsCard.dart';
import 'package:personal_profile/screen/SocialLinksCard.dart';

class ProfileContent extends StatelessWidget {
  final UserProfile profile;

  const ProfileContent({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 600;

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: isWide
                ? _buildWideLayout(context)
                : _buildNarrowLayout(context),
          ),
        );
      },
    );
  }

  Widget _buildWideLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: Column(
            children: [
              ProfileHeader(profile: profile),
              const SizedBox(height: 16),
              SocialLinksCard(socialLinks: profile.socialLinks),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 2,
          child: Column(
            children: [
              BioCard(bio: profile.bio),
              const SizedBox(height: 16),
              SkillsCard(skills: profile.skills),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNarrowLayout(BuildContext context) {
    return Column(
      children: [
        ProfileHeader(profile: profile),
        const SizedBox(height: 16),
        BioCard(bio: profile.bio),
        const SizedBox(height: 16),
        SkillsCard(skills: profile.skills),
        const SizedBox(height: 16),
        SocialLinksCard(socialLinks: profile.socialLinks),
      ],
    );
  }
}