import '../../injection_container.dart';
import 'data/datasources/search_remote_data_source.dart';
import 'data/repositories/category_repository_impl.dart';
import 'domain/repositories/search_repository.dart';
import 'domain/usecases/get_category.dart';
import 'domain/usecases/search.dart';
import 'presentation/cubits/category/category_cubit.dart';
import 'presentation/cubits/search/search_cubit.dart';

void initaSearchFeature() {
// Blocs

  sl.registerFactory<CategoryCubit>(
    () => CategoryCubit(getCategoryUseCase: sl()),
  );
  sl.registerFactory<SearchCubit>(
    () => SearchCubit(searchUseCase: sl()),
  );

  // Use cases

  sl.registerLazySingleton<GetCategory>(
    () => GetCategory(searchRepository: sl()),
  );
  sl.registerLazySingleton<Search>(
    () => Search(searchRepository: sl()),
  );

  // Repository
  sl.registerLazySingleton<SearchRepository>(
    () => SearchRepositoryImpl(searchRemoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<SearchRemoteDataSource>(
    () => SearchRemoteDataSourceImpl(apiConsumer: sl()),
  );
}
