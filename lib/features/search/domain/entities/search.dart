import 'package:equatable/equatable.dart';

import '../../../../core/entities/songs.dart';

class SearchData extends Equatable {
  final List<Songs>? foryou;
  final List<Songs>? audioBook;

  final List<Songs>? categories;
  final List<Songs>? podcasts;

  const SearchData({
    this.foryou,
    this.categories,
    this.audioBook,
    this.podcasts,
  });

  @override
  List<Object?> get props => [
        foryou,
        categories,
        audioBook,
        podcasts,
      ];
}
