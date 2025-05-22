import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

import '../../../../core/components/reused_background.dart';
import '../../../../core/helper/font_style.dart';
import '../../../../core/helper/images.dart';
import '../../../../core/utils/hex_color.dart';

class AudioPlayerDetailsScreen extends StatelessWidget {
  const AudioPlayerDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _bodyContent(context),
    );
  }

  Widget _bodyContent(BuildContext context) {
    return SafeArea(
      child: ReusedBackground(
        // darKBG: ImagesPath.homeBGDarkBG,
        //
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AudioPlayerDetailsBar(),
                _audioPlaterItem(
                  context,
                  title: 'Like',
                  iconPath: ImagesPath.playerIcon0,
                  colorBG: HexColor('#F44182'),
                ),
                _audioPlaterItem(
                  context,
                  title: 'Hide audio',
                  iconPath: ImagesPath.playerIcon1,
                  colorBG: HexColor('#4189F4'),
                ),
                _audioPlaterItem(
                  context,
                  title: 'Add to playlist',
                  iconPath: ImagesPath.playerIcon2,
                  colorBG: HexColor('#A641F4'),
                ),
                _audioPlaterItem(
                  context,
                  title: 'Add to queue',
                  iconPath: ImagesPath.playerIcon3,
                  colorBG: HexColor('#02BF70'),
                ),
                _audioPlaterItem(
                  context,
                  title: 'Share',
                  iconPath: ImagesPath.playerIcon4,
                  colorBG: HexColor('#007DD8'),
                ),
                _audioPlaterItem(
                  context,
                  title: 'View album',
                  iconPath: ImagesPath.playerIcon5,
                  colorBG: HexColor('#00CBD8'),
                ),
                _audioPlaterItem(
                  context,
                  title: 'View artist',
                  iconPath: ImagesPath.playerIcon6,
                  colorBG: HexColor('#F21967'),
                ),
                _audioPlaterItem(
                  context,
                  title: 'Audio credits',
                  iconPath: ImagesPath.playerIcon7,
                  colorBG: HexColor('#E8AA31'),
                ),
              ]
                  .map(
                    (e) => Padding(
                      padding: const EdgeInsetsDirectional.only(
                        top: 20,
                        bottom: 20,
                      ),
                      child: e,
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _audioPlaterItem(
    BuildContext context, {
    String? title,
    Color? colorBG,
    String? iconPath,
  }) {
    return Row(
      children: [
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: colorBG,
          ),
          child: SvgPicture.asset(
            iconPath!,
            height: 20,
            width: 20,
          ),
        ),
        const SizedBox(
          width: 6,
        ),
        Text(
          title!,
          style: styleW400(
            context,
            fontSize: 18,
          ),
        ),
      ],
    );
  }
}

class AudioPlayerDetailsBar extends StatelessWidget {
  const AudioPlayerDetailsBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RotatedBox(
          quarterTurns: 2,
          child: SvgPicture.asset(ImagesPath.forwardIconSvg),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 15),
          child: Column(
            children: [
              Container(
                height: 165,
                width: 165,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: const DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage(
                      ImagesPath.singerImage,
                    ),
                  ),
                  border: GradientBoxBorder(
                    gradient: LinearGradient(
                      colors: [
                        HexColor("#F915DE"),
                        HexColor("#8DFF33"),
                        HexColor("#4FF4A5"),
                        HexColor("#F3DC07"),
                      ],
                    ),
                    width: 1.5,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'Aalach',
                style: styleW600(context, fontSize: 20),
              ),
              Text(
                'by Najwa Farouk',
                style: styleW400(
                  context,
                  fontSize: 12,
                  color: HexColor('#D9D9D9'),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(),
      ],
    );
  }
}
