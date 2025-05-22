import '../../injection_container.dart';
import 'data/datasources/library_remote_data_source.dart';
import 'data/repositories/library_repository_impl.dart';
import 'domain/repositories/library_repository.dart';
import 'domain/usecases/get_library.dart';
import 'presentation/cubits/library/library_cubit.dart';

void initaLibraryFeature() {
// Blocs

  sl.registerFactory<LibraryCubit>(
    () => LibraryCubit(getLibraryUseCase: sl()),
  );

  // Use cases

  sl.registerLazySingleton<GetLibrary>(
    () => GetLibrary(libraryRepository: sl()),
  );

  // Repository
  sl.registerLazySingleton<LibraryRepository>(
    () => LibraryRepositoryImpl(libraryRemoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<LibraryRemoteDataSource>(
    () => LibraryRemoteDataSourceImpl(apiConsumer: sl()),
  );
}
