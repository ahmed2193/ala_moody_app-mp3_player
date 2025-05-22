import 'dart:developer';

import 'package:alamoody/dynamic_link_handler.dart';
import 'package:alamoody/features/ads/presentation/screens/ads_screen.dart';
import 'package:alamoody/features/membership/presentation/cubit/coupon_cubit/coupon_cubit.dart';
import 'package:alamoody/features/membership/presentation/cubit/plan_cubit.dart';
import 'package:alamoody/notification_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../config/locale/app_localizations.dart';
import '../../../../core/components/reused_background.dart';
import '../../../../core/helper/ad_helper.dart';
import '../../../../core/helper/images.dart';
import '../../../../core/utils/bottom_nav_bar/persistent-tab-view.dart';
import '../../../../core/utils/controllers/main_controller.dart';
import '../../../../core/utils/hex_color.dart';
import '../../../../core/utils/player/bottom_play_widget.dart';
import '../../../auth/presentation/cubit/login/login_cubit.dart';
import '../../../home/presentation/screens/home_screen.dart';
import '../../../library/presentation/screens/library_screen.dart';
import '../../../live_stream/presentation/cubits/live_users/live_users_cubit.dart';
import '../../../live_stream/presentation/screen/live_straem_screen.dart';
import '../../../membership/presentation/screen/plan_screen.dart';
import '../../../player/presentation/screens/players_screen.dart';
import '../../../profile/presentation/cubits/profile/profile_cubit.dart';
import '../../../search/presentation/screens/search_screen.dart';
import '../../cubit/tab_cubit.dart';
import '../widgets/active_color_widget.dart';

const int maxFailedLoadAttempts = 3;

class MainLayoutScreen extends StatefulWidget {
  const MainLayoutScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<MainLayoutScreen> createState() => _AppState();
}

class _AppState extends State<MainLayoutScreen> with WidgetsBindingObserver {
  // InterstitialAd? _interstitialAd;

  late bool isSub;

  MainController? con;
  late final NotificationService _notificationService;
  int _playWidgetClickCount = 0;
  bool _isFirstPlayClickSinceAppOpen = true; // New flag

  @override
  void initState() {
    super.initState();
    context.read<TabCubit>().controller.index == 4
        ? isSub = true
        : isSub = false;
    con = Provider.of<MainController>(context, listen: false);
    con!.preventDispose = false;

    DynamicLinkHandler(con, context).initDynamicLinks();
    _notificationService = NotificationService();
    _notificationService.initializeLocalNotifications(context);

    Future.microtask(() async {
      if (context
              .read<ProfileCubit>()
              .userProfileData
              ?.user
              ?.subscription
              ?.serviceId ==
          '1') {}
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final MainController con = context.read<MainController>();
    if (state == AppLifecycleState.detached ||
        state == AppLifecycleState.paused) {
      con.closePlayer();
    }
  }

  void _showInterstitialAd(MainController controller) {
    controller.player.pause();
    Navigator.of(context).push(MaterialPageRoute(
        fullscreenDialog: true, builder: (context) => FullScreenAds()));
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: ActiveIconContainer(
          child: SvgPicture.asset(
            fit: BoxFit.scaleDown,
            ImagesPath.homeIconSvg,
            color: Colors.white,
          ),
        ),
        inactiveIcon: SizedBox(
          width: 40,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                fit: BoxFit.scaleDown,
                ImagesPath.homeIcon,
                color: Colors.white,
              ),
              Container(
                width: 45,
                padding: const EdgeInsets.symmetric(vertical: 3.0),
                child: Text(
                  AppLocalizations.of(context)!.translate('home_screen')!,
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        activeColorSecondary: Colors.white,
        activeColorPrimary: Colors.white,
      ),
      PersistentBottomNavBarItem(
        icon: ActiveIconContainer(
          child: SvgPicture.asset(
            fit: BoxFit.scaleDown,
            ImagesPath.searchIconSvg,
            color: Colors.white,
          ),
        ),
        inactiveIcon: SizedBox(
          width: 40,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: SvgPicture.asset(
                  ImagesPath.searchIconSvg,
                  height: 20,
                  width: 20,
                ),
              ),
              Container(
                width: 70,
                padding: const EdgeInsets.symmetric(vertical: 3.0),
                child: Text(
                  AppLocalizations.of(context)!.translate('search')!,
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        activeColorSecondary: Colors.white,
        activeColorPrimary: Colors.white,
      ),
      PersistentBottomNavBarItem(
        icon: ActiveIconContainer(
          child: SvgPicture.asset(
            fit: BoxFit.scaleDown,
            ImagesPath.playlistIconSvg,
            color: Colors.white,
          ),
        ),
        inactiveIcon: SizedBox(
          width: 40,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: SvgPicture.asset(
                  ImagesPath.playlistIconSvg,
                  height: 20,
                  width: 20,
                ),
              ),
              Container(
                width: 70,
                padding: const EdgeInsets.symmetric(vertical: 3.0),
                child: Text(
                  AppLocalizations.of(context)!.translate('library')!,
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        activeColorSecondary: Colors.white,
        activeColorPrimary: Colors.white,
      ),
      PersistentBottomNavBarItem(
        icon: ActiveIconContainer(
          child: SvgPicture.asset(
            fit: BoxFit.scaleDown,
            ImagesPath.liveIconSvg,
            color: Colors.white,
          ),
        ),
        inactiveIcon: SizedBox(
          width: 40,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: SvgPicture.asset(
                  ImagesPath.liveIconSvg,
                  height: 20,
                  width: 20,
                ),
              ),
              Container(
                width: 70,
                padding: const EdgeInsets.symmetric(vertical: 3.0),
                child: Text(
                  AppLocalizations.of(context)!.translate('live_stream')!,
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(color: Colors.white),
                  overflow: TextOverflow.fade,
                ),
              ),
            ],
          ),
        ),
        activeColorSecondary: Colors.white,
        activeColorPrimary: Colors.white,
      ),
      PersistentBottomNavBarItem(
        icon: ActiveIconContainer(
          child: SvgPicture.asset(
            fit: BoxFit.scaleDown,
            ImagesPath.subscriptionIconSvg,
            color: Colors.white,
          ),
        ),
        inactiveIcon: SizedBox(
          width: 40,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: SvgPicture.asset(
                  ImagesPath.subscriptionIconSvg,
                  height: 20,
                  width: 20,
                ),
              ),
              Container(
                width: 70,
                padding: const EdgeInsets.symmetric(vertical: 3.0),
                child: Text(
                  AppLocalizations.of(context)!.translate('subscription')!,
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        activeColorSecondary: Colors.white,
        activeColorPrimary: Colors.white,
      ),
    ];
  }

  List<Widget> _buildScreens() {
    final tabCubit = context.read<TabCubit>();
    return [
      Navigator(
        key: tabCubit.navigatorKeys[0],
        onGenerateRoute: (settings) => MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      ),
      Navigator(
        key: tabCubit.navigatorKeys[1],
        onGenerateRoute: (settings) => MaterialPageRoute(
          builder: (context) => const SearchScreen(),
        ),
      ),
      Navigator(
        key: tabCubit.navigatorKeys[2],
        onGenerateRoute: (settings) => MaterialPageRoute(
          builder: (context) => const LibraryScreen(),
        ),
      ),
      Navigator(
        key: tabCubit.navigatorKeys[3],
        onGenerateRoute: (settings) => MaterialPageRoute(
          builder: (context) => const LiveStreamScreen(),
        ),
      ),
      Navigator(
        key: tabCubit.navigatorKeys[4],
        onGenerateRoute: (settings) => MaterialPageRoute(
          builder: (context) => const PlanScreen(),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final tabCubit = context.read<TabCubit>();
        final currentIndex = tabCubit.controller.index;
        final currentKey = tabCubit.navigatorKeys[currentIndex];

        if (currentKey.currentState?.canPop() ?? false) {
          currentKey.currentState!.pop();
          return false;
        }
        return true;
      },
      child: Scaffold(
        body: Stack(
          children: [
            const ReusedBackground(),
            SafeArea(
              child: PersistentTabView(
                context,
                controller: context.read<TabCubit>().controller,
                onItemSelected: (value) {
                  context.read<TabCubit>().changeTab(value);
                  log(value.toString());
                  if (value == 3) {
                    BlocProvider.of<LiveUsersCubit>(context).getLiveUsers(
                      context: context,
                      accessToken: context
                          .read<LoginCubit>()
                          .authenticatedUser!
                          .accessToken!,
                    );
                  }
                  setState(() {
                    if (value != 4) {
                      isSub = false;
                    } else {
                      isSub = true;
                    }
                  });

                  if (value == 4) {
                    BlocProvider.of<CouponCubit>(context)
                        .couponFocusNode
                        .unfocus();
                    BlocProvider.of<CouponCubit>(context)
                        .couponController
                        .clear();
                    // final subscription = context
                    //     .read<ProfileCubit>()
                    //     .userProfileData
                    //     ?.user
                    //     ?.subscription;
                    context.read<PlanCubit>().setInitialSubscriptionState(
                          clear: true,
                          subscribedPlanId:
                              BlocProvider.of<ProfileCubit>(context)
                                  .userProfileData!
                                  .user!
                                  .subscription
                                  ?.serviceId,
                          subscribedPlanName:
                              BlocProvider.of<ProfileCubit>(context)
                                  .userProfileData!
                                  .user!
                                  .subscription
                                  ?.planName,
                        );
                  } else {
                    FocusScope.of(context).unfocus();
                  }
                },
                playWidget: isSub
                    ? const SizedBox()
                    : Material(
                        child: con!.player == null
                            ? const SizedBox()
                            : StreamBuilder<SequenceState?>(
                                stream: con!.player.sequenceStateStream,
                                builder: (context, snapshot) {
                                  final state = snapshot.data;
                                  if (state?.sequence.isEmpty ?? true) {
                                    return const SizedBox();
                                  }

                                  final currentSource = state!.currentSource;

                                  final isRadioStream =
                                      currentSource is UriAudioSource &&
                                          currentSource.uri
                                              .toString()
                                              .contains('stream');
                                  return PlayWidget(
                                    con: con!,
                                    onTap: () {
                                      if (isRadioStream) {
                                        return null; // Or handle radio stream separately
                                      }

                                      // Check if it's the very first click since app open
                                      if (_isFirstPlayClickSinceAppOpen && context
                                              .read<ProfileCubit>()
                                              .userProfileData
                                              ?.user
                                              ?.subscription
                                              ?.serviceId ==
                                          '1') {
                                        _isFirstPlayClickSinceAppOpen =
                                            false; // Set flag to false
                                        _playWidgetClickCount =
                                            0; // Reset counter for the 3-click cycle

                                        _showInterstitialAd(con!);

                                        return; // Exit early
                                      }

                                      // For subsequent clicks, apply the 3-click ad logic
                                      _playWidgetClickCount++;

                                      if (context
                                              .read<ProfileCubit>()
                                              .userProfileData
                                              ?.user
                                              ?.subscription
                                              ?.serviceId ==
                                          '1') {
                                        if (_playWidgetClickCount % 3 == 0) {
                                          _showInterstitialAd(con!);
                                        } else {
                                          Navigator.push(
                                            context,
                                            CupertinoPageRoute(
                                              builder: (context) => Material(
                                                child: PlayerScreen(con: con!),
                                              ),
                                            ),
                                          );
                                        }
                                      } else {
                                        // If not serviceId '1' or not subscribed, navigate to PlayerScreen
                                        Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                            builder: (context) => Material(
                                              child: PlayerScreen(con: con!),
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                  );
                                },
                              ),
                      ),
                screens: _buildScreens(),
                items: _navBarsItems(),
                backgroundColor: HexColor('#1B0E3E'),
                hideNavigationBarWhenKeyboardShows: false,
                navBarHeight: 200,
                bottomScreenMargin: 8.0,
                padding: const NavBarPadding.all(20),
                confineInSafeArea: false,
                stateManagement: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
