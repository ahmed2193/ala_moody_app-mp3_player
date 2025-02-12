class SongsShareData {
  final String id;
  final String title;
  final String artworkUrl;
  final String lyrics;
  final String listened;
  final String streamUrl;
  final String? artist;
  final bool favorite;

  SongsShareData({
    required this.id,
    required this.title,
    required this.artworkUrl,
    required this.lyrics,
    required this.listened,
    required this.streamUrl,
    required this.favorite,
    required this.artist,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'artwork_url': artworkUrl,
        'favorite': favorite,
        'audio': streamUrl,
        'listened': listened,
        'lyrics': lyrics,
        'artist': artist,
      };

  static SongsShareData fromJson(Map<String, dynamic> json) => SongsShareData(
        id: json['id'] ?? '',
        title: json['title'] ?? '',
        artworkUrl: json['artwork_url'] ?? '',
        streamUrl: json['audio'] ?? '',
        favorite: json['favorite'] ?? false,
        listened: json['listened'] ?? '',
        lyrics: json['lyrics'] ?? '',
        artist: json['artist'] ?? '',
      );
}