import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/notification.dart';
import '../../../services/session_service.dart';
import '../../../services/local_database_service.dart';
import 'package:smart_farmer_procurement/l10n/generated/app_localizations.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final userId = SessionService.instance.currentUser?.farmerId ?? SessionService.instance.currentUser?.uid;
    if (userId == null) {
      return Scaffold(
        body: Center(
          child: Text(l10n.signInToViewNotifications),
        ),
      );
    }
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text(l10n.notifications)),
      body: FutureBuilder<List<NotificationModel>>(
        future: IsarDatabaseService().userNotifications(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(l10n.unableToLoadNotifications(snapshot.error.toString())),
            );
          }
          final notifications = snapshot.data ?? [];
          if (notifications.isEmpty) {
            return Center(
              child: Text(l10n.noNotificationsYet),
            );
          }
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
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(isDelay ? Icons.warning_amber_rounded : Icons.notifications_active, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.title,
                  style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 6),
                Text(
                  notification.body,
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}