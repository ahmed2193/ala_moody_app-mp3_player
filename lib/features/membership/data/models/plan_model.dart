import 'package:alamoody/features/membership/data/models/plan_data_model.dart';
import 'package:alamoody/features/membership/domain/entities/plan_entity.dart';

class PlanModel extends PlanEntity {
  const PlanModel({required super.message, required super.planListEntity});
  factory PlanModel.fromJson(Map<String, dynamic> json) => PlanModel(
        message: json["st"],
        planListEntity: json["data"].map((d) => PlanDataModel.fromJson(d)),
      );
}
