import 'dart:developer';

import 'package:alamoody/core/utils/media_query_values.dart';
import 'package:alamoody/core/utils/no_data.dart';
import 'package:alamoody/features/live_stream/presentation/cubits/create_user_is_live/create_live_user_cubit.dart';
import 'package:alamoody/features/live_stream/presentation/cubits/live_users/live_users_cubit.dart';
import 'package:alamoody/features/live_stream/presentation/screen/live_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

import '../../../../config/locale/app_localizations.dart';
import '../../../../config/themes/colors.dart';
import '../../../../core/components/reused_background.dart';
import '../../../../core/helper/font_style.dart';
import '../../../../core/helper/images.dart';
import '../../../../core/utils/hex_color.dart';
import '../../../auth/presentation/cubit/login/login_cubit.dart';
import '../../../auth/presentation/widgets/gradient_auth_button.dart';
import '../../../main_layout/cubit/tab_cubit.dart';
import '../../../profile/presentation/cubits/profile/profile_cubit.dart';

class LiveStreamScreen extends StatefulWidget {
  const LiveStreamScreen({
    super.key,
  });

  @override
  State<LiveStreamScreen> createState() => _LiveStreamScreenState();
}

class _LiveStreamScreenState extends State<LiveStreamScreen> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  Future<void> _getLiveUsers() =>
      BlocProvider.of<LiveUsersCubit>(context).getLiveUsers(
        context: context,
        accessToken: context.read<LoginCubit>().authenticatedUser!.accessToken!,
      );
  // @override
  // void initState() {
  //   _getLiveUsers();
  //   super.initState();
  // }
  Future<void> _refresh() {
    return _getLiveUsers();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Theme.of(context).primaryColor,
      key: _refreshIndicatorKey,
      onRefresh: _refresh,
      child: BlocConsumer<CreateUserIsLiveCubit, CreateUserIsLiveState>(
        listener: (context, state) {
          // if (state is CreateUserIsLiveSuccess ) {
          //   getLiveUsers();
          // } else {
          //   log('end');
          // }
        },
        builder: (context, state) {
          return SafeArea(
            child: Scaffold(
              body: _bodyContent(
                context,
              ),
            ),
          );
        },
      ),
    );
  }

  ReusedBackground _bodyContent(
    BuildContext context,
  ) {
    final bool isPremium =
        context.read<ProfileCubit>().userProfileData != null &&
                context
                        .read<ProfileCubit>()
                        .userProfileData!
                        .user!
                        .subscription!
                        .serviceId ==
                    '1'
            ? true
            : false;
    void jumpToLivePage(BuildContext context, {required bool isHost}) {
      Navigator.of(context, rootNavigator: true).push(
        MaterialPageRoute(
          builder: (context) => LivePage(
            isHost: isHost,
            liveID: context
                .read<ProfileCubit>()
                .userProfileData!
                .user!
                .id
                .toString(),
          ),
        ),
      );
    }

    return ReusedBackground(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              const LiveStreamBar(),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        end: const Alignment(1, 2),
                        colors: [
                          HexColor("#F915DE"),
                          HexColor("#F44019"),
                        ],
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 5,
                          width: 5,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: HexColor('#4BDA73'),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          AppLocalizations.of(context)!.translate('live')!,
                          style: styleW400(context, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  SvgPicture.asset(
                    ImagesPath.locationIconSvg,
                    color: Theme.of(context).listTileTheme.iconColor,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              const PeopleLiveStreamList(),
              const SizedBox(
                height: 15,
              ),
              GradientCenterTextButton(
                onTap: () {
                  isPremium
                      ? context.read<TabCubit>().changeTab(4)
                      : jumpToLivePage(context, isHost: true);
                },
                buttonText: AppLocalizations.of(context)!
                    .translate('start_a_live_radio'),
                icon: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: SvgPicture.asset(ImagesPath.liveIconSvg),
                ),
                listOfGradient: [
                  HexColor("#E01CD7"),
                  HexColor("#FFB001"),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 30),
                child: Row(
                  children: [
                    Text(
                      AppLocalizations.of(context)!
                          .translate('top_of_the_claps')!,
                      style: styleW500(context, fontSize: 18),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    SvgPicture.asset(ImagesPath.handImage),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: AppColors.cBottomBarDark,
                        border: GradientBoxBorder(
                          gradient: LinearGradient(
                            colors: [
                              HexColor("#E123CC"),
                              HexColor("#16CCF7"),
                              HexColor("#FFB001"),
                            ],
                          ),
                          width: 1.5,
                        ),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.translate('more')!,
                        style: styleW600(
                          context,
                          fontSize: 10,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const NoData(
              ),
//const TopOfTheClapsWidget()
            ],
          ),
        ),
      ),
    );
  }
}

class TopOfTheClapsWidget extends StatelessWidget {
  const TopOfTheClapsWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        right: 30,
      ),
      child: Column(
        children: [
          for (int i = 0; i < 100; i++)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  Container(
                    height: 60,
                    width: 60,
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
                            HexColor("#DC29E3"),
                            HexColor("#C38EF9"),
                            HexColor("#5D8DFA"),
                          ],
                        ),
                        width: 1.5,
                      ),
                    ),
                    child: SvgPicture.asset(
                      ImagesPath.playIconSvg,
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Amr Diab Live',
                        style: styleW600(context, fontSize: 18),
                      ),
                      Text(
                        'Amr Diab',
                        style: styleW600(
                          context,
                          fontSize: 10,
                          color: HexColor('#B3B3B3'),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Column(
                    children: [
                      SvgPicture.asset(ImagesPath.viewsIconSvg),
                      Text(
                        '55.5k',
                        style: styleW600(
                          context,
                          fontSize: 10,
                          color: HexColor('#B3B3B3'),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                    ),
                    height: 20,
                    child: const VerticalDivider(
                      color: Colors.white,
                      width: 2,
                    ),
                  ),
                  Column(
                    children: [
                      SvgPicture.asset(
                        ImagesPath.groupPeopleIconSvg,
                      ),
                      Text(
                        '55.5k',
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
      ),
    );
  }
}

class PeopleLiveStreamList extends StatefulWidget {
  const PeopleLiveStreamList({
    Key? key,
  }) : super(key: key);

  @override
  State<PeopleLiveStreamList> createState() => _PeopleLiveStreamListState();
}

class _PeopleLiveStreamListState extends State<PeopleLiveStreamList> {
  Future<void> _getLiveUsers() =>
      BlocProvider.of<LiveUsersCubit>(context).getLiveUsers(
        context: context,
        accessToken: context.read<LoginCubit>().authenticatedUser!.accessToken!,
      );

  @override
  Widget build(BuildContext context) {
    const state = LiveUsersState;
    state is CreateUserIsLiveSuccess
        ? {
            Future.delayed(const Duration(seconds: 1), () {
              log('Delayed action executed after pop');
              _getLiveUsers();
            }),
          }
        : null;
    return BlocBuilder<LiveUsersCubit, LiveUsersState>(
      builder: (context, state) {
        if (state is LiveUsersLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is LiveUsersSuccess) {
          final liveUsers = BlocProvider.of<LiveUsersCubit>(context).liveUsers;
          return SizedBox(
            height: 120,
            child: liveUsers!.users!.isEmpty
                ? Center(
                    child: Text(
                      AppLocalizations.of(context)!
                          .translate('no_live_streams')!,
                      style: const TextStyle(fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: liveUsers.users!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context, rootNavigator: true).push(
                            MaterialPageRoute(
                              builder: (context) => LivePage(
                                liveID: liveUsers.users![index].id!.toString(),
                              ),
                            ),
                          );
                        },
                        child: Padding(
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
                                child: CircleAvatar(
                                  radius: 25,
                                  backgroundImage: NetworkImage(
                                    liveUsers.users![index].artworkUrl!,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Center(
                                child: Text(
                                  liveUsers.users![index].username!,
                                  style: styleW400(context, fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          );
        } else if (state is LiveUsersError) {
          return Column(
            children: [
              Text(
                state.message,
              ),
              Container(
                width: context.width * 0.55,
                margin: const EdgeInsets.symmetric(vertical: 15),
                child: GradientCenterTextButton(
                  buttonText:
                      AppLocalizations.of(context)!.translate('try_again'),
                  listOfGradient: [
                    HexColor("#DF23E1"),
                    HexColor("#3820B2"),
                    HexColor("#39BCE9"),
                  ],
                  onTap: () {
                    _getLiveUsers();
                  },
                ),
              ),
            ],
          );
        } else {
          return const Center(
            child: NoData(),
          );
        }
      },
    );
  }
}

class LiveStreamBar extends StatelessWidget {
  const LiveStreamBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox(),
        Text(
          AppLocalizations.of(context)!.translate('live_stream')!,
          style: styleW700(context, fontSize: 18),
        ),
        if (context.read<ProfileCubit>().userProfileData != null &&
            context
                    .read<ProfileCubit>()
                    .userProfileData!
                    .user!
                    .subscription!
                    .serviceId ==
                '1')
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(),
              GestureDetector(
                onTap: () {
                  context.read<TabCubit>().changeTab(4);
                },
                child: Image.asset(ImagesPath.premiumImage),
              ),
            ],
          )
        else
          const SizedBox(),
        // Container(
        //   padding: const EdgeInsets.symmetric(
        //     horizontal: 10,
        //     vertical: 4,
        //   ),
        //   decoration: BoxDecoration(
        //     borderRadius: BorderRadius.circular(AppRadius.pSmall),
        //     color: HexColor('#FFB00136'),
        //   ),
        //   child:

        //    Row(
        //     children: [
        //       // subscriptionIconSvg
        //       SvgPicture.asset(
        //         ImagesPath.subscriptionIconSvg,
        //         color: HexColor('#FFB001'),
        //       ),
        //       const SizedBox(
        //         width: 4,
        //       ),
        //       Text(
        //         'premium',
        //         overflow: TextOverflow.ellipsis,
        //         style: styleW500(
        //           context,
        //           fontSize: 14,
        //           color: HexColor('#FFB001'),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
      ],
    );
  }
}
