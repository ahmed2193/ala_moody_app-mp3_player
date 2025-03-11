import 'package:alamoody/core/utils/back_arrow.dart';
import 'package:alamoody/core/utils/constants.dart';
import 'package:alamoody/core/utils/controllers/main_controller.dart';
//import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:alamoody/core/utils/media_query_values.dart';
import 'package:alamoody/core/utils/navigator_reuse.dart';
import 'package:alamoody/features/plan_details/presentation/screen/following_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../config/locale/app_localizations.dart';
import '../../../../core/components/reused_background.dart';
import '../../../../core/helper/font_style.dart';
import '../../../../core/helper/images.dart';
import '../../../../injection_container.dart' as di;
import '../../../auth/presentation/cubit/login/login_cubit.dart';
import '../../../auth/presentation/screen/reset_password_screen.dart';
import '../../../profile/presentation/cubits/profile/profile_cubit.dart';
import '../../../profile/presentation/cubits/update_profile/update_profile_cubit.dart';
import '../../../profile/presentation/screens/edit_profile_info_screen.dart';
import '../../../settings/presentation/screen/settings_screen.dart';

class AccountSettingsScreen extends StatelessWidget {
  const AccountSettingsScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final List<AccountData> accountData = [
      AccountData(
        title: AppLocalizations.of(context)!.translate("update_profile")!,
        iconPath: ImagesPath.profileIcon,
        onTap: () {
          // Navigator.of(context, rootNavigator: true)
          //     .pushNamed(Routes.updteProfileRoute);
          pushNavigate(
              context,
              BlocProvider(
                create: (_) => di.sl<UpdateProfileCubit>(),
                child: const EditProfileInfoScreen(),
              ),
              rootNavigator: true,);
        },
      ),
      // AccountData(
      //   title: AppLocalizations.of(context)!.translate("your_plan_details")!,
      //   iconPath: ImagesPath.subscriptionIconpng,
      //   onTap: () {
      //     pushNavigate(context, PlanDetailsScreen(con: con!));
      //   },
      // ),
      // AccountData(
      //   title: AppLocalizations.of(context)!.translate("following")!,
      //   iconPath: ImagesPath.followersIconpng,
      //   onTap: () {
      //     pushNavigate(context, FollowingScreen(con: con!));
      //   },
      // ),

      // TermAndcondition
      AccountData(
        title:
            AppLocalizations.of(context)!.translate("purchased_plan_details")!,
        iconPath: ImagesPath.purchasedPlanIcon,
        onTap: () {
          pushNavigate(context, const PlanDetailsScreen());
          // pushNavigateAndRemoveUntil(context, const App(index: 4,));
        },
      ),
      // AccountData(
      //   title: AppLocalizations.of(context)!.translate("unsubscribe_plan")!,
      //   iconPath: ImagesPath.unsubscribeIcon,
      //   onTap: () {
      //     Constants.unsubscribePlanDialog(context);
      //   },
      // ),
      AccountData(
        title: AppLocalizations.of(context)!.translate("app_settings")!,
        iconPath: ImagesPath.settingIconSvg,
        onTap: () {
          pushNavigate(context, const SettingsScreen());
        },
      ),
      AccountData(
        title: AppLocalizations.of(context)!.translate("terms_and_conditions")!,
        iconPath: ImagesPath.termConditionIcon,
        onTap: () {
          Navigator.of(context, rootNavigator: true).push(
            MaterialPageRoute(
              builder: (context) => const TermAndcondition(),
            ),
          );
        },
      ),
      AccountData(
        title: AppLocalizations.of(context)!.translate("privacy_policy")!,
        iconPath: ImagesPath.privacyIcon,
        onTap: () {
          Navigator.of(context, rootNavigator: true).push(
            MaterialPageRoute(
              builder: (context) => const ParivacyPolicy(),
            ),
          );
        },
      ),
      AccountData(
        title: AppLocalizations.of(context)!.translate("change_password")!,
        iconPath: ImagesPath.passwordIconSvg,
        onTap: () {
          Navigator.of(context, rootNavigator: true).push(
            MaterialPageRoute(
              builder: (context) => const ResetPasswordScreen(),
            ),
          );
        },
      ),
      AccountData(
        title: AppLocalizations.of(context)!.translate("delete_account")!,
        iconPath: ImagesPath.deleteAccountoIcon,
        onTap: () {
          Constants.deleteAccountDialog(context);
        },
      ),
      AccountData(
        title: AppLocalizations.of(context)!.translate("log_out")!,
        iconPath: ImagesPath.logoutcurve,
        onTap: () {
          Constants.showLogoutDialog(context);
        },
      ),
    ];
    final user = context.read<ProfileCubit>().userProfileData!.user!;
    return MultiBlocListener(
      listeners: [
        BlocListener<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state is UnAuthenticated) {
              Provider.of<MainController>(context, listen: false).closePlayer();
            }
          },
        ),
      ],
      child: Scaffold(
        body: ReusedBackground(
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 15),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const BackArrow(),
                    Center(
                      child: Text(
                        AppLocalizations.of(context)!
                            .translate("account_settings")!,
                        style: styleW700(context)!.copyWith(fontSize: 20),
                      ),
                    ),
                    SizedBox(
                      width: context.height * 0.017,
                    ),
                  ],
                ),
                SizedBox(
                  height: context.height * 0.017,
                ),
                InkWell(
                  onTap: () {
                    pushNavigate(
                        context,
                        BlocProvider(
                          create: (_) => di.sl<UpdateProfileCubit>(),
                          child: const EditProfileInfoScreen(),
                        ),
                        rootNavigator: true,);
                  },
                  child: Center(
                    child: CircleAvatar(
                      radius: 58,
                      backgroundColor: Colors.white,
                      child: ClipOval(
                        child: user.image! == null
                            ? Image.asset(
                                ImagesPath.defaultUserIcon,
                                width: MediaQuery.of(context).size.width *
                                    0.29, // Adjust as needed
                                height:
                                    MediaQuery.of(context).size.width * 0.29,
                                fit: BoxFit.cover,
                              )
                            : CachedNetworkImage(
                                imageUrl:
                                    user.image!, // Default placeholder URL
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator(),
                                errorWidget: (
                                  context,
                                  url,
                                  error,
                                ) =>
                                    Image.asset(
                                  ImagesPath.defaultUserIcon,
                                ), // Local error image asset
                                fit: BoxFit.cover,
                                width: MediaQuery.of(context).size.width *
                                    0.29, // Adjust as needed
                                height:
                                    MediaQuery.of(context).size.width * 0.29,
                              ),
                      ),
                    ),

                    //                    CircleAvatar(
                    //                 radius: 58,
                    //                 backgroundColor: Colors.white,
                    //                 child:

                    //                  ClipOval(
                    //                   child:

                    //                   user.image != null
                    //                       ?
                    //                       SvgPicture.asset(
                    //         ImagesPath.playerIcon6,
                    // width: MediaQuery.of(context).size.width *
                    //                               0.29, // Adjust as needed
                    //                           height: MediaQuery.of(context).size.width * 0.29,
                    //                                                         fit: BoxFit.cover,
                    //       )

                    //                       : CachedNetworkImage(
                    //                           imageUrl: user.image!, // Default placeholder URL
                    //                           placeholder: (context, url) =>
                    //                               CircularProgressIndicator(),
                    //                           errorWidget: (context, url, error) => Image.asset(
                    //                               ImagesPath
                    //                                   .defaultUserIcon), // Local error image asset
                    //                           fit: BoxFit.cover,
                    //                           width: MediaQuery.of(context).size.width *
                    //                               0.29, // Adjust as needed
                    //                           height: MediaQuery.of(context).size.width * 0.29,
                    //                         ),
                    //                 ),
                    //               )),
                  ),
                ),
                SizedBox(
                  height: context.height * 0.012,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: InkWell(
                    onTap: () {
                      // Navigator.of(context, rootNavigator: true)
                      //     .pushNamed(Routes.updteProfileRoute);
                      pushNavigate(
                          context,
                          BlocProvider(
                            create: (_) => di.sl<UpdateProfileCubit>(),
                            child: const EditProfileInfoScreen(),
                          ),
                          rootNavigator: true,);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Text(
                              user.username!,
                              style: styleW600(context)!.copyWith(fontSize: 18),
                            ),
                            Text(
                              user.name!,
                              style: styleW600(context)!
                                  .copyWith(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.edit,
                            color:
                                Theme.of(context).textTheme.labelLarge!.color,
                            size: 18,
                          ),
                          onPressed: () {
                            // Navigator.of(context, rootNavigator: true)
                            //     .pushNamed(Routes.updteProfileRoute);

                            pushNavigate(
                                context,
                                BlocProvider(
                                  create: (_) => di.sl<UpdateProfileCubit>(),
                                  child: const EditProfileInfoScreen(),
                                ),
                                rootNavigator: true,);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: context.height * 0.017,
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(bottom: 40),
                    itemCount: accountData.length,
                    itemBuilder: (context, index) {
                      return SettingListItem(
                        accountData: accountData[index],
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: context.height * 0.097,
                ),
                // for (int i = 0; i < accountData.length; i++)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SettingListItem extends StatelessWidget {
  const SettingListItem({required this.accountData, super.key});
  final AccountData accountData;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: accountData.onTap,
      child: Row(
        children: [
          if (accountData.iconPath.contains('.svg'))
            SizedBox(
              width: 30,
              child: SvgPicture.asset(
                accountData.iconPath,
                color: Theme.of(context).iconTheme.color,
              ),
            )
          else
            SizedBox(
              width: 30,
              child: Image.asset(
                accountData.iconPath,
                height: 23,
                width: 23,
                color: Theme.of(context).iconTheme.color,
              ),
            ),
          // const SizedBox(width: 15),
          Text(
            accountData.title,
            style: styleW400(context),
          ),
        ]
            .map(
              (e) => Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 5,
                ),
                child: e,
              ),
            )
            .toList(),
      ),
    );
  }
}

class AccountData {
  final String iconPath;
  final String title;
  final VoidCallback onTap;

  AccountData({
    required this.iconPath,
    required this.title,
    required this.onTap,
  });
}

class TermAndcondition extends StatelessWidget {
  const TermAndcondition({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.translate("terms_and_conditions")!,
        ),
        centerTitle: true,
        leading: const BackArrow(),
      ),
      body: const SafeArea(
        child: CustomWebView(
          url: 'https://alamoody.webtekdemo.com/page/term-and-condition',
        ),
      ),
    );
  }
}

class ParivacyPolicy extends StatelessWidget {
  const ParivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.translate("privacy_policy")!),
        centerTitle: true,
        leading: const BackArrow(),
      ),
      body: const SafeArea(
        child: CustomWebView(
          url: 'https://alamoody.webtekdemo.com/page/privacy-policy',
        ),
      ),
    );
  }
}

class CustomWebView extends StatefulWidget {
  final String url;

  const CustomWebView({
    Key? key,
    required this.url,
  }) : super(key: key);

  @override
  _CustomWebViewState createState() => _CustomWebViewState();
}

class _CustomWebViewState extends State<CustomWebView> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(controller: _controller);
  }
}
