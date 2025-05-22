class LiveUserModel {
  bool? success;
  List<Users>? users;

  LiveUserModel({this.success, this.users});

  LiveUserModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['users'] != null) {
      users = <Users>[];
      json['users'].forEach((v) {
        users!.add(Users.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (users != null) {
      data['users'] = users!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Users {
  int? id;
  String? name;
  String? username;
  dynamic sessionId;
  String? soundcloudUrl;
  String? instagramUrl;
  String? youtubeUrl;
  String? facebookUrl;
  String? twitterUrl;
  String? websiteUrl;
  String? artistId;
  String? collectionCount;
  int? followingCount;
  int? followerCount;
  int? notification;
  String? bio;
  String? birth;
  String? allowComments;
  String? commentCount;
  String? image;

  String? fcmToken;
  String? isLive;
  String? artworkUrl;
  String? permalinkUrl;
  bool? favorite;
  Subscription? subscription;
  bool? hasNotifications;

  Users(
      {this.id,
      this.name,
      this.username,
      this.sessionId,
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
      this.birth,
      this.allowComments,
      this.commentCount,
      this.image,
      this.fcmToken,
      this.isLive,
      this.artworkUrl,
      this.permalinkUrl,
      this.favorite,
      this.subscription,
      this.hasNotifications,});

  Users.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    username = json['username'];
    sessionId = json['session_id'];
    soundcloudUrl = json['soundcloud_url'];
    instagramUrl = json['instagram_url'];
    youtubeUrl = json['youtube_url'];
    facebookUrl = json['facebook_url'];
    twitterUrl = json['twitter_url'];
    websiteUrl = json['website_url'];
    artistId = json['artist_id'];
    collectionCount = json['collection_count'];
    followingCount = json['following_count'];
    followerCount = json['follower_count'];
    notification = json['notification'];
    bio = json['bio'];
    birth = json['birth'];
    allowComments = json['allow_comments'];
    commentCount = json['comment_count'];
    image = json['image'];
    // facebookId = json['facebook_id']==null ? '' : json['facebook_id'];
    // phone = json['phone'];
    fcmToken = json['fcm_token'];
    isLive = json['is_live'];
    artworkUrl = json['artwork_url'];
    permalinkUrl = json['permalink_url'];
    favorite = json['favorite'];
    subscription = json['subscription'] != null
        ? Subscription.fromJson(json['subscription'])
        : null;
    hasNotifications = json['has_notifications'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['username'] = username;
    data['session_id'] = sessionId;
    data['soundcloud_url'] = soundcloudUrl;
    data['instagram_url'] = instagramUrl;
    data['youtube_url'] = youtubeUrl;
    data['facebook_url'] = facebookUrl;
    data['twitter_url'] = twitterUrl;
    data['website_url'] = websiteUrl;
    data['artist_id'] = artistId;
    data['collection_count'] = collectionCount;
    data['following_count'] = followingCount;
    data['follower_count'] = followerCount;
    data['notification'] = notification;
    data['bio'] = bio;
    data['birth'] = birth;
    data['allow_comments'] = allowComments;
    data['comment_count'] = commentCount;
    data['image'] = image;
    data['is_live'] = isLive;
    data['artwork_url'] = artworkUrl;
    data['permalink_url'] = permalinkUrl;
    data['favorite'] = favorite;
    if (subscription != null) {
      data['subscription'] = subscription!.toJson();
    }
    data['has_notifications'] = hasNotifications;
    return data;
  }
}

class Subscription {
  int? id;
  String? gate;
  String? autoBilling;
  String? cycles;
  String? userId;
  String? serviceId;
  String? lastPaymentDate;
  String? amount;
  String? paymentStatus;
  String? approved;
  String? createdAt;
  String? updatedAt;

  Subscription({
    this.id,
    this.gate,
    this.autoBilling,
    this.cycles,
    this.userId,
    this.serviceId,
    this.lastPaymentDate,
    this.amount,
    this.paymentStatus,
    this.approved,
    this.createdAt,
    this.updatedAt,
  });

  Subscription.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    gate = json['gate'];
    autoBilling = json['auto_billing'];
    cycles = json['cycles'];
    userId = json['user_id'];
    serviceId = json['service_id'];
    lastPaymentDate = json['last_payment_date'];

    amount = json['amount'];
    paymentStatus = json['payment_status'];
    approved = json['approved'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['gate'] = gate;
    data['auto_billing'] = autoBilling;
    data['cycles'] = cycles;
    data['user_id'] = userId;
    data['service_id'] = serviceId;
    data['last_payment_date'] = lastPaymentDate;
    data['amount'] = amount;
    data['payment_status'] = paymentStatus;
    data['approved'] = approved;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
