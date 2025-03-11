import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

import '../../../../../config/locale/app_localizations.dart';
import '../../../../../core/artist_details.dart';
import '../../../../../core/entities/artists.dart';
import '../../../../../core/helper/font_style.dart';
import '../../../../../core/helper/images.dart';
import '../../../../../core/utils/hex_color.dart';
import '../../../../../core/utils/navigator_reuse.dart';
import '../../../../artists/presentation/screen/artists_screen.dart';
import '../../../../main/presentation/cubit/main_cubit.dart';
import '../../widgets/title_go_bar.dart';

class ArtistsSection extends StatelessWidget {
  const ArtistsSection({
    Key? key,
    required this.artists,
  }) : super(key: key);

  final List<Artists> artists;

  @override
  Widget build(BuildContext context) {
    return _buildBodyContent(context);
  }

  Widget _buildBodyContent(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double imageSize = screenWidth * 0.2; // Dynamic size
    final double textSize = screenWidth * 0.03; // Adjust text size

    return SizedBox(
      height: screenHeight / 5,
      child: Column(
        children: [
          TitleGoBar(
            text: AppLocalizations.of(context)!.translate('popular_artists'),
            imagePath: ImagesPath.forwardIconSvg,
            onPressed: () {
              pushNavigate(context, const ArtistsScreen());
            },
          ),
          if (artists.isEmpty)
            Expanded(
              child: Text(
                AppLocalizations.of(context)!.translate('no_data_found')!,
                style: styleW700(context, fontSize: textSize),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: artists.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      pushNavigate(
                          context, ArtistDetails(artistId: artists[index].id.toString()),);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Column(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Container(
                              height: imageSize,
                              width: imageSize,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: MainCubit.isDark
                                    ? GradientBoxBorder(
                                        gradient: LinearGradient(
                                          colors: [
                                            HexColor("#F915DE"),
                                            HexColor("#16CCF7"),
                                            HexColor("#25DC84"),
                                          ],
                                        ),
                                        width: 1.5,
                                      )
                                    : null,
                              ),
                              child: ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl: artists[index].artworkUrl!,
                                  fit: BoxFit.fill,
                                  width: imageSize,
                                  height: imageSize,
                                  placeholder: (context, url) =>
                                      const CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          SizedBox(
                            width: screenWidth * 0.22,
                            child: Center(
                              child: Text(
                                artists[index].name!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: styleW700(
                                  context,
                                  fontSize: textSize,
                                  color: !MainCubit.isDark
                                      ? HexColor('#1B0E3E')
                                      : null,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
