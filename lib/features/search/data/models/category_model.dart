import '../../domain/entities/category.dart';

class CategoryModel extends Category {
  const CategoryModel({
    required super.id,
    required super.parentId,
    required super.priority,
    required super.name,
    required super.altName,
    required super.discover,
    required super.artworkUrl,
    required super.permalinkUrl,
  });
  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        id: json['id'],
        parentId: json['parent_id'],
        priority: json['priority'],
        name: json['name'],
        altName: json['alt_name'],
        discover: json['discover'],
        artworkUrl: json['artwork_url'],
        permalinkUrl: json['permalink_url'],
      );
}
