import 'package:equatable/equatable.dart';

import '../../../../core/entities/songs.dart';
import '../../../../core/entities/user.dart';

class NotificationDetails extends Equatable {
  final Songs? object;
  final User? host;

  const NotificationDetails({
    this.object,
    this.host,

  });

  @override
  List<Object?> get props => [
    object,
    host,
      ];
}
