
import 'package:alamoody/features/radio/data/repositories/radio_repository_impl.dart';

import '../../injection_container.dart';
import 'data/datasources/radio_remote_data_source.dart';
import 'domain/repositories/radio_repository.dart';
import 'domain/usecases/get_radio.dart';
import 'domain/usecases/get_radio_categories.dart';
import 'presentation/cubits/radio/radio_cubit.dart';
import 'presentation/cubits/radio_category/radio_category_cubit.dart';

void initaRadioFeature() {
// Blocs
  sl.registerFactory<RadioCubit>(
    () => RadioCubit(radioUseCase: sl()),
  );

  sl.registerFactory<RadioCategoryCubit>(
    () => RadioCategoryCubit(radioCategoryUseCase: sl()),
  );

  // Use cases
  sl.registerLazySingleton<GetRadio>(
    () => GetRadio(radioRepository: sl()),
  );
  sl.registerLazySingleton<GetRadioCategories>(
    () => GetRadioCategories(radioCategoriesRepository: sl()),
  );

  // Repository
  sl.registerLazySingleton<RadioRepository>(
    () => RadioRepositoryImpl(radioRemoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<RadioRemoteDataSource>(
    () => RadioRemoteDataSourceImpl(apiConsumer: sl()),
  );
}
