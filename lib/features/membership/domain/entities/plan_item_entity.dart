import 'package:equatable/equatable.dart';

class PlanDataItemEntity extends Equatable {
  final int? id;
  final String? title;
  final String? price;
  final String? description;
  final String? roleId;
  final String? active;
  final String? trial;
  final dynamic trialPeriod;
  final String? trialPeriodFormat;
  final String? planPeriod;
  final String? planPeriodFormat;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? currency;
  final String? currencySymbol;
  final int? remainingSDys;

  const PlanDataItemEntity({
    this.id,
    this.title,
    this.price,
    this.description,
    this.roleId,
    this.active,
    this.trial,
    this.trialPeriod,
    this.trialPeriodFormat,
    this.planPeriod,
    this.planPeriodFormat,
    this.createdAt,
    this.updatedAt,
    this.currency,
    this.currencySymbol,
    this.remainingSDys,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
        id,
        title,
        description,
        roleId,
        active,
        trial,
        trialPeriod,
        trialPeriodFormat,
        planPeriod,
        planPeriodFormat,
        createdAt,
        updatedAt,
        currency,
        remainingSDys,
        currencySymbol,
      ];
}
