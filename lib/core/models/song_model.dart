import '../entities/songs.dart';
import 'artists_model.dart';

class SongModel extends Songs {
  const SongModel({
     super.id,
     super.saleImpression,
     super.streamImpression,
     super.mp3,
     super.waveform,
     super.preview,
     super.wav,
     super.flac,
     super.hd,
     super.hls,
     super.explicit,
     super.selling,
     super.title,
     super.duration,
     super.loves,
     super.collectors,
     super.plays,
     super.releasedAt,
     super.allowDownload,
     super.downloadCount,
     super.allowComments,
     super.commentCount,
     super.visibility,
     super.approved,
     super.pending,
     super.createdAt,
     super.updatedAt,
     super.artworkUrl,
     super.artists,
     super.permalinkUrl,
     super.streamUrl,
     super.favorite,
     super.library,
     super.streamable,
     super.allowHighQualityDownload,
     super.listened,
     super.audio,
     super.extension,
     super.lyrics,
     super.followerCount,
  });

  factory SongModel.fromJson(Map<String, dynamic> json) => SongModel(
        id: json['id'] ?? 0,
        saleImpression: json['sale_impression'] ?? '',
        streamImpression: json['stream_impression'] ?? '',
        mp3: json['mp3'] ?? '',
        waveform: json['waveform'] ?? '',
        preview: json['preview'] ?? '',
        wav: json['wav'] ?? '',
        flac: json['flac'] ?? '',
        hd: json['hd'] ?? '',
        hls: json['hls'] ?? '',
        explicit: json['explicit'] ?? false,
        selling: json['selling'] ?? false,
        title: json['title'] ?? 'Unknown Title',
        duration: json['duration'] ?? 0,
        loves: json['loves'] ?? 0,
        collectors: json['collectors'] ?? 0,
        plays: json['plays'] ?? 0,
        releasedAt: json['released_at'] ?? '',
        allowDownload: json['allow_download'] ?? false,
        downloadCount: json['download_count'] ?? 0,
        allowComments: json['allow_comments'] ?? false,
        commentCount: json['comment_count'] ?? 0,
        visibility: json['visibility'] ?? 'public',
        approved: json['approved'] ?? false,
        pending: json['pending'] ?? false,
        createdAt: json['created_at'] ?? '',
        updatedAt: json['updated_at'] ?? '',
        artworkUrl: json['artwork_url'] ?? '',
        permalinkUrl: json['permalink_url'] ?? '',
        streamUrl: json['audio'] ?? '',
        favorite: json['favorite'] ?? false,
        library: json['library'] ?? false,
        streamable: json['streamable'] ?? false,
        listened: json['listened'] ?? 0,
        extension: json['extension'] ?? '',
        audio: json['audio'] ?? '',
        lyrics: json['lyrics'] ?? '',
        followerCount: json['follower_count'] ?? 0,
        allowHighQualityDownload: json['allow_high_quality_download'] ?? false,
        artists: json["artists"] == null
            ? []
            : List<ArtistsModel>.from(json["artists"].map((x) => ArtistsModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['sale_impression'] = saleImpression;
    data['stream_impression'] = streamImpression;
    data['mp3'] = mp3;
    data['waveform'] = waveform;
    data['preview'] = preview;
    data['wav'] = wav;
    data['flac'] = flac;
    data['hd'] = hd;
    data['hls'] = hls;
    data['explicit'] = explicit;
    data['selling'] = selling;

    data['title'] = title;
    data['duration'] = duration;

    data['loves'] = loves;
    data['collectors'] = collectors;
    data['plays'] = plays;
    data['released_at'] = releasedAt;
    data['allow_download'] = allowDownload;
    data['download_count'] = downloadCount;
    data['allow_comments'] = allowComments;
    data['comment_count'] = commentCount;
    data['visibility'] = visibility;
    data['approved'] = approved;
    data['pending'] = pending;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['artwork_url'] = artworkUrl;

    data['permalink_url'] = permalinkUrl;
    data['stream_url'] = streamUrl;
    data['favorite'] = favorite;
    data['library'] = library;
    data['streamable'] = streamable;
    data['allow_high_quality_download'] = allowHighQualityDownload;
    data['audio'] = audio;
    data['listened'] = listened;
    data['extension'] = extension;
    data['lyrics'] = lyrics;
    return data;
  }
}
