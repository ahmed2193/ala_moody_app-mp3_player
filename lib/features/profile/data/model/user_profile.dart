import 'dart:convert';

class UserProfile {
  UserProfile({
    this.user,
    this.message,
  });

  final User? user;
  final String? message;

  factory UserProfile.fromRawJson(String str) =>
      UserProfile.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "user": user?.toJson(),
        "message": message,
      };
}

class User {
  User({
    this.id,
    this.name,
    this.username,
    this.email,
    this.emailVerified,
    this.soundcloudUrl,
    this.instagramUrl,
    this.youtubeUrl,
    this.facebookUrl,
    this.twitterUrl,
    this.websiteUrl,
    this.banned,
    this.artistId,
    this.playlistCount,
    this.collectionCount,
    this.favoriteCount,
    this.followingCount,
    this.followerCount,
    this.loggedIp,
    this.lastSeenNotif,
    this.hasNotifications,
    this.notification,
    this.country,
    this.bio,
    this.gender,
    this.allowComments,
    this.commentCount,
    this.restoreQueue,
    this.persistShuffle,
    this.playPauseFade,
    this.disablePlayerShortcuts,
    this.crossfadeAmount,
    this.activityPrivacy,
    this.notifFollower,
    this.notifPlaylist,
    this.notifShares,
    this.notifFeatures,
    this.image,
    this.createdAt,
    this.updatedAt,
    this.phone,
    this.artworkUrl,
    this.permalinkUrl,
    this.favorite,
    this.subscription,
    this.birth,
  });

  final int? id;
  final bool? hasNotifications;
  final String? name;
  final String? username;
  final String? email;
  final String? emailVerified;
  final String? soundcloudUrl;
  final String? instagramUrl;
  final String? youtubeUrl;
  final String? facebookUrl;
  final String? twitterUrl;
  final String? websiteUrl;
  final String? banned;
  final String? artistId;
  final String? playlistCount;
  final String? collectionCount;
  final String? favoriteCount;
  final int? followingCount;
  final int? followerCount;
  final String? loggedIp;
  final DateTime? lastSeenNotif;
  final int? notification;
  final String? country;
  final String? bio;
  final String? gender;
  final String? allowComments;
  final String? commentCount;
  final String? restoreQueue;
  final String? persistShuffle;
  final String? playPauseFade;
  final String? disablePlayerShortcuts;
  final String? crossfadeAmount;
  final String? activityPrivacy;
  final String? notifFollower;
  final String? notifPlaylist;
  final String? notifShares;
  final String? notifFeatures;
  final String? image;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  final dynamic phone;
  // final Group? group;
  final String? artworkUrl;
  final String? permalinkUrl;
  final String? birth;
  final bool? favorite;
  final Subscription? subscription;

  factory User.fromRawJson(String str) => User.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"] ?? '',
        username: json["username"],
        email: json["email"] ?? '',
        emailVerified: json["email_verified"],
        soundcloudUrl: json["soundcloud_url"],
        instagramUrl: json["instagram_url"],
        youtubeUrl: json["youtube_url"],
        facebookUrl: json["facebook_url"],
        twitterUrl: json["twitter_url"],
        hasNotifications: json["has_notifications"],
        websiteUrl: json["website_url"],
        banned: json["banned"],
        artistId: json["artist_id"],
        playlistCount: json["playlist_count"],
        collectionCount: json["collection_count"],
        favoriteCount: json["favorite_count"],
        followingCount: json["following_count"],
        followerCount: json["follower_count"],
        loggedIp: json["logged_ip"],
        lastSeenNotif: json["last_seen_notif"] == null
            ? null
            : DateTime.parse(json["last_seen_notif"]),
        notification: json["notification"],
        country: json["country"] ?? '',
        bio: json["bio"] ?? '',
        gender: json["gender"] ?? '',
        allowComments: json["allow_comments"],
        commentCount: json["comment_count"],
        restoreQueue: json["restore_queue"],
        persistShuffle: json["persist_shuffle"],
        playPauseFade: json["play_pause_fade"],
        disablePlayerShortcuts: json["disablePlayerShortcuts"],
        crossfadeAmount: json["crossfade_amount"],
        activityPrivacy: json["activity_privacy"],
        notifFollower: json["notif_follower"],
        notifPlaylist: json["notif_playlist"],
        notifShares: json["notif_shares"],
        notifFeatures: json["notif_features"],
        image: json["image"] ?? "",
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        phone: json["phone"] ?? '',
        artworkUrl: json["artwork_url"],
        permalinkUrl: json["permalink_url"],
        favorite: json["favorite"],
        birth: json["birth"] ?? '',
        subscription: json["subscription"] == null
            ? null
            : Subscription.fromJson(json["subscription"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "username": username,
        "email": email,
        "email_verified": emailVerified,
        "soundcloud_url": soundcloudUrl,
        "instagram_url": instagramUrl,
        "youtube_url": youtubeUrl,
        "facebook_url": facebookUrl,
        "has_notifications": hasNotifications,
        "twitter_url": twitterUrl,
        "website_url": websiteUrl,
        "banned": banned,
        "artist_id": artistId,
        "playlist_count": playlistCount,
        "collection_count": collectionCount,
        "favorite_count": favoriteCount,
        "following_count": followingCount,
        "follower_count": followerCount,
        "logged_ip": loggedIp,
        "last_seen_notif": lastSeenNotif?.toIso8601String(),
        "notification": notification,
        "country": country,
        "bio": bio,
        "gender": gender,
        "allow_comments": allowComments,
        "comment_count": commentCount,
        "restore_queue": restoreQueue,
        "persist_shuffle": persistShuffle,
        "play_pause_fade": playPauseFade,
        "disablePlayerShortcuts": disablePlayerShortcuts,
        "crossfade_amount": crossfadeAmount,
        "activity_privacy": activityPrivacy,
        "notif_follower": notifFollower,
        "notif_playlist": notifPlaylist,
        "notif_shares": notifShares,
        "notif_features": notifFeatures,
        "image": image,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "phone": phone,
        "artwork_url": artworkUrl,
        "permalink_url": permalinkUrl,
        "favorite": favorite,
        "birth": birth,
        "subscription": subscription?.toJson(),
      };
}

class Subscription {
  Subscription({
    this.id,
    this.gate,
    this.autoBilling,
    this.cycles,
    this.userId,
    this.token,
    this.serviceId,
    this.lastPaymentDate,
    this.amount,
    this.paymentStatus,
    this.approved,
    this.createdAt,
    this.updatedAt,
    this.planName,
  });

  final int? id;
  final String? gate;
  final String? autoBilling;
  final String? cycles;
  final String? userId;
  final dynamic token;
  final String? serviceId;
  final DateTime? lastPaymentDate;
  final String? amount;
  final String? paymentStatus;
  final String? approved;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? planName;

  factory Subscription.fromRawJson(String str) =>
      Subscription.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Subscription.fromJson(Map<String, dynamic> json) => Subscription(
        id: json["id"],
        gate: json["gate"],
        autoBilling: json["auto_billing"],
        cycles: json["cycles"],
        userId: json["user_id"],
        token: json["token"] ?? '',
        serviceId: json["service_id"],
        lastPaymentDate: json["last_payment_date"] == null
            ? null
            : DateTime.parse(json["last_payment_date"]),
        amount: json["amount"],
        paymentStatus: json["payment_status"],
        approved: json["approved"],
        planName: json["plan_name"] ?? '',
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "gate": gate,
        "auto_billing": autoBilling,
        "cycles": cycles,
        "user_id": userId,
        "token": token,
        "service_id": serviceId,
        "last_payment_date": lastPaymentDate?.toIso8601String(),
        "amount": amount,
        "payment_status": paymentStatus,
        "approved": approved,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
