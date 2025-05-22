import '../entities/artists.dart';

class ArtistsModel extends Artists {
  ArtistsModel({
    super.id,
    super.impression,
    super.name,
    super.loves,
    super.allowComments,
    super.commentCount,
    super.verified,
    super.artworkUrl,
    super.favorite,
    super.permalinkUrl,
  });
  factory ArtistsModel.fromJson(Map<String, dynamic> json) => ArtistsModel(
        id: json[
                'id'] ?? 0, // Assuming 'id' should be an int, using 0 as the default
        impression: json['impression'] ?? 0, // Assuming int, using 0 as default
        name: json['name'] ?? 'Unknown', // String with 'Unknown' as default
        loves: json['loves'] ?? 0, // Assuming int, using 0 as default
        allowComments: json['allow_comments'] ?? false, // Assuming bool, using false
        commentCount: json['comment_count'] ?? 0, // Assuming int, using 0 as default
        verified: json['verified'] ?? false, // Assuming bool, using false
        artworkUrl: json['artwork_url'] ?? '', // String with '' as default
        favorite: json['favorite'] ?? false, // Assuming bool, using false
        permalinkUrl: json['permalink_url'] ?? '', // String with '' as default
      );
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'impression': impression,
      'name': name,
      'loves': loves,
      'allow_comments': allowComments,
      'comment_count': commentCount,
      'verified': verified,
      'artwork_url': artworkUrl,
      'favorite': favorite,
      'permalink_url': permalinkUrl,
    };
  }
}
