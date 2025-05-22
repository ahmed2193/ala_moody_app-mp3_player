class AdsModel {
  String? status;
  List<AdsData>? adsData;

  AdsModel({this.status, this.adsData});

  AdsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      adsData = <AdsData>[];
      json['data'].forEach((v) {
        adsData!.add(new AdsData.fromJson(v));
      });
    }
  }


}

class AdsData {
  int? id;
  String? image;
  String? link;
  String? fromdate;
  String? todate;
  int? status;
  String? addedBy;
  String? createdAt;
  String? updatedAt;

  AdsData(
      {this.id,
      this.image,
      this.link,
      this.fromdate,
      this.todate,
      this.status,
      this.addedBy,
      this.createdAt,
      this.updatedAt});

  AdsData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    link = json['link'];
    fromdate = json['fromdate'];
    todate = json['todate'];
    status = json['status'];
    addedBy = json['added_by'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    data['link'] = this.link;
    data['fromdate'] = this.fromdate;
    data['todate'] = this.todate;
    data['status'] = this.status;
    data['added_by'] = this.addedBy;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}