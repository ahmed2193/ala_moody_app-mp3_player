import 'dart:developer';

//import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:alamoody/core/utils/media_query_values.dart';
import 'package:alamoody/core/utils/navigator_reuse.dart';
import 'package:alamoody/features/auth/presentation/screen/verify_otp_screen.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/helper/images.dart';
import '../../../../config/locale/app_localizations.dart';
import '../../../../config/themes/colors.dart';
import '../../../../core/components/reused_background.dart';
import '../../../../core/helper/font_style.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/default_text_form_field/auth_textformfield.dart';
import '../../../../core/utils/default_text_form_field/validation_mixin.dart';
import '../../../../core/utils/hex_color.dart';
import '../../../../core/utils/loading_indicator.dart';
import '../cubit/register/register_cubit.dart';
import '../widgets/gradient_auth_button.dart';

class RegisterWithMobileNumberScreen extends StatefulWidget {
  const RegisterWithMobileNumberScreen({Key? key}) : super(key: key);

  @override
  State<RegisterWithMobileNumberScreen> createState() =>
      _RegisterWithMobileNumberScreenState();
}

class _RegisterWithMobileNumberScreenState
    extends State<RegisterWithMobileNumberScreen> with ValidationMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _mobileNumberController = TextEditingController();

  final TextEditingController _userNameController = TextEditingController();

  String? countryName;
  String? countrycode;

  final bool _credentialsIsRemembered = false;

  AutovalidateMode autovalidateMode(RegisterState state) => state
          is RegisterValidatation
      ? (state.isValidate ? AutovalidateMode.always : AutovalidateMode.disabled)
      : AutovalidateMode.disabled;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state is VerifyPhoneNumberSuccess) {
          // Navigator.of(context).pushNamedAndRemoveUntil(
          //     Routes.mainRoute, (Route<dynamic> route) => false);
          pushNavigate(
            context,
            VerifyOtpScreen(
              mobileNumber: _mobileNumberController.text,
              countryCode: countrycode,
            ),
          );
        } else if (state is RegisterFailed) {
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
    RegisterState state,
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
                    ),
                    // Register text
                    Text(
                      AppLocalizations.of(context)!.translate("sign_in")!,
                      style: styleW700(context, fontSize: 28),
                      textAlign: TextAlign.start,
                    ),
                    Text(
                      AppLocalizations.of(context)!
                          .translate("verification_code")!,
                      style: styleW400(context, fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                    // email text form
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
                    // TextFormWithFlag(
                    //   countryName: countryName,
                    //   textEditingController: _mobileNumberController,
                    //   validationFunction: validatePhoneNO,
                    //   countrycode: countrycode,
                    // ),
                    // passowrd text form

                    // Register button
                    // ignore: prefer_if_elements_to_conditional_expressions
                    if (!context.watch<RegisterCubit>().isloading)
                      GradientCenterTextButton(
                        buttonText:
                            AppLocalizations.of(context)!.translate('send_otp'),
                        listOfGradient: [
                          HexColor("#DF23E1"),
                          HexColor("#3820B2"),
                          HexColor("#39BCE9"),
                        ],
                        onTap: () async {
                          log("$countrycode${_mobileNumberController.text}");
                          // await FirebaseAuth.instance.verifyPhoneNumber(
                          //   phoneNumber:
                          //       "${countrycode}${_mobileNumberController.text}",
                          //   verificationCompleted:
                          //       (PhoneAuthCredential credential) {},
                          //   verificationFailed: (FirebaseAuthException e) {
                          //     log(e.message.toString());
                          //   },
                          //   codeSent:
                          //       (String verificationId, int? resendToken) {
                          //     pushNavigate(
                          //       context,
                          //       VerifyOtpScreen(
                          //         verificationId: verificationId,
                          //         mobileNumber:
                          //             _mobileNumberController.text,
                          //         countryCode: countrycode,
                          //       ),
                          //     );
                          //   },
                          //   codeAutoRetrievalTimeout:
                          //       (String verificationId) {},
                          // );
                          log('$countrycode${_mobileNumberController.text}');
                          if (_formKey.currentState!.validate()) {
                            BlocProvider.of<RegisterCubit>(context).userName =
                                _userNameController.text;
                            BlocProvider.of<RegisterCubit>(context)
                                .verifyPhoneNumber(
                              phone:
                                  "$countrycode${_mobileNumberController.text}",
                            );
                          }
                        },
                      )
                    else
                      const LoadingIndicator(),
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
