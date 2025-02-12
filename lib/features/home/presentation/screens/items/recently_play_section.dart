import 'package:alamoody/core/helper/font_style.dart';
import 'package:alamoody/core/utils/song_item.dart';
import 'package:flutter/material.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:provider/provider.dart';

import '../../../../../config/locale/app_localizations.dart';
import '../../../../../core/entities/songs.dart';
import '../../../../../core/helper/app_size.dart';
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

  Widget _buildBodyContent(context) {
    final double pixelRatio = MediaQuery.of(context).devicePixelRatio;

    final double logicalSize = 200 / pixelRatio;
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
            // pushNavigate(
            //     context,
            //     DownLoad(
            //       // con: con!,
            //     ));
          },
        ),
        const SizedBox(
          height: AppPadding.p10,
        ),
        if (recentListen.isEmpty)
          Center(
            child: Text(
              AppLocalizations.of(context)!.translate('no_data_found')!,
              style: styleW700(context, fontSize: 14),
            ),
          )
        else
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.09,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: recentListen.length,
              itemBuilder: (context, index) {
                final song = recentListen[index];
                return GestureDetector(
                  onTap: () async {
                    final con =
                        Provider.of<MainController>(context, listen: false);

                    con.playSong(
                      con.convertToAudio(recentListen),
                      recentListen.indexOf(song),
                    );

                    // downloadSong(context, song);
                  },
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          height: logicalSize,
                          width: logicalSize,
                          padding: const EdgeInsets.all(AppPadding.p4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: GradientBoxBorder(
                              gradient: LinearGradient(
                                colors: [
                                  HexColor("#A866AE"),
                                  HexColor("#37C3EE"),
                                ],
                              ),
                              width: 2,
                            ),
                            gradient: LinearGradient(
                              colors: [
                                HexColor("#1818B7"),
                                HexColor("#AE39A0"),
                              ],
                            ),
                            image: DecorationImage(
                              image: NetworkImage(
                                recentListen[index].artworkUrl!,
                              ),
                              fit: BoxFit.contain,
                            ),
                          ),
                          child: AudioWave(song: song),
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Container(
                        width: 50,
                        alignment: Alignment.center,
                        child: Text(
                          recentListen[index].title!,
                          maxLines: 1,
                          style: styleW400(context, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
