import 'package:alamoody/config/locale/app_localizations.dart';
import 'package:alamoody/core/helper/font_style.dart';
import 'package:alamoody/core/helper/images.dart';
import 'package:alamoody/core/utils/navigator_reuse.dart';
import 'package:alamoody/features/mood/domain/entities/moods.dart';
import 'package:alamoody/features/mood/presentation/widgets/mood_songs_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/helper/app_size.dart';

class HomeMoodsSection extends StatelessWidget {
  const HomeMoodsSection({
    Key? key,
    required this.moods,
  }) : super(key: key);
  
  final List<Moods> moods;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // ✅ Reduce sizes by 10%
    final double containerSize = screenWidth * 0.25; 
    final double imageSize = containerSize * 0.9; 
    final double borderSize = containerSize * 1.05; 

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03, vertical: screenHeight * 0.005),
          child: Text(
            AppLocalizations.of(context)!.translate('moods')!,
            style: styleW500(context, fontSize: FontSize.f14),
          ),
        ),
        if (moods.isEmpty)
          Container(
            alignment: Alignment.center,
            height: screenHeight / 10, // ✅ Responsive height
            child: Text(
              AppLocalizations.of(context)!.translate('no_data_found')!,
              style: styleW700(context, fontSize: 14),
            ),
          )
        else
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(moods.length, (index) {
                return GestureDetector(
                  onTap: () {
                    pushNavigate(
                      context,
                      MoodSongsScreen(
                        id: moods[index].id,
                        name: moods[index].name,
                      ),
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.all(screenWidth * 0.02), // ✅ Reduced padding
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // ✅ Moods Border Image
                        Image.asset(
                          ImagesPath.moodsBorder,
                          width: borderSize,
                          height: borderSize,
                          fit: BoxFit.fill,
                        ),

                        // ✅ Mood Image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CachedNetworkImage(
                            errorWidget: (context, url, error) => const Icon(Icons.error),
                            imageUrl: moods[index].artworkUrl!,
                            width: imageSize,
                            height: imageSize,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
      ],
    );
  }
}
