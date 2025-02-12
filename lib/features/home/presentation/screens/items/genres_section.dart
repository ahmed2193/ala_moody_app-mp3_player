import 'package:alamoody/core/helper/font_style.dart';
import 'package:alamoody/features/genres/presentation/screens/genres_screen.dart';
import 'package:flutter/material.dart';

import '../../../../../config/locale/app_localizations.dart';
import '../../../../../core/entities/songs.dart';
import '../../../../../core/helper/images.dart';
import '../../../../../core/utils/navigator_reuse.dart';

import '../../widgets/carousel_reused.dart';
import '../../widgets/title_go_bar.dart';

class GenresBody extends StatelessWidget {
  const GenresBody({
    Key? key,
    // required this.widget,
    required this.genresSongs,
  }) : super(key: key);

  // final MostGenersSection widget;
  final List<Songs> genresSongs;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleGoBar(
          text: AppLocalizations.of(context)!
                                          .translate('genres'),
          imagePath: ImagesPath.forwardIconSvg,
          onPressed: () {
            pushNavigate(
              context,
              const GenresScreen(
              ),
            );
          },
        ),
        // Most Genres Section Carousel

        if (genresSongs.isEmpty) Center(
                child: Text(
                  AppLocalizations.of(context)!.translate('no_data_found')!,
                  style: styleW700(context, fontSize: 14),
                ),
              ) else ReusedCarousel(
                items: [
                  for (final Songs song in genresSongs) song,
                ],
              ),
      ],
    );
  }
}
