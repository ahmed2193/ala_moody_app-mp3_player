import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'audiodetais_state.dart';

class AudiodetaisCubit extends Cubit<AudiodetaisState> {
  AudiodetaisCubit() : super(AudiodetaisInitial());
}
