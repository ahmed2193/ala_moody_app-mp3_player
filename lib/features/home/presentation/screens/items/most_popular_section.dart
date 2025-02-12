import 'package:alamoody/core/helper/font_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../../../config/locale/app_localizations.dart';
import '../../../../../core/entities/songs.dart';
import '../../../../../core/helper/app_size.dart';
import '../../../../../core/helper/images.dart';
import '../../../../../core/utils/controllers/main_controller.dart';
import '../../../../../core/utils/error_widget.dart' as error_widget;
import '../../../../../core/utils/hex_color.dart';
import '../../../../../core/utils/loading_indicator.dart';
import '../../../../../core/utils/navigator_reuse.dart';
import '../../../../../core/utils/song_item.dart';
import '../../../../most_popular/presentation/screen/most_popular_screen.dart';
import '../../cubits/popular_songs/popular_songs_cubit.dart';
import '../../widgets/carousel_reused.dart';
import '../../widgets/title_go_bar.dart';

class MostPopularSection extends StatefulWidget {
  MostPopularSection({
    Key? key,
    required this.scrollController,
  }) : super(key: key);
  ScrollController scrollController = ScrollController();

  @override
  State<MostPopularSection> createState() => _MostPopularSectionState();
}

class _MostPopularSectionState extends State<MostPopularSection> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PopularSongsCubit, PopularSongsState>(
      builder: (context, state) {
        if (state is PopularSongsIsLoading && state.isFirstFetch) {
          return const LoadingIndicator();
        }
        if (state is PopularSongsIsLoading) {
          BlocProvider.of<PopularSongsCubit>(context).loadMore = true;
        } else if (state is PopularSongsError) {
          return error_widget.ErrorWidget(
            msg: state.message!,
          );
        }
        return PopularBody(
          popularSongs:
              BlocProvider.of<PopularSongsCubit>(context).popularSongs,
        );
        //     PopularLightBody(
        //   con: widget.con!,
        //   popularSongs:
        //       BlocProvider.of<PopularSongsCubit>(context).popularSongs,
        // );
      },
    );
  }
}

class PopularBody extends StatelessWidget {
  const PopularBody({
    Key? key,
    // required this.widget,
    required this.popularSongs,
  }) : super(key: key);

  // final MostPopularSection widget;
  final List<Songs> popularSongs;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleGoBar(
          text: AppLocalizations.of(context)!.translate('most_popular'),
          imagePath: ImagesPath.forwardIconSvg,
          onPressed: () {
            pushNavigate(
              context,
              const MostPopularScreen(),
            );
          },
        ),
        // Most Popular Section Carousel

        if (popularSongs.isEmpty)
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
          ReusedCarousel(
            items: [
              for (final Songs song in popularSongs) song,
            ],
          ),
      ],
    );
  }
}

class PopularLightBody extends StatelessWidget {
  const PopularLightBody({
    Key? key,
    required this.popularSongs,
  }) : super(key: key);

  final List<Songs> popularSongs;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final imageSize =
        screenWidth * 0.33; // Adjust the size relative to screen width

    return Column(
      children: [
        TitleGoBar(
          text: AppLocalizations.of(context)!.translate('most_popular'),
          imagePath: ImagesPath.forwardIconSvg,
          onPressed: () {
            pushNavigate(
              context,
              const MostPopularScreen(),
            );
          },
        ),
        // Most Popular Section Carousel

        if (popularSongs.isEmpty)
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
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
                children: List.generate(popularSongs.length, (index) {
              return GestureDetector(
                onTap: () {
                  final con =
                      Provider.of<MainController>(context, listen: false);

                  con.playSong(
                    con.convertToAudio(popularSongs),
                    index,
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(AppPadding.p10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Image and shadow
                      Container(
                        width: imageSize,
                        height: imageSize, // Ensure the container is square
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(AppRadius.pLarge),
                          image: DecorationImage(
                            image: NetworkImage(
                              popularSongs[index].artworkUrl!,
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: AudioWave(
                          song: popularSongs[index],
                        ),
                      ),
                      const SizedBox(
                        height: AppPadding.p6,
                      ),
                      // Artist name

                      // SizedBox(
                      //   width: imageSize - 10,
                      //   child: Text(
                      //     popularSongs[index].artists![0].name!,
                      //     overflow: TextOverflow.clip,
                      //     maxLines: 1,
                      //     style: styleW400(
                      //       context,
                      //       fontSize: screenWidth *
                      //           0.025, // Adjust the font size relative to screen width
                      //       color: AppColors.cOffWhite2,
                      //     ),
                      //   ),
                      // ),
                      // Song title
                      SizedBox(
                        width: imageSize,
                        child: Text(
                          textAlign: TextAlign.center,
                          popularSongs[index].title!,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: styleW600(
                            context,
                          )!
                              .copyWith(
                                  fontSize: 14,
                                  height: 1.0,
                                  color: HexColor('#1B0E3E'),),
                        ),
                      ),
                      const SizedBox(
                        height: AppPadding.p4,
                      ),
                      Text(
                        '${popularSongs[index].artists![0].name}',
                        style: styleW400(
                          context,
                          fontSize: 12,
                          color: HexColor('#AAAAAA'),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),),
          ),
      ],
    );
  }
}
