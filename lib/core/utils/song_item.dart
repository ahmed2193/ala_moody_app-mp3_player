import 'package:alamoody/core/helper/images.dart';
import 'package:alamoody/core/utils/controllers/main_controller.dart';
import 'package:alamoody/core/utils/lyrics_screen.dart';
import 'package:alamoody/core/utils/media_query_values.dart';
import 'package:alamoody/core/utils/navigator_reuse.dart';
import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import '../../config/locale/app_localizations.dart';
import '../../features/audio_playlists/presentation/screen/loading.dart';
import '../entities/songs.dart';
import '../helper/font_style.dart';
import 'hex_color.dart';

class SongItem extends StatelessWidget {
  const SongItem({Key? key, required this.songs, required this.menuItem, this.son}) : super(key: key);

  final Songs songs;
  final List<Songs>? son;
  final Widget menuItem;

  @override
  Widget build(BuildContext context) {
    final double imageSize = context.width * 0.10; // Reduced by another 10%

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.width * 0.016, // Further reduced
        vertical: context.height * 0.008,
      ),
      decoration: BoxDecoration(
        border: GradientBoxBorder(
          gradient: LinearGradient(colors: [HexColor("#020024"), HexColor("#090979"), Colors.black26]),
        ),
        borderRadius: BorderRadius.circular(5.5), // Further reduced border radius
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(5.5), // Adjusted
            child: CachedNetworkImage(
              errorWidget: (_, __, ___) => const Icon(Icons.error, size: 18), // Adjusted error icon size
              width: imageSize,
              height: imageSize,
              imageUrl: songs.artworkUrl!,
              memCacheHeight: 135, // Further reduced caching size
              memCacheWidth: 135,
              maxHeightDiskCache: 135,
              maxWidthDiskCache: 135,
              progressIndicatorBuilder: (_, __, ___) => const LoadingImage(),
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: context.width * 0.016), // Further reduced spacing
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    AudioWave(song: songs),
                    Expanded(
                      child: Text(
                        songs.title!,
                        style: styleW700(context, fontSize: 12), // Further reduced font size
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                if (songs.lyrics!.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(top: context.height * 0.0055),
                    child: GestureDetector(
                      onTap: () => pushNavigate(context, LyricsScreen(songs: songs)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: HexColor('#D9D9D9'),
                              borderRadius: BorderRadius.circular(4.8), // Further reduced
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 4.8, vertical: 1.2),
                            child: Text(
                              AppLocalizations.of(context)!.translate('lyrics')!,
                              style: styleW400(context, color: Colors.black, fontSize: 6.5), // Further reduced
                            ),
                          ),
                          Text(
                            songs.artists![0].name!,
                            style: styleW400(context, fontSize: 11), // Further reduced font size
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          menuItem,
        ],
      ),
    );
  }
}

class AudioWave extends StatelessWidget {
  const AudioWave({super.key, required this.song});
  final Songs song;

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<MainController>(context, listen: false);

    return StreamBuilder<PlayerState>(
      stream: controller.player.playerStateStream,
      builder: (context, snapshot) {
        final state = snapshot.data;
        if (state == null || !state.playing || state.processingState != ProcessingState.ready) {
          return const SizedBox.shrink();
        }

        final index = controller.currentIndex;
        if (index == null || index < 0 || index >= controller.audios.length) {
          return const SizedBox.shrink();
        }

        final currentAudio = controller.audios[index];
        if (currentAudio is! UriAudioSource) return const SizedBox.shrink();

        final mediaItem = currentAudio.tag as MediaItem;
        return (mediaItem.id == song.id.toString() && mediaItem.title == song.title)
            ? Image.asset(ImagesPath.audioWave, scale: 4.8) // Further reduced scale
            : const SizedBox.shrink();
      },
    );
  }
}
