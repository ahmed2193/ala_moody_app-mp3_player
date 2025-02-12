
import 'package:alamoody/config/locale/app_localizations.dart';
import 'package:alamoody/core/helper/app_size.dart';
import 'package:alamoody/core/helper/font_style.dart';
import 'package:alamoody/core/helper/images.dart';
import 'package:alamoody/core/utils/navigator_reuse.dart';
import 'package:alamoody/features/mood/domain/entities/moods.dart';

import 'package:alamoody/features/mood/presentation/widgets/mood_songs_screen.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class HomeMoodsSection extends StatelessWidget {
  const HomeMoodsSection({
    Key? key,
    required this.moods,
  }) : super(key: key);
  final List<Moods> moods;
  @override
  Widget build(BuildContext context) {
    final List<String> colors = [
      '#C4CEF6',
      '#FFE4F6',
      '#FFEDED',
      '#D8F5FF',
      '#F9F0DB',
    ];
    final double pixelRatio = MediaQuery.of(context).devicePixelRatio;

    // Calculate the adjusted size in logical pixels
    final double logicalSize = 240 / pixelRatio;
   

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
          child: Text(
            AppLocalizations.of(context)!.translate('moods')!,
            style: styleW500(context, fontSize: FontSize.f14),
          ),
        ),
        if (moods.isEmpty)
          Container(
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.height / 10,
            child: Text(
              AppLocalizations.of(context)!.translate('no_data_found')!,
              style: styleW700(context, fontSize: 14),
            ),
          )
        else
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(moods.length, (index) {
             
                return GestureDetector(
                  onTap: () {
                    pushNavigate(
                      context,
                      MoodSongsScreen(
                        id: moods[index].id,
                        name: moods[index].name,
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Stack(
                      alignment: AlignmentDirectional.center,
                      children: [
                        // if (isSelected)

                        // container

                        Image.asset(
                          ImagesPath.moodsBorder,
                          width: logicalSize+10,
                          height: logicalSize+10,
                          fit: BoxFit.fill,
                        ),
                             ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.easeInOut,
                                    child: CachedNetworkImage(
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                      width: logicalSize,
                                      height: logicalSize,
                                      imageUrl: moods[index].artworkUrl!,
                                      // if
                                      // width:
                                      //     MediaQuery.of(context).size.width - 30,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                            
                      ],
                    ),
                  ),
                );
              }),

              // ),
            ),
          ),
      ],
    );
  }
}

// new ui
// import 'package:alamoody/config/locale/app_localizations.dart';
// import 'package:alamoody/core/helper/app_size.dart';
// import 'package:alamoody/core/helper/font_style.dart';
// import 'package:alamoody/core/helper/images.dart';
// import 'package:alamoody/core/utils/controllers/main_controller.dart';
// import 'package:alamoody/core/utils/hex_color.dart';
// import 'package:alamoody/core/utils/media_query_values.dart';
// import 'package:alamoody/core/utils/navigator_reuse.dart';
// import 'package:alamoody/features/mood/domain/entities/moods.dart';

// import 'package:alamoody/features/mood/presentation/widgets/mood_songs_screen.dart';

// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';

// import '../../../../config/themes/colors.dart';

// class HomeMoodsSection extends StatelessWidget {
//   const HomeMoodsSection({
//     Key? key,
//     required this.con,
//     required this.moods,
//   }) : super(key: key);
//   final MainController con;
//   final List<Moods> moods;
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
//           child: Text(
//             AppLocalizations.of(context)!.translate('moods')!,
//             style: styleW500(context, fontSize: FontSize.f14),
//           ),
//         ),
//         if (moods.isEmpty)
//           Container(
//             alignment: Alignment.center,
//             height: MediaQuery.of(context).size.height / 10,
//             child: Text(
//               AppLocalizations.of(context)!.translate('no_data_found')!,
//               style: styleW700(context, fontSize: 14),
//             ),
//           )
//         else
//           SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             child: Row(
//               children: List.generate(
//                 moods.length,
//                 (index) => GestureDetector(
//                   onTap: () {
//                     pushNavigate(
//                       context,
//                       MoodSongsScreen(
//                         con: con,
//                         id: moods[index].id,
//                         name: moods[index].name,
//                       ),
//                     );
//                   },
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child:
//                Stack(
//   alignment: AlignmentDirectional.center,
//   children: [
//     // if (isSelected)

//     // container

//     Image.asset(
//       ImagesPath.moodsBorder,
//       width: context.width * .35,
//       height: context.width * .38,
//       fit: BoxFit.fill,
//     ),
//     Container(
//       decoration: BoxDecoration(
//         color: moods[index].color == null
//             ? AppColors.cPrimary
//             : HexColor(moods[index].color!),
//         borderRadius: BorderRadius.circular(10),
//         image: DecorationImage(
//           image: NetworkImage(moods[index].artworkUrl!),
//           fit: BoxFit.fill,
//         ),
//       ),
//       width: context.width * .3,
//       height: context.width * .3,
//       padding: const EdgeInsets.all(10),
//       child: Stack(
//         alignment: AlignmentDirectional.center,
//         children: [
//           // Semi-transparent overlay
          
//           const SizedBox(
//             height: 6,
//           ),
//         Container(
//           padding: EdgeInsets.all(4),
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [
//                   Colors.black.withOpacity(0.5),
//                   Colors.transparent,
//                 ],
//                 begin: Alignment.bottomCenter,
//                 end: Alignment.topCenter,
//               ),
//               borderRadius: BorderRadius.circular(10),
//             ),
          
//             child: FittedBox(
//               child: Text(
//                 moods[index].name ?? "",
//                 style: styleW500(
//                   context,
//                   color: Colors.white,
//                   fontSize: 16,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     ),
//   ],
// )

                  
//                   ),
//                 ),
//               ),

//               // ),
//             ),
//           ),
//       ],
//     );
//   }
// }
