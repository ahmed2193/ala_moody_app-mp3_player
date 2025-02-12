
import '../../domain/entities/radio.dart';

class RadioModel extends Radio {
  const RadioModel({
required super. id,
 required super.parentId,
 required super.priority,
 required super.name,
 required super.altName,
 required super.description,
 required super.metaKeywords,
 required super.createdAt,
 required super.updatedAt,
 required super.artworkUrl,
  });
  factory RadioModel.fromJson(Map<String, dynamic> json) => RadioModel(
     id : json['id'],
    parentId : json['parent_id'],
    priority : json['priority'],
    name : json['name'],
    altName : json['alt_name'],
    description : json['description'],

    metaKeywords : json['meta_keywords'],
    createdAt : json['created_at'],
    updatedAt : json['updated_at'],
    artworkUrl : json['artwork_url'],
      );
}
