import 'dart:developer';
import 'dart:io' show Platform;

import 'package:alamoody/core/utils/constants.dart';
import 'package:alamoody/core/utils/navigator_reuse.dart';
import 'package:alamoody/features/auth/presentation/cubit/login/login_cubit.dart';
import 'package:alamoody/features/auth/presentation/screen/login_screen.dart';
import 'package:alamoody/features/auth/presentation/screen/login_with_phone_number_scree.dart';
import 'package:alamoody/features/main_layout/presentation/pages/main_layout_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../../config/locale/app_localizations.dart';
import '../../../../../config/themes/colors.dart';
import '../../../../../core/components/reused_background.dart';
import '../../../../../core/helper/app_size.dart';
import '../../../../../core/helper/font_style.dart';
import '../../../../../core/helper/images.dart';
import '../../../../../core/utils/hex_color.dart';
import '../../../../../core/utils/media_query_values.dart';
import '../../../../profile/presentation/cubits/profile/profile_cubit.dart';
import 'welcome_widgets/welcom_gradient_button.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  //   late Timer _timer;

  // _goNext() => Navigator.pushReplacementNamed(context, Routes.mainRoute);

  // @override
  // void initState() {
  //   super.initState();
  //   _goNext();
  // }

  // @override
  // void dispose() {
  //   _timer.cancel();
  //   super.dispose();
  // }
  final bool _credentialsIsRemembered = true;
  Map<String, dynamic>? _userData;

  signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser != null) {
      log(googleUser.email);
      log(googleUser.displayName!);
      log(googleUser.id);
      BlocProvider.of<LoginCubit>(context).loginWitSocialMedia(
        email: googleUser.email,
        displayName: googleUser.displayName!,
        isGoogle: 0,
        socialId: googleUser.id,
        credentialsIsSaved: _credentialsIsRemembered,
      );
    }
  }

  signInWithFaceBook() async {
    final LoginResult result = await FacebookAuth.instance.login();

    if (result.status == LoginStatus.success) {
      final userData = await FacebookAuth.instance.getUserData();
      _userData = userData;
      log(_userData!['name'].toString());
      log(_userData!['id'].toString());

      BlocProvider.of<LoginCubit>(context).loginWitSocialMedia(
        email: _userData!['email'],
        displayName: _userData!['name'],
        isGoogle: 1,
        socialId: _userData!['id'],
        credentialsIsSaved: _credentialsIsRemembered,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) async {
        if (state is Authenticated) {
          // Navigator.of(context).pushNamedAndRemoveUntil(
          //     Routes.mainRoute, (Route<dynamic> route) => false);
          await BlocProvider.of<ProfileCubit>(context).getUserProfile(
            accessToken:
                context.read<LoginCubit>().authenticatedUser!.accessToken!,
          );
                       pushNavigateAndRemoveUntil(context, const MainLayoutScreen());

     
        } else if (state is UnAuthenticated) {
          Constants.showToast(message: state.message);
        }
      },
      child: Scaffold(
        body: ReusedBackground(
          body: SafeArea(
            child: Stack(
              alignment: AlignmentDirectional.topEnd,
              children: [
                Center(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: context.height * .012,
                        ),
                        Image.asset(
                          ImagesPath.logoImage,
                          width: 200,
                        ),
                        Text(
                          AppLocalizations.of(context)!
                              .translate("play_your_millions")!,
                          style: styleW700(
                            context,
                            fontSize: FontSize.f26,
                          )!
                              .copyWith(
                            height: 1.2,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: context.height * .005,
                        ),
                        // google
                        // nav to login in debug
                        GradientRoundedButton(
                          buttonText: AppLocalizations.of(context)!
                              .translate('sign_in_for_free'),
                          startIcon: Image.asset(
                            ImagesPath.signUpForFreeIcon,
                            width: 28,
                          ),
                          listOfGradient: const [
                            AppColors.cViolet,
                            AppColors.cYellow,
                          ],
                          onTap: () {
                                         pushNavigateAndRemoveUntil(context, const LoginScreen());

                        
                          },
                        ),
                        // phone
                        GradientRoundedButton(
                          buttonText: AppLocalizations.of(context)!
                              .translate('continue_phone'),
                          onTap: () {
                            pushNavigateAndRemoveUntil(
                              context,
                              const LoginWithPhoneNumberScreen(),
                            );
                          },
                          startIcon: Image.asset(
                            ImagesPath.phoneIcon,
                            width: 28,
                          ),
                          listOfGradient: const [
                            AppColors.cPrimary,
                            AppColors.cViolet,
                          ],
                        ),
                        // //google
                        // GradientRoundedButton(
                        //   buttonText: AppLocalizations.of(context)!
                        //       .translate('continue_google'),
                        //   onTap: () {
                        //     BlocProvider.of<LoginCubit>(context)
                        //         .signInWithGoogle();
                        //   },
                        //   startIcon: Image.asset(
                        //     ImagesPath.googleIcon,
                        //     width: 28,
                        //   ),
                        //   circleAvatarColor: AppColors.cApple,
                        //   listOfGradient: [
                        //     HexColor("#020024"),
                        //     HexColor("#090979"),
                        //     Colors.black26,
                        //   ],
                        //   listOfGradientBorder: [
                        //     HexColor("#1943F4"),
                        //     HexColor("#CE0B24"),
                        //     HexColor("#201348"),
                        //   ],
                        // ),

                        // // facebook
                        // GradientRoundedButton(
                        //   onTap: () {
                        //     BlocProvider.of<LoginCubit>(context)
                        //         .signInWithFaceBook();
                        //   },
                        //   buttonText: AppLocalizations.of(context)!
                        //       .translate('continue_facebook'),
                        //   startIcon: Image.asset(
                        //     ImagesPath.facebookIcon,
                        //     width: 30,
                        //   ),
                        //   circleAvatarColor: Colors.transparent,
                        //   listOfGradient: const [
                        //     Color(0xff0052FF),
                        //     Color(0xff2FCEFF),
                        //   ],
                        // ),
                        // // apple
                        // if (Platform.isAndroid)
                        //   const SizedBox()
                        // else
                        //   GradientRoundedButton(
                        //     buttonText: AppLocalizations.of(context)!
                        //         .translate('continue_apple'),
                        //     onTap: () {},
                        //     startIcon: Image.asset(
                        //       ImagesPath.appleIcon,
                        //       width: 28,
                        //     ),
                        //     circleAvatarColor: AppColors.cApple,
                        //     listOfGradient: const [
                        //       Colors.black26,
                        //       Colors.black26,
                        //     ],
                        //     listOfGradientBorder: [
                        //       HexColor("#1943F4"),
                        //       HexColor("CE0B24"),
                        //     ],
                        //   ),
                      ]
                          .map(
                            // to make space after every element
                            (e) => Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: context.height * .008,
                                horizontal: context.width * .05,
                              ),
                              child: e,
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
                // need help button
                // Padding(
                //   padding: EdgeInsetsDirectional.only(
                //     end: context.width * .05,
                //   ),
                //   child: TextButton(
                //     style: TextButton.styleFrom(
                //       backgroundColor: AppColors.cOffWhite,
                //     ),
                //     child: Text(
                //       AppLocalizations.of(context)!.translate("need_help")!,
                //       style: styleW400(
                //         context,
                //         fontSize: FontSize.f14,
                //         color: Colors.black,
                //       ),
                //     ),
                //     onPressed: () {},
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
