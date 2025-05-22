import 'package:equatable/equatable.dart';

import '../../../../core/entities/songs.dart';
import '../../../../core/entities/user.dart';

class NotificationDetails extends Equatable {
  final Songs? object;
  final User? host;
  final String? artistId;

  const NotificationDetails({
    this.object,
    this.host,
    this.artistId,

  });

  @override
  List<Object?> get props => [
    object,
    host,
    artistId,
      ];
}
