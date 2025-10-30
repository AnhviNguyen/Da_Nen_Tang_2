import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:personal_profile/model/Skill.dart';
import 'package:personal_profile/screen/SkillItem.dart';

class SkillsCard extends StatelessWidget {
  final List<Skill> skills;

  const SkillsCard({super.key, required this.skills});

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
                Icon(Icons.star, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Skills',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...skills.map((skill) => SkillItem(skill: skill)),
          ],
        ),
      ),
    );
  }
}