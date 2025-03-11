import '../../../../core/models/song_model.dart';
import '../../../../core/models/user_model.dart';
import '../../domain/entities/notification_deatils.dart';

class NotificationDetailsModel extends NotificationDetails {
  const NotificationDetailsModel({
    required super.object,
    required super.host,
    required super.artistId,
  });
  factory NotificationDetailsModel.fromJson(Map<String, dynamic> json) =>
      NotificationDetailsModel(
        object: json['object'] != null ?  SongModel.fromJson(json['object']) : null,
        host: json['host'] != null ?  UserModel.fromJson(json['host']) : null,
        artistId: json['object']['artist_id'] ?? 'null',
      );
}
