import 'package:alamoody/features/membership/domain/entities/plan_item_entity.dart';
import 'package:equatable/equatable.dart';

class PlanListEntity extends Equatable {
  final List<PlanDataItemEntity>? yearly;
  final List<PlanDataItemEntity>? monthly;
  final List<PlanDataItemEntity>? others;
  final PlanDataItemEntity? current;

  const PlanListEntity({
    this.yearly,
    this.monthly,
    this.others,
    this.current,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
        yearly,
        monthly,
        others,
        current,
      ];
}
