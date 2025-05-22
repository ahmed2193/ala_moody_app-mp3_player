import 'dart:io' show Platform;

import 'package:alamoody/core/helper/user_hive.dart';
import 'package:alamoody/core/utils/navigator_reuse.dart';
import 'package:alamoody/features/auth/presentation/cubit/forget_password/forget_password_cubit.dart';
import 'package:alamoody/features/auth/presentation/screen/forget_password_screen.dart';
import 'package:alamoody/features/auth/presentation/screen/login_with_phone_number_scree.dart';
import 'package:alamoody/features/auth/presentation/screen/register_screen.dart';
import 'package:alamoody/features/main/presentation/screens/auth_screens/data/models/remember_me_model.dart';
import 'package:alamoody/features/main_layout/presentation/pages/main_layout_screen.dart';
import 'package:alamoody/features/profile/presentation/cubits/profile/profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/helper/images.dart';
import '../../../../config/locale/app_localizations.dart';
import '../../../../config/themes/colors.dart';
import '../../../../core/components/reused_background.dart';
import '../../../../core/helper/app_size.dart';
import '../../../../core/helper/font_style.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/default_text_form_field/auth_textformfield.dart';
import '../../../../core/utils/default_text_form_field/validation_mixin.dart';
import '../../../../core/utils/hex_color.dart';
import '../../../../core/utils/loading_indicator.dart';
import '../../../../core/utils/media_query_values.dart';
import '../../../../injection_container.dart' as di;
import '../../../main/presentation/screens/welcome_screen/welcome_widgets/welcom_gradient_button.dart';
import '../cubit/login/login_cubit.dart';
import '../cubit/register/register_cubit.dart';
import '../widgets/gradient_auth_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with ValidationMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _credentialsIsRemembered = false;

  AutovalidateMode autovalidateMode(LoginState state) => state
          is LoginValidatation
      ? (state.isValidate ? AutovalidateMode.always : AutovalidateMode.disabled)
      : AutovalidateMode.disabled;

  @override
  void initState() {
    getRememberMeData();
    super.initState();
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) async {
        if (state is Authenticated) {
            // Provider.of<MainController>(context, listen: false)
            //             .loginPlayer();
   
          await BlocProvider.of<ProfileCubit>(context).getUserProfile(
            accessToken:
                context.read<LoginCubit>().authenticatedUser!.accessToken!,
          );
              pushNavigateAndRemoveUntil(context, const MainLayoutScreen());

          // Navigator.of(context).pushReplacementNamed(
          //   Routes.mainRoute,
          // );
        } else if (state is UnAuthenticated) {
          Constants.showToast(message: state.message);
        }
      },
      builder: (context, state) {
        return _buildBodyContent(context, state);
      },
    );
  }

  Scaffold _buildBodyContent(
    BuildContext context,
    LoginState state,
  ) {
    return Scaffold(
      body: ReusedBackground(
        body: Center(
          child: SingleChildScrollView(
            child: Form(
              autovalidateMode: autovalidateMode(state),
              key: _formKey,
              child: SafeArea(
                child: Column(
                  children: [
                    // welcome text
                    Text(
                      // "Welcome to",
                      AppLocalizations.of(context)!.translate("welcome_to")!,
                      style: styleW500(
                        context,
                      ),
                    ),
                    Image.asset(
                      ImagesPath.logoImage,
                      fit: BoxFit.scaleDown,
                    ),
                    // login text
                    Text(
                      AppLocalizations.of(context)!.translate("login")!,
                      style: styleW500(context, fontSize: 24),
                    ),
                    // email text form
                    AuthTextFormField(
                      hintText:
                          AppLocalizations.of(context)!.translate("user_name"),
                      svgPath: ImagesPath.emailIconSvg,
                      inputData: TextInputType.text,
                      textEditingController: _userNameController,
                      validationFunction: validateUserName,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).nextFocus(),
                    ),
                    // passowrd text form
                    AuthTextFormField(
                      hintText: AppLocalizations.of(context)!
                          .translate('password_hint'),
                      svgPath: ImagesPath.passwordIconSvg,
                      isPassword: true,
                      inputData: TextInputType.visiblePassword,
                      textEditingController: _passwordController,
                      validationFunction: validatePassword,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => FocusScope.of(context).unfocus(),
                    ),
                    // forgot password
                    Align(
                      alignment: AlignmentDirectional.bottomStart,
                      child: Row(
                        children: [
                          StatefulBuilder(
                            builder: (context, setState) {
                              return Row(
                                children: [
                                  Checkbox(
                                    activeColor: AppColors.cPrimary,
                                    fillColor: WidgetStateProperty.all(
                                      Colors.transparent,
                                    ),
                                    checkColor: AppColors.cPrimary,
                                    value: _credentialsIsRemembered,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(2.0),
                                    ),
                                    side: WidgetStateBorderSide.resolveWith(
                                      (states) => BorderSide(
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .color!,
                                      ),
                                    ),
                                    onChanged: (_) {
                                      setState(() {
                                        _credentialsIsRemembered =
                                            !_credentialsIsRemembered;
                                      });
                                    },
                                  ),
                                  Text(
                                    AppLocalizations.of(context)!
                                        .translate("remember_me")!,
                                    style: styleW400(context),
                                  ),
                                ],
                              );
                            },
                          ),
                          const Spacer(),
                          TextButton(
                            child: Text(
                              AppLocalizations.of(context)!
                                  .translate("forget_password")!,
                              style: styleW400(
                                context,
                                fontSize: 12,
                              ),
                            ),
                            onPressed: () {
                                         pushNavigate(context, BlocProvider(
           create: (_) => di.sl<ForgetPasswordCubit>(),
            child: const ForgetPasswordScreen(),
          ),);
                      
                            },
                          ),
                        ],
                      ),
                    ),

                    // login button
                    // ignore: prefer_if_elements_to_conditional_expressions
                    !context.watch<LoginCubit>().isloading
                        ? GradientCenterTextButton(
                            buttonText: AppLocalizations.of(context)!
                                .translate('sign_in'),
                            listOfGradient: [
                              HexColor("#DF23E1"),
                              HexColor("#3820B2"),
                              HexColor("#39BCE9"),
                            ],
                            onTap: () {
                              BlocProvider.of<LoginCubit>(context).login(
                                formKey: _formKey,
                                email: _userNameController.text,
                                password: _passwordController.text,
                                isRememberMe: _credentialsIsRemembered,
                              );
                            },
                          )
                        : const LoadingIndicator(),
                    // OR
                    Text(
                      AppLocalizations.of(context)!.translate("or")!,
                      style: styleW400(context, fontSize: FontSize.f12),
                    ),
                    // phone
                    GradientRoundedButton(
                      buttonText: AppLocalizations.of(context)!
                          .translate('continue_phone'),
                      startIcon: Image.asset(
                        ImagesPath.phoneIcon,
                        width: 28,
                      ),
                      onTap: () {
                        pushNavigate(
                          context,
                          const LoginWithPhoneNumberScreen(),
                        );
                      },
                      listOfGradient: const [
                        AppColors.cPrimary,
                        AppColors.cViolet,
                      ],
                    ),
                    // // apple
                    // GradientRoundedButton(
                    //   buttonText: AppLocalizations.of(context)!
                    //       .translate('continue_google'),
                    //   onTap: () {
                    //     BlocProvider.of<LoginCubit>(context).signInWithGoogle();
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
                    //   buttonText: AppLocalizations.of(context)!
                    //       .translate('continue_facebook'),
                    //   onTap: () {
                    //     BlocProvider.of<LoginCubit>(context)
                    //         .signInWithFaceBook();
                    //   },
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
                    // if (Platform.isAndroid)
                    //   const SizedBox()
                    // else
                    //   GradientRoundedButton(
                    //     buttonText: AppLocalizations.of(context)!
                    //         .translate('continue_apple'),
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
                    // no account
                    Column(
                      children: [
                        Text(
                          AppLocalizations.of(context)!
                              .translate("no_account")!,
                          style: styleW400(
                            context,
                          ),
                        ),
                        // go to sign up
                        TextButton(
                          child: Text(
                            AppLocalizations.of(context)!.translate("sign_up")!,
                            style: styleW500(
                              context,
                              color: AppColors.cPrimary,
                              fontSize: 14,
                            ),
                          ),
                          onPressed: () {
                                pushNavigate(context, BlocProvider(
            create: (_) => di.sl<RegisterCubit>(),
            child: const RegisterScreen(),
          ),);

                            // Navigator.of(context)
                            //     .pushNamed(Routes.registerRoute);
                          },
                        ),
                      ],
                    ),
                  ]
                      .map(
                        (e) => Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: context.height * .004,
                            horizontal: context.width * .05,
                          ),
                          child: e,
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> getRememberMeData() async {
    final RememberMeModel rememberMeModel = await UserHive.getUserData();
    if (rememberMeModel.email != null) {
      _userNameController.text = rememberMeModel.email ?? '';
      _passwordController.text = rememberMeModel.password ?? '';
      _credentialsIsRemembered = true;
    }
  }
}
