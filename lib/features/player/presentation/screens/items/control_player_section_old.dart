// import 'package:alamoody/config/themes/colors.dart';
// import 'package:alamoody/core/utils/controllers/main_controller.dart';
//   
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import '../../../../../core/helper/app_size.dart';
// import '../../../../../core/utils/media_query_values.dart';
// import '../../../../library/presentation/widgets/icon_button_of_play.dart';
// import '../../../../main/presentation/cubit/locale_cubit.dart';
// import '../../widgets/pause_player_screen.dart';

// class ControlPlayerSection extends StatefulWidget {
//   final bool isPlaying;
//   final LoopMode? loopMode;
//   final bool isPlaylist;
//   final Function()? onPrevious;
//   final Function() onPlay;
//   final Function()? onNext;
//   final Function()? toggleLoop;
//   final Function()? onStop;
//   final MainController con;
//   const ControlPlayerSection({
//     super.key,
//     required this.isPlaying,
//     this.isPlaylist = false,
//     this.loopMode,
//     this.toggleLoop,
//     this.onPrevious,
//     required this.onPlay,
//     this.onNext,
//     this.onStop,
//     required this.con,
//   });

//   @override
//   State<ControlPlayerSection> createState() => _ControlPlayerSectionState();
// }

// class _ControlPlayerSectionState extends State<ControlPlayerSection> {
//   bool isSuffled = false;
//   @override
//   void initState() {
//     setState(() {
//       isSuffled = widget.con.player.shuffle;
//     });
//     super.initState();
//   }

//   Icon loopIcon(BuildContext context) {
//     if (widget.loopMode == LoopMode.none) {
//       return const Icon(
//         Icons.repeat_outlined,
//         size: 24,
//         color: Colors.grey,
//       );
//     } else if (widget.loopMode == LoopMode.playlist) {
//       return const Icon(
//         Icons.repeat_outlined,
//         size: 24,
//         color: Colors.white,
//       );
//     } else {
//       return const Icon(
//         Icons.repeat_outlined,
//         size: 24,
//         color: AppColors.cPrimary,
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsetsDirectional.only(
//         start: AppPadding.p24,
//         end: AppPadding.p24,
//         bottom: context.height * 0.00,
//       ),
//       child: Column(
//         children: [
//           PauseInPlayerScreen(
//             onPressed: () {
//               widget.onPlay();
//             },
//             icon: widget.isPlaying ? Icons.pause : Icons.play_arrow,
//             width: 34,
//             padding: AppPadding.p22,
//           ),

//           Row(
//             mainAxisAlignment: MainAxisAlignment  

// .spaceBetween  ,
//             children: [
//               // shuffle
//                IconButtonOfPlay(
//                    onPressed: () {
//               setState(() {
//                 isSuffled = !isSuffled;
//               });
//               widget.con.player.toggleShuffle();
//             },
//                 icon: Icon(
//                   Icons.shuffle_outlined,
//                   color:!isSuffled? Colors.white:AppColors.cPrimary,
//                 ),
//                 width: AppSize.a22,
//                 widthOfBorder: 3,
//                 padding: AppPadding.p4 + 2,
//               ),
//               // repeat
//               // IconButtonOfPlay(
//               //   icon: Icons.repeat_outlined,
//               //   width: AppSize.a22,
//               //   widthOfBorder: 3,
//               //   padding: AppPadding.p4 + 2,
//               // ),
//               IconButtonOfPlay(
//                 onPressed: () {
//                   if (widget.toggleLoop != null) widget.toggleLoop!();
//                 },
//                 icon: loopIcon(context),
//                 width: AppSize.a22,
//                 widthOfBorder: 3,
//                 padding: AppPadding.p4 + 2,
//               ),
//               //      IconButton(
//               //   padding: const EdgeInsets.all(0),
//               //   splashRadius: 24,
//               //   onPressed: () {
//               //     if (widget.toggleLoop != null) widget.toggleLoop!();
//               //   },
//               //   icon: loopIcon(context),
//               // ),
//             ],
//           ),
//           // prev and next
//           Row(
//             mainAxisAlignment: MainAxisAlignment  .spaceEvenly

// ,
//             children: [
//               // previous
//               IconButtonOfPlay(
//                 onPressed: widget.isPlaylist ? widget.onPrevious : null,
//                 icon: RotatedBox(
//      quarterTurns:  context.read<LocaleCubit>().currentLangCode =='ar'?2:4,
//                   child: const Icon(
//                     Icons.skip_previous_outlined,
//                     color: Colors.white,
//                   ),
//                 ),
//                 width: 30,
//                 widthOfBorder: 3,
//                 padding: AppPadding.p4 + 2,
//               ),

//               IconButtonOfPlay(
//                 onPressed: widget.isPlaylist ? widget.onNext : null,
//                 icon: RotatedBox(
//      quarterTurns:  context.read<LocaleCubit>().currentLangCode =='ar'?2:4,
//                   child: const Icon(
//                     Icons.skip_next_outlined,
//                     color: Colors.white,
//                   ),
//                 ),
//                 width: 30,
//                 widthOfBorder: 3,
//                 padding: AppPadding.p4 + 2,
//               ),
//             ],
//           ),
//         ],
//       ),
//       // slider
// // SizedBox(),
//       // Positioned(
//       //   top: 0,
//       //   right: 5,
//       //   left: 5,
//       //   child:
//       // ),
//     );
//   }
// }
