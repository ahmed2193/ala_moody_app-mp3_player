import 'dart:math';
import 'package:alamoody/core/utils/usecases/usecase.dart';
import 'package:alamoody/features/ads/data/models/ads_model.dart'; // Ensure this path is correct
import 'package:alamoody/features/ads/domain/usecases/get_ads.dart'; // Ensure this path is correct
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart'; // Only if needed, typically not in cubit
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/api/base_response.dart'; // Ensure this path is correct
import '../../../../../core/error/failures.dart'; // Ensure this path is correct

part 'ads_state.dart';

class AdsCubit extends Cubit<AdsState> {
  final GetAds getAdsUseCase;
  AdsCubit({required this.getAdsUseCase}) : super(AdsInitial());

  List<AdsData> adsList = [];
  AdsData? currentAd;

  Future<void> getAds({String? accessToken}) async {
    print("CUBIT: getAds called. Current cubit state: ${state.runtimeType}");
    // Always emit loading state to ensure UI can react to subsequent states
    emit(AdsIsLoading());

    // If adsList is empty, fetch them.
    if (adsList.isEmpty) {
      print("CUBIT: adsList is empty, attempting to fetch from use case.");
      final Either<Failure, BaseResponse> response =
          await getAdsUseCase(NoParams());

      response.fold(
        (failure) {
          print("CUBIT: Fetching error: ${failure.message}");
          emit(AdsError(message: failure.message));
        },
        (value) {
          // Assuming value.data.adsData is List<AdsData>
          // Ensure value.data and value.data.adsData are not null and adsData is not empty
          if (value.data != null && value.data.adsData != null && value.data.adsData.isNotEmpty) {
            print("CUBIT: Successfully fetched ${value.data.adsData.length} ads.");
            adsList = List<AdsData>.from(value.data.adsData); // Create a new list
            selectRandomAdAndEmit();
          } else {
            print("CUBIT: Fetched data is null, or adsData is null/empty. API Message: ${value.message}");
            // Emit AdsLoaded with ad: null, so UI can handle closing.
            emit(AdsLoaded(ad: null));
          }
        },
      );
    } else {
      // Ads are already in adsList, just re-select and emit.
      print("CUBIT: adsList is not empty (${adsList.length} ads), re-selecting a random ad.");
      selectRandomAdAndEmit();
    }
  }

  // Helper method to select an ad and emit the AdsLoaded state
  void selectRandomAdAndEmit() {
    if (adsList.isNotEmpty) {
      final randomIndex = Random().nextInt(adsList.length);
      currentAd = adsList[randomIndex];
      print("CUBIT: Selected ad with link: ${currentAd?.link}. Emitting AdsLoaded.");
      emit(AdsLoaded(ad: currentAd));
    } else {
      currentAd = null;
      print("CUBIT: No ads in list to select. Emitting AdsLoaded with null ad.");
      // This case means adsList was empty. UI should handle AdsLoaded(ad: null) by closing.
      emit(AdsLoaded(ad: null));
    }
  }

  // Optional: A method to completely reset the ads if needed for specific scenarios
  void clearAdsCacheAndReset() {
    print("CUBIT: Clearing ads cache and resetting state to AdsInitial.");
    adsList = [];
    currentAd = null;
    emit(AdsInitial());
  }
}