import 'package:alamoody/core/entities/genreic.dart';

class GenresModel extends Genres {
  const GenresModel({
    required super.id,
    required super.parentId,
    required super.priority,
    required super.altName,
    required super.discover,
    required super.name,
    required super.type,
    required super.artworkUrl,
    required super.permalinkUrl,
  });
  factory GenresModel.fromJson(Map<String, dynamic> json) => GenresModel(
        id: json['id'],
        parentId: json['parent_id'],
        priority: json['priority'],
        name: json['name'],
        altName: json['alt_name'],
        discover: json['discover'],
        type: json['type'],
        artworkUrl: json['artwork_url'],
        permalinkUrl: json['permalink_url'],
      );
}
