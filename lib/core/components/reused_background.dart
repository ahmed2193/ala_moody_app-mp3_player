import 'package:alamoody/core/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/main/presentation/cubit/main_cubit.dart';

class ReusedBackground extends StatelessWidget {
  const ReusedBackground({
    Key? key,
    this.body,
  }) : super(key: key);

  final Widget? body;

  @override
  Widget build(BuildContext context) {
    final size =
        MediaQuery.of(context).size; // Cache MediaQuery for performance

    return BlocBuilder<MainCubit, MainState>(
      buildWhen: (previous, current) =>
          previous != current, // Prevent unnecessary rebuilds
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
                height: size.height,
                width: size.width,
                decoration: 
                
        Constants.  customBackgroundDecoration(isDarkMode: isDarkMode),
             
              ),
              if (body != null) body!,
            ],
          ),
        );
      },
    );
  }
}
