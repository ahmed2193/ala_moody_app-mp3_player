import 'package:alamoody/core/entities/genreic.dart';
import 'package:alamoody/features/home/domain/entities/Songs_PlayLists.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/entities/artists.dart';
import '../../../../core/entities/songs.dart';
import '../../../mood/domain/entities/moods.dart';
import '../../../radio/domain/entities/radio.dart';

class HomeData extends Equatable {
  final List<Songs>? recentListens;
  final List<SongsPlayLists>? playlists;
  final List<Songs>? popularSongs;
  final List<Artists>? artists;
  final List<Radio>? radio;
  final List<Genres>? genres;
  final List<Genres>? occasions;
  final List<Moods>? moods;
  final List<Genres>? categories;
  const HomeData({
    this.recentListens,
    this.playlists,
    this.popularSongs,
    this.artists,
    this.radio,
    this.genres,
    this.occasions,
    this.moods,
    this.categories,
  });

  @override
  List<Object?> get props => [
        genres,
        occasions,
        recentListens,
        playlists,
        popularSongs,
        artists,
        radio,
        categories,
      ];
}
