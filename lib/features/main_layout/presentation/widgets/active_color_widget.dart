import 'package:alamoody/features/main/presentation/cubit/main_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

import '../../../../core/utils/hex_color.dart';

class ActiveIconContainer extends StatelessWidget {
  const ActiveIconContainer({Key? key, required this.child}) : super(key: key);
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return  BlocConsumer<MainCubit, MainState>(
          listener: (context, state) {},
          builder: (context, state) {
        return Container(
          margin: const EdgeInsets.all(5),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: GradientBoxBorder(
              gradient: LinearGradient(
                colors:MainCubit.isDark == true ? [
                  HexColor("#A866AE"),
                  HexColor("#37C3EE"),
                ]:[
                Colors.transparent,
                Colors.transparent,
                ],
              ),
              width: 3,
            ),
            gradient: LinearGradient(
              colors: MainCubit.isDark== true ?[
                HexColor("#1818B7"),
                HexColor("#AE39A0"),
              ]:[
                  HexColor("#8D00FF"),
                  HexColor("#CF3DFF"),
                ],
            ),
          ),
          child: child,
        );
      },
    );
  }
}
