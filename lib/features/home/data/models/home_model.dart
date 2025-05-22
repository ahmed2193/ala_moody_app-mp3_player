import '../../../../core/models/artists_model.dart';
import '../../../../core/models/genres_model.dart';
import '../../../../core/models/song_model.dart';
import '../../../mood/data/models/moods_model.dart';
import '../../../radio/data/models/radio_model.dart';
import '../../domain/entities/home.dart';
import 'songs_play_lists_model.dart';

class HomeModel extends HomeData {
  const HomeModel({
    required super.playlists,
    required super.popularSongs,
    required super.recentListens,
    required super.artists,
    required super.radio,
    required super.genres,
    required super.occasions,
    required super.moods,
    required super.categories,
  });
  factory HomeModel.fromJson(Map<String, dynamic> json) => HomeModel(
        recentListens: json["recentListens"] != null
            ? List<SongModel>.from(
                json["recentListens"].map((x) => SongModel.fromJson(x)),)
            : [], // Handle null with an empty list
        radio: json["radio"] != null
            ? List<RadioModel>.from(
                json["radio"].map((x) => RadioModel.fromJson(x)),)
            : [], // Handle null with an empty list
        playlists: json["playlists"] != null
            ? List<SongsPlayListsModel>.from(
                json["playlists"].map((x) => SongsPlayListsModel.fromJson(x)),)
            : [], // Handle null with an empty list
        popularSongs: json["popularSongs"] != null
            ? List<SongModel>.from(
                json["popularSongs"].map((x) => SongModel.fromJson(x)),)
            : [], // Handle null with an empty list
        artists: json["artists"] != null
            ? List<ArtistsModel>.from(
                json["artists"].map((x) => ArtistsModel.fromJson(x)),)
            : [], // Handle null with an empty list
        genres: json["genres"] != null
            ? List<GenresModel>.from(
                json["genres"].map((x) => GenresModel.fromJson(x)),)
            : [], // Handle null with an empty list
        occasions: json["special_occasion"] != null
            ? List<GenresModel>.from(
                json["special_occasion"].map((x) => GenresModel.fromJson(x)),)
            : [], // Handle null with an empty list
        moods: json["moods"] != null
            ? List<MoodsModel>.from(
                json["moods"].map((x) => MoodsModel.fromJson(x)),)
            : [], // Handle null with an empty list
        categories: json["categories"] != null
            ? List<GenresModel>.from(
                json["categories"].map((x) => GenresModel.fromJson(x)),)
            : [], // Handle null with an empty list
      );
}
