import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/entities/songs.dart';

class SearchSongCubit extends Cubit<List<Songs>> {
  SearchSongCubit() : super([]);

  late List<Songs> _allSongs;

  void setSongs(List<Songs> songs) {
    _allSongs = songs;
    emit(_allSongs);
  }

  void searchSongs(String query) {
    if (query.isEmpty) {
      emit(List.from(_allSongs));
    } else {
      emit(_allSongs
          .where((song) => song.title!.toLowerCase().contains(query.toLowerCase()))
          .toList(),);
    }
  }
}
