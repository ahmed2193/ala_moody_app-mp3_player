import 'package:equatable/equatable.dart';

class RadioCategory extends Equatable {
  final dynamic id;
  final String? category;
  final String? title;
  final String? description;

  final String? streamUrl;
  final dynamic allowComments;
  final dynamic commentCount;
  final dynamic playCount;
  final dynamic failedCount;
  final dynamic visibility;
  final String? createdAt;
  final String? updatedAt;
  final String? artworkUrl;
  final String? permalinkUrl;

  const RadioCategory({
    this.id,
    this.category,
    this.title,
    this.description,
    this.streamUrl,
    this.allowComments,
    this.commentCount,
    this.playCount,
    this.failedCount,
    this.visibility,
    this.createdAt,
    this.updatedAt,
    this.artworkUrl,
    this.permalinkUrl,
  });

  @override
  List<Object?> get props => [
        id,
        category,
        title,
        description,
        streamUrl,
        allowComments,
        commentCount,
        playCount,
        failedCount,
        visibility,
        createdAt,
        updatedAt,
        artworkUrl,
        permalinkUrl,
      ];
}
