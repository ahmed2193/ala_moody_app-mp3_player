import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/api/base_response.dart';
import '../../../../../core/error/failures.dart';
import '../../../domain/entities/home.dart';
import '../../../domain/usecases/home_data.dart';

part 'home_data_state.dart';

class HomeDataCubit extends Cubit<HomeDataState> {
  final HomeDataUseCase homeDataUseCase;
  HomeDataCubit({required this.homeDataUseCase}) : super(HomeDataInitial());

  HomeData? homeData;

  Future<void> getHomeData({
    String? accessToken,
    String? searchTxt,
  }) async {
    emit(const HomeDataIsLoading());
    final Either<Failure, BaseResponse> response = await homeDataUseCase(
      HomeDataUseCaseParams(
        accessToken: accessToken!,
        searchTxt: searchTxt!,
      ),
    );
    emit(
      response.fold((failure) => HomeDataError(message: failure.message),
          (value) {
        homeData = value.data;
        if (homeData!.playlists!.isEmpty) {
          log('homeData');
          // print(homeData!.playlists);
          log('homeData');
        }
       else {log('homeData');}

        return HomeDataLoaded();
      }),
    );
  }
}
