import 'package:alamoody/features/membership/domain/entities/plan_list_entity.dart';
import 'package:equatable/equatable.dart';

class PlanEntity extends Equatable {
  final String message;
  final PlanListEntity planListEntity;

  const PlanEntity({
    required this.message,
    required this.planListEntity,
  });

  @override
  List<Object> get props => [
        message,
        planListEntity,
      ];
}
