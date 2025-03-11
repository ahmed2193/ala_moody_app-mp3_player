import 'package:alamoody/core/helper/font_style.dart';
import 'package:alamoody/core/utils/song_item.dart';
import 'package:flutter/material.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:provider/provider.dart';

import '../../../../../config/locale/app_localizations.dart';
import '../../../../../core/entities/songs.dart';
import '../../../../../core/helper/images.dart';
import '../../../../../core/utils/controllers/main_controller.dart';
import '../../../../../core/utils/hex_color.dart';
import '../../../../../core/utils/navigator_reuse.dart';
import '../../../../recently_play/presentation/screen/recently_play_screen.dart';
import '../../widgets/title_go_bar.dart';

class RecentlyPlaySection extends StatelessWidget {
  const RecentlyPlaySection({
    Key? key,
    required this.recentListen,
  }) : super(key: key);

  final List<Songs> recentListen;

  @override
  Widget build(BuildContext context) {
    return _buildBodyContent(context);
  }

  Widget _buildBodyContent(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double imageSize = screenWidth * 0.2;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleGoBar(
          text: AppLocalizations.of(context)!.translate('recently_play'),
          imagePath: ImagesPath.forwardIconSvg,
          onPressed: () {
            pushNavigate(
              context,
              RecentlyPlayScreen(
                headerTitle:
                    AppLocalizations.of(context)!.translate('recently_play')!,
              ),
            );
          },
        ),
        SizedBox(height: screenHeight * 0.02),
        if (recentListen.isEmpty)
          Center(
            child: Text(
              AppLocalizations.of(context)!.translate('no_data_found')!,
              style: styleW700(context, fontSize: screenWidth * 0.04),
            ),
          )
        else
          SizedBox(
            width: screenWidth,
            height: screenHeight * 0.15,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
              itemCount: recentListen.length,
              itemBuilder: (context, index) {
                final song = recentListen[index];
                return GestureDetector(
                  onTap: () async {
                    final con = Provider.of<MainController>(context, listen: false);
                    con.playSong(con.convertToAudio(recentListen), recentListen.indexOf(song));
                  },
                  child: Padding(
                    padding:  EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                    child: Column(
                      children: [
                        Container(
                          height: imageSize,
                          width: imageSize,
                          padding: EdgeInsets.all(screenWidth * 0.01),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: GradientBoxBorder(
                              gradient: LinearGradient(
                                colors: [HexColor("#A866AE"), HexColor("#37C3EE")],
                              ),
                              width: 2,
                            ),
                            gradient: LinearGradient(
                              colors: [HexColor("#1818B7"), HexColor("#AE39A0")],
                            ),
                            image: DecorationImage(
                              image: NetworkImage(song.artworkUrl!),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: AudioWave(song: song),
                        ),
                        SizedBox(height: screenHeight * 0.005),
                        Container(
                          width: screenWidth * 0.15,
                          alignment: Alignment.center,
                          child: Text(
                            song.title!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: styleW400(context, fontSize: screenWidth * 0.03),
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
    );
  }
}
