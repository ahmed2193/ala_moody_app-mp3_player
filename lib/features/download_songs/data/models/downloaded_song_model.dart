
class DownloadedMusicModel {
  final int? id;
  final String? title;
  final String? path;
  final String? image;
  final String? artists;
  final String? date;
  final String? lyrics;

  DownloadedMusicModel({
    this.id,
    this.title,
    this.path,
    this.image,
    this.date,
    this.artists,
    this.lyrics,
  });

  DownloadedMusicModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'] as String?,
        path = json['path'] as String?,
        date = json['date'] as String?,
        artists = json['artists'] as String?,
        image = json['image'] as String?,
        lyrics = json['lyrics'] as String?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'path': path,
        'date': date,
        'artists': artists,
        'image': image,
        'lyrics': image,
      };

  @override
  List<Object?> get props => [
        id,
        title,
        path,
        date,
        artists,
        image,
        lyrics,
      ];
  DownloadedMusicModel copyWith({
    final int? id,
    final String? title,
    final String? path,
    final String? date,
    final String? artists,
    final String? image,
    final String? lyrics,
  }) =>
      DownloadedMusicModel(
        id: id ?? this.id,
        title: title ?? this.title,
        path: path ?? this.path,
        date: date ?? this.date,
        artists: artists ?? this.artists,
        image: image ?? this.image,
        lyrics: lyrics ?? this.lyrics,
      );
}
