import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/api/base_response.dart';
import '../../../../../core/error/failures.dart';
import '../../../domain/entities/moods.dart';
import '../../../domain/usecases/get_mood.dart';
import 'your_mood_state.dart';

class YourMoodCubit extends Cubit<YourMoodState> {
  final GetMood getMoodUseCase;

  YourMoodCubit({required this.getMoodUseCase}) : super(YourMoodInitial());

// super(MoodInitial());

  List<Moods> mood = [];

  Future<void> getMood({
    String? accessToken,
  }) async {
    emit(const YourMoodIsLoading());
    final Either<Failure, BaseResponse> response = await getMoodUseCase(
      GetMoodParams(
        accessToken: accessToken!,
      ),
    );
    emit(
      response.fold((failure) => YourMoodError(message: failure.message),
          (value) {
        mood = value.data;
        selectedMood = mood.first;
        selectedMood!.moodState = true;
        return YourMoodLoaded();
      }),
    );
  }

  // List moods = [
  //   [
  //     'Happy',
  //     false,
  //     ImagesPath.smileHeartEmoji,
  //     'Make people happier through their mood sharing caring to other.'
  //   ],
  //   [
  //     'Wow',
  //     false,
  //     ImagesPath.wowEmoji,
  //     'Make people wow through their mood sharing caring to other.'
  //   ],
  //   [
  //     'Amazing',
  //     false,
  //     ImagesPath.amazingEmojiIcon,
  //     'Make people amazing through their mood sharing caring to other.'
  //   ],
  //   [
  //     'Sad',
  //     false,
  //     ImagesPath.sadEmojiIcon,
  //     'Make people sad through their mood sharing caring to other.'
  //   ],
  //   [
  //     'Confused ',
  //     false,
  //     ImagesPath.confusedEmojiIcon,
  //     'Make people confused through their mood sharing caring to other.'
  //   ],
  //   [
  //     'Angry',
  //     false,
  //     ImagesPath.angryEmojiIcon,
  //     'Make people angry through their mood sharing caring to other.'
  //   ],
  // ];

  Moods? selectedMood;

  void changeSelectedMood(int index) {
    emit(YourMoodInitial());
    mood.elementAt(index).name = mood.elementAt(index).name;
    selectedMood = mood[index];
    for (final ele in mood) {
      if (ele.id == selectedMood!.id) {
        ele.moodState = !ele.moodState!;
      } else {
        ele.moodState = false;
      }
      //   if(selectedMood!.moodState==true){
      //   ele.moodState = true;
      // }
    }

    emit(YourMoodChangeSelectedMood());
  }
}
