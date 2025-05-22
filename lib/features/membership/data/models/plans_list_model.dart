import 'package:alamoody/features/membership/data/models/plan_data_model.dart';
import 'package:alamoody/features/membership/domain/entities/plan_list_entity.dart';

class PlanListModel extends PlanListEntity {
  const PlanListModel({
    required super.monthly,
    required super.others,
    required super.yearly,
    required super.current,
  });
  factory PlanListModel.fromJson(Map<String, dynamic> json) => PlanListModel(
        monthly: json["monthly"] == null
            ? []
            : List<PlanDataModel>.from(
                json["monthly"]!.map((x) => PlanDataModel.fromJson(x)),
              ),
        others: json["others"] == null
            ? []
            : List<PlanDataModel>.from(
                json["others"]!.map((x) => PlanDataModel.fromJson(x)),
              ),
        yearly: json["yearly"] == null
            ? []
            : List<PlanDataModel>.from(
                json["yearly"]!.map((x) => PlanDataModel.fromJson(x)),
              ),
        current: json['current'] != null
            ? PlanDataModel.fromJson(json['current'])
            : null,
      );
}
