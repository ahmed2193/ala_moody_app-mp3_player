import 'package:alamoody/core/utils/controllers/main_controller.dart';
import 'package:flutter/material.dart';

import '../../../../../core/entities/songs.dart';
import '../../../../../core/helper/font_style.dart';
import '../../widgets/carousel_with_indicator.dart';

class TabPageOfCategory extends StatelessWidget {
  const TabPageOfCategory({
    Key? key,
    required this.searchData,
    required this.con,
  }) : super(key: key);
  final List<Songs> searchData;
  final MainController con;

  @override
  Widget build(BuildContext context) {
    return searchData.isNotEmpty
        ? ReusedCarouselWithIndicator(
            con: con,
            items: searchData,
          )
        : Container(
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.height / 7,
            child: Text(
              '',
              style: styleW700(context, fontSize: 14),
            ),
          );
  }
}
