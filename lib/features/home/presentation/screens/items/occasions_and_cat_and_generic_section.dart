
import 'package:alamoody/core/entities/genreic.dart';
import 'package:alamoody/core/helper/app_size.dart';
import 'package:alamoody/core/helper/font_style.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../../config/locale/app_localizations.dart';
import '../../../../../core/helper/images.dart';
import '../../../../../core/utils/navigator_reuse.dart';

import '../../../../occasions/presentation/screens/occasions_screen.dart';

class OccassionAndGenericCategoriesBody extends StatelessWidget {
  const OccassionAndGenericCategoriesBody({
    Key? key,
    required this.items,
    required this.headerName,
    required this.txt,
  }) : super(key: key);

  // final MostOccassionAndGenericCategoriesSection widget;
  final List<Genres> items;
  final String headerName;
  final String txt;
  @override
  Widget build(BuildContext context) {

    final double pixelRatio = MediaQuery.of(context).devicePixelRatio;

    // Calculate the adjusted size in logical pixels
    final double logicalSize = 240 / pixelRatio;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
          child: Text(
            AppLocalizations.of(context)!.translate(headerName)??'',
            style: styleW500(context, fontSize: FontSize.f14),
          ),
        ),
        if (items.isEmpty)
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
              children: List.generate(items.length, (index) {
                // final String randomColor = colors[random.nextInt(colors.length)];

                return GestureDetector(
                  onTap: () {
                    pushNavigate(
                      context,
                      OccasionsScreen(
                        txt: txt,
                        id: items[index].id!,
                        headerName: headerName,
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
                          width: logicalSize + 10,
                          height: logicalSize + 10,
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
                              imageUrl: items[index].artworkUrl!,
                              width: logicalSize,
                              height: logicalSize,
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


// class OccassionAndGenericCategoriesBody extends StatelessWidget {
//   const OccassionAndGenericCategoriesBody({
//     Key? key,
//     // required this.widget,
//     required this.con,
//     required this.items,
//     required this.headerName,
//   }) : super(key: key);

//   // final MostOccassionAndGenericCategoriesSection widget;
//   final MainController? con;
//   final List<Genres> items;
//   final String headerName;
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
//           child: Text(
//             AppLocalizations.of(context)!.translate(headerName)!,
//             style: styleW500(context, fontSize: FontSize.f14),
//           ),
//         ),
//         if (items.isEmpty) Center(
//                 child: Text(
//                   AppLocalizations.of(context)!.translate('no_data_found')!,
//                   style: styleW700(context, fontSize: 14),
//                 ),
//               ) else OccassionAndGenericCategoriesReusedCarousel(
//                 con: con,
//                 headerName: headerName,
//                 items: [
//                   for (final Genres song in items) song,
//                 ],
//               ),
//       ],
//     );
//   }
// }




//     required this.headerName,
//   }) : super(key: key);

//   // final MostOccassionAndGenericCategoriesSection widget;
//   final MainController? con;
//   final List<Genres> items;
//   final String headerName;
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
//           child: Text(
//             AppLocalizations.of(context)!.translate(headerName)!,
//             style: styleW500(context, fontSize: FontSize.f14),
//           ),
//         ),
//         if (items.isEmpty)
//           Container(
//             alignment: Alignment.center,
//             height: MediaQuery.of(context).size.height / 10,
//             child: Text(
//               AppLocalizations.of(context)!.translate('no_data_found')!,
//               style: styleW700(context, fontSize: 14),
//             ),
//           )
//         else
//           OccassionAndGenericCategoriesReusedCarousel(
//             con: con,
//             headerName: headerName,
//             items: [
//               for (final Genres song in items) song,
//             ],
//           ),
//       ],
//     );
//   }
// }

// class OccassionAndGenericCategoriesReusedCarousel extends StatefulWidget {
//   const OccassionAndGenericCategoriesReusedCarousel({
//     super.key,
//     required this.items,
//     required this.con,
//     required this.headerName,
//   });
//   final MainController? con;

//   final List<Genres>? items;

//   final String headerName;

//   @override
//   State<OccassionAndGenericCategoriesReusedCarousel> createState() =>
//       _OccassionAndGenericCategoriesReusedCarouselState();
// }

// class _OccassionAndGenericCategoriesReusedCarouselState
//     extends State<OccassionAndGenericCategoriesReusedCarousel> {
//   int index = 0;
//   bool isplay = false;

//   @override
//   Widget build(BuildContext context) {
//     return CarouselSlider(
//       options: CarouselOptions(
//         enlargeCenterPage: true,
//         viewportFraction: .53,
//         aspectRatio: 2.5,
//         onPageChanged: (index, reason) {
//           this.index = index;
//           setState(() {});
//         },
//       ),
//       items: List.generate(
//         widget.items!.length,
//         (index) => this.index == index
//             // for selected item
//             ? GestureDetector(
//                 onTap: () {
//                   pushNavigate(
//                     context,
//                     OccassionAndGenericCategoriesScreen(
//                       con: widget.con!,
//                       id: widget.items![index].id!,
//                       headerName: widget.headerName,
//                     ),
//                   );
//                 },
//                 child: Stack(
//                   alignment: AlignmentDirectional.center,
//                   children: [
//                     ClipRRect(
//                       borderRadius: const BorderRadiusDirectional.all(
//                           Radius.circular(AppRadius.pLarge)),
//                       // Theme.of(context).dividerTheme.color
//                       child: CachedNetworkImage(
//                         errorWidget: (context, url, error) =>
//                             const Icon(Icons.error),
//                         imageUrl: widget.items![index].artworkUrl!,
//                         fit: BoxFit.cover,
//                         width: context.width * .36,
//                         height: context.height * .16,
//                       ),
//                     ),
//                     Image.asset(
//                       ImagesPath.itemsBorder,
//                       width: context.width * .4,
//                       height: context.height * .4,
//                       fit: BoxFit.fill,
//                     ),
//                     Container(
//                       padding: EdgeInsets.all(2),
//                       decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                           colors: [
//                             Colors.black.withOpacity(0.7),
//                             Colors.transparent,
//                           ],
//                           begin: Alignment.bottomCenter,
//                           end: Alignment.topCenter,
//                         ),
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: FittedBox(
//                         child: Container(
//     constraints: BoxConstraints(maxWidth:  context.width * .34), 
//                           child: Text('${widget.items![index].name} ',
//                               selectionColor: Colors.green,
//                               maxLines: 3,
//                               textAlign: TextAlign.center,
//                               overflow: TextOverflow.clip,
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.w700,
//                                 shadows: [
//                                   Shadow(
//                                     color: Colors.black.withOpacity(0.7),
//                                     blurRadius: 5,
//                                     offset: Offset(1, 1),
//                                   ),
//                                 ],
//                               )
                          
//                               //  styleW700(
//                               //       context,
//                               //       color: Colors.white,
//                               //       fontSize: 16,
//                               //     ),
//                               ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               )
//             // for unselected item
//             : Container(
//                 decoration: BoxDecoration(
//                   borderRadius: const BorderRadiusDirectional.all(
//                       Radius.circular(AppRadius.pLarge)
//                       // topStart: Radius.circular(AppRadius.pLarge),
//                       // bottomEnd: Radius.circular(AppRadius.pLarge + 10),
//                       ),
//                   image: DecorationImage(
//                     image: NetworkImage(
//                       widget.items![index].artworkUrl!,
//                     ),
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//                 child: Image.asset(
//                   ImagesPath.popularUnselectedImage,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//       ),
//     );
//   }
// }
