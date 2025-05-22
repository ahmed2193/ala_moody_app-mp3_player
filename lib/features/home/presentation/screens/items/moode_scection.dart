import 'package:alamoody/config/locale/app_localizations.dart';
import 'package:alamoody/core/helper/font_style.dart';
import 'package:alamoody/core/helper/images.dart';
import 'package:alamoody/core/utils/navigator_reuse.dart';
import 'package:alamoody/features/home/presentation/widgets/title_go_bar.dart';
import 'package:alamoody/features/mood/domain/entities/moods.dart';
import 'package:alamoody/features/mood/presentation/widgets/mood_songs_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';




class MoodsBody extends StatelessWidget {
  MoodsBody({
    Key? key,
    required this.items,
  }) : super(key: key);

  final List<Moods> items;

  ScrollController scrollController = ScrollController();

  // final MostPopularSection widget;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleGoBar(
          text: AppLocalizations.of(context)!.translate('moods'),

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
          MoodsReusedCarousel(
            items: [
              for (final Moods song in items) song,
            ],
          ),
      ],
    );
  }
}

class MoodsReusedCarousel extends StatefulWidget {
  MoodsReusedCarousel({
    Key? key,
    required this.items,
  }) : super(key: key);

  final List<Moods> items;

  @override
  State<MoodsReusedCarousel> createState() => _MoodsReusedCarouselState();
}

class _MoodsReusedCarouselState extends State<MoodsReusedCarousel> {
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

        return GestureDetector(
            onTap: () => pushNavigate(
                  context,
                  MoodSongsScreen(
                    id: widget.items[i].id,
                    name: widget.items[i].name,
                  ),
                ),
            child: Stack(
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
                      width: logicalSize + 20,
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
                      ),
                    ],
                  ),
                ),
              ],
            ));
      }),
    );
  }
}
