import 'package:alamoody/features/home/domain/entities/Songs_PlayLists.dart';
import '../../../../core/models/user_model.dart';

class SongsPlayListsModel extends SongsPlayLists {
  const SongsPlayListsModel({
    int? id,
    String? artistIds,
    dynamic collaboration,
    String? title,
    String? description,
    dynamic loves,
    dynamic allowComments,
    dynamic commentCount,
    dynamic visibility,
    String? createdAt,
    String? artworkUrl,
    String? permalinkUrl,
    dynamic songCount,
    dynamic subscriberCount,
    bool? favorite,
    UserModel? user,
  }) : super(
          id: id,
          artistIds: artistIds,
          collaboration: collaboration,
          title: title,
          description: description,
          loves: loves,
          allowComments: allowComments,
          commentCount: commentCount,
          visibility: visibility,
          createdAt: createdAt,
          artworkUrl: artworkUrl,
          permalinkUrl: permalinkUrl,
          songCount: songCount,
          subscriberCount: subscriberCount,
          favorite: favorite,
          user: user,
        );
  factory SongsPlayListsModel.fromJson(Map<String, dynamic> json) =>
      SongsPlayListsModel(
        id: json['id'],
        artistIds: json['artistIds'],
        collaboration: json['collaboration'],
        title: json['title'],
        description: json['description'] ?? '',
        loves: json['loves'],
        allowComments: json['allow_comments'],
        commentCount: json['comment_count'],
        visibility: json['visibility'],
        createdAt: json['created_at'],
        artworkUrl: json['artwork_url'],
        permalinkUrl: json['permalink_url'],
        songCount: json['song_count'],
        subscriberCount: json['subscriber_count'],
        favorite: json['favorite'],
        user: (json['user'] is Map<String, dynamic>)
            ? UserModel.fromJson(json['user'])
            : null,
      );
}
