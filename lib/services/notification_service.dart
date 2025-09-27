import 'package:flutter/foundation.dart';

/// Mock notification service for demo purposes
/// In a real app, this would integrate with flutter_local_notifications
class NotificationService {
  // Mock notification storage for demo
  static final List<MockNotification> _scheduledNotifications = [];

  /// Initialize notifications (mock)
  Future<void> initialize() async {
    debugPrint('🔔 Notification service initialized (mock)');
  }

  /// Schedule a notification for a specific date and time (mock)
  Future<void> scheduleNotification(
    int id,
    String title,
    String body,
    DateTime scheduledDate,
  ) async {
    final notification = MockNotification(
      id: id,
      title: title,
      body: body,
      scheduledDate: scheduledDate,
    );

    _scheduledNotifications.add(notification);

    debugPrint('📅 Mock notification scheduled:');
    debugPrint('   ID: $id');
    debugPrint('   Title: $title');
    debugPrint('   Body: $body');
    debugPrint('   Scheduled for: ${scheduledDate.toString()}');

    // In a real implementation, you would use:
    // await flutterLocalNotificationsPlugin.schedule(
    //   id,
    //   title,
    //   body,
    //   scheduledDate,
    //   notificationDetails,
    // );
  }

  /// Cancel a scheduled notification (mock)
  Future<void> cancelNotification(int id) async {
    _scheduledNotifications.removeWhere(
      (notification) => notification.id == id,
    );
    debugPrint('❌ Mock notification cancelled: ID $id');

    // In a real implementation:
    // await flutterLocalNotificationsPlugin.cancel(id);
  }

  /// Get all scheduled notifications (mock)
  List<MockNotification> getScheduledNotifications() {
    return List.from(_scheduledNotifications);
  }

  /// Clear all notifications (mock)
  Future<void> cancelAllNotifications() async {
    _scheduledNotifications.clear();
    debugPrint('🗑️ All mock notifications cancelled');

    // In a real implementation:
    // await flutterLocalNotificationsPlugin.cancelAll();
  }
}

/// Mock notification model for demonstration
class MockNotification {
  final int id;
  final String title;
  final String body;
  final DateTime scheduledDate;

  MockNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.scheduledDate,
  });

  @override
  String toString() {
    return 'MockNotification{id: $id, title: $title, body: $body, scheduledDate: $scheduledDate}';
  }
}
