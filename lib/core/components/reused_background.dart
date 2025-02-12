import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    return Stack(
      children: [
        BlocConsumer<MainCubit, MainState>(
          listener: (context, state) {},
          builder: (context, state) {
            return 
            
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                image: darKBG!.contains('https')
                    ? DecorationImage(
                        image: NetworkImage(
                          MainCubit.isDark == true ? darKBG! : lightBG!,
                        ),
                        fit: BoxFit.cover,
                      )
                    : MainCubit.isDark == true ? DecorationImage(
                        image: AssetImage(
                       darKBG! ,
                        ),
                        fit: BoxFit.cover,
                      ):DecorationImage(
                        image: AssetImage(
                       lightBG! ,
                        ),
                        fit: BoxFit.cover,
                      ),
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
            );
          },
     
        ),
        body ?? const SizedBox.shrink(),
      ],
    );
  }
}
