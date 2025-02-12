
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
  ArtistsSection({
    Key? key,
    required this.artists,
  }) : super(key: key);
  List<Artists> artists;
  @override
  Widget build(BuildContext context) {
    return _buildBodyContent(context);
  }

  Widget _buildBodyContent(context) {
    final double pixelRatio = MediaQuery.of(context).devicePixelRatio;

 
    final double logicalSize = 220 / pixelRatio;
    return SizedBox(
      height: MediaQuery.of(context).size.height / 5,
      child: Column(
        children: [
          TitleGoBar(
            text: AppLocalizations.of(context)!.translate('popular_artists'),
            imagePath: ImagesPath.forwardIconSvg,
            onPressed: () {
              pushNavigate(
                context,
                const ArtistsScreen(
                ),
              );
            },
          ),
          if (artists.isEmpty)
            Expanded(
              child: Text(
                AppLocalizations.of(context)!.translate('no_data_found')!,
                style: styleW700(context, fontSize: 14),
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
                        context,
                        ArtistDetails(
                          artist: artists[index],

                          
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Column(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Container(
                              height: logicalSize,
                              width:logicalSize,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  fit: BoxFit.contain,
                                  image: NetworkImage(
                                    artists[index].artworkUrl!,
                                  ),
                                ),
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
                              // child:Image.asset(ImagesPath.singerImage ,fit: BoxFit.cover,)
                              //  const CircleAvatar(
                              //   // radius: 25,
                              //   backgroundImage: AssetImage(
                              //     ImagesPath.singerImage,
                              //   ),
                              // ),
                            ),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          SizedBox(
                          
                            width:MediaQuery.of(context).size.width * 0.22,
                            child: Center(
                              child: Text(artists[index].name!,
                              maxLines: 1,
                              
                                  style: styleW700(context,
                                      fontSize: 12, color:!MainCubit.isDark? HexColor('#1B0E3E'):null,),
                                  overflow: TextOverflow.visible,),
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
