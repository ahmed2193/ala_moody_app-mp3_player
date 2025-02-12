import 'package:alamoody/core/utils/hex_color.dart';
import 'package:alamoody/core/utils/media_query_values.dart';
import 'package:flutter/material.dart';
import 'package:gradient_borders/gradient_borders.dart';

import '../../../../../config/locale/app_localizations.dart';
import '../../../../../core/helper/font_style.dart';
import '../../../../../core/helper/images.dart';
import '../../../../../core/utils/navigator_reuse.dart';
import '../../../../main/presentation/cubit/main_cubit.dart';
import '../../../../radio/domain/entities/radio.dart' as radio;
import '../../../../radio/presentation/screens/radio_channels.dart';
import '../../../../radio/presentation/screens/radio_screen.dart';
import '../../widgets/title_go_bar.dart';

class RadioSection extends StatelessWidget {
  const RadioSection({
    Key? key,
    required this.radioData,
  }) : super(key: key);
  final List<radio.Radio> radioData;

  @override
  Widget build(BuildContext context) {
    return _buildBodyContent(context);
  }

  Widget _buildBodyContent(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleGoBar(
          text: AppLocalizations.of(context)!.translate('radio'),
          imagePath: ImagesPath.forwardIconSvg,
          onPressed: () {
            pushNavigate(
              context,
              const RadioScreen(
              ),
            );
          },
        ),
        if (radioData.isEmpty)
          Center(
            child: Text(
              AppLocalizations.of(context)!.translate('no_data_found')!,
              style: styleW700(
                context,
                fontSize: 14,
              ),
            ),
          )
        else 
        
        // MainCubit.isDark? 
        RadioDarkBody(radioData: radioData, ),
          // RadioLightBody(radioData: radioData, con: con),
      ],
    );
  }
}

class RadioLightBody extends StatelessWidget {
  const RadioLightBody({
    super.key,
    required this.radioData,
  });

  final List<radio.Radio> radioData;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.height/5,
    
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: radioData.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              pushNavigate(
                context,
                // BlocProvider(
                //   create: (context) => di.sl<RadioCategoryCubit>(),
                //   child:
                // ),
                RadioChannels(
                  radioData: radioData[index],
                ),
              );
            },
            child: Container(
                // width:context.width *.32,
                margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                alignment: Alignment.center,
              decoration: BoxDecoration(
                 border: GradientBoxBorder(
                          gradient: LinearGradient(
                            colors: [
                              HexColor("#58257F"),
                              HexColor("#A5508C"),
                              // Colors.white,
                            ],
                          ),
                          width: 1.4,
                        ),
                        // gradient: const LinearGradient(
                        //   end: Alignment(1, 2),
                        //   colors: [
                        //     Colors.transparent,
                        //     Colors.transparent,
                        //     Colors.transparent,
                        //     // HexColor("#020024"),
                        //     // HexColor("#090979"),
                        //     // Colors.black26,
                        //   ],
                        // ),
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                color:Colors.grey.withOpacity(0.1),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 80,
                    width: 80,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                          radioData[index].artworkUrl!,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Center(
                    child: Text(
                      radioData[index].name!,
                      style: styleW600(
                        context,
                        fontSize: 13,
                        color:MainCubit.isDark?Colors.white: HexColor('#1B0E3E'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}


class RadioDarkBody extends StatelessWidget {
  const RadioDarkBody({
    super.key,
    required this.radioData,
  });

  final List<radio.Radio> radioData;

  @override
  Widget build(BuildContext context) {
        final double pixelRatio = MediaQuery.of(context).devicePixelRatio;

 
    final double logicalSize = 220 / pixelRatio;
    return SizedBox(
      height: logicalSize+30,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: radioData.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              pushNavigate(
                context,
      
                RadioChannels(
                  radioData: radioData[index],
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  Container(
                    height: logicalSize,
                    width: logicalSize,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                          radioData[index].artworkUrl!,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                          Expanded(
                    child: Center(
                      child: Text(
                        radioData[index].name!,
                        style: styleW400(
                          context,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

