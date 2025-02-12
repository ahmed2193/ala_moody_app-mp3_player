import 'package:alamoody/features/notification/domain/usecases/change_notification_status_usecase.dart';

import '../../injection_container.dart';
import 'data/datasources/notification_remote_data_source.dart';
import 'data/repositories/notification_repository_impl.dart';
import 'domain/repositories/notification_repository.dart';
import 'domain/usecases/get_notification.dart';
import 'presentation/cubits/get_notification/get_notification_cubit.dart';

void initaNotificationsFeature() {
// Blocs

  sl.registerFactory<GetNotificationCubit>(
    () => GetNotificationCubit(
        getNotificationUseCase: sl(), changeNotificationStatusUseCase: sl(),),
  );

  // Use cases

  sl.registerLazySingleton<GetNotification>(
    () => GetNotification(notificationRepository: sl()),
  );
  sl.registerLazySingleton<ChangeNotificationStatusUseCase>(
    () => ChangeNotificationStatusUseCase(baseNotificationsRepository: sl()),
  );

  // Repository
  sl.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(notificationRemoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<NotificationRemoteDataSource>(
    () => NotificationRemoteDataSourceImpl(apiConsumer: sl()),
  );
}
