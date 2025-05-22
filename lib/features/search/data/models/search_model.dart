import '../../../../core/models/song_model.dart';
import '../../domain/entities/search.dart';

class SearchModel extends SearchData {
  const SearchModel({
    required super.foryou,
    required super.audioBook,
    required super.categories,
    required super.podcasts,
  });
  factory SearchModel.fromJson(Map<String, dynamic> json) => SearchModel(
        foryou: List<SongModel>.from(
          json["foryou"].map((x) => SongModel.fromJson(x)),
        ),
        categories: List<SongModel>.from(
          json["categories"].map((x) => SongModel.fromJson(x)),
        ),
        audioBook: List<SongModel>.from(
          json["audio_book"].map((x) => SongModel.fromJson(x)),
        ),
        podcasts: List<SongModel>.from(
          json["podcasts"].map((x) => SongModel.fromJson(x)),
        ),
      );
}
