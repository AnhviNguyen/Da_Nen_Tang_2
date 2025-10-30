import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:personal_profile/model/Skill.dart';

class SkillItem extends StatelessWidget {
  final Skill skill;

  const SkillItem({super.key, required this.skill});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(skill.icon, size: 20),
              const SizedBox(width: 8),
              Text(
                skill.name,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Text(
                '${(skill.proficiency * 100).toInt()}%',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: skill.proficiency,
            backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }
}
