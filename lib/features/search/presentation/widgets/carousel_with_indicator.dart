import 'package:alamoody/core/utils/controllers/main_controller.dart';
import 'package:alamoody/core/utils/song_item.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';

import '../../../../core/entities/songs.dart';
import '../../../../core/helper/app_size.dart';

class ReusedCarouselWithIndicator extends StatefulWidget {
  const ReusedCarouselWithIndicator({
    super.key,
    required this.items,
    required this.con,
  });
  final MainController con;
  final List<Songs> items;

  @override
  State<ReusedCarouselWithIndicator> createState() =>
      _ReusedCarouselWithIndicatorState();
}

class _ReusedCarouselWithIndicatorState
    extends State<ReusedCarouselWithIndicator> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    //padding: const EdgeInsets.all(AppPadding.pMedium),
    return Padding(
      padding: const EdgeInsets.all(AppPadding.pDefault),
      child: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
       
      // slider

          CarouselSlider(
            options: CarouselOptions(
              enlargeCenterPage: true,
              autoPlay: true,
              viewportFraction: 1,
              aspectRatio: 2.5,
              onPageChanged: (index, reason) {
                this.index = index;
                setState(() {});
              },
            ),
            items: List.generate(
              widget.items.length,
              (index) => GestureDetector(
                onTap: () {
                  widget.con.playSong(
                    widget.con.convertToAudio(widget.items),
                    widget.items.indexOf(widget.items[index]),
                  );
                },
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppRadius.pLarge),
                    image: DecorationImage(
                      
                      image: NetworkImage(
                        
                        widget.items[index].artworkUrl!,
                        
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
          // indicator
          Padding(
            padding:
                const EdgeInsetsDirectional.only(bottom: AppPadding.p10 - 2),
            child: DotsIndicator(
              dotsCount: widget.items.length,
              position: index,
              decorator: DotsDecorator(
                activeColor: Colors.white,
                color: Colors.white.withOpacity(.4),
                spacing: const EdgeInsets.symmetric(
                  horizontal: 3,
                ),
              ),
            ),
          ),
      Padding(
        padding: const EdgeInsets.all(30.0),
        child: Align(
          child: AudioWave(song: widget.items[index]),),
      ),
        ],
      ),
    );
  }
}
