//import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:alamoody/core/utils/media_query_values.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

import '../../../../config/locale/app_localizations.dart';
import '../../../../core/components/reused_background.dart';
import '../../../../core/helper/app_size.dart';
import '../../../../core/helper/font_style.dart';
import '../../../../core/helper/images.dart';
import '../../../../core/utils/back_arrow.dart';
import '../../../../core/utils/hex_color.dart';
import '../../../auth/presentation/widgets/gradient_auth_button.dart';
import '../../../main_layout/cubit/tab_cubit.dart';
import '../../../main_layout/presentation/pages/main_layout_screen.dart';
import '../../../profile/presentation/cubits/profile/profile_cubit.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    super.key,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _bodyContent(context),
    );
  }

  Widget _bodyContent(BuildContext context) {
    final bool isPremium = context
                .read<ProfileCubit>()
                .userProfileData!
                .user!
                .subscription!
                .serviceId ==
            '1'
        ? true
        : false;
    return SafeArea(
      child: ReusedBackground(
        lightBG: ImagesPath.homeBGLightBG,
        body: StatefulBuilder(
          builder: (BuildContext context, setState) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SettingsBar(),
                    const SettingsProfileDetailsWidget(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: AppLocalizations.of(context)!
                                    .translate('your_current_plan')!,
                                style: styleW600(context, fontSize: 18),
                              ),
                              TextSpan(
                                text:
                                    '  ${context.read<ProfileCubit>().userProfileData!.user!.subscription!.planName!}',
                                style: styleW500(
                                  context,
                                  fontSize: 16,
                                ), // Customize color if  needed
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    Center(
                      child: GradientCenterTextButton(
                        onTap: () {
                          // setState(() {
                          //   isPremium = !isPremium;
                          // });

                    context
                                                .read<TabCubit>()
                                                .changeTab(4);
                        },
                        width: MediaQuery.of(context).size.width / 1.3,
                        buttonText: AppLocalizations.of(context)!
                            .translate('get_premium'),
                        listOfGradient: [
                          HexColor("#DA00FF"),
                          HexColor("#FFB000"),
                        ],
                      ),
                    ),

                    Text(
                      AppLocalizations.of(context)!.translate('get_premium')!,
                      style: styleW600(context, fontSize: 20),
                      textAlign: TextAlign.start,
                    ),
                    //
                    PremiumAccountItem(
                      title: AppLocalizations.of(context)!
                          .translate('ADS_free_music_listening'),
                    ),
                    PremiumAccountItem(
                      title: AppLocalizations.of(context)!
                          .translate('play_any_song'),
                    ),
                    PremiumAccountItem(
                      title: AppLocalizations.of(context)!
                          .translate('unlimited_skips'),
                    ),
                    PremiumAccountItem(
                      title: AppLocalizations.of(context)!
                          .translate('offline_listening'),
                    ),
                    PremiumAccountItem(
                      title: AppLocalizations.of(context)!
                          .translate('high_audio_quality'),
                    ),
                    PremiumAccountItem(
                      title: AppLocalizations.of(context)!
                          .translate('exclusive_content_&_listen_audio'),
                    ),
                    PremiumAccountItem(
                      title: AppLocalizations.of(context)!
                          .translate('set_up_your_Favorite_ringtone'),
                    ),

                    SizedBox(
                      height: context.height * 0.116,
                    ),
                  ]
                      .map(
                        (e) => Padding(
                          padding: const EdgeInsetsDirectional.only(
                            top: AppPadding.p10,
                            bottom: AppPadding.p10,
                          ),
                          child: e,
                        ),
                      )
                      .toList(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class SettingsWidgetWithSwitch extends StatelessWidget {
  const SettingsWidgetWithSwitch({
    required this.title,
    required this.subtitle,
    this.planId = 0,
    this.ispremium = false,
    Key? key,
  }) : super(key: key);

  final String? title;
  final String? subtitle;
  final int? planId;
  final bool? ispremium;

  @override
  Widget build(BuildContext context) {
    bool isSwitched = false;
    isSwitchedSe() {
      if (planId == 1) {
        isSwitched = true;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title!,
              style: styleW400(context, fontSize: 20),
              textAlign: TextAlign.start,
            ),
            const Spacer(),
            StatefulBuilder(
              builder: (context, updateUi) {
                return Center(
                  child: Switch(
                    value: isSwitched,
                    onChanged: (value) {
                      // !ispremium!
                      //     ? updateUi(() {
                      //         isSwitched = value;
                      //       })
                      //     : null;
                    },
                    activeTrackColor: Colors.lightGreenAccent,
                    activeColor: Colors.green,
                    inactiveTrackColor: HexColor('#D9D9D9'),
                  ),
                );
              },
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(right: 70),
          child: Text(
            subtitle!,
            style: styleW400(
              context,
              fontSize: 10,
              height: 1.8,
            ),
            textAlign: TextAlign.start,
          ),
        ),
      ],
    );
  }
}

class SettingsProfileDetailsWidget extends StatelessWidget {
  const SettingsProfileDetailsWidget({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
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
                      context
                          .read<ProfileCubit>()
                          .userProfileData!
                          .user!
                          .artworkUrl!,
                    ),
                  ),
                  border: GradientBoxBorder(
                    gradient: LinearGradient(
                      colors: [
                        HexColor("#F915DE"),
                        HexColor("#FAC130"),
                        HexColor("#16CCF7"),
                      ],
                    ),
                    width: 1.5,
                  ),
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context
                        .read<ProfileCubit>()
                        .userProfileData!
                        .user!
                        .username!,
                    style: styleW600(context, fontSize: 20),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    context
                            .read<ProfileCubit>()
                            .userProfileData!
                            .user!
                            .username ??
                        'null',
                    style: styleW600(
                      context,
                      fontSize: 10,
                      color: HexColor('#B3B3B3'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class PeopleSettingsList extends StatelessWidget {
  const PeopleSettingsList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 20,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                Container(
                  height: 90,
                  width: 90,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: const DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage(
                        ImagesPath.ellipseImageBg,
                      ),
                    ),
                    border: GradientBoxBorder(
                      gradient: LinearGradient(
                        colors: [
                          HexColor("#F915DE"),
                          HexColor("#16CCF7"),
                          HexColor("#25DC84"),
                        ],
                      ),
                      width: 1.5,
                    ),
                  ),
                  child: const CircleAvatar(
                    radius: 25,
                    backgroundImage: AssetImage(
                      ImagesPath.singerImage,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Center(
                  child: Text(
                    'Amr diab',
                    style: styleW400(context, fontSize: 12),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class SettingsBar extends StatelessWidget {
  const SettingsBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const BackArrow(),
        Text(
          AppLocalizations.of(context)!.translate('settings')!,
          style: styleW700(context, fontSize: 18),
        ),
        const SizedBox(),
      ],
    );
  }
}

class PremiumAccountItem extends StatelessWidget {
  const PremiumAccountItem({
    required this.title,
    Key? key,
  }) : super(key: key);

  final String? title;

  @override
  Widget build(BuildContext context) {
    final bool isSwitched = context
                .read<ProfileCubit>()
                .userProfileData!
                .user!
                .subscription!
                .serviceId !=
            '1'
        ? true
        : false;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: HexColor('#FD55E9'),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            SizedBox(
              width: 250,
              child: Text(
                title!,
                style: styleW400(context, fontSize: 16),
                textAlign: TextAlign.start,
                maxLines: 2,
              ),
            ),
            const Spacer(),
            StatefulBuilder(
              builder: (context, updateUi) {
                return Center(
                  child: Switch(
                    value: isSwitched,
                    onChanged: (value) {
                context
                                                .read<TabCubit>()
                                                .changeTab(4);
                    },
                    activeTrackColor: HexColor('#D9D9D9'),
                    activeColor: HexColor('#4FDE43'),
                    inactiveThumbColor: HexColor('#F915DE'),
                    inactiveTrackColor: HexColor('#D9D9D9'),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
