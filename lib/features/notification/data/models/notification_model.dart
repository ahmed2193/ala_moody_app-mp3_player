import '../../domain/entities/notification.dart';
import 'notification_details_model.dart';

class NotificationModel extends Notification {
  const NotificationModel({
    required super.id,
    required super.userId,
    required super.objectId,
    required super.notificationableId,
    required super.notificationableType,
    required super.hostableId,
    required super.title,
    required super.description,
    required super.action,
    required super.updatedAt,
    required super.read,
    required super.details,
  });
  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        id: json['id'],
        userId: json['user_id'],
        objectId: json['object_id'],
        notificationableId: json['notificationable_id'],
        notificationableType: json['notificationable_type'],
        hostableId: json['hostable_id'],
        action: json['action'],
        description: json['description'],
        title: json['title'],
        updatedAt: json['updated_at'],
        read: json['read'],
        details: json['details'] != null
            ? NotificationDetailsModel.fromJson(json['details'])
            : null,
      );
}
