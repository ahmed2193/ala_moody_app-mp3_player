// import 'dart:async';
// import 'dart:developer';

// import 'package:alamoody/core/helper/font_style.dart';
// import 'package:alamoody/core/utils/hex_color.dart';
// import 'package:alamoody/core/utils/loading_indicator.dart';
// import 'package:alamoody/features/audio_playlists/presentation/cubit/audio_playlists_cubit.dart';
// import 'package:alamoody/features/audio_playlists/presentation/screen/loading.dart';
// import 'package:alamoody/features/auth/presentation/cubit/login/login_cubit.dart';
// import 'package:alamoody/features/home/domain/entities/songs_PlayLists.dart';
// import 'package:alamoody/features/home/presentation/widgets/icon_button_reuse.dart';
// import 'package:alamoody/features/home/presentation/widgets/search_bar_text_form.dart';
// import 'package:alamoody/features/library/presentation/widgets/reused_play_item.dart';
//   
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:collection/collection.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// //import 'package:flutter_screenutil/flutter_screenutil.dart';



// import '../../../../../../core/helper/app_size.dart';
// import '../../../../../../core/utils/error_widget.dart' as error_widget;
// import '../../../../core/components/reused_background.dart';
// import '../../../../core/helper/images.dart';
// import '../../../../core/utils/controllers/main_controller.dart';

// import 'package:alamoody/injection_container.dart' as di;

// import '../../features/drawer/presentation/screens/drawer_screen.dart';

// // di.sl<MainController>()
// class AudioPlayListsScreen extends StatefulWidget {
//   const AudioPlayListsScreen({
//     required this.con,
//     required this.songsPlayLists,
//     Key? key,
//   }) : super(key: key);
//   final MainController con;
//   final SongsPlayLists songsPlayLists;

//   @override
//   State<AudioPlayListsScreen> createState() => _AudioPlayListsScreenState();
// }

// class _AudioPlayListsScreenState extends State<AudioPlayListsScreen> {
//   ScrollController scrollController = ScrollController();

//   getAudioPlayLists() {
//     BlocProvider.of<AudioPlayListsCubit>(context).getAudioPlayLists(
//       id:1, //songsPlayLists.id, //widget.songsPlayLists.id,
//       accessToken: context.read<LoginCubit>().authenticatedUser!.accessToken,
//     );
//   }

//   void _setupScrollControllerSongs(context) {
//     scrollController.addListener(() {
//       if (scrollController.position.atEdge) {
//         if (scrollController.position.pixels != 0 &&
//             BlocProvider.of<AudioPlayListsCubit>(context).pageNo <=
//                 BlocProvider.of<AudioPlayListsCubit>(context).totalPages) {
//           getAudioPlayLists();
//         }
//       }
//     });
//   }

//   @override
//   void initState() {
//     BlocProvider.of<AudioPlayListsCubit>(context).clearData();

//     getAudioPlayLists();

//     _setupScrollControllerSongs(context);

//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return _buildBodyContent();
//   }

//   Widget _buildBodyContent() {
//     // final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

//     return SafeArea(
//       child: Scaffold(
//         // key: scaffoldKey,
//         drawer: const DrawerScreen(),
//         body: ReusedBackground(
//           darKBG: ImagesPath.homeBGDarkBG,
//           lightBG: ImagesPath.homeBGLightBG,
//           body: BlocBuilder<AudioPlayListsCubit, AudioPlayListsState>(
//             builder: (context, state) {
//               if (state is AudioPlayListsIsLoading && state.isFirstFetch) {
//                 return const LoadingIndicator();
//               }
//               if (state is AudioPlayListsIsLoading) {
//                 BlocProvider.of<AudioPlayListsCubit>(context).loadMore = true;
//               } else if (state is AudioPlayListsError) {
//                 return error_widget.ErrorWidget(
//                   // onRetryPressed: () => _getAllAudioPlayLists(),
//                   msg: state.message!,
//                 );
//               }

//               return BlocProvider.of<AudioPlayListsCubit>(context)
//                       .audioPlayLists
//                       .isNotEmpty
//                   ? Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         SizedBox(
//                           height: context.height * 0.017
// ,
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment  

// aceBetween,
//                           children: [
//                             // sort
//                             // Text(widget.con.audios[0].metas.id.toString() ),
//                             ReusedIconButton(
//                               image: ImagesPath.sortIconSvg,
//                               onPressed: () =>
//                                   Scaffold.of(context).openDrawer(),
//                             ),
//                             // search textformfield
//                             Expanded(
//                               child: Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: SearchTextFormReuse(
//                                   searchController: TextEditingController(),
//                                   hintText: 'search_audio_here',
//                                   // readOnly: true,
//                                 ),
//                               ),
//                             ),
//                             // equalizer
//                           ],
//                         ),
//                         Stack(
//                           children: [
//                             Container(
//                               margin: const EdgeInsets.all(25),
//                               // borderRadius: new BorderRadius.circular(10.0),
//                               child: CachedNetworkImage(
  // errorWidget: (context, url, error) => Icon(Icons.error),

//                                 imageUrl: widget.songsPlayLists.artworkUrl!,
//                                 width: MediaQuery.of(context).size.width,
//                                 height: 1context.height * 0.088
// ,
//                                 maxHeightDiskCache: 100,
//                                 maxWidthDiskCache: 100,
//                                 memCacheHeight: (50 *
//                                         MediaQuery.of(context).devicePixelRatio)
//                                     .round(),
//                                 memCacheWidth: (50 *
//                                         MediaQuery.of(context).devicePixelRatio)
//                                     .round(),
//                                 progressIndicatorBuilder: (context, url, l) =>
//                                     const LoadingImage(),
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                             Positioned(
//                               bottom:  context.height*0.116
// ,
//                               right: 0.0,
//                               left: 0.0,
//                               // alignment: Alignment.bottomCenter,
//                               child: Text(
//                                 widget.songsPlayLists.title!,
//                                 style: styleW700(context, fontSize: 22  

// ),
//                                 textAlign: TextAlign.center,
//                               ),
//                             )
//                           ],
//                         ),
//                         widget.con.player.builderCurrent(
//                           builder: (context, playing) {
//                             final Function eq = const ListEquality().equals;
//                             final bool isSame = eq(
//                               widget.con.player.playlist!.audios,
//                               widget.con.convertToAudio(
//                                 BlocProvider.of<AudioPlayListsCubit>(
//                                   context,
//                                 ).audioPlayLists,
//                               ),
//                             );
//                             // playing.audio.audio..
//                             bool play;
//                             for (int i = 0;
//                                 i < widget.con.player.playlist!.audios.length;
//                                 i++) {
//                               if (widget.con.player.playlist!.audios[i].metas
//                                       .id ==
//                                   BlocProvider.of<AudioPlayListsCubit>(
//                                     context,
//                                   ).audioPlayLists[i].id) {
//                                 log(widget
//                                     .con.player.playlist!.audios[i].metas.id
//                                     .toString());
//                               } else {
//                                 log(playing.audio.audio.metas.title!);
//                               }
//                             }
//                             return Padding(
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: AppPadding.pDefault,
//                               ),
//                               child: PlayerBuilder.isPlaying(
//                                 player: widget.con.player,
//                                 builder: (context, isPlaying) {
//                                   return Row(
//                                     children: [
//                                       Text(playing.audio.audio.metas.title!),
//                                       const Spacer(),
//                                       Container(
//                                         alignment: Alignment.center,
//                                         padding: const EdgeInsets.all(12),
//                                         decoration: BoxDecoration(
//                                           shape: BoxShape.circle,
//                                           gradient: LinearGradient(
//                                             //begin: AlignmentDirectional.bottomStart,
//                                             // 10% of the width, so there are ten blinds.
//                                             colors: [
//                                               HexColor("#1943F4"),
//                                               HexColor("#F915DE"),
//                                               // HexColor("#39BCE9"),
//                                             ],
//                                           ),
//                                         ),
//                                         child: IconButton(
//                                           onPressed: () {
//                                             if (isSame) {
//                                               widget.con.player.playOrPause();
//                                             } 
//                                             else {
//                                               widget.con.playSong(
//                                                 widget.con.convertToAudio(
//                                                   BlocProvider.of<
//                                                       AudioPlayListsCubit>(
//                                                     context,
//                                                   ).audioPlayLists,
//                                                 ),
//                                                 0,
//                                               );
//                                             }
//                                           },
//                                           icon: isSame 
//                                               ? Icon(
//                                                  isPlaying
//                                                       ? Icons.pause
//                                                       : Icons.play_arrow,
//                                                   color: Colors.white,
//                                                   size: 35,
//                                                 )
//                                               : const Icon(
//                                                   Icons.play_arrow,
//                                                   color: Colors.white,
//                                                   size: 35,
//                                                 ),
//                                         ),
//                                       ),
//                                     ],
//                                   );
//                                 },
//                               ),
//                             );
//                           },
//                         ),
//                         Expanded(
//                           child: Padding(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: AppPadding.pDefault,
//                             ),
//                             child: ListView.separated(
//                               shrinkWrap: true,
//                               padding: const EdgeInsetsDirectional.only(
//                                 top: AppPadding.p20,
//                                 bottom: AppPadding.p20 * 6,
//                               ),
//                               physics: const NeverScrollableScrollPhysics(),
//                               controller: scrollController,
//                               separatorBuilder: (context, index) =>
//                                   const SizedBox(
//                                 height: AppPadding.p20,
//                               ),
//                               itemCount: BlocProvider.of<AudioPlayListsCubit>(
//                                     context,
//                                   ).audioPlayLists.length +
//                                   (BlocProvider.of<AudioPlayListsCubit>(
//                                     context,
//                                   ).loadMore
//                                       ? 1
//                                       : 0),
//                               itemBuilder: (context, index) {
//                                 if (index <
//                                     BlocProvider.of<AudioPlayListsCubit>(
//                                       context,
//                                     ).audioPlayLists.length) {
//                                   final bool isPlaying =
//                                       widget.con.player.getCurrentAudioTitle ==
//                                           BlocProvider.of<AudioPlayListsCubit>(
//                                             context,
//                                           ).audioPlayLists[index].title;

//                                   log('isPlaying audiooooo$isPlaying ');

//                                   return GestureDetector(
//                                     onTap: () {
//                                       // pushNavigate(
//                                       //     context,
//                                       //     HorizontalSongList(
//                                       //       songs: BlocProvider.of<
//                                       //                   AudioPlayListsCubit>(
//                                       //               context)
//                                       //           .audioPlayLists,
//                                       //       user: BlocProvider.of<
//                                       //                   AudioPlayListsCubit>(
//                                       //               context)
//                                       //           .user!,
//                                       //       con: widget.con,
//                                       //     ));

//                                       BlocProvider.of<AudioPlayListsCubit>(
//                                         context,
//                                       ).playSongs(widget.con, index,BlocProvider.of<AudioPlayListsCubit>(
//                                             context,
//                                           ).audioPlayLists);
//                                     },
//                                     child: ItemOfLastPlayedList(
//                                       songs:
//                                           BlocProvider.of<AudioPlayListsCubit>(
//                                                   context)
//                                               .audioPlayLists[index],
//                                     ),
//                                   );
//                                 } else if (BlocProvider.of<AudioPlayListsCubit>(
//                                             context)
//                                         .pageNo <=
//                                     BlocProvider.of<AudioPlayListsCubit>(
//                                       context,
//                                     ).totalPages) {
//                                   Timer(const Duration(milliseconds: 30), () {
//                                     scrollController.jumpTo(
//                                       scrollController.position.maxScrollExtent,
//                                     );
//                                   });

//                                   return const LoadingIndicator();
//                                 }
//                                 return const SizedBox();
//                               },
//                             ),
//                           ),
//                         ),
//                       ],
//                     )
//                   : const Center(
//                       child: Text('no data'),
//                     );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }


// // class RootScaffold {
// //   static openDrawer(BuildContext context) {
// //     final ScaffoldState scaffoldState =
// //         context.rootAncestorStateOfType(TypeMatcher<ScaffoldState>());
// //     scaffoldState.openDrawer();
// //   }
// // }