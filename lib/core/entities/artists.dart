import 'package:equatable/equatable.dart';

class Artists extends Equatable {
  final int? id;
  final String? impression;

  final String? name;

  final dynamic loves;
  final dynamic allowComments;
  final dynamic commentCount;
  final dynamic verified;
  final String? artworkUrl;
   bool? favorite;
  final String? permalinkUrl;

   Artists({
    this.id,
    this.impression,
    this.name,
    this.loves,
    this.allowComments,
    this.commentCount,
    this.verified,
    this.artworkUrl,
    this.favorite,
    this.permalinkUrl,
  });

  @override
  List<Object?> get props => [
        id,
        impression,
        name,
        loves,
        allowComments,
        commentCount,
        verified,
        artworkUrl,
        favorite,
        permalinkUrl,
      ];
}
