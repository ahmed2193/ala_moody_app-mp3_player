import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'artists_state.dart';

class ArtistsCubit extends Cubit<ArtistsState> {
  ArtistsCubit() : super(ArtistsInitial());
}
