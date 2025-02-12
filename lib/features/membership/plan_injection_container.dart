import 'package:alamoody/features/membership/data/datasources/plan_remote_datasource.dart';
import 'package:alamoody/features/membership/data/repositories/plan_repository.dart';
import 'package:alamoody/features/membership/domain/repositories/plan_details_repository.dart';
import 'package:alamoody/features/membership/domain/usecases/get_paln_usecase.dart';
import 'package:alamoody/features/membership/domain/usecases/subscribe_to_plan_usecase.dart';
import 'package:alamoody/features/membership/domain/usecases/unsubscribe_plan_usecase.dart';
import 'package:alamoody/features/membership/presentation/cubit/coupon_cubit/coupon_cubit.dart';
import 'package:alamoody/features/membership/presentation/cubit/plan_cubit.dart';
import 'package:alamoody/features/membership/presentation/cubit/unsubscribe_plan_cubit/unsubscribe_plan_cubit.dart';

import '../../injection_container.dart';
import 'domain/usecases/coupon_code.dart';
import 'domain/usecases/direct_subscribe_to_plan_usecase.dart';

void initPlanFeature() {
// Blocs
  sl.registerFactory<UnsubscribePlanCubit>(
    () => UnsubscribePlanCubit(
      unsubscribePlanUseCase: sl(),
    ),
  );
  sl.registerFactory<PlanCubit>(
    () => PlanCubit(
      subscribeToPlanUseCase: sl(),
      getPlanUseCase: sl(),
      directsubscribeToPlanUseCase: sl(),
    ),
  );
  sl.registerFactory<CouponCubit>(
    () => CouponCubit(
      couponCodeUseCase: sl(),
    ),
  );
  // Use cases
  sl.registerLazySingleton<GetPlanUseCase>(
    () => GetPlanUseCase(basePlanRepository: sl()),
  );
  sl.registerLazySingleton<SubscribeToPlanUseCase>(
    () => SubscribeToPlanUseCase(basePlanRepository: sl()),
  );
  sl.registerLazySingleton<DirectSubscribeToPlanUseCase>(
    () => DirectSubscribeToPlanUseCase(basePlanRepository: sl()),
  );
  sl.registerLazySingleton<UnsubscribePlanUseCase>(
    () => UnsubscribePlanUseCase(basePlanRepository: sl()),
  );
  sl.registerLazySingleton<CouponCodeUseCase>(
    () => CouponCodeUseCase(basePlanRepository: sl()),
  );

  // Repository
  sl.registerLazySingleton<BasePlanRepository>(
    () => PlanRepository(sl()),
  );
  // Data sources
  sl.registerLazySingleton<BasePlanRemoteDataSource>(
    () => PlanRemoteDataSource(apiConsumer: sl()),
  );
}
