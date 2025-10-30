import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:personal_profile/model/SocialLink.dart';

class SocialLinkItem extends StatelessWidget {
  final SocialLink link;

  const SocialLinkItem({super.key, required this.link});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        child: Icon(
          link.icon,
          color: Theme.of(context).colorScheme.onPrimaryContainer,
        ),
      ),
      title: Text(
        link.platform,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(link.url),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Opening ${link.platform}...'),
            duration: const Duration(seconds: 1),
          ),
        );
      },
    );
  }
}