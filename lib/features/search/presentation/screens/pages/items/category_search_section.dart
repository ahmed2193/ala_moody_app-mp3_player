import 'package:flutter/material.dart';

import '../../../../../../core/helper/app_size.dart';
import '../../../../../../core/helper/images.dart';
import '../../../../../home/presentation/widgets/search_bar_text_form.dart';

class CategorySearchSection extends StatelessWidget {
  const CategorySearchSection({Key? key, this.isPremium = false})
      : super(key: key);
  final bool? isPremium;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(
        end: AppPadding.pDefault,
        start: AppPadding.pDefault,
        top: AppPadding.p10,
      ),
      child: IntrinsicHeight(
        child: Column(
          children: [
            // back and premium image
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween  

,
              children: [
                // GestureDetector(
                //   onTap: () {},
                //   child: Icon(
                //     Icons.arrow_back_ios_new_outlined,
                //     color: Theme.of(context).iconTheme.color,
                //     size: 28,
                //   ),
                // ),
                const SizedBox(),
                if (isPremium == true) Image.asset(ImagesPath.premiumImage),
              ],
            ),
            const SizedBox(
              height: AppPadding.p20,
            ),
            SearchTextFormReuse(
              searchController: TextEditingController(),
              hintText: 'search',
              
            ),
          ],
        ),
      ),
    );
  }
}
