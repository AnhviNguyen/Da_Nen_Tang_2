import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reminder_app/provider/ReminderProvider.dart';
import 'package:reminder_app/screen/ReminderCard.dart';

class RemindersListScreen extends StatelessWidget {
  const RemindersListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🔔 Reminders'),
        elevation: 0,
      ),
      body: Consumer<ReminderProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final upcomingReminders = provider.upcomingReminders;

          if (upcomingReminders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('🔔', style: TextStyle(fontSize: 64)),
                  const SizedBox(height: 16),
                  Text(
                    'No reminders',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  const Text('Add your first reminder'),
                ],
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(8),
            children: [
              // Today's Reminders
              if (provider.todayReminders.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Today',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ...provider.todayReminders.map(
                      (reminder) => ReminderCard(reminder: reminder),
                ),
                const SizedBox(height: 16),
              ],

              // Upcoming Reminders
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Upcoming',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ...upcomingReminders
                  .where((r) => !r.isToday)
                  .map((reminder) => ReminderCard(reminder: reminder)),
            ],
          );
        },
      ),
    );
  }
}
