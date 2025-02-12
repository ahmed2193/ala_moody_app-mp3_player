// import 'package:flutter/material.dart';

// import '../../../../core/helper/app_size.dart';
// import '../../../../core/helper/font_style.dart';
// import '../../../../core/utils/hex_color.dart';
// import '../../domain/entities/category.dart';

// class CategoryGridItem extends StatelessWidget {
//   const CategoryGridItem({
//     Key? key,
//     required this.category,
//   }) : super(key: key);
//   final Category category;

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       alignment: AlignmentDirectional.bottomStart,
//       children: [
//         // image
//         Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(AppRadius.pLarge),
//             image: DecorationImage(
//               image: NetworkImage(
//                 category.artworkUrl!,
//               ),
//               fit: BoxFit.cover,
//             ),
//           ),
//         ),
//         // filter color container
//         Container(
//           height: double.infinity,
//           width: double.infinity,
//           padding: const EdgeInsetsDirectional.only(
//             start: AppPadding.p20,
//             end: AppPadding.p20,
//             bottom: AppPadding.p10,
//           ),
//           alignment: AlignmentDirectional.bottomStart,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(AppRadius.pLarge),
//             gradient: LinearGradient(
//               begin: AlignmentDirectional.bottomEnd,
//               colors: [
//                 HexColor("#D9D9D900"),
//                 HexColor("#00B654BA"),
//               ],
//             ),
//           ),
//           child: Text(
//             category.name ?? "",
//             style: styleW600(
//               context,
//               fontSize: 13,
//               color: Colors.white,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
import 'package:alamoody/core/utils/navigator_reuse.dart';
import 'package:alamoody/features/occasions/presentation/screens/occasions_screen.dart';
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
          // image
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.pLarge),
              image: DecorationImage(
                image: NetworkImage(
                  category.artworkUrl!,
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // filter color container
          Container(
            height: double.infinity,
            width: double.infinity,
            padding: const EdgeInsetsDirectional.only(
              start: AppPadding.p20,
              end: AppPadding.p20,
              bottom: AppPadding.p10,
            ),
            alignment: AlignmentDirectional.bottomStart,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.pLarge),
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
                fontSize: 13,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}