import 'package:equatable/equatable.dart';

import 'artists.dart';

class Songs extends Equatable {
  final dynamic id;
  final String? saleImpression;
  final String? streamImpression;
  final dynamic mp3;
  final dynamic waveform;
  final dynamic preview;
  final dynamic wav;
  final dynamic flac;
  final dynamic hd;
  final dynamic hls;
  final dynamic explicit;
  final dynamic selling;

  final String? title;
  final dynamic duration;

  final dynamic loves;
  final dynamic collectors;
  final String? releasedAt;
  final dynamic allowDownload;
  final dynamic downloadCount;
  final dynamic allowComments;
  final dynamic commentCount;
  final dynamic visibility;
  final dynamic approved;
  final dynamic pending;
  final String? createdAt;
  final String? updatedAt;
  final String? artworkUrl;
  final List<Artists>? artists;
  final String? permalinkUrl;
  final String? streamUrl;
  final bool? favorite;
  final bool? library;
  final bool? streamable;
  final bool? allowHighQualityDownload;
  final dynamic listened;
  final String? audio;
  final String? extension;
  final String? lyrics;
  final dynamic followerCount;
  final dynamic plays;

  const Songs({
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
    this.audio,
    this.extension,
    this.listened,
    this.lyrics,
    this.followerCount,
  });

  @override
  List<Object?> get props => [
        id,
        saleImpression,
        streamImpression,
        mp3,
        waveform,
        preview,
        wav,
        flac,
        hd,
        hls,
        explicit,
        selling,
        title,
        duration,
        loves,
        collectors,
        plays,
        releasedAt,
        allowDownload,
        downloadCount,
        allowComments,
        commentCount,
        visibility,
        approved,
        pending,
        createdAt,
        updatedAt,
        artworkUrl,
        artists,
        permalinkUrl,
        streamUrl,
        favorite,
        library,
        streamable,
        allowHighQualityDownload,
        artists,
        listened,
        audio,
        extension,
        lyrics,
        followerCount,
      ];
}
