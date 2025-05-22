import 'dart:developer';

//import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:alamoody/core/utils/media_query_values.dart';
import 'package:alamoody/core/utils/navigator_reuse.dart';
import 'package:alamoody/features/auth/presentation/cubit/register/register_cubit.dart';
import 'package:alamoody/features/auth/presentation/screen/login_with_phone_number_scree.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sms_autofill/sms_autofill.dart';

import '../../../../../../core/helper/images.dart';
import '../../../../config/locale/app_localizations.dart';
import '../../../../config/themes/colors.dart';
import '../../../../core/components/reused_background.dart';
import '../../../../core/helper/font_style.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/default_text_form_field/validation_mixin.dart';
import '../../../../core/utils/hex_color.dart';
import '../../../../core/utils/loading_indicator.dart';
import '../widgets/gradient_auth_button.dart';

class VerifyOtpScreen extends StatefulWidget {
  final String? mobileNumber;
  final String? countryCode;
  final String? title;

  const VerifyOtpScreen({
    Key? key,
    required this.mobileNumber,
    this.countryCode,
    this.title,
  }) : super(key: key);

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen>
    with ValidationMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _mobileNumberController = TextEditingController();
  String? otp;

  final bool _credentialsIsRemembered = false;
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state is RegisterSuccess) {
          // Navigator.of(context).pushNamedAndRemoveUntil(
          //     Routes.mainRoute, (Route<dynamic> route) => false);
          log('RegisterFailed');
          Constants.showToast(
            message: AppLocalizations.of(context)!
                .translate('register_successfully')!,
          );
          pushNavigateAndRemoveUntil(
            context,
            const LoginWithPhoneNumberScreen(),
          );
        } else if (state is RegisterFailed) {
          Constants.showError(context, state.message);
        }
      },
      builder: (context, state) {
        return _buildBodyContent(
          context,
        );
      },
    );
  }

  Widget otpLayout() {
    return Padding(
      padding: const EdgeInsetsDirectional.only(
        start: 50.0,
        end: 50.0,
      ),
      child: Center(
        child: PinFieldAutoFill(
          decoration: UnderlineDecoration(
            textStyle: TextStyle(
              fontSize: 20,
              color: Theme.of(context).textTheme.bodyLarge!.color,
            ),
            colorBuilder: const FixedColorBuilder(Colors.deepOrange),
          ),
          currentCode: otp,
          onCodeChanged: (String? code) {
            otp = code;
          },
          onCodeSubmitted: (String code) {
            otp = code;
          },
        ),
      ),
    );
  }

  Scaffold _buildBodyContent(
    BuildContext context,
  ) {
    return Scaffold(
      body: ReusedBackground(
        body: Center(
          child: SingleChildScrollView(
            child: SafeArea(
              child: Column(
                children: [
                  // welcome text

                  Image.asset(
                    ImagesPath.logoImage,
                  ),
                  // login text
                  Text(
                    AppLocalizations.of(context)!
                        .translate("MOBILE_NUMBER_VARIFICATION")!,
                    style: styleW700(
                      context,
                      fontSize: 24,
                      color: AppColors.cPrimary.withOpacity(0.7),
                    ),
                    textAlign: TextAlign.start,
                  ),
                  Text(
                    AppLocalizations.of(context)!
                        .translate("SENT_VERIFY_CODE_TO_NO_LBL")!,
                    style: styleW400(context, fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    '${widget.countryCode}-${widget.mobileNumber!}',
                    style: styleW400(context, fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                  // email text form

                  otpLayout(),

                  // login button
                  // ignore: prefer_if_elements_to_conditional_expressions
                  !context.watch<RegisterCubit>().isloading
                      ? GradientCenterTextButton(
                          buttonText: AppLocalizations.of(context)!
                              .translate('VERIFY_AND_PROCEED'),
                          listOfGradient: [
                            HexColor("#DF23E1"),
                            HexColor("#3820B2"),
                            HexColor("#39BCE9"),
                          ],
                          onTap: () async {
                            log(BlocProvider.of<RegisterCubit>(context)
                                .userName!,);
                            // BlocProvider.of<RegisterCubit>(context)
                            //     .registerWithMobileNumber(
                            //   otp: otp!,
                            // );
                          },
                        )
                      : const LoadingIndicator(),

                  // no account
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppLocalizations.of(context)!
                            .translate("DIDNT_GET_THE_CODE")!,
                        style: styleW400(
                          context,
                        ),
                      ),
                      // go to sign up
                      TextButton(
                        child: Text(
                          AppLocalizations.of(context)!
                              .translate("RESEND_OTP")!,
                          style: styleW500(
                            context,
                            color: AppColors.cPrimary.shade100,
                            fontSize: 14,
                          ),
                        ),
                        onPressed: () {
                          BlocProvider.of<RegisterCubit>(context)
                              .verifyPhoneNumber(
                            phone: BlocProvider.of<RegisterCubit>(context)
                                .phoneNumber!,
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
    );
  }
}
