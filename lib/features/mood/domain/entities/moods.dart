import 'package:equatable/equatable.dart';

class Moods extends Equatable {
  final int? id;
  final dynamic parentId;
  final dynamic priority;
  final String? color;
  String? name;
  final String? altName;
  String? artworkUrl;
  final String? permalinkUrl;
  bool? moodState;

  Moods({
    this.id,
    this.parentId,
    this.priority,
    this.name,
    this.altName,
    this.artworkUrl,
    this.permalinkUrl,
    this.color,
    this.moodState = false,
  });

  @override
  List<Object?> get props => [
        moodState,
        id,
        parentId,
        priority,
        name,
        altName,
        artworkUrl,
        permalinkUrl,
        color,
      ];
}
