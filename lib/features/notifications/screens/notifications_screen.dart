import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/notification.dart';
import '../../../services/session_service.dart';
import '../../../services/local_database_service.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = SessionService.instance.currentUser?.farmerId ?? SessionService.instance.currentUser?.uid;
    if (userId == null) return const Scaffold(body: Center(child: Text('Sign in to view notifications.')));
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Notifications')),
      body: FutureBuilder<List<NotificationModel>>(
        future: IsarDatabaseService().userNotifications(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (snapshot.hasError) return Center(child: Text('Unable to load notifications: ${snapshot.error}'));
          final notifications = snapshot.data ?? [];
          if (notifications.isEmpty) return const Center(child: Text('No notifications yet.'));
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: notifications.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) => _notificationCard(notifications[index]),
          );
        },
      ),
    );
  }

  Widget _notificationCard(NotificationModel notification) {
    final isDelay = notification.type == 'delayWarning';
    final color = isDelay ? Colors.red : AppColors.primary;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(isDelay ? Icons.warning_amber_rounded : Icons.notifications_active, color: color),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(notification.title, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          const SizedBox(height: 6),
          Text(notification.body, style: const TextStyle(color: AppColors.textSecondary)),
        ])),
      ]),
    );
  }
}
