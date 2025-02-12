import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:flutter/material.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

import '../../../../core/helper/app_size.dart';
import '../../../../core/helper/font_style.dart';
import '../../../../core/utils/hex_color.dart';

class TabBarMembershipReuse extends StatefulWidget {
  const TabBarMembershipReuse({Key? key, required this.names, this.body})
      : super(key: key);
  final List<String>? names;
  final List<Widget>? body;

  @override
  State<TabBarMembershipReuse> createState() => _TabBarMembershipReuseState();
}

class _TabBarMembershipReuseState extends State<TabBarMembershipReuse> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return 
    Theme(
      data: theme.copyWith(
        tabBarTheme: const TabBarTheme(
          
           indicator: BoxDecoration(),
          indicatorColor: Colors.transparent,
        ),

      colorScheme: theme.colorScheme.copyWith(
          surfaceVariant: Colors.transparent,
        ),
      ),
      child: ContainedTabBarView(
        
        onChange: (index) {
          if (index != _selectedIndex) {
            _selectedIndex = index;
            setState(() {});
          }
        },
        tabs: List.generate(
          widget.body!.length,
          (index) => Container(
            margin: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            alignment: Alignment.center,
            decoration: _selectedIndex == index
                ? BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        HexColor('#0052FF'),
                        HexColor('#2FCEFF'),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(30),
                  )
                : BoxDecoration(
                    color: Colors.black.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(30),
                  ),
            child: FittedBox(
              child: Text(
                widget.names![index],
              ),
            ),
          ),
        ),
        tabBarProperties: TabBarProperties(
          // isScrollable :true,
          // indicatorWeight: 0.00000001,
          indicatorSize: TabBarIndicatorSize.tab,
          alignment: TabBarAlignment.start,
          labelPadding: const EdgeInsets.symmetric(horizontal: AppPadding.p10),
          background: Container(
            padding: const EdgeInsets.only(left: 40),
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: GradientBoxBorder(
                gradient: LinearGradient(
                  colors: [
                    HexColor("#F915DE"),
                    HexColor("#13F36D"),
                    HexColor("#16CCF7"),
                    HexColor("#16CCF7"),
                    HexColor("#FFCE00"),
                  ],
                ),
                width: 2.5,
              ),
              borderRadius: BorderRadius.circular(40),
            ),
          ),
          labelColor: Colors.white,
          labelStyle: styleW500(
            context,
            color: Colors.white,
            fontSize: FontSize.f16,
          ),
          
          unselectedLabelStyle: styleW500(
            context,
            color: Colors.white,
            fontSize: FontSize.f18,
          ),
          unselectedLabelColor: Colors.white,
        ),
        views: List.generate(
          widget.body!.length,
          (index) => widget.body![index],
        ),
      ),
    );
  
  }
}
