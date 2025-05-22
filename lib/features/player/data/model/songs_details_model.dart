import 'dart:convert';

SongsDetailsModel songsDetailsModelFromJson(String str) =>
    SongsDetailsModel.fromJson(json.decode(str));
String songsDetailsModelToJson(SongsDetailsModel data) =>
    json.encode(data.toJson());

class SongsDetailsModel {
  SongsDetailsModel({
    this.message,
    this.data,
  });

  SongsDetailsModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  String? message;
  Data? data;
  SongsDetailsModel copyWith({
    String? message,
    Data? data,
  }) =>
      SongsDetailsModel(
        message: message ?? this.message,
        data: data ?? this.data,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = message;
    if (data != null) {
      map['data'] = data?.toJson();
    }
    return map;
  }
}

Data dataFromJson(String str) => Data.fromJson(json.decode(str));
String dataToJson(Data data) => json.encode(data.toJson());

class Data {
  Data({
    this.id,
    this.saleImpression,
    this.streamImpression,
    this.mp3,
    this.waveform,
    this.preview,
    this.wav,
    this.flac,
    this.hd,
    this.hls,
    this.explicit,
    this.selling,
    this.title,
    this.duration,
    this.loves,
    this.collectors,
    this.plays,
    this.releasedAt,
    this.allowDownload,
    this.downloadCount,
    this.allowComments,
    this.commentCount,
    this.visibility,
    this.approved,
    this.pending,
    this.createdAt,
    this.updatedAt,
    this.artworkUrl,
    this.artists,
    this.permalinkUrl,
    this.streamUrl,
    this.favorite,
    this.library,
    this.streamable,
    this.allowHighQualityDownload,
  });

  Data.fromJson(dynamic json) {
    id = json['id'];
    saleImpression = json['sale_impression'];
    streamImpression = json['stream_impression'];
    mp3 = json['mp3'];
    waveform = json['waveform'];
    preview = json['preview'];
    wav = json['wav'];
    flac = json['flac'];
    hd = json['hd'];
    hls = json['hls'];
    explicit = json['explicit'];
    selling = json['selling'];
    title = json['title'];
    duration = json['duration'];
    loves = json['loves'];
    collectors = json['collectors'];
    plays = json['plays'];
    releasedAt = json['released_at'];
    allowDownload = json['allow_download'];
    downloadCount = json['download_count'];
    allowComments = json['allow_comments'];
    commentCount = json['comment_count'];
    visibility = json['visibility'];
    approved = json['approved'];
    pending = json['pending'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    artworkUrl = json['artwork_url'];
    if (json['artists'] != null) {
      artists = [];
      json['artists'].forEach((v) {
        artists?.add(Artists.fromJson(v));
      });
    }
    permalinkUrl = json['permalink_url'];
    streamUrl = json['stream_url'];
    favorite = json['favorite'];
    library = json['library'];
    streamable = json['streamable'];
    allowHighQualityDownload = json['allow_high_quality_download'];
  }
  int? id;
  String? saleImpression;
  String? streamImpression;
  String? mp3;
  String? waveform;
  String? preview;
  String? wav;
  String? flac;
  String? hd;
  String? hls;
  String? explicit;
  String? selling;
  String? title;
  String? duration;
  String? loves;
  String? collectors;
  String? plays;
  String? releasedAt;
  bool? allowDownload;
  String? downloadCount;
  String? allowComments;
  String? commentCount;
  String? visibility;
  String? approved;
  String? pending;
  String? createdAt;
  String? updatedAt;
  String? artworkUrl;
  List<Artists>? artists;
  String? permalinkUrl;
  String? streamUrl;
  bool? favorite;
  bool? library;
  bool? streamable;
  bool? allowHighQualityDownload;
  Data copyWith({
    int? id,
    String? saleImpression,
    String? streamImpression,
    String? mp3,
    String? waveform,
    String? preview,
    String? wav,
    String? flac,
    String? hd,
    String? hls,
    String? explicit,
    String? selling,
    String? title,
    String? duration,
    String? loves,
    String? collectors,
    String? plays,
    String? releasedAt,
    bool? allowDownload,
    String? downloadCount,
    String? allowComments,
    String? commentCount,
    String? visibility,
    String? approved,
    String? pending,
    String? createdAt,
    String? updatedAt,
    String? artworkUrl,
    List<Artists>? artists,
    String? permalinkUrl,
    String? streamUrl,
    bool? favorite,
    bool? library,
    bool? streamable,
    bool? allowHighQualityDownload,
  }) =>
      Data(
        id: id ?? this.id,
        saleImpression: saleImpression ?? this.saleImpression,
        streamImpression: streamImpression ?? this.streamImpression,
        mp3: mp3 ?? this.mp3,
        waveform: waveform ?? this.waveform,
        preview: preview ?? this.preview,
        wav: wav ?? this.wav,
        flac: flac ?? this.flac,
        hd: hd ?? this.hd,
        hls: hls ?? this.hls,
        explicit: explicit ?? this.explicit,
        selling: selling ?? this.selling,
        title: title ?? this.title,
        duration: duration ?? this.duration,
        loves: loves ?? this.loves,
        collectors: collectors ?? this.collectors,
        plays: plays ?? this.plays,
        releasedAt: releasedAt ?? this.releasedAt,
        allowDownload: allowDownload ?? this.allowDownload,
        downloadCount: downloadCount ?? this.downloadCount,
        allowComments: allowComments ?? this.allowComments,
        commentCount: commentCount ?? this.commentCount,
        visibility: visibility ?? this.visibility,
        approved: approved ?? this.approved,
        pending: pending ?? this.pending,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        artworkUrl: artworkUrl ?? this.artworkUrl,
        artists: artists ?? this.artists,
        permalinkUrl: permalinkUrl ?? this.permalinkUrl,
        streamUrl: streamUrl ?? this.streamUrl,
        favorite: favorite ?? this.favorite,
        library: library ?? this.library,
        streamable: streamable ?? this.streamable,
        allowHighQualityDownload:
            allowHighQualityDownload ?? this.allowHighQualityDownload,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['sale_impression'] = saleImpression;
    map['stream_impression'] = streamImpression;
    map['mp3'] = mp3;
    map['waveform'] = waveform;
    map['preview'] = preview;
    map['wav'] = wav;
    map['flac'] = flac;
    map['hd'] = hd;
    map['hls'] = hls;
    map['explicit'] = explicit;
    map['selling'] = selling;
    map['title'] = title;
    map['duration'] = duration;
    map['loves'] = loves;
    map['collectors'] = collectors;
    map['plays'] = plays;
    map['released_at'] = releasedAt;
    map['allow_download'] = allowDownload;
    map['download_count'] = downloadCount;
    map['allow_comments'] = allowComments;
    map['comment_count'] = commentCount;
    map['visibility'] = visibility;
    map['approved'] = approved;
    map['pending'] = pending;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    map['artwork_url'] = artworkUrl;
    if (artists != null) {
      map['artists'] = artists?.map((v) => v.toJson()).toList();
    }
    map['permalink_url'] = permalinkUrl;
    map['stream_url'] = streamUrl;
    map['favorite'] = favorite;
    map['library'] = library;
    map['streamable'] = streamable;
    map['allow_high_quality_download'] = allowHighQualityDownload;
    return map;
  }
}

Artists artistsFromJson(String str) => Artists.fromJson(json.decode(str));
String artistsToJson(Artists data) => json.encode(data.toJson());

class Artists {
  Artists({
    this.id,
    this.impression,
    this.name,
    this.loves,
    this.allowComments,
    this.commentCount,
    this.verified,
    this.artworkUrl,
    this.favorite,
    this.permalinkUrl,
  });

  Artists.fromJson(dynamic json) {
    id = json['id'];
    impression = json['impression'];
    name = json['name'];
    loves = json['loves'];
    allowComments = json['allow_comments'];
    commentCount = json['comment_count'];
    verified = json['verified'];
    artworkUrl = json['artwork_url'];
    favorite = json['favorite'];
    permalinkUrl = json['permalink_url'];
  }
  int? id;
  String? impression;
  String? name;
  String? loves;
  String? allowComments;
  String? commentCount;
  String? verified;
  String? artworkUrl;
  bool? favorite;
  String? permalinkUrl;
  Artists copyWith({
    int? id,
    String? impression,
    String? name,
    String? loves,
    String? allowComments,
    String? commentCount,
    String? verified,
    String? artworkUrl,
    bool? favorite,
    String? permalinkUrl,
  }) =>
      Artists(
        id: id ?? this.id,
        impression: impression ?? this.impression,
        name: name ?? this.name,
        loves: loves ?? this.loves,
        allowComments: allowComments ?? this.allowComments,
        commentCount: commentCount ?? this.commentCount,
        verified: verified ?? this.verified,
        artworkUrl: artworkUrl ?? this.artworkUrl,
        favorite: favorite ?? this.favorite,
        permalinkUrl: permalinkUrl ?? this.permalinkUrl,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['impression'] = impression;
    map['name'] = name;
    map['loves'] = loves;
    map['allow_comments'] = allowComments;
    map['comment_count'] = commentCount;
    map['verified'] = verified;
    map['artwork_url'] = artworkUrl;
    map['favorite'] = favorite;
    map['permalink_url'] = permalinkUrl;
    return map;
  }
}
