import 'package:equatable/equatable.dart';

class User extends Equatable {
  final dynamic id;
  final String? name;
  final String? username;
  final String? soundcloudUrl;
  final String? instagramUrl;
  final String? youtubeUrl;
  final String? facebookUrl;
  final String? twitterUrl;
  final String? websiteUrl;
  final String? artistId;
  final String? collectionCount;
  final dynamic followingCount;
  final dynamic followerCount;
  final dynamic notification;
  final String? bio;
  final String? allowComments;
  final String? commentCount;
  final String? image;
  final String? artworkUrl;
  final String? permalinkUrl;
  final dynamic favorite;

  const User({
    this.id,
    this.name,
    this.username,
    this.soundcloudUrl,
    this.instagramUrl,
    this.youtubeUrl,
    this.facebookUrl,
    this.twitterUrl,
    this.websiteUrl,
    this.artistId,
    this.collectionCount,
    this.followingCount,
    this.followerCount,
    this.notification,
    this.bio,
    this.allowComments,
    this.commentCount,
    this.image,
    this.artworkUrl,
    this.permalinkUrl,
    this.favorite,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        username,
        soundcloudUrl,
        instagramUrl,
        youtubeUrl,
        facebookUrl,
        twitterUrl,
        websiteUrl,
        artistId,
        collectionCount,
        followingCount,
        followerCount,
        notification,
        bio,
        allowComments,
        commentCount,
        image,
        artworkUrl,
        permalinkUrl,
        favorite,
      ];
}
