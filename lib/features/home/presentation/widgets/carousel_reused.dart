import 'dart:developer';

import 'package:alamoody/core/helper/font_style.dart';
import 'package:alamoody/core/utils/song_item.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/entities/songs.dart';
import '../../../../core/helper/app_size.dart';
import '../../../../core/helper/images.dart';
import '../../../../core/utils/controllers/main_controller.dart';

class ReusedCarousel extends StatefulWidget {
  const ReusedCarousel({
    super.key,
    required this.items,
  });

  final List<Songs>? items;

  @override
  State<ReusedCarousel> createState() => _ReusedCarouselState();
}

class _ReusedCarouselState extends State<ReusedCarousel> {
  int index = 0;
  bool isplay = false;

  @override
  Widget build(BuildContext context) {
    final double pixelRatio = MediaQuery.of(context).devicePixelRatio;

    // Calculate the adjusted size in logical pixels
    final double logicalSize = 240 / pixelRatio;
    log(logicalSize.toString());
    return CarouselSlider(
      options: CarouselOptions(
        enlargeCenterPage: true,
        viewportFraction: .33,
        aspectRatio: 3.5,
        onPageChanged: (index, reason) {
          this.index = index;
          setState(() {});
        },
      ),
      items: List.generate(
        widget.items!.length,
        (index) => this.index == index
            // for selected item
            ? GestureDetector(
                onTap: () {
                  final con =
                      Provider.of<MainController>(context, listen: false);

                  con.playSong(
                    con.convertToAudio(widget.items!),
                    index,
                  );
                  // pushNavigate(context, const PlayerScreen());
                },
                child:
                 Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    Image.asset(
                      ImagesPath.moodsBorder,
                      width: logicalSize + 20,
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
                          imageUrl: widget.items![index].artworkUrl!,
                          width: logicalSize,
                          height: logicalSize,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AudioWave(
                            song: widget.items![index],
                          ),
                          SizedBox(
                            width: logicalSize,
                            child: Text(
                              '${widget.items![index].title}',
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              style: styleW600(
                                context,
                                fontSize: 13,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
           
              )
            // for unselected item
            : Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadiusDirectional.all(
                    Radius.circular(AppRadius.pLarge),
                  ),
                  image: DecorationImage(
                    image: NetworkImage(
                      widget.items![index].artworkUrl!,
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Image.asset(
                  ImagesPath.popularUnselectedImage,
                  fit: BoxFit.cover,
                ),
              ),
      ),
    );
  }
}
