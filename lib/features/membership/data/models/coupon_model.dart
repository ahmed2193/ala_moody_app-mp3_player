class CouponModel {
  bool? status;
  String? msg;
  Data? data;

  CouponModel({this.status, this.msg, this.data});

  CouponModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    data = (json['data'] != null && json['status'] == true)
        ? Data.fromJson(json['data'])
        : null;
  }


}

class Data {
  int? id;
  String? title;
  var price;
  String? description;
  String? roleId;
  String? active;
  String? trial;
  String? trialPeriod;
  String? trialPeriodFormat;
  String? planPeriod;
  String? planPeriodFormat;
  String? createdAt;
  String? updatedAt;
  var discount;
  var totalPrice;


  Data(
      {this.id,
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
      this.discount,
      this.totalPrice,
     });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    price = json['price'];
    description = json['description'];
    roleId = json['role_id'];
    active = json['active'];
    trial = json['trial'];
    trialPeriod = json['trial_period'];
    trialPeriodFormat = json['trial_period_format'];
    planPeriod = json['plan_period'];
    planPeriodFormat = json['plan_period_format'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    discount = json['discount'];
    totalPrice = json['total_price'];

  }
}


// class CouponModel {
//   int? id;
//   String? title;
//   String? price;
//   String? description;
//   String? roleId;
//   String? active;
//   String? trial;
//   String? trialPeriod;
//   String? trialPeriodFormat;
//   String? planPeriod;
//   String? planPeriodFormat;
//   String? createdAt;
//   String? updatedAt;
//   var discount;
//   var totalPrice;
//   String? couponValue;
//   String? couponType;
//   String? currency;
//   String? currencySymbol;

//   CouponModel(
//       {this.id,
//       this.title,
//       this.price,
//       this.description,
//       this.roleId,
//       this.active,
//       this.trial,
//       this.trialPeriod,
//       this.trialPeriodFormat,
//       this.planPeriod,
//       this.planPeriodFormat,
//       this.createdAt,
//       this.updatedAt,
//       this.discount,
//       this.totalPrice,
//       this.couponValue,
//       this.couponType,
//       this.currency,
//       this.currencySymbol});

//   CouponModel.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     title = json['title'];
//     price = json['price'];
//     description = json['description'];
//     roleId = json['role_id'];
//     active = json['active'];
//     trial = json['trial'];
//     trialPeriod = json['trial_period'];
//     trialPeriodFormat = json['trial_period_format'];
//     planPeriod = json['plan_period'];
//     planPeriodFormat = json['plan_period_format'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//     discount = json['discount'];
//     totalPrice = json['total_price'];
//     couponValue = json['coupon_value'];
//     couponType = json['coupon_type'];
//     currency = json['currency'];
//     currencySymbol = json['currency_symbol'];
//   }
// }
