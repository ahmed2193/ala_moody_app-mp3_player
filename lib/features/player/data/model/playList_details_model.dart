import 'dart:convert';
PlayListDetailsModel playListDetailsModelFromJson(String str) => PlayListDetailsModel.fromJson(json.decode(str));
String playListDetailsModelToJson(PlayListDetailsModel data) => json.encode(data.toJson());
class PlayListDetailsModel {
  PlayListDetailsModel({
      this.message, 
      this.data,});

  PlayListDetailsModel.fromJson(dynamic json) {
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  String? message;
  Data? data;
PlayListDetailsModel copyWith({  String? message,
  Data? data,
}) => PlayListDetailsModel(  message: message ?? this.message,
  data: data ?? this.data,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = message;
    if (data != null) {
      map['data'] = data?.toJson();
    }
    return map;
  }

}

Data dataFromJson(String str) => Data.fromJson(json.decode(str));
String dataToJson(Data data) => json.encode(data.toJson());
class Data {
  Data({
      this.id, 
      this.artistIds, 
      this.collaboration, 
      this.genre, 
      this.mood, 
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
      this.activities,});

  Data.fromJson(dynamic json) {
    id = json['id'];
    artistIds = json['artistIds'];
    collaboration = json['collaboration'];
    genre = json['genre'];
    mood = json['mood'];
    title = json['title'];
    description = json['description'];
    loves = json['loves'];
    allowComments = json['allow_comments'];
    commentCount = json['comment_count'];
    visibility = json['visibility'];
    createdAt = json['created_at'];
    artworkUrl = json['artwork_url'];
    permalinkUrl = json['permalink_url'];
    songCount = json['song_count'];
    subscriberCount = json['subscriber_count'];
    favorite = json['favorite'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    activities = json['activities'] != null ? Activities.fromJson(json['activities']) : null;
  }
  int? id;
  String? artistIds;
  String? collaboration;
  String? genre;
  String? mood;
  String? title;
  String? description;
  String? loves;
  String? allowComments;
  String? commentCount;
  String? visibility;
  String? createdAt;
  String? artworkUrl;
  String? permalinkUrl;
  int? songCount;
  int? subscriberCount;
  bool? favorite;
  User? user;
  Activities? activities;
Data copyWith({  int? id,
  String? artistIds,
  String? collaboration,
  String? genre,
  String? mood,
  String? title,
  String? description,
  String? loves,
  String? allowComments,
  String? commentCount,
  String? visibility,
  String? createdAt,
  String? artworkUrl,
  String? permalinkUrl,
  int? songCount,
  int? subscriberCount,
  bool? favorite,
  User? user,
  Activities? activities,
}) => Data(  id: id ?? this.id,
  artistIds: artistIds ?? this.artistIds,
  collaboration: collaboration ?? this.collaboration,
  genre: genre ?? this.genre,
  mood: mood ?? this.mood,
  title: title ?? this.title,
  description: description ?? this.description,
  loves: loves ?? this.loves,
  allowComments: allowComments ?? this.allowComments,
  commentCount: commentCount ?? this.commentCount,
  visibility: visibility ?? this.visibility,
  createdAt: createdAt ?? this.createdAt,
  artworkUrl: artworkUrl ?? this.artworkUrl,
  permalinkUrl: permalinkUrl ?? this.permalinkUrl,
  songCount: songCount ?? this.songCount,
  subscriberCount: subscriberCount ?? this.subscriberCount,
  favorite: favorite ?? this.favorite,
  user: user ?? this.user,
  activities: activities ?? this.activities,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['artistIds'] = artistIds;
    map['collaboration'] = collaboration;
    map['genre'] = genre;
    map['mood'] = mood;
    map['title'] = title;
    map['description'] = description;
    map['loves'] = loves;
    map['allow_comments'] = allowComments;
    map['comment_count'] = commentCount;
    map['visibility'] = visibility;
    map['created_at'] = createdAt;
    map['artwork_url'] = artworkUrl;
    map['permalink_url'] = permalinkUrl;
    map['song_count'] = songCount;
    map['subscriber_count'] = subscriberCount;
    map['favorite'] = favorite;
    if (user != null) {
      map['user'] = user?.toJson();
    }
    if (activities != null) {
      map['activities'] = activities?.toJson();
    }
    return map;
  }

}

Activities activitiesFromJson(String str) => Activities.fromJson(json.decode(str));
String activitiesToJson(Activities data) => json.encode(data.toJson());
class Activities {
  Activities({
      this.currentPage, 
      this.firstPageUrl, 
      this.from, 
      this.lastPage, 
      this.lastPageUrl, 
      this.nextPageUrl, 
      this.path, 
      this.perPage, 
      this.total,});

  Activities.fromJson(dynamic json) {
    currentPage = json['current_page'];
    firstPageUrl = json['first_page_url'];
    from = json['from'];
    lastPage = json['last_page'];
    lastPageUrl = json['last_page_url'];
    nextPageUrl = json['next_page_url'];
    path = json['path'];
    perPage = json['per_page'];
    total = json['total'];
  }
  int? currentPage;
  String? firstPageUrl;
  String? from;
  int? lastPage;
  String? lastPageUrl;
  String? nextPageUrl;
  String? path;
  int? perPage;
  int? total;
Activities copyWith({  int? currentPage,
  String? firstPageUrl,
  String? from,
  int? lastPage,
  String? lastPageUrl,
  String? nextPageUrl,
  String? path,
  int? perPage,
  int? total,
}) => Activities(  currentPage: currentPage ?? this.currentPage,
  firstPageUrl: firstPageUrl ?? this.firstPageUrl,
  from: from ?? this.from,
  lastPage: lastPage ?? this.lastPage,
  lastPageUrl: lastPageUrl ?? this.lastPageUrl,
  nextPageUrl: nextPageUrl ?? this.nextPageUrl,
  path: path ?? this.path,
  perPage: perPage ?? this.perPage,
  total: total ?? this.total,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['current_page'] = currentPage;
    map['first_page_url'] = firstPageUrl;
    map['from'] = from;
    map['last_page'] = lastPage;
    map['last_page_url'] = lastPageUrl;
    map['next_page_url'] = nextPageUrl;
    map['path'] = path;
    map['per_page'] = perPage;
    map['total'] = total;
    return map;
  }

}

User userFromJson(String str) => User.fromJson(json.decode(str));
String userToJson(User data) => json.encode(data.toJson());
class User {
  User({
      this.id, 
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
      this.lastActivity, 
      this.notification, 
      this.bio, 
      this.allowComments, 
      this.commentCount, 
      this.image, 
      this.artworkUrl, 
      this.permalinkUrl, 
      this.favorite,});

  User.fromJson(dynamic json) {
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
    lastActivity = json['last_activity'];
    notification = json['notification'];
    bio = json['bio'];
    allowComments = json['allow_comments'];
    commentCount = json['comment_count'];
    image = json['image'];
    artworkUrl = json['artwork_url'];
    permalinkUrl = json['permalink_url'];
    favorite = json['favorite'];
  }
  int? id;
  String? name;
  String? username;
  String? sessionId;
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
  String? lastActivity;
  int? notification;
  String? bio;
  String? allowComments;
  String? commentCount;
  String? image;
  String? artworkUrl;
  String? permalinkUrl;
  bool? favorite;
User copyWith({  int? id,
  String? name,
  String? username,
  String? sessionId,
  String? soundcloudUrl,
  String? instagramUrl,
  String? youtubeUrl,
  String? facebookUrl,
  String? twitterUrl,
  String? websiteUrl,
  String? artistId,
  String? collectionCount,
  int? followingCount,
  int? followerCount,
  String? lastActivity,
  int? notification,
  String? bio,
  String? allowComments,
  String? commentCount,
  String? image,
  String? artworkUrl,
  String? permalinkUrl,
  bool? favorite,
}) => User(  id: id ?? this.id,
  name: name ?? this.name,
  username: username ?? this.username,
  sessionId: sessionId ?? this.sessionId,
  soundcloudUrl: soundcloudUrl ?? this.soundcloudUrl,
  instagramUrl: instagramUrl ?? this.instagramUrl,
  youtubeUrl: youtubeUrl ?? this.youtubeUrl,
  facebookUrl: facebookUrl ?? this.facebookUrl,
  twitterUrl: twitterUrl ?? this.twitterUrl,
  websiteUrl: websiteUrl ?? this.websiteUrl,
  artistId: artistId ?? this.artistId,
  collectionCount: collectionCount ?? this.collectionCount,
  followingCount: followingCount ?? this.followingCount,
  followerCount: followerCount ?? this.followerCount,
  lastActivity: lastActivity ?? this.lastActivity,
  notification: notification ?? this.notification,
  bio: bio ?? this.bio,
  allowComments: allowComments ?? this.allowComments,
  commentCount: commentCount ?? this.commentCount,
  image: image ?? this.image,
  artworkUrl: artworkUrl ?? this.artworkUrl,
  permalinkUrl: permalinkUrl ?? this.permalinkUrl,
  favorite: favorite ?? this.favorite,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['username'] = username;
    map['session_id'] = sessionId;
    map['soundcloud_url'] = soundcloudUrl;
    map['instagram_url'] = instagramUrl;
    map['youtube_url'] = youtubeUrl;
    map['facebook_url'] = facebookUrl;
    map['twitter_url'] = twitterUrl;
    map['website_url'] = websiteUrl;
    map['artist_id'] = artistId;
    map['collection_count'] = collectionCount;
    map['following_count'] = followingCount;
    map['follower_count'] = followerCount;
    map['last_activity'] = lastActivity;
    map['notification'] = notification;
    map['bio'] = bio;
    map['allow_comments'] = allowComments;
    map['comment_count'] = commentCount;
    map['image'] = image;
    map['artwork_url'] = artworkUrl;
    map['permalink_url'] = permalinkUrl;
    map['favorite'] = favorite;
    return map;
  }

}