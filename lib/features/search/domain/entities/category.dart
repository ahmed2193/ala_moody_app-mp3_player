import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final int? id;
  final dynamic parentId;
  final dynamic priority;
  final String? name;
  final String? altName;
  final dynamic discover;
  final String? artworkUrl;
  final String? permalinkUrl;

  const Category({
    this.id,
    this.parentId,
    this.priority,
    this.name,
    this.altName,
    this.discover,
    this.artworkUrl,
    this.permalinkUrl,
  });

  @override
  List<Object?> get props => [
        id,
        parentId,
        priority,
        name,
        altName,
        discover,
        artworkUrl,
        permalinkUrl,
      ];
}
