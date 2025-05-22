import 'package:flutter/material.dart';

import '../../../../config/themes/colors.dart';
import '../../../../core/helper/app_size.dart';
import '../../../../core/helper/font_style.dart';

class TabBarReuse extends StatelessWidget {
  const TabBarReuse({Key? key, required this.names, this.body})
      : super(key: key);
  final List<String>? names;
  final List<Widget>? body;

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent, // Hide the divider
        ),
      child: DefaultTabController(
        length: names!.length,
        child: Column(
          children: [
             Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width: .01,
                    
                    color: Colors.transparent.withOpacity(0.1), // Hide the divider
                  ),
                ),
              ),
              child: TabBar(
                tabAlignment: TabAlignment.start,
                isScrollable: true,
                labelColor: Theme.of(context).textTheme.bodyLarge!.color,
                unselectedLabelColor: Theme.of(context).dividerColor,
                indicator: const BoxDecoration(), // Hide indicator
                labelPadding:
                    const EdgeInsets.symmetric(horizontal: AppPadding.p20),
                labelStyle: styleW500(
                  context,
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                  fontSize: FontSize.f16,
                ),
                unselectedLabelStyle: styleW500(
                  context,
                  color: AppColors.cGreyColor,
                  fontSize: FontSize.f18,
                ),
                tabs: List.generate(
                  names!.length,
                  (index) => Tab(text: names![index]),
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: List.generate(
                  body!.length,
                  (index) => body![index],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
