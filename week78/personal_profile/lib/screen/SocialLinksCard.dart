import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:personal_profile/model/SocialLink.dart';
import 'package:personal_profile/screen/SocialLinkItem.dart';

class SocialLinksCard extends StatelessWidget {
  final List<SocialLink> socialLinks;

  const SocialLinksCard({super.key, required this.socialLinks});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.link, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Connect With Me',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...socialLinks.map((link) => SocialLinkItem(link: link)),
          ],
        ),
      ),
    );
  }
}