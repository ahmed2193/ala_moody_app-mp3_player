import 'dart:developer';

//import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:alamoody/core/utils/media_query_values.dart';
import 'package:alamoody/core/utils/navigator_reuse.dart';
import 'package:alamoody/features/auth/presentation/screen/register_with_mobile_number.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/helper/images.dart';
import '../../../../config/locale/app_localizations.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../../config/themes/colors.dart';
import '../../../../core/components/reused_background.dart';
import '../../../../core/helper/font_style.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/default_text_form_field/auth_textformfield.dart';
import '../../../../core/utils/default_text_form_field/validation_mixin.dart';
import '../../../../core/utils/hex_color.dart';
import '../../../../core/utils/loading_indicator.dart';
import '../../../profile/presentation/cubits/profile/profile_cubit.dart';
import '../cubit/login/login_cubit.dart';
import '../widgets/gradient_auth_button.dart';

class LoginWithPhoneNumberScreen extends StatefulWidget {
  const LoginWithPhoneNumberScreen({Key? key}) : super(key: key);

  @override
  State<LoginWithPhoneNumberScreen> createState() =>
      _LoginWithPhoneNumberScreenState();
}

class _LoginWithPhoneNumberScreenState extends State<LoginWithPhoneNumberScreen>
    with ValidationMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();

  String? countryName;
  String? countrycode;

  bool _credentialsIsRemembered = false;

  AutovalidateMode autovalidateMode(LoginState state) => state
          is LoginValidatation
      ? (state.isValidate ? AutovalidateMode.always : AutovalidateMode.disabled)
      : AutovalidateMode.disabled;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) async {
        if (state is Authenticated) {
          // Navigator.of(context).pushNamedAndRemoveUntil(
          //     Routes.mainRoute, (Route<dynamic> route) => false);
          await BlocProvider.of<ProfileCubit>(context).getUserProfile(
            accessToken:
                context.read<LoginCubit>().authenticatedUser!.accessToken!,
          );
          Navigator.of(context).pushReplacementNamed(
            Routes.mainRoute,
          );
        } else if (state is UnAuthenticated) {
          Constants.showError(context, state.message);
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
        // darKBG: ImagesPath.homeBGDarkBG,
        // lightBG: ImagesPath.homeBGLightBG,
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
                    ),
                    // login text
                    Text(
                      AppLocalizations.of(context)!
                          .translate("login_with_mobile_number")!,
                      style: styleW700(context, fontSize: 24),
                      textAlign: TextAlign.center,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: StatefulBuilder(
                            builder: (BuildContext context, setState) {
                              return CountryCodePicker(
                                searchStyle: styleW400(context),
                                flagWidth: 20,
                                boxDecoration: const BoxDecoration(
                                  color: AppColors.cAppBarDark,
                                ),
                                searchDecoration: InputDecoration(
                                  hintText: AppLocalizations.of(context)!
                                      .translate('COUNTRY_CODE_LBL'),
                                  hintStyle: styleW400(context),
                                  fillColor: Colors.amber,
                                ),
                                initialSelection: 'AE',
                                // dialogSize: Size(width, height),
                                alignLeft: true,
                                textStyle: styleW400(context),
                                onChanged: (CountryCode countryCode) {
                                  setState(() {
                                    countrycode = countryCode.toString();
                                    countryName = countryCode.name;
                                  });

                                  log(countryName!);
                                  log(countrycode!);
                                },
                                onInit: (code) {
                                  countrycode = code.toString();
                                  log(countrycode!);
                                  log(code.toString());
                                },
                              );
                            },
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: AuthTextFormField(
                            hintText: AppLocalizations.of(context)!
                                .translate("mobile_number"),
                            svgPath: '',
                            allowPrefixIcon: false,
                            inputData: TextInputType.phone,
                            textEditingController: _mobileNumberController,
                            validationFunction: validatePhoneNO,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) =>
                                FocusScope.of(context).nextFocus(),
                          ),
                        ),
                      ],
                    ),
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
                              log(" $countrycode${_mobileNumberController.text}");
                              BlocProvider.of<LoginCubit>(context)
                                  .loginWithMobileNumber(
                                formKey: _formKey,
                                phone:
                                    "$countrycode${_mobileNumberController.text}",
                                mobileFlag: '1',
                                userName: _userNameController.text,
                                credentialsIsSaved: _credentialsIsRemembered,
                              );
                            },
                          )
                        : const LoadingIndicator(),

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
                            pushNavigate(
                              context,
                              const RegisterWithMobileNumberScreen(),
                            );
                          },
                        ),
                      ],
                    ),
                  ]
                      .map(
                        (e) => Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: context.height * .007,
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
}
