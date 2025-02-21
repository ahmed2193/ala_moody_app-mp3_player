import 'dart:convert';
import 'dart:developer';

import 'package:alamoody/core/helper/print.dart';
import 'package:alamoody/core/models/artists_model.dart';
import 'package:alamoody/notification_service.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

import '../../../../config/locale/app_localizations.dart';
import '../../../../core/artist_details.dart';
import '../../../../core/components/reused_background.dart';
import '../../../../core/helper/ad_helper.dart';
import '../../../../core/helper/images.dart';
import '../../../../core/models/song_share_model.dart';
import '../../../../core/utils/bottom_nav_bar/persistent-tab-view.dart';
import '../../../../core/utils/controllers/main_controller.dart';
import '../../../../core/utils/hex_color.dart';
import '../../../../core/utils/navigator_reuse.dart';
import '../../../../core/utils/player/bottom_play_widget.dart';
import '../../../auth/presentation/cubit/login/login_cubit.dart';
import '../../../download_songs/presentation/cubit/download_cubit.dart';
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

class App extends StatefulWidget {
  const App({
    Key? key,
  }) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
  // PersistentTabController controller = PersistentTabController();
  InterstitialAd? _interstitialAd;
  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
  List<SongsShareData>? songs = [];
  Uri? deepLink;
  late bool isSub;

  MainController? con;
  late final NotificationService _notificationService;

  Future<void> initDynamicLinks() async {
    // log('initDynamicLinks');

    final FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;

    dynamicLinks.onLink.listen((dynamicLinkData) {
      songs!.clear();
      final Uri deepLink = dynamicLinkData.link;
      final String? screenName =
          deepLink.pathSegments.isNotEmpty ? deepLink.pathSegments[0] : null;

      printColored(screenName! * 1000);
      final shareDataEncoded = deepLink.queryParameters['parameters'];
      log('Initial link encoded parameters: $shareDataEncoded');
      if (shareDataEncoded != null) {
        try {
          final String decodedString = Uri.decodeComponent(shareDataEncoded);
          final Map<String, dynamic> songsShareDataMap =
              json.decode(decodedString);
          if (screenName.contains('artistDetails')) {
            final ArtistsModel songsShareData =
                ArtistsModel.fromJson(songsShareDataMap);
            pushNavigate(
              context,
              ArtistDetails(
                artist: songsShareData,
              ),
            );
          } else

          // log('Initial link decoded parameters: $decodedString');

          {
            final SongsShareData songsShareData =
                SongsShareData.fromJson(songsShareDataMap);

            songs!.add(songsShareData);
            // log('start playing' * 1000);
            con!.playSong(
              con!.convertToAudio(songs!),
              0,
            );
          }
        } catch (e) {
          log('Error decoding JSON: $e');
        }
      }
    }).onError((error) {
      log('onLink error: ${error.message}');
    });

    final PendingDynamicLinkData? data = await dynamicLinks.getInitialLink();
    deepLink = data?.link;
    final String? screenName =
        (deepLink != null && deepLink!.pathSegments.isNotEmpty)
            ? deepLink!.pathSegments[0]
            : null;

    // printColored(screenName! * 1000);
    if (deepLink != null) {
      songs!.clear();
      final shareDataEncoded = deepLink!.queryParameters['parameters'];
      log('Initial link encoded parameters: $shareDataEncoded');

      if (shareDataEncoded != null) {
        try {
          final String decodedString = Uri.decodeComponent(shareDataEncoded);
          final Map<String, dynamic> songsShareDataMap =
              json.decode(decodedString);
          if (screenName!.contains('artistDetails')) {
            final ArtistsModel songsShareData =
                ArtistsModel.fromJson(songsShareDataMap);
            pushNavigate(
              context,
              ArtistDetails(
                artist: songsShareData,
              ),
            );
          } else

          // log('Initial link decoded parameters: $decodedString');

          {
            final SongsShareData songsShareData =
                SongsShareData.fromJson(songsShareDataMap);

            songs!.add(songsShareData);
            // log('start playing' * 1000);
            con!.playSong(
              con!.convertToAudio(songs!),
              0,
            );
          }

          // setState(() {

          //   isFirsOpenDynamic = true;
          // });
        } catch (e) {
          log('Error decoding initial link JSON: $e');
        }
      }
    } else {
      con!.init();
    }
  }

  @override
  void initState() {
    con = Provider.of<MainController>(context, listen: false);
    initDynamicLinks();
    _notificationService = NotificationService();
    _notificationService.initializeLocalNotifications(context);
    // _notificationService.handleIncomingMessages(
    //   context,
    // );
    context.read<TabCubit>().controller.index == 4
        ? isSub = true
        : isSub = false;
    _getDownloadsData();
    context.read<ProfileCubit>().userProfileData != null &&
            context
                    .read<ProfileCubit>()
                    .userProfileData!
                    .user!
                    .subscription!
                    .serviceId ==
                '1'
        ? _createInterstitialAd()
        : null;
    // controller.jumpToTab(widget.index!);
    super.initState();
    // WidgetsBinding.instance!.addPostFrameCallback((_) {
    //   final MainController con = context.read<MainController>();
    //   if (sharedata != null && songs!.isNotEmpty) {
    //     con.playSong(
    //       con.convertShareDataToAudio(songs!),
    //       0,
    //     );
    //   } else {
    //     if (widget.index == 0) {
    //       return con.init();
    //     }
    //   }
    // });
  }

  @override
  void dispose() {
    _interstitialAd?.dispose();
    // Unregister the observer
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final MainController con = context.read<MainController>();
    if (state == AppLifecycleState.detached ||
        state == AppLifecycleState.paused) {
      con.closePlayer(); // Close the player and dismiss notification when app is closed
    }
  }

  Future<void> _getDownloadsData() async {
    await BlocProvider.of<DownloadCubit>(context)
        .getSavedDownloads()
        .then((value) {});
  }

  void _createInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
        },
        onAdFailedToLoad: (LoadAdError error) {
          log(error.toString());
          _interstitialAd = null;
          _createInterstitialAd();
        },
      ),
    );
  }

  void _showInterstitialAd(MainController controller) {
    if (_interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (InterstitialAd ad) {
          controller.player.play();
          ad.dispose();
          _createInterstitialAd();
        },
        onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
          controller.player.play();
          ad.dispose();
          _createInterstitialAd();
        },
      );
      controller.player.pause();
      _interstitialAd!.show();
    }
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

  List<Widget> _buildScreens(con) {
    return [
      const HomeScreen(),
      SearchScreen(con: con),
      const LibraryScreen(),
      const LiveStreamScreen(),
      const PlanScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// Background image without SafeArea so it covers the whole screen
          const ReusedBackground(
            lightBG: ImagesPath.homeBGLightBG,
          ),

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
                                    isRadioStream
                                        ? null
                                        : {
                                            if (context
                                                    .read<ProfileCubit>()
                                                    .userProfileData!
                                                    .user!
                                                    .subscription!
                                                    .serviceId ==
                                                '1')
                                              _showInterstitialAd(con!)
                                            else
                                              null,
                                            Navigator.push(
                                              context,
                                              CupertinoPageRoute(
                                                builder: (context) => Material(
                                                  child: PlayerScreen(
                                                    con: con!,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          };
                                  },
                                );
                              },
                            ),
                    ),
              screens: _buildScreens(con),
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

      // ),
    );
  }
}

class DynamicLinkScreen extends StatelessWidget {
  const DynamicLinkScreen(this.song, {super.key});
  final SongsShareData song;
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Hello World DeepLink'),
        ),
        body: Center(
          child: Text('Custom Data: ${song.title} (ID: ${song.id})'),
        ),
      ),
    );
  }
}
