import 'package:flutter/material.dart';

import '../../../../core/helper/app_size.dart';
import 'rounded_container_recently_section.dart';

class RecentlyPlayList extends StatelessWidget {
  const RecentlyPlayList({Key? key, required this.items}) : super(key: key);
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          items.length,
          // will send model after api here
          (index) => CircleContainerWithGradientBorder(
            image: items[index],
          ),
        )
            .map(
              // to make space between items
              (e) => Padding(
                padding: const EdgeInsetsDirectional.only(
                  start: AppPadding.p10,
                  end: AppPadding.p10,
                ),
                child: e,
              ),
            )
            .toList(),
      ),
    );
  }
}
