
import 'package:alamoody/features/live_stream/data/model/live_users_model.dart';
import 'package:alamoody/features/live_stream/domain/usecases/get_live_user.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/api/base_response.dart';
import '../../../../../core/error/failures.dart';
import '../../../../auth/presentation/cubit/login/login_cubit.dart';
import '../create_user_is_live/create_live_user_cubit.dart';
part 'live_users_state.dart';

class LiveUsersCubit extends Cubit<LiveUsersState> {
  final GetLive liveUsersUseCase;

  LiveUsersCubit({
    required this.liveUsersUseCase,
  }) : super(LiveUsersInitial());
LiveUserModel? liveUsers ;

  Future<void> getLiveUsers({
    required String accessToken,
  required  BuildContext context,
  }) async {
    emit(LiveUsersLoading());
        BlocProvider.of<CreateUserIsLiveCubit>(context).createUserIsLive(
          isLive: '0',
          accessToken:
              context.read<LoginCubit>().authenticatedUser!.accessToken!,
        );
    final Either<Failure, BaseResponse> response = await liveUsersUseCase(
      GetLiveParams(
        accessToken: accessToken,
      ),
    );
    emit(
      response.fold((failure) => LiveUsersError(message: failure.message!),
          (value) {
        liveUsers = value.data;

        return LiveUsersSuccess();
      }),
    );
  }
}
