import 'package:alamoody/features/contact_us/data/datasources/contact_us_remote_datasource.dart';
import 'package:alamoody/features/contact_us/data/repositories/contact_us_repository.dart';
import 'package:alamoody/features/contact_us/domain/repositories/base_contact_us_repository.dart';
import 'package:alamoody/features/contact_us/domain/usecases/send_form_usecase.dart';
import 'package:alamoody/features/contact_us/presentation/cubit/contact_us_cubit.dart';

import '../../injection_container.dart';

void initLikedProjectsFeature() {
// Blocs
  sl.registerFactory<ContactUsCubit>(
    () => ContactUsCubit(likedProjectsUseCase: sl()),
  );
  // Use cases
  sl.registerLazySingleton<ContactUsUseCase>(
    () => ContactUsUseCase(sl()),
  );

  // Repository
  sl.registerLazySingleton<BaseContactUsRepository>(
    () => LikedProjectsRepository(sl()),
  );
  // Data sources
  sl.registerLazySingleton<BaseContactUsRemoteDataSource>(
    () => ContactUsRemoteDataSource(apiConsumer: sl()),
  );
}
