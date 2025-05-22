import 'package:alamoody/core/api/base_response.dart';
import 'package:alamoody/core/error/failures.dart';
import 'package:alamoody/core/utils/constants.dart';
import 'package:alamoody/features/membership/domain/entities/plan_list_entity.dart';
import 'package:alamoody/features/membership/domain/usecases/get_paln_usecase.dart';
import 'package:alamoody/features/membership/domain/usecases/subscribe_to_plan_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';

import '../../domain/usecases/direct_subscribe_to_plan_usecase.dart';

part 'plan_state.dart';

class PlanCubit extends Cubit<PlanState> {
  PlanCubit({
    required this.getPlanUseCase,
    required this.subscribeToPlanUseCase,
    required this.directsubscribeToPlanUseCase,
  }) : super(PlanInitial());

  final GetPlanUseCase getPlanUseCase;
  final SubscribeToPlanUseCase subscribeToPlanUseCase;
  final DirectSubscribeToPlanUseCase directsubscribeToPlanUseCase;

  /// streams that the UI listens to:
  final BehaviorSubject<String> rxPlanNumber = BehaviorSubject.seeded('');
  final BehaviorSubject<String> rxPlanTitle = BehaviorSubject.seeded('');

  String? _currentlySubscribedPlanId;


  void setInitialSubscriptionState({
    required String? subscribedPlanId,
    required String? subscribedPlanName,
    bool clear =false
  }) {
    _currentlySubscribedPlanId = subscribedPlanId;

    if (rxPlanNumber.value.isEmpty || rxPlanNumber.value == _currentlySubscribedPlanId ||clear) {
      rxPlanNumber.add(subscribedPlanId ?? '');
      rxPlanTitle.add(subscribedPlanName ?? '');
    }

  }

  void selectPlan({
    required String planId,
    required String planTitle,
  }) {
    rxPlanNumber.add(planId);
    rxPlanTitle.add(planTitle);
  }

  @override
  Future<void> close() {
    rxPlanNumber.close();
    rxPlanTitle.close();
    return super.close();
  }

  Future<void> getPlans({
    required String accessToken,
  }) async {
    emit(PlanDataLoading());

    final Either<Failure, BaseResponse> response = await getPlanUseCase(
      GetPlanParams(
        accessToken: accessToken,
      ),
    );
    emit(
      response.fold(
        (failure) =>
            PlanDataError(message: Constants().mapFailureToMsg(failure)),
        (data) {
          return PlanDataSuccess(planData: data.data);
        },
      ),
    );
  }

  Future<void> subscribeToPlans({
    required String accessToken,
    required String planId,
    String? couponCode,
  }) async {
    final Either<Failure, BaseResponse> response = await subscribeToPlanUseCase(
      SubscribeToPlanParams(
        accessToken: accessToken,
        planId: planId,
        couponCode: couponCode,
      ),
    );
    emit(
      response.fold(
        (failure) =>
            PlanDataError(message: Constants().mapFailureToMsg(failure)),
        (data) {
          return PlanSelected(htmlData: data.data.toString());
        },
      ),
    );
  }

  Future<void> directsubscribeToPlans({
    required String accessToken,
    required String planId,
  }) async {
    final Either<Failure, BaseResponse> response =
        await directsubscribeToPlanUseCase(
      DirectSubscribeToPlanParams(
        accessToken: accessToken,
        planId: planId,
      ),
    );
    emit(
      response.fold(
        (failure) =>
            PlanDataError(message: Constants().mapFailureToMsg(failure)),
        (data) {

          getPlans(accessToken: accessToken);
          return const SubPlanSelected(message: 'Subscribed Success To Plan');
        },
      ),
    );
  }
}