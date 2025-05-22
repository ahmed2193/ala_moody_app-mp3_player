//import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:alamoody/core/utils/media_query_values.dart';
import 'package:alamoody/features/Playlists/presentation/screen/your_palyLists.dart';
import 'package:alamoody/features/account_seetings/presentation/screens/account_settings_screen.dart';
import 'package:alamoody/features/contact_us/presentation/screens/contact_us_screen.dart';
import 'package:alamoody/features/following/presentation/screens/following_screen.dart';
import 'package:alamoody/features/main_layout/cubit/tab_cubit.dart';
import 'package:alamoody/features/recently_play/presentation/screen/recently_play_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/locale/app_localizations.dart';
import '../../../../core/components/reused_background.dart';
import '../../../../core/helper/app_size.dart';
import '../../../../core/helper/images.dart';
import '../../../../core/utils/change_app_language.dart';
import '../../../../core/utils/navigator_reuse.dart';
import '../../../discover/presentation/screens/discover_screen.dart';
import '../../../download_songs/presentation/pages/downloads_screen.dart';
import '../../../favorites/presentation/screen/favorites_screen.dart';
import '../../../main/presentation/cubit/main_cubit.dart';
import '../widgets/reuse_listTile_of_drawer.dart';
import 'items/user_section.dart';

class DrawerScreen extends StatelessWidget {
  const DrawerScreen({Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ReusedBackground(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // back
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.arrow_back_ios_outlined,
                  color: Theme.of(context).iconTheme.color,
                ),
              ),
              const SizedBox(height: AppPadding.p10),
              // user info
              const UserSectionDrawer(),
              const SizedBox(height: AppPadding.pDefault),
              // all sections
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // browse music
                      
                      SectionOfDrawer(
                        topTitle: "browse_music",
                        items: [
                          ListTileOfDrawer(
                            colorCode: '#F44182',
                            imageOfLeading: ImagesPath.globalIconSvg,
                            title: 'discover',
                            onTap: () => pushNavigate(
                              context,
                              const DiscoverScreen(),
                            ),
                          ),
                          
                          ListTileOfDrawer(
                            colorCode: '#449FF3',
                            imageOfLeading: ImagesPath.musicIconSvg,
                            title: 'your_playlist',
                            onTap: () {
                              pushNavigate(
                                context,
                                const MyPlaylistsScreen(
                                ),
                              );
                            },
                          ),
                      
                          ListTileOfDrawer(
                            colorCode: '#22A465',
                            imageOfLeading: ImagesPath.languageIconSvg,
                            title: 'language',
                            onTap: () {
                              showModalBottomSheet(
                                        useSafeArea: true,
                                      useRootNavigator: true,
                                      
                               
                                elevation: 1,
                                context: context,
                                backgroundColor: Colors.black,
                                builder: (context) => const ChangeAppLanguage(
                                ),
                              );
                            },
                          ),
                          ListTileOfDrawer(
                            colorCode: '#00CBD8',
                            imageOfLeading: ImagesPath.userIconSvg,
                            title: 'profile',
                            onTap: () {
                              pushNavigate(
                                context,
                                const AccountSettingsScreen(),
                              );
                            },
                          ),
                        ],
                      ),

                      
                      SectionOfDrawer(
                        topTitle: "your_music",
                        items: [
                        
                          ListTileOfDrawer(
                            colorCode: '#22A465',
                            imageOfLeading: ImagesPath.downloadIconSvg,
                            title: 'download',
                            onTap: () => pushNavigate(
                              context,
                              const DownloadsScreen(),
                            ),
                            // Navigator.of(context, rootNavigator: true)
                            //     .pushNamed(Routes.downloadsRoute),
                          ),
                                      ListTileOfDrawer(
                            colorCode: '#449FF3',
                            imageOfLeading:ImagesPath.followersIconpng,
                            title: 'following',
                            onTap: () {
                           pushNavigate(context, const FollowingScreen());
                            },
                          ),
                          // favorite
                          ListTileOfDrawer(
                            colorCode: '#E939BE',
                            imageOfLeading: ImagesPath.favouriteIconSvg,
                            title: 'favorite',
                            onTap: () {
                              pushNavigate(
                                context,
                                const FavoriteScreen(
                                ),
                              );
                              //
                            },
                          ),
                          // history
                          ListTileOfDrawer(
                            colorCode: '#8453EC',
                            imageOfLeading: ImagesPath.historyIconSvg,
                            title: 'history',
                            onTap: () => pushNavigate(
                              context,
                              RecentlyPlayScreen(
                                headerTitle: AppLocalizations.of(context)!
                                    .translate('history')!,
                              ),
                            ),
                          ),
                          // Subscription Plan
                          // TODO: will add radio button after merge settings screen
                          ListTileOfDrawer(
                            onTap: () {
                          context
                                                .read<TabCubit>()
                                                .changeTab(4);
                            },
                            colorCode: '#E13F3F',
                            imageOfLeading: ImagesPath.subscriptionIconSvg,
                            title: 'subscription_plan',
                          ),
                          // support
                          ListTileOfDrawer(
                            colorCode: '#00CBD8',
                            imageOfLeading: ImagesPath.settingIconSvg,
                            title: 'support',
                            onTap: () {
                              Navigator.of(context, rootNavigator: true).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const ContactUsScreen(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      // other
                      SectionOfDrawer(
                        topTitle: "other",
                        items: [
                          // change theme
                          ListTileOfDrawer(
                            colorCode: '#8453EC',
                            imageOfLeading: ImagesPath.themeSvg,
                            title: 'change_theme',
                            onTap: () async {
                              await MainCubit.get(context).changeThem();
                              Navigator.of(context).pop();
                            },
                          ),
                 
                          // // your mood
                          // ListTileOfDrawer(
                          //   colorCode: '#FFBD43',
                          //   imageOfLeading: ImagesPath.moodIconSvg,
                          //   title: 'your_mood',
                          //   onTap: () {
                          //     pushNavigate(
                          //       context,
                          //       const MoodScreen(),
                          //     );
                          //     // Navigator.of(context, rootNavigator: true)
                          //     //     .pushNamed(Routes.moodsRoute);
                          //   },
                          // ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // privacy

              SizedBox(
                height: context.height * 0.129,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
