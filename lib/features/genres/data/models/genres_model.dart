class OccasionsModel {
  int? id;
  int? parentId;
  int? priority;
  String? name;
  String? altName;
  int? discover;
  String? type;
  String? occasionDate;
  String? artworkUrl;
  String? permalinkUrl;

  OccasionsModel(
      {this.id,
      this.parentId,
      this.priority,
      this.name,
      this.altName,
      this.discover,
      this.type,
      this.occasionDate,
      this.artworkUrl,
      this.permalinkUrl,});

  OccasionsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    parentId = json['parent_id'];
    priority = json['priority'];
    name = json['name'];
    altName = json['alt_name'];
    discover = json['discover'];
    type = json['type'];
    occasionDate = json['occasion_date'];
    artworkUrl = json['artwork_url'];
    permalinkUrl = json['permalink_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['parent_id'] = parentId;
    data['priority'] = priority;
    data['name'] = name;
    data['alt_name'] = altName;
    data['discover'] = discover;
    data['type'] = type;
    data['occasion_date'] = occasionDate;
    data['artwork_url'] = artworkUrl;
    data['permalink_url'] = permalinkUrl;
    return data;
  }
}