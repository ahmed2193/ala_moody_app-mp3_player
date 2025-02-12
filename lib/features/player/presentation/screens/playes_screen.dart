// import 'dart:developer';
// import 'dart:io';

// import 'package:alamoody/core/utils/hex_color.dart';
// import 'package:alamoody/core/utils/media_query_values.dart';
  
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import '../../../../config/locale/app_localizations.dart';
// import '../../../../config/themes/colors.dart';
// import '../../../../core/helper/font_style.dart';
// import '../../../../core/helper/images.dart';
// import '../../../../core/utils/controllers/main_controller.dart';
// import '../../../../core/utils/play_list.dart';
// import '../../../auth/presentation/widgets/gradient_auth_button.dart';
// import '../../../drawer/presentation/screens/drawer_screen.dart';
// import '../../../main_layout/presentation/pages/main_layout_screen.dart';
// import '../../../profile/presentation/cubits/profile/profile_cubit.dart';
// import 'items/control_player_section_old.dart';
// import 'items/favourite_in_player_section.dart';
// import 'items/first_section.dart';
// import 'items/slider_player_reuse.dart';

// class PlayerScreen extends StatefulWidget {
//   const PlayerScreen({
//     Key? key,
//   }) : super(key: key);

//   @override
//   State<PlayerScreen> createState() => _PlayerScreenState();
// }

// class _PlayerScreenState extends State<PlayerScreen> {
//   @override
//   Widget build(BuildContext context) {
//     final devicePexelRatio = MediaQuery.of(context).devicePixelRatio;

//     double logicalWidthSize = 880 / devicePexelRatio;
//     double logicalHeightSize = 440 / devicePexelRatio;
//     bool isLyrics = false;
//     bool isNextOrPreviousLoading = true;
//     final bool isPremium = context
//                 .read<ProfileCubit>()
//                 .userProfileData!
//                 .user!
//                 .subscription!
//                 .serviceId ==
//             '1'
//         ? false
//         : true;

//     return widget.con.isloading == 0
//         ? CircularProgressIndicator()
//         : Container(
//             child: widget.con.player.builderCurrent(
//               builder: (context, playing) {
//                 final myAudio = widget.con.find(
//                   widget.con.player.playlist!.audios,
//                   playing.audio.assetAudioPath,
//                 );
//                 log(myAudio.toString(), name: 'myAudio');
//                 log(myAudio.path, name: 'path');
//                 final String lyrics = myAudio.metas.extra!['lyrics'] ?? '';

//                 return Scaffold(
//                   drawer: const DrawerScreen(),
//                   backgroundColor: AppColors.cScaffoldBackgroundColorDark,
//                   body: StatefulBuilder(
//                     builder: (BuildContext context, setState) {
//                       return Stack(
//                         children: [
//                           SingleChildScrollView(
//                             child: Container(
//                               height: MediaQuery.of(context).size.height,
//                               width: MediaQuery.of(context).size.width,
//                               decoration: const BoxDecoration(
//                                 image: DecorationImage(
//                                   image: AssetImage(ImagesPath.playerBG),
//                                   fit: BoxFit.cover,
//                                 ),
//                                 color: Colors.transparent,
//                               ),
//                             ),
//                           ),
//                           SafeArea(
//                             bottom: false,
//                             child: Column(
//                               children: [
//                                 FirstSectionPlayerScreen(
//                                   isPremium: true,
//                                   myAudio: myAudio,
//                                   streamUrl: '',
//                                 ),
//                                 if (isLyrics && lyrics.isNotEmpty)
//                                   Column(
//                                     children: [
//                                       Padding(
//                                         padding: const EdgeInsets.fromLTRB(
//                                             0, 16, 12, 20),
//                                         child: Row(
//                                           children: [
//                                             SizedBox(
//                                                 width: context.height * 0.01),
//                                             ClipRRect(
//                                               borderRadius:
//                                                   BorderRadius.circular(10),
//                                               child: CachedNetworkImage(
//                                                 errorWidget:
//                                                     (context, url, error) =>
//                                                         const Icon(Icons.error),
//                                                 imageUrl:
//                                                     myAudio.metas.image!.path,
//                                                 width: context.width * 0.111,
//                                                 height: context.height * 0.058,
//                                                 fit: BoxFit.cover,
//                                               ),
//                                             ),
//                                             SizedBox(
//                                                 width: context.height * 0.012),
//                                             Expanded(
//                                               flex: 2,
//                                               child: Column(
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment.center,
//                                                 crossAxisAlignment:
//                                                     CrossAxisAlignment.start,
//                                                 children: [
//                                                   Text(
//                                                     myAudio.metas.title!,
//                                                     style: styleW700(context,
//                                                         color: Colors.white),
//                                                   ),
//                                                   SizedBox(
//                                                       height: context.height *
//                                                           0.0060),
//                                                   Text(
//                                                     myAudio.metas.artist!,
//                                                     style: styleW400(context,
//                                                         fontSize: 12),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                       SizedBox(
//                                         height:
//                                             MediaQuery.of(context).size.height /
//                                                 3.7,
//                                         child: SingleChildScrollView(
//                                           child: Column(
//                                             children: [
//                                               Text(
//                                                 myAudio.metas.extra!['lyrics']!,
//                                                 textAlign: TextAlign.center,
//                                                 style: styleW700(context,
//                                                     fontSize: 18,
//                                                     height: 2,
//                                                     color: Colors.white),
//                                                 maxLines: isPremium ? null : 3,
//                                               ),
//                                               if (!isPremium)
//                                                 Center(
//                                                   child:
//                                                       GradientCenterTextButton(
//                                                     onTap: () {
//                                                       Navigator.of(context,
//                                                               rootNavigator:
//                                                                   true)
//                                                           .push(
//                                                         MaterialPageRoute(
//                                                           builder: (context) =>
//                                                               const App(
//                                                                   index: 4),
//                                                         ),
//                                                       );
//                                                     },
//                                                     width:
//                                                         MediaQuery.of(context)
//                                                                 .size
//                                                                 .width /
//                                                             1.3,
//                                                     buttonText: AppLocalizations
//                                                             .of(context)!
//                                                         .translate(
//                                                             'unlock_full_lyrics'),
//                                                     listOfGradient: [
//                                                       HexColor("#DA00FF"),
//                                                       HexColor("#FFB000"),
//                                                     ],
//                                                   ),
//                                                 )
//                                               else
//                                                 const SizedBox(),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   )
//                                 else
//                                   Center(
//                                     child: Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.center,
//                                       children: [
//                                         SizedBox(width: context.height * 0.01),
//                                         Padding(
//                                           padding: const EdgeInsets.symmetric(
//                                               horizontal: 0),
//                                           child: ClipRRect(
//                                             borderRadius:
//                                                 BorderRadius.circular(10),
//                                             child: widget
//                                                     .con
//                                                     .player
//                                                     .current
//                                                     .value!
//                                                     .audio
//                                                     .audio
//                                                     .audioType
//                                                     .name
//                                                     .contains('file')
//                                                 ? Image.file(
//                                                     File(myAudio
//                                                         .metas.image!.path),
//                                                     width: logicalWidthSize,
//                                                     height: logicalHeightSize,
//                                                     fit: BoxFit.cover,
//                                                   )
//                                                 : CachedNetworkImage(
//                                                     errorWidget: (context, url,
//                                                             error) =>
//                                                         const Icon(Icons.error),
//                                                     imageUrl: myAudio
//                                                         .metas.image!.path,
//                                                     width: logicalWidthSize,
//                                                     height: logicalHeightSize,
//                                                     fit: BoxFit.cover,
//                                                   ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 const Spacer(),
//                                 if (isLyrics ||
//                                     widget.con.player.current.value!.audio.audio
//                                         .audioType.name
//                                         .contains('file'))
//                                   const SizedBox()
//                                 else
//                                   FavoriteInPlayerSection(
//                                       myAudio: myAudio as dynamic,
//                                       con: widget.con as dynamic),
//                                 Stack(
//                                   alignment: Alignment.topCenter,
//                                   children: [
//                                     Padding(
//                                       padding: EdgeInsets.only(
//                                           top: context.height * 0.03),
//                                       child: widget.con.player
//                                           .builderRealtimePlayingInfos(
//                                         builder: (context,
//                                             RealtimePlayingInfos? infos) {
//                                           if (infos == null) {
//                                             return const SizedBox();
//                                           }
//                                           return SliderPlayerReuse(
//                                             currentPosition:
//                                                 infos.currentPosition,
//                                             duration: infos.duration,
//                                             seekTo: (to) {
//                                               widget.con.player.seek(to);
//                                             },
//                                           );
//                                         },
//                                       ),
//                                     ),
//                                     Padding(
//                                       padding: EdgeInsets.only(
//                                           top: context.height * 0.21),
//                                       child: widget.con.player.builderLoopMode(
//                                         builder: (context, loopMode) {
//                                           return PlayerBuilder.isPlaying(
//                                             player: widget.con.player,
//                                             builder: (context, isPlaying) {
//                                               return ControlPlayerSection(
//                                                 con: widget.con,
//                                                 loopMode: loopMode,
//                                                 isPlaying: isPlaying,
//                                                 isPlaylist: true,
//                                                 onStop: () =>
//                                                     widget.con.player.stop(),
//                                                 toggleLoop: () => widget
//                                                     .con.player
//                                                     .toggleLoop(),
//                                                 onPlay: () => widget.con.player
//                                                     .playOrPause(),
//                                                 onNext: !isPremium
//                                                     ? () {
//                                                         Navigator.of(context,
//                                                                 rootNavigator:
//                                                                     true)
//                                                             .push(
//                                                           MaterialPageRoute(
//                                                             builder:
//                                                                 (context) =>
//                                                                     const App(
//                                                                         index:
//                                                                             4),
//                                                           ),
//                                                         );
//                                                       }
//                                                     : () {
//                                                         isNextOrPreviousLoading
//                                                             ? widget.con.player
//                                                                 .next()
//                                                             : null;
//                                                         setState(() {
//                                                           isNextOrPreviousLoading =
//                                                               false;
//                                                         });
//                                                       },
//                                                 onPrevious: !isPremium
//                                                     ? () {
//                                                         Navigator.of(context,
//                                                                 rootNavigator:
//                                                                     true)
//                                                             .push(
//                                                           MaterialPageRoute(
//                                                             builder:
//                                                                 (context) =>
//                                                                     const App(
//                                                                         index:
//                                                                             4),
//                                                           ),
//                                                         );
//                                                       }
//                                                     : () {
//                                                         isNextOrPreviousLoading
//                                                             ? widget.con.player
//                                                                 .previous()
//                                                             : null;
//                                                         setState(() {
//                                                           isNextOrPreviousLoading =
//                                                               false;
//                                                         });
//                                                       },
//                                               );
//                                             },
//                                           );
//                                         },
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 if (widget.con.player.current.value!.audio.audio
//                                     .audioType.name
//                                     .contains('file'))
//                                   const SizedBox()
//                                 else
//                                   Padding(
//                                     padding: const EdgeInsets.symmetric(
//                                         vertical: 4, horizontal: 8),
//                                     child: Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         InkWell(
//                                           onTap: () {
//                                             lyrics.isEmpty
//                                                 ? null
//                                                 : setState(() {
//                                                     isLyrics = !isLyrics;
//                                                   });
//                                             log(isLyrics.toString());
//                                           },
//                                           child: Container(
//                                             padding: const EdgeInsets.all(4),
//                                             decoration: BoxDecoration(
//                                               color:
//                                                   isLyrics && lyrics.isNotEmpty
//                                                       ? AppColors.cPrimary
//                                                       : Colors.transparent,
//                                               borderRadius:
//                                                   const BorderRadius.all(
//                                                       Radius.circular(15)),
//                                             ),
//                                             child: Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.center,
//                                               children: [
//                                                 const Icon(
//                                                   CupertinoIcons.layers_alt,
//                                                   color: Colors.white,
//                                                   size: 18,
//                                                 ),
//                                                 SizedBox(
//                                                     width: context.height *
//                                                         0.0060),
//                                                 Text('lyrics',
//                                                     style: styleW700(context,
//                                                         fontSize: 18,
//                                                         color: Colors.white)),
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                         InkWell(
//                                           onTap: !isPremium
//                                               ? () {
//                                                   Navigator.of(context,
//                                                           rootNavigator: true)
//                                                       .push(
//                                                     MaterialPageRoute(
//                                                       builder: (context) =>
//                                                           const App(index: 4),
//                                                     ),
//                                                   );
//                                                 }
//                                               : () => Navigator.push(
//                                                     context,
//                                                     CupertinoPageRoute(
//                                                       builder: (context) =>
//                                                           AudioQueueWidget(
//                                                         controller: widget.con
//                                                             as dynamic,
//                                                       ),
//                                                     ),
//                                                   ),
//                                           child: Row(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.center,
//                                             children: [
//                                               const Icon(
//                                                   CupertinoIcons
//                                                       .music_note_list,
//                                                   color: Colors.white,
//                                                   size: 18),
//                                               SizedBox(
//                                                   width:
//                                                       context.height * 0.0060),
//                                               Text('queue',
//                                                   style: styleW700(context,
//                                                       fontSize: 16,
//                                                       color: Colors.white)),
//                                             ],
//                                           ),
//                                         ),
//                                         const SizedBox(),
//                                       ],
//                                     ),
//                                   ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       );
//                     },
//                   ),
//                 );
//               },
//             ),
//           );
//   }
// }
