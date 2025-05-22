import 'package:alamoody/core/helper/font_style.dart';
import 'package:flutter/material.dart';

import '../../../../../config/locale/app_localizations.dart';
import '../../../../../core/helper/app_size.dart';
import '../../../../../core/helper/images.dart';
import '../../../../../core/utils/navigator_reuse.dart';
import '../../../../Playlists/presentation/screen/playlists_screen.dart';
import '../../../../main/presentation/cubit/main_cubit.dart';
import '../../../domain/entities/Songs_PlayLists.dart';
import '../../widgets/featured_list_slider.dart';
import '../../widgets/light_featured_list_slider.dart';
import '../../widgets/title_go_bar.dart';

class FeaturedListSection extends StatelessWidget {
  FeaturedListSection({
    Key? key,
    required this.songsPlayLists,
  }) : super(key: key);

  List<SongsPlayLists> songsPlayLists;
  @override
  Widget build(BuildContext context) {
    return _buildBodyContent(context);
  }

  Widget _buildBodyContent(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // featured text
        TitleGoBar(
          text: AppLocalizations.of(context)!.translate('featured_playlist'),
          imagePath: ImagesPath.forwardIconSvg,
          onPressed: () {
            pushNavigate(
              context,
              const PlayListsScreen(),
            );
          },
        ),
        if (songsPlayLists.isEmpty)
          Container(
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.height / 10,
            child: Text(
              AppLocalizations.of(context)!.translate('no_data_found')!,
              style: styleW700(
                context,
                fontSize: 14,
              ),
            ),
          )
        else
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 100,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              separatorBuilder: (context, index) => const SizedBox(
                width: AppPadding.p20,
              ),
              padding: const EdgeInsets.symmetric(horizontal: AppPadding.p10),
              itemCount: songsPlayLists.length,
              itemBuilder: (context, index) {
                // log(songsPlayLists[index].title!);
                return MainCubit.isDark
                    ? FeaturedListSlider(
                        index: index,
                        songsPlayLists: songsPlayLists[index],
                      )
                    : LightFeaturedListSlider(
                        index: index,
                        songsPlayLists: songsPlayLists[index],
                      );
              },
            ),
          ),
      ],
    );
  }
}
