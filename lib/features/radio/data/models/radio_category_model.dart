import '../../domain/entities/radio_category.dart';

class RadioCategoryModel extends RadioCategory {
  const RadioCategoryModel({
    required super. id,
 required super.category,
 required super.title,
 required super.description,

 required super.streamUrl,
 required super.allowComments,
 required super.commentCount,
 required super.playCount,
 required super.failedCount,
 required super.visibility,
 required super.createdAt,
 required super.updatedAt,
 required super.artworkUrl,
 required super.permalinkUrl,
  });
  factory RadioCategoryModel.fromJson(Map<String, dynamic> json) => RadioCategoryModel(
          id : json['id'],

    category : json['category'],
    title : json['title'],
    description : json['description'],

    streamUrl : json['stream_url'],
    allowComments : json['allow_comments'],
    commentCount : json['comment_count'],
    playCount : json['play_count'],
    failedCount : json['failed_count'],
    visibility : json['visibility'],
    createdAt : json['created_at'],
    updatedAt : json['updated_at'],
    artworkUrl : json['artwork_url'],
    permalinkUrl : json['permalink_url'],
      );
}
