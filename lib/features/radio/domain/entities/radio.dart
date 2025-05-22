import 'package:equatable/equatable.dart';

class Radio extends Equatable {
  final int? id;
  final dynamic parentId;
  final dynamic priority;
  final String? name;
  final String? altName;
  final String? description;
  final String? metaKeywords;
  final String? createdAt;
  final String? updatedAt;
  final String? artworkUrl;

  const Radio({
    this.id,
    this.parentId,
    this.priority,
    this.name,
    this.altName,
    this.description,
    this.metaKeywords,
    this.createdAt,
    this.updatedAt,
    this.artworkUrl,
  });

  @override
  List<Object?> get props => [
        id,
        parentId,
        priority,
        name,
        altName,
        description,
        metaKeywords,
        createdAt,
        updatedAt,
        artworkUrl,
      ];
}
