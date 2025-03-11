import 'package:alamoody/core/entities/genreic.dart';
import 'package:alamoody/core/helper/app_size.dart';
import 'package:alamoody/core/helper/font_style.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../../config/locale/app_localizations.dart';
import '../../../../../core/helper/images.dart';
import '../../../../../core/utils/navigator_reuse.dart';
import '../../../../occasions/presentation/screens/occasions_screen.dart';

class OccassionAndGenericCategoriesBody extends StatelessWidget {
  const OccassionAndGenericCategoriesBody({
    Key? key,
    required this.items,
    required this.headerName,
    required this.txt,
  }) : super(key: key);

  final List<Genres> items;
  final String headerName;
  final String txt;

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
            AppLocalizations.of(context)!.translate(headerName) ?? '',
            style: styleW500(context, fontSize: FontSize.f14),
          ),
        ),
        if (items.isEmpty)
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
              children: List.generate(items.length, (index) {
                return GestureDetector(
                  onTap: () {
                    pushNavigate(
                      context,
                      OccasionsScreen(
                        txt: txt,
                        id: items[index].id!,
                        headerName: headerName,
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

                        // ✅ Category Image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CachedNetworkImage(
                            errorWidget: (context, url, error) => const Icon(Icons.error),
                            imageUrl: items[index].artworkUrl!,
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
