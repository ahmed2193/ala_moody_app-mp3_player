import 'package:alamoody/features/membership/domain/entities/plan_item_entity.dart';

class PlanDataModel extends PlanDataItemEntity {
  const PlanDataModel({
    required super.id,
    required super.title,
    required super.price,
    required super.description,
    required super.roleId,
    required super.active,
    required super.trial,
    required super.trialPeriod,
    required super.trialPeriodFormat,
    required super.planPeriod,
    required super.planPeriodFormat,
    required super.createdAt,
    required super.updatedAt,
    required super.currency,
    required super.currencySymbol,
    required super.remainingSDys,
  });
  factory PlanDataModel.fromJson(Map<String, dynamic> json) => PlanDataModel(
      id: json["id"],
      title: json["title"],
      price: json["price"],
      description: json["description"],
      roleId: json["role_id"],
      active: json["active"],
      trial: json["trial"],
      trialPeriod: json["trial_period"],
      trialPeriodFormat: json["trial_period_format"],
      planPeriod: json["plan_period"],
      planPeriodFormat: json["plan_period_format"],
      createdAt: DateTime.parse(json["created_at"]),
      updatedAt: DateTime.parse(json["updated_at"]),
      currency: json["currency"],
      currencySymbol: json["currency_symbol"],
      remainingSDys:
          json["remaining_days"] ?? 0,);
}
