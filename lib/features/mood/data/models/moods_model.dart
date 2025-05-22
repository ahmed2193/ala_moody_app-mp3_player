import '../../domain/entities/moods.dart';

class MoodsModel extends Moods {
  MoodsModel({
    required super.id,
    required super.parentId,
    required super.priority,
    required super.name,
    required super.altName,
    required super.artworkUrl,
    required super.permalinkUrl,
    required super.color,
  });
  factory MoodsModel.fromJson(Map<String, dynamic> json) => MoodsModel(
        id: json['id'],
        parentId: json['parent_id'],
        priority: json['priority'],
        name: json['name'],
        altName: json['alt_name'],
        artworkUrl: json['artwork_url'],
        permalinkUrl: json['permalink_url'],
        color: json['color'],
      );
}
