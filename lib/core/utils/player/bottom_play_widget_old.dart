// import 'dart:developer';
// import 'dart:io';
// import 'dart:ui';

// import 'package:alamoody/core/utils/app_strings.dart';
  
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import '../../../config/locale/app_localizations.dart';
// import '../../../features/auth/presentation/cubit/login/login_cubit.dart';
// import '../../../features/home/presentation/cubits/save_song_on_track_play/save_song_on_track_play_cubit.dart';
// import '../../helper/font_style.dart';
// import '../controllers/main_controller.dart';
// import '../hex_color.dart';
// import 'position_seek_widget.dart';

// class PlayWidget extends StatefulWidget {
//   final void Function()? onTap;

//   const PlayWidget({
//     Key? key,
//     required this.onTap,
//   }) : super(key: key);

//   @override
//   State<PlayWidget> createState() => _PlayWidgetState();
// }

// class _PlayWidgetState extends State<PlayWidget> {
//   @override
//   Widget build(BuildContext context) {
//     final devicePexelRatio = MediaQuery.of(context).devicePixelRatio;
//     final decoration = BoxDecoration(
//       color: HexColor('#1B0E3E'),
//       // border: Border.all(
//       //   color: Colors.grey,
//       //   width: 0.5,
//       // ),
//       borderRadius: BorderRadius.circular(0.0),
//       // boxShadow: kElevationToShadow[9],
//     );
//     Widget buildContent() {
//       if (widget.con.isloading == 1 && widget.con.isNext == false) {
//         return widget.con.audio == null
//             ? const SizedBox()
//             : Container(
//                 margin: EdgeInsets.zero,
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
//                 decoration: BoxDecoration(
//                   color: HexColor('#1B0E3E'),
//                   // border: Border.all(
//                   //   color: Colors.grey,
//                   //   width: 0.5,
//                   // ),
//                   borderRadius: BorderRadius.circular(0.0),
//                   // boxShadow: kElevationToShadow[9],
//                 ),
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(10),
//                   child: Stack(
//                     children: [
//                       BackdropFilter(
//                         filter: ImageFilter.blur(),
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(
//                             vertical: 4.0,
//                             horizontal: 8,
//                           ),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Flexible(
//                                 child: Row(
//                                   children: [
//                                     ClipRRect(
//                                       borderRadius: BorderRadius.circular(3),
//                                       child: !widget
//                                               .con.audio!.metas.image!.path
//                                               .contains('http')
//                                           ? Image.file(
//                                               File(
//                                                 widget.con.audio!.metas.image!
//                                                     .path,
//                                               ),
//                                               width: 40,
//                                               height: 40,
//                                               fit: BoxFit.cover,
//                                             )
//                                           : CachedNetworkImage(
//                                               // errorWidget:
//                                               //     (context, url, error) =>
//                                               //         Icon(Icons.error),
//                                               imageUrl: widget
//                                                   .con.audio!.metas.image!.path,
//                                               width: 40,
//                                               height: 40,
//                                               memCacheHeight:
//                                                   (70 * devicePexelRatio)
//                                                       .round(),
//                                               memCacheWidth:
//                                                   (70 * devicePexelRatio)
//                                                       .round(),
//                                               maxHeightDiskCache:
//                                                   (70 * devicePexelRatio)
//                                                       .round(),
//                                               maxWidthDiskCache:
//                                                   (70 * devicePexelRatio)
//                                                       .round(),
//                                               progressIndicatorBuilder: (
//                                                 context,
//                                                 url,
//                                                 l,
//                                               ) =>
//                                                   const CircularProgressIndicator(),
//                                               fit: BoxFit.cover,
//                                             ),
//                                     ),
//                                     Flexible(
//                                       child: Padding(
//                                         padding: const EdgeInsets.all(8.0),
//                                         child: Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             Text(
//                                               widget.con.audio!.metas.title!,
//                                               maxLines: 1,
//                                               style: styleW400(
//                                                 context,
//                                                 color: Colors.white,
//                                               ),
//                                             ),
//                                             const SizedBox(height: 5),
//                                             Text(
//                                               'loading...',
//                                               maxLines: 1,
//                                               style: styleW400(
//                                                 context,
//                                                 color: Colors.white,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               const Center(
//                                 child: CircularProgressIndicator(
//                                   color: Colors.white,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//         // : SizedBox(child: Text(con.audio!.metas.title!),);
//       } else if (widget.con.isloading == 2 || widget.con.isNext) {
//         return widget.con.player.builderCurrent(
//           builder: (context, playing) {
//             final myAudio = widget.con.find(
//               widget.con.player.playlist!.audios,
//               playing.audio.assetAudioPath,
//             );

//             final audioType =
//                 widget.con.player.current.value!.audio.audio.audioType.name;
//             audioType.contains('liveStream') || audioType.contains('file')
//                 ? null
//                 : myAudio.metas.extra!['listened'] == 0
//                     ? {
//                         BlocProvider.of<SaveSongOnTrackPlayCubit>(
//                           context,
//                         ).saveSongOnTrackPlay(
//                           id: myAudio.metas.id.toString(),
//                           type: AppStrings.song,
//                           accessToken: context
//                               .read<LoginCubit>()
//                               .authenticatedUser!
//                               .accessToken!,
//                         ),
//                         myAudio.metas.extra!['listened'] = 1,
//                       }
//                     : null;
//             return Dismissible(
//               background: Container(
//                 decoration: decoration,
//               ),
//               key: const Key('Dismissible PlayWidget'),
//               onDismissed: (direction) {
//                 widget.con.player.stop();
//               },
//               child: GestureDetector(
//                 onTap: widget.onTap,
//                 child: Container(
//                   margin: EdgeInsets.zero,
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
//                   decoration: decoration,
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(10),
//                     child: Stack(
//                       children: [
//                         BackdropFilter(
//                           filter: ImageFilter.blur(),
//                           child: Padding(
//                             padding: const EdgeInsets.symmetric(
//                               vertical: 2.0,
//                               horizontal: 8,
//                             ),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Flexible(
//                                   child: Row(
//                                     children: [
//                                       ClipRRect(
//                                         borderRadius: BorderRadius.circular(3),
//                                         child: widget.con.player.current.value!
//                                                 .audio.audio.audioType.name
//                                                 .contains('file')
//                                             ? Image.file(
//                                                 File(myAudio.metas.image!.path),
//                                                 width: 35,
//                                                 height: 35,
//                                                 fit: BoxFit.cover,
//                                               )
//                                             : CachedNetworkImage(
//                                                 errorWidget:
//                                                     (context, url, error) =>
//                                                         const Icon(Icons.error),
//                                                 imageUrl:
//                                                     myAudio.metas.image!.path,
//                                                 width: 35,
//                                                 height: 35,
//                                                 memCacheHeight:
//                                                     (70 * devicePexelRatio)
//                                                         .round(),
//                                                 memCacheWidth:
//                                                     (70 * devicePexelRatio)
//                                                         .round(),
//                                                 maxHeightDiskCache:
//                                                     (70 * devicePexelRatio)
//                                                         .round(),
//                                                 maxWidthDiskCache:
//                                                     (70 * devicePexelRatio)
//                                                         .round(),
//                                                 progressIndicatorBuilder: (
//                                                   context,
//                                                   url,
//                                                   l,
//                                                 ) =>
//                                                     const CircularProgressIndicator(),
//                                                 fit: BoxFit.cover,
//                                               ),
//                                       ),
//                                       Flexible(
//                                         child: Padding(
//                                           padding: const EdgeInsets.all(8.0),
//                                           child: Column(
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             children: [
                                              
//                                               Text(
//                                                 myAudio.metas.title!,
//                                                 maxLines: 1,
//                                                 style: styleW400(
//                                                   context,
//                                                   color: Colors.white,
//                                                 ),
//                                               ),
//                                               // const SizedBox(height: 5),
//                                               widget.con.player
//                                                   .builderRealtimePlayingInfos(
//                                                 builder: (
//                                                   context,
//                                                   RealtimePlayingInfos? infos,
//                                                 ) {
//                                                   if (infos == null) {
//                                                     return const SizedBox();
//                                                   }
//                                                   return !audioType.contains(
//                                                     'liveStream',
//                                                   )
//                                                       ? Text(
//                                                           audioType.contains(
//                                                             'liveStream',
//                                                           )
//                                                               ? durationToString(
//                                                                   infos
//                                                                       .currentPosition,
//                                                                 )
//                                                               : durationToString(
//                                                                   infos
//                                                                       .duration,
//                                                                 ),
//                                                           style: styleW400(
//                                                             context,
//                                                             color: Colors.white,
//                                                           ),
//                                                         )
//                                                       : Row(
//                                                           children: [
//                                                             Row(
//                                                               mainAxisAlignment:
//                                                                   MainAxisAlignment
//                                                                       .spaceBetween,
//                                                               children: [
//                                                                 Container(
//                                                                   height: 5,
//                                                                   width: 5,
//                                                                   decoration:
//                                                                       BoxDecoration(
//                                                                     shape: BoxShape
//                                                                         .circle,
//                                                                     color:
//                                                                         HexColor(
//                                                                       '#4BDA73',
//                                                                     ),
//                                                                   ),
//                                                                 ),
//                                                                 const SizedBox(
//                                                                   width: 10,
//                                                                 ),
//                                                                 Text(
//                                                                   AppLocalizations
//                                                                           .of(
//                                                                     context,
//                                                                   )!
//                                                                       .translate(
//                                                                     "live",
//                                                                   )!,
//                                                                   style:
//                                                                       styleW400(
//                                                                     context,
//                                                                     fontSize:
//                                                                         14,
//                                                                   ),
//                                                                 ),
//                                                               ],
//                                                             ),
//                                                           ],
//                                                         );
//                                                 },
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 if (audioType.contains('liveStream'))
//                                   IconButton(
//                                     onPressed: () {
//                                       widget.con.player.pause();
//                                     },
//                                     icon: const Icon(
//                                       Icons.stop_circle_sharp,
//                                       size: 30,
//                                       color: Colors.white,
//                                     ),
//                                   )
//                                 else
//                                   PlayerBuilder.isPlaying(
//                                     player: widget.con.player,
//                                     builder: (context, isPlaying) {
//                                       return Container(
//                                         alignment: Alignment.center,
//                                         margin: const EdgeInsets.all(2),
//                                         decoration: BoxDecoration(
//                                           shape: BoxShape.circle,
//                                           gradient: LinearGradient(
//                                             colors: [
//                                               HexColor("#1943F4"),
//                                               HexColor("#F915DE"),
//                                             ],
//                                           ),
//                                         ),
//                                         child: IconButton(
//                                           onPressed: () {
//                                             audioType.contains('liveStream')
//                                                 ? widget.con.player.pause()
//                                                 : widget.con.player
//                                                     .playOrPause();
//                                           },
//                                           icon: Icon(
//                                             isPlaying
//                                                 ? Icons.pause
//                                                 : Icons.play_arrow,
//                                             size: 20,
//                                             color: Colors.white,
//                                           ),
//                                         ),
//                                       );
//                                     },
//                                   ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           },
//         );
//       } else {
//         log('loading nullllll');
//         return const SizedBox();
//       }
//     }

//     return buildContent();
//   }
// }

