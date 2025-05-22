// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import '../../../../../../core/helper/app_size.dart';
// import '../../../../config/themes/colors.dart';
// import '../../../../core/entities/songs.dart';
// import '../../../../core/helper/font_style.dart';
// import '../../../../core/utils/hex_color.dart';
// import '../../../auth/presentation/cubit/login/login_cubit.dart';
// import '../../../favorites/presentation/cubits/add_and_remove_from_favorite/add_and_remove_from_favorite_cubit.dart';
// import '../../../home/presentation/widgets/rounded_container_recently_section.dart';

// class ItemOfLastPlayedList extends StatelessWidget {
//   const ItemOfLastPlayedList({
//     Key? key,
//     this.onFavPress,
//     this.onMorePress,
//     required this.songs,
//   }) : super(key: key);
//   final GestureTapCallback? onFavPress;
//   final GestureTapCallback? onMorePress;
//   final Songs songs;
//   @override
//   Widget build(BuildContext context) {
//     bool isFav = songs.favorite! ?? false;
//     return StatefulBuilder(builder: (BuildContext context, setState) {
//       return BlocConsumer<AddAndRemoveFromFavoritesCubit,
//           AddAndRemoveFromFavoritesState>(
//         listener: (context, state) {
//           if (state is AddAndRemoveFromFavoritesLoading) {
//             if (state.id == songs.id) {
//               setState(() {
//                 isFav = !isFav;
//               });
//             }
//           }
//           // else {
//           //   setState(() {
//           //     isFav = false;
//           //   });
//           // }

//           if (state is AddAndRemoveFromFavoritesFailed) {
//             if (state.id == songs.id) {
//               setState(() {
//                 isFav = !isFav;
//               });
//             }
//           }
//         },
//         builder: (context, state) {
//           return Row(
//             children: [
//               CircleContainerWithGradientBorder(
//                 image: songs.artworkUrl,
//                 width: 50,
//               ),
//               const SizedBox(
//                 width: AppPadding.p10,
//               ),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     songs.title!,
//                     style: styleW400(context, fontSize: FontSize.f14),
//                   ),
//                   Text(
//                     songs.artists![0].name!,
//                     style: styleW400(
//                       context,
//                       fontSize: FontSize.f10,
//                       color: AppColors.cGreyColor,
//                     ),
//                   ),
//                 ],
//               ),
//               const Spacer(),
//               GestureDetector(
//                 onTap: onFavPress ??
//                     () {
//                       BlocProvider.of<AddAndRemoveFromFavoritesCubit>(context)
//                           .addAndRemoveFromFavorites(
//                         id: songs.id!,
//                         accessToken: context
//                             .read<LoginCubit>()
//                             .authenticatedUser!
//                             .accessToken!,
//                         favtype: !isFav
//                             ? BlocProvider.of<AddAndRemoveFromFavoritesCubit>(
//                                     context,)
//                                 .type = 1
//                             : BlocProvider.of<AddAndRemoveFromFavoritesCubit>(
//                                     context,)
//                                 .type = 0,
//                       );
//                     },
//                 child: Icon(
//                   isFav ? Icons.favorite : Icons.favorite_border_sharp,
//                   color: isFav ? HexColor('#F915DE') : AppColors.cGreyColor,
//                 ),
//               ),
//               const SizedBox(
//                 width: AppPadding.p10,
//               ),
//               GestureDetector(
//                 onTap: onMorePress ?? () {},
//                 child: Icon(
//                   Icons.more_vert_outlined,
//                   color: Theme.of(context).iconTheme.color,
//                 ),
//               ),
//             ],
//           );
//         },
//       );
//     },);
  
//   }
// }
