import 'package:alamoody/core/utils/controllers/main_controller.dart';
import 'package:alamoody/core/utils/song_item.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';

import '../../../../core/entities/songs.dart';

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
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            // **🔹 Responsive Carousel Slider**
            CarouselSlider(
              options: CarouselOptions(
                height: screenHeight * 0.16, // Reduced height by 10%
                enlargeCenterPage: true,
                autoPlay: true,
                viewportFraction: 1,
                aspectRatio: 16 / 5.4, // Adjusted aspect ratio
                onPageChanged: (index, reason) {
                  setState(() {
                    this.index = index;
                  });
                },
              ),
              items: widget.items.map((song) {
                return GestureDetector(
                  onTap: () {
                    widget.con.playSong(
                      widget.con.convertToAudio(widget.items),
                      widget.items.indexOf(song),
                    );
                  },
                  child: Container(
                    width: double.infinity, // **Full Width**
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CachedNetworkImage(
                        imageUrl: song.artworkUrl!,
                        fit: BoxFit.fill,
                        width: double.infinity,
                        placeholder: (context, url) => Container(
                          color: Colors.grey.shade300,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error, ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
      
            // **🔹 Indicator (Dots)**
            Positioned(
              bottom: screenHeight * 0.015, // Responsive padding
              child: DotsIndicator(
                dotsCount: widget.items.length,
                position: index,
                decorator: DotsDecorator(
                  activeColor: Colors.white,
                  color: Colors.white.withOpacity(0.4),
                  spacing: const EdgeInsets.symmetric(horizontal: 3),
                ),
              ),
            ),
      
            // **🔹 Audio Wave (Aligned)**
            Positioned(
              bottom: screenHeight * 0.02, // Adjusted padding
              child: AudioWave(song: widget.items[index]),
            ),
          ],
        ),
      ),
    );
  }
}
