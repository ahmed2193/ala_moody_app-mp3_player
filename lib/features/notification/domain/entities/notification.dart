import 'package:equatable/equatable.dart';

import 'notification_deatils.dart';

class Notification extends Equatable {
  final int? id;
  final int? userId;
  final int? objectId;
  final int? notificationableId;
  final String? notificationableType;
  final int? hostableId;
  final String? action;
  final String? title;
  final String? description;
  final String? updatedAt;
  final int? read;
  final NotificationDetails? details;

  const Notification({
    this.id,
    this.userId,
    this.objectId,
    this.title,
    this.description,
    this.notificationableId,
    this.notificationableType,
    this.hostableId,
    this.action,
    this.updatedAt,
    this.read,
    this.details,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        objectId,
        notificationableId,
        notificationableType,
        hostableId,
        action,
        updatedAt,
        read,
        details,
      ];
}
