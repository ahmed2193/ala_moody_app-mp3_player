import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';

import '../../features/main/presentation/cubit/main_cubit.dart';
import '../helper/images.dart';

class ReusedBackground extends StatelessWidget {
  const ReusedBackground({
    Key? key,
    this.darKBG = ImagesPath.homeBGDarkBG,
    this.lightBG = ImagesPath.bgIntroLight,
    this.body,
  }) : super(key: key);
  
  final String? darKBG;
  final String? lightBG;
  final Widget? body;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainCubit, MainState>(
      builder: (context, state) {
        final bool isDarkMode = MainCubit.isDark;

        // Set status bar style based on theme mode
        final SystemUiOverlayStyle overlayStyle = isDarkMode
            ? SystemUiOverlayStyle.light.copyWith(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: Brightness.light, // White icons
              )
            : SystemUiOverlayStyle.dark.copyWith(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: Brightness.dark, // Black icons
              );

        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: overlayStyle,
          child: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: darKBG!.contains('https')
                        ? NetworkImage(isDarkMode ? darKBG! : lightBG!)
                        : AssetImage(isDarkMode ? darKBG! : lightBG!)
                            as ImageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              body ?? const SizedBox.shrink(),
            ],
          ),
        );
      },
    );
  }
}
