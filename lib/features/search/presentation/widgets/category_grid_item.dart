import 'package:alamoody/core/utils/navigator_reuse.dart';
import 'package:alamoody/features/occasions/presentation/screens/occasions_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/helper/app_size.dart';
import '../../../../core/helper/font_style.dart';
import '../../../../core/utils/hex_color.dart';
import '../../domain/entities/category.dart';

class CategoryGridItem extends StatelessWidget {
  const CategoryGridItem({
    Key? key,
    required this.category,
  }) : super(key: key);

  final Category category;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double reducedSize = screenWidth * 0.88; // Reduced size by 12%
    const double borderRadius = AppRadius.pLarge * 0.88; // Reduced border radius

    return GestureDetector(
      onTap: () {
        pushNavigate(
          context,
          OccasionsScreen(
            txt: 'categories/',
            id: category.id ?? 0,
            headerName: 'categories' ?? "",
          ),
        );
      },
      child: Stack(
        alignment: AlignmentDirectional.bottomStart,
        children: [
          // **🖼️ Category Image with Rounded Corners**
          Container(
            width: reducedSize, // Reduced width
            height: reducedSize * 0.6, // Maintain aspect ratio
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(borderRadius),
              child: CachedNetworkImage(
                imageUrl: category.artworkUrl!,
                fit: BoxFit.cover,
                width: double.infinity, // Full width
                height: double.infinity, // Full height
                placeholder: (context, url) => const Center(
                  child: SizedBox(
                    width: 18, // Slightly smaller
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
                errorWidget: (context, url, error) => const Icon(
                  Icons.error,
                  size: 22, // Slightly reduced
                ),
              ),
            ),
          ),

          // **🎨 Gradient Overlay with Title**
          Container(
            width: reducedSize, // Keep size consistent
            height: reducedSize * 0.6, // Maintain aspect ratio
            padding: const EdgeInsets.symmetric(
              horizontal: AppPadding.p20 * 0.88, // Reduced padding
              vertical: AppPadding.p10 * 0.88,
            ),
            alignment: AlignmentDirectional.bottomStart,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              gradient: LinearGradient(
                begin: AlignmentDirectional.bottomEnd,
                colors: [
                  HexColor("#D9D9D900"),
                  HexColor("#00B654BA"),
                ],
              ),
            ),
            child: Text(
              category.name ?? "",
              style: styleW600(
                context,
                fontSize: 11, // Reduced font size
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
