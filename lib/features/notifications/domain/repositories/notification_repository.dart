import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/notification.dart';

/// Repository for notification operations
abstract class NotificationRepository {
  /// Get all notifications for user
  Future<Either<Failure, List<AppNotification>>> getUserNotifications(
      String userId);

  /// Get unread notifications
  Future<Either<Failure, List<AppNotification>>> getUnreadNotifications(
      String userId);

  /// Mark notification as read
  Future<Either<Failure, void>> markAsRead(String notificationId);

  /// Mark all notifications as read
  Future<Either<Failure, void>> markAllAsRead(String userId);

  /// Delete notification
  Future<Either<Failure, void>> deleteNotification(String notificationId);

  /// Clear all notifications
  Future<Either<Failure, void>> clearAllNotifications(String userId);

  /// Get notifications stream (real-time updates)
  Stream<List<AppNotification>> getNotificationsStream(String userId);

  /// Send push notification (internal use)
  Future<Either<Failure, void>> sendPushNotification({
    required String userId,
    required String title,
    required String body,
    Map<String, dynamic>? data,
  });
}
