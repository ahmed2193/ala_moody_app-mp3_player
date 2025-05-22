


import 'package:alamoody/features/ads/data/datasources/ads_remote_data_source.dart';
import 'package:alamoody/features/ads/data/repositories/ads_repository_impl.dart';
import 'package:alamoody/features/ads/domain/repositories/ads_repository.dart';
import 'package:alamoody/features/ads/domain/usecases/get_ads.dart';
import 'package:alamoody/features/ads/presentation/cubits/ads_cubit.dart';

import '../../injection_container.dart';

void initaAdsFeature() {
// Blocs

  sl.registerFactory<AdsCubit>(
    () => AdsCubit(getAdsUseCase: sl()),
  );

  // Use cases

  sl.registerLazySingleton<GetAds>(
    () => GetAds(adsRepository: sl()),
  );

  // Repository
  sl.registerLazySingleton<AdsRepository>(
    () => AdsRepositoryImpl(adsRemoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<AdsRemoteDataSource>(
    () => AdsRemoteDataSourceImpl(apiConsumer: sl()),
  );
}
