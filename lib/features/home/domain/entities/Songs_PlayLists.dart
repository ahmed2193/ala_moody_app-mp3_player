import 'package:equatable/equatable.dart';

import '../../../../core/entities/user.dart';

class SongsPlayLists extends Equatable {
  final int? id;
  final String? artistIds;
  final dynamic collaboration;
  final String? title;
  final String? description;
  final dynamic loves;
  final dynamic allowComments;
  final dynamic commentCount;
  final dynamic visibility;
  final String? createdAt;
  final String? artworkUrl;
  final String? permalinkUrl;
  final dynamic songCount;
  final dynamic subscriberCount;
  final bool? favorite;
  final User? user;

  const SongsPlayLists({
    this.id,
    this.artistIds,
    this.collaboration,
    this.title,
    this.description,
    this.loves,
    this.allowComments,
    this.commentCount,
    this.visibility,
    this.createdAt,
    this.artworkUrl,
    this.permalinkUrl,
    this.songCount,
    this.subscriberCount,
    this.favorite,
    this.user,
  });

  @override
  List<Object?> get props => [
        id,
        artistIds,
        collaboration,
        title,
        description,
        loves,
        allowComments,
        commentCount,
        visibility,
        createdAt,
        artworkUrl,
        permalinkUrl,
        songCount,
        subscriberCount,
        favorite,
        user,
      ];
}
