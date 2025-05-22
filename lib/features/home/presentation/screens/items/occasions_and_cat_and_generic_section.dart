import 'dart:developer';

import 'package:alamoody/core/entities/genreic.dart';
import 'package:alamoody/core/helper/app_size.dart';
import 'package:alamoody/core/helper/font_style.dart';
import 'package:alamoody/features/home/presentation/widgets/carousel_reused.dart';
import 'package:alamoody/features/home/presentation/widgets/title_go_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import '../../../../../config/locale/app_localizations.dart';
import '../../../../../core/helper/images.dart';
import '../../../../../core/utils/navigator_reuse.dart';
import '../../../../occasions/presentation/screens/occasions_screen.dart';

class OccassionAndGenericCategoriesBody extends StatelessWidget {
  OccassionAndGenericCategoriesBody({
    Key? key,
    required this.items,
    required this.headerName,
    required this.txt,
  }) : super(key: key);

  final List<Genres> items;
  final String headerName;
  final String txt;
  ScrollController scrollController = ScrollController();

  // final MostPopularSection widget;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleGoBar(
          text: headerName,
     
          // },
        ),

        if (items.isEmpty)
          Center(
            child: Text(
              AppLocalizations.of(context)!.translate('no_data_found')!,
              style: styleW700(
                context,
                fontSize: 14,
              ),
            ),
          )
        else
          OccassionAndGenericCategoriesReusedCarousel(
            headerName: headerName,
            txt: txt,
            items: [
              for (final Genres song in items) song,
            ],
          ),
      ],
    );
  }
}

class OccassionAndGenericCategoriesReusedCarousel extends StatefulWidget {
  OccassionAndGenericCategoriesReusedCarousel({
    Key? key,
    required this.items,
    required this.headerName,
    required this.txt,
  }) : super(key: key);

  final List<Genres> items;
  final String headerName;
  final String txt;

  @override
  State<OccassionAndGenericCategoriesReusedCarousel> createState() =>
      _OccassionAndGenericCategoriesReusedCarouselState();
}

class _OccassionAndGenericCategoriesReusedCarouselState
    extends State<OccassionAndGenericCategoriesReusedCarousel> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final baseFraction = 0.33;
    final itemSize = screenWidth * baseFraction * 1.15;
        final double pixelRatio = MediaQuery.of(context).devicePixelRatio;

    final double logicalSize = 240 / pixelRatio;

    return CarouselSlider(
      options: CarouselOptions(
        enlargeCenterPage: true,
        viewportFraction: .34,
        aspectRatio: 3.5,
        onPageChanged: (i, _) => setState(() => index = i),
      ),
      items: List.generate(widget.items.length, (i) {
        final genre = widget.items[i];
        final isActive = i == index;

        return GestureDetector(
            onTap: () => pushNavigate(
                  context,
                  OccasionsScreen(
                    txt: widget.txt,
                    id: genre.id!,
                    headerName: widget.headerName,
                  ),
                ),
            child:     Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    Image.asset(
                      ImagesPath.moodsBorder,
                      width: logicalSize + 40,
                      height: logicalSize + 20,
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
                          imageUrl: genre.artworkUrl!,
                          width: logicalSize+20,
                          height: logicalSize,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                    Container(
                      width: logicalSize,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 4),
                          decoration: BoxDecoration(
                            color: Colors.black45,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            genre.name!,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: styleW600(context,
                                    fontSize: 11 * 1.15, color: Colors.white)!
                                .copyWith(shadows: const [
                              Shadow(
                                blurRadius: 2,
                                offset: Offset(0, 1),
                                color: Colors.black54,
                              )
                            ]),
                          ),
                        )
                    ,
                        
                        ],
                      ),
                    ),
                  ],
                ));
           
            
            //  Container(
            //   // 1) Outer container paints the gradient border.
           
            //   child: ClipRRect(
            //     // 2) Clip the inner content so it doesn’t draw over the border
                
            //     borderRadius:
            //         BorderRadius.circular(10), // outerRadius - borderThickness
            //     child: Container(
            //       // color: Colors.black,
            //                     padding: const EdgeInsets.all( 8),

            //       child: Stack(
            //         alignment: Alignment.center,
            //         children: [
            // Image.asset(
            //           ImagesPath.moodsBorder,
            //           width: itemSize + 20,
            //           height: itemSize + 20,
            //           fit: BoxFit.fill,
            //         ),

            //           CachedNetworkImage(
            //             imageUrl: genre.artworkUrl!,
            //             width: itemSize,
            //             height: itemSize,
            //             fit: BoxFit.cover,
            //             errorWidget: (_, __, ___) => const Icon(Icons.error),
            //           ),

            //           // a semi‑opaque band for the text
            //           Positioned(
            //             bottom: 8,
            //             left: 0,
            //             right: 0,
            //             child: Container(
            //               margin: const EdgeInsets.symmetric(horizontal: 8),
            //               padding: const EdgeInsets.symmetric(
            //                   vertical: 4, horizontal: 6),
            //               decoration: BoxDecoration(
            //                 color: Colors.black45,
            //                 borderRadius: BorderRadius.circular(6),
            //               ),
            //               child: Text(
            //                 genre.name!,
            //                 textAlign: TextAlign.center,
            //                 maxLines: 2,
            //                 overflow: TextOverflow.ellipsis,
            //                 style: styleW600(context,
            //                         fontSize: 13 * 1.15, color: Colors.white)!
            //                     .copyWith(shadows: const [
            //                   Shadow(
            //                     blurRadius: 2,
            //                     offset: Offset(0, 1),
            //                     color: Colors.black54,
            //                   )
            //                 ]),
            //               ),
            //             ),
            //           ),
            //         ],
            //       ),
            //     ),
            //   ),
            // ));
    
    
      }),
    );
  }
}
