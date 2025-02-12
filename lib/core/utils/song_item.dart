
import 'package:alamoody/core/helper/images.dart';
import 'package:alamoody/core/utils/controllers/main_controller.dart';
import 'package:alamoody/core/utils/lyrics_screen.dart';
//import 'package:flutter_screenutil/flutter_screenutil.dart';

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
  const SongItem({
    Key? key,
    required this.songs,
    required this.menuItem,
    this.son,
  }) : super(key: key);

  final Songs songs;
  final List<Songs>? son;
  final Widget menuItem;

  @override
  Widget build(BuildContext context) {
    final devicePexelRatio = MediaQuery.of(context).devicePixelRatio;
    final double logicalSize = 140 / devicePexelRatio;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        border: GradientBoxBorder(
          gradient: LinearGradient(
            colors: [
              HexColor("#020024"),
              HexColor("#090979"),
              Colors.black26,
            ],
          ),
          width: 2.4,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              errorWidget: (context, url, error) => const Icon(Icons.error),
              width: logicalSize,
              height: logicalSize,
              imageUrl: songs.artworkUrl!,
              memCacheHeight: (300 * devicePexelRatio).round(),
              memCacheWidth: (300 * devicePexelRatio).round(),
              maxHeightDiskCache: (300 * devicePexelRatio).round(),
              maxWidthDiskCache: (300 * devicePexelRatio).round(),
              progressIndicatorBuilder: (context, url, l) =>
                  const LoadingImage(),
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: context.height * 0.012),
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    AudioWave(
                      song: songs,
                    ),
                    Expanded(
                      child: Text(
                        songs.title!,
                        style: styleW700(context),
                        overflow: TextOverflow.clip,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: context.height * 0.0145),
                if (songs.lyrics!.isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      pushNavigate(
                        context,
                        LyricsScreen(songs: songs),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: HexColor('#D9D9D9'),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8)),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          child: Text(
                            AppLocalizations.of(context)!.translate('lyrics')!,
                            style: styleW400(
                              context,
                              color: Colors.black,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Text(
                          songs.artists![0].name!,
                          style: styleW400(context),
                        ),
                        const SizedBox(),
                      ],
                    ),
                  )
                else
                  const SizedBox(),
              ],
            ),
          ),
          const Spacer(),
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
    final controller = Provider.of<MainController>(context);
    final isPlaying = controller.isPlaying;

    // Using StreamBuilder to listen to the current audio playing stream
    return StreamBuilder<SequenceState?>(
      stream: controller.player!.sequenceStateStream,
      builder: (context, snapshot) {
        final state = snapshot.data;
        if (state?.sequence.isEmpty ?? true) {
          return const SizedBox();
        }
        final metadata = state!.currentSource!.tag as MediaItem;
        final currentSource = state.currentSource;

        final isRadioStream = currentSource is UriAudioSource &&
            currentSource.uri.toString().contains('stream');
        return isRadioStream?SizedBox.shrink():  StreamBuilder<PlayerState>(
          stream: controller.player!.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            final isPlaying = playerState?.playing ?? false;
            final currentIndex = controller.currentIndex;
           
            if (controller.audios.isEmpty) {
              return const Center(child: SizedBox());
            }
        
            final currentAudioSource =
                currentIndex != null && currentIndex < controller.audios.length
                    ? controller.audios[currentIndex]
                    : null;
            MediaItem? currentMediaItem;
        
            if (currentAudioSource is UriAudioSource) {
              currentMediaItem = currentAudioSource.tag as MediaItem?;
            }
            if (snapshot.connectionState == ConnectionState.active &&
                snapshot.hasData) {
              final currentAudio = snapshot.data;
        
              // Access the metadata of the current audio
              if (controller.isPlaying &&
                  currentMediaItem != null &&
                  currentMediaItem.id == song.id.toString()&&song.title==currentMediaItem.title) {
                return Image.asset(
                  ImagesPath.audioWave,
                  scale: 3.5,
                );
              }
            }
        
            // Return empty widget if no match or not playing
            return const SizedBox.shrink();
          },
        );
      },
    );
  }
}




// import 'package:alamoody/core/helper/images.dart';
// import 'package:alamoody/core/utils/controllers/main_controller_test.dart';
// import 'package:alamoody/core/utils/lyrics_screen.dart';
// //import 'package:flutter_screenutil/flutter_screenutil.dart';

// import 'package:alamoody/core/utils/media_query_values.dart';
// import 'package:alamoody/core/utils/navigator_reuse.dart';
//   
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:gradient_borders/gradient_borders.dart';
// import 'package:provider/provider.dart';

// import '../../config/locale/app_localizations.dart';
// import '../../features/audio_playlists/presentation/screen/loading.dart';
// import '../entities/songs.dart';
// import '../helper/font_style.dart';
// import 'controllers/main_controller.dart';
// import 'hex_color.dart';

// class SongItem extends StatelessWidget {
//   const SongItem({
//     Key? key,
//     required this.songs,
//     required this.con,
//     required this.menuItem,
//     this.son,
//   }) : super(key: key);

//   final Songs songs;
//   final List<Songs>? son;
//   final MainController con;
//   final Widget menuItem;

//   @override
//   Widget build(BuildContext context) {
//     final devicePexelRatio = MediaQuery.of(context).devicePixelRatio;

  
//     double logicalSize = 140 / devicePexelRatio;
//     return Container(
//       padding: const EdgeInsets.symmetric(
//         horizontal: 12,
//         vertical: 10,
//       ),
//       decoration: BoxDecoration(
//         border: GradientBoxBorder(
//           gradient: LinearGradient(
//             colors: [
//               HexColor("#020024"),
//               HexColor("#090979"),
//               Colors.black26,
//             ],
//           ),
//           width: 2.4,
//         ),
//         gradient: const LinearGradient(
//           end: Alignment(1, 2),
//           colors: [
//             Colors.transparent,
//             Colors.transparent,
//             Colors.transparent,
//             // HexColor("#020024"),
//             // HexColor("#090979"),
//             // Colors.black26,
//           ],
//         ),
//         borderRadius: const BorderRadius.all(
//           Radius.circular(10),
//         ),
//       ),
//       child: Row(
//         children: [
//           ClipRRect(
//             borderRadius: BorderRadius.circular(10),
//             child: CachedNetworkImage(
//               errorWidget: (context, url, error) => const Icon(Icons.error),
//               width: logicalSize,
//               height: logicalSize,
//               imageUrl: songs.artworkUrl!,
//               memCacheHeight: (300 * devicePexelRatio).round(),
//               memCacheWidth: (300 * devicePexelRatio).round(),
//               maxHeightDiskCache: (300 * devicePexelRatio).round(),
//               maxWidthDiskCache: (300 * devicePexelRatio).round(),
//               progressIndicatorBuilder: (context, url, l) =>
//                   const LoadingImage(),
//               fit: BoxFit.cover,
//             ),
//           ),
//           SizedBox(
//             width: context.height * 0.012,
//           ),
//           Expanded(
//             flex: 2,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     AudioWave(
//                       con: con,
//                       song: songs,
//                     ),
//                     Expanded(
//                       child: Text(
//                         songs.title!,
//                         style: styleW700(context),
//                         overflow: TextOverflow.clip,
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(
//                   height: context.height * 0.0145,
//                 ),
//                 if (songs.lyrics!.isNotEmpty)
//                   GestureDetector(
//                     onTap: () {
//                       pushNavigate(
//                         context,
//                         LyricsScreen(
//                           songs: songs,
//                         ),
//                       );
//                     },
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Container(
//                           decoration: BoxDecoration(
//                             color: HexColor('#D9D9D9'),
//                             borderRadius:
//                                 const BorderRadius.all(Radius.circular(8)),
//                           ),
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 8,
//                             vertical: 2,
//                           ),
//                           child: Text(
//                             AppLocalizations.of(context)!.translate('lyrics')!,
//                             style: styleW400(
//                               context,
//                               color: Colors.black,
//                               fontSize: 12,
//                             ),
//                           ),
//                         ),
//                         Text(
//                           songs.artists![0].name!,
//                           style: styleW400(
//                             context,
//                           ),
//                         ),
//                         const SizedBox(),
//                       ],
//                     ),
//                   )
//                 else
//                   const SizedBox(),
//               ],
//             ),
//           ),
//           const Spacer(),
//           menuItem,
//         ],
//       ),
//     );
//   }
// }

// class AudioWave extends StatelessWidget {
//   const AudioWave({super.key, required this.con, required this.song});
//   final MainController con;
//   final Songs song;

//   @override
//   Widget build(BuildContext context) {
//     final controller = Provider.of<MainController>(context);
// final currentIndex = controller.currentIndex;
// final isPlaying = controller.isPlaying;
//               log('controller.isPlaying.toString()');
//               log(controller.isPlaying.toString());
//               log(currentIndex.toString());
//     return isPlaying
//                   ? Image.asset(
//                       ImagesPath.audioWave,
//                       scale: 3.5,
//                     )
//                   : const SizedBox.shrink();
//     // con.player.builderCurrent(
//     //   builder: (context, playing) {
//     //     final bool isPlaying = con.player.current.value!.audio.audio.metas.id ==
//     //         song.id.toString();
//     //     if (isPlaying == true) {
//     //       return PlayerBuilder.isPlaying(
//     //         player: con.player,
//     //         builder: (context, isPlaying) {
//     //           return isPlaying
//     //               ? Image.asset(
//     //                   ImagesPath.audioWave,
//     //                   scale: 3.5,
//     //                 )
//     //               : const SizedBox();
//     //         },
//     //       );
//     //     } else if (isPlaying == false) {
//     //       return const SizedBox();
//     //     } else {
//     //       return const Text('null');
//     //     }
//     //   },
//     // );
//   }
// }
