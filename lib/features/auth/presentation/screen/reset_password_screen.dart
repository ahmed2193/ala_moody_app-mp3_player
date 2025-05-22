import 'dart:developer';

//import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:alamoody/core/utils/media_query_values.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/locale/app_localizations.dart';
import '../../../../core/components/reused_background.dart';
import '../../../../core/helper/font_style.dart';
import '../../../../core/helper/images.dart';
import '../../../../core/utils/back_arrow.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/default_text_form_field/auth_textformfield.dart';
import '../../../../core/utils/default_text_form_field/validation_mixin.dart';
import '../../../../core/utils/hex_color.dart';
import '../../../../core/utils/loading_indicator.dart';
import '../../../../core/utils/navigator_reuse.dart';
import '../../../main_layout/presentation/pages/main_layout_screen.dart';
import '../cubit/login/login_cubit.dart';
import '../cubit/reset_password/reset_password_cubit.dart';
import '../widgets/gradient_auth_button.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen>
    with ValidationMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _oldPasswordController = TextEditingController();

  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  AutovalidateMode autovalidateMode(ResetPasswordState state) => state
          is ResetPasswordValidatation
      ? (state.isValidate ? AutovalidateMode.always : AutovalidateMode.disabled)
      : AutovalidateMode.disabled;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
      listener: (context, state) {
        if (state is ResetPasswordSuccess) {
          Constants.showToast(message: state.message);
           pushNavigateAndRemoveUntil(context, const MainLayoutScreen());
  
        } else if (state is ResetPasswordFailed) {
          Constants.showError(context, state.message);
        }
      },
      builder: (context, state) {
        return _buildBodyContent(context, state);
      },
    );
  }

  Widget _buildBodyContent(
    BuildContext context,
    ResetPasswordState state,
  ) {
    return Scaffold(
      body: ReusedBackground(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Form(
              autovalidateMode: autovalidateMode(state),
              key: _formKey,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const BackArrow(),
                      Center(
                        child: Text(
                          AppLocalizations.of(context)!
                              .translate("change_password")!,
                          style: styleW700(context)!.copyWith(
                            fontSize: 20,
                          ),
                        ),
                      ),
                      const SizedBox(),
                    ],
                  ),
                  SizedBox(
                    height: context.height * 0.175,
                  ),
                  Column(
                    children: [
                      Image.asset(
                        ImagesPath.logoImage,
                      ),
                      // signup text
                      Text(
                        AppLocalizations.of(context)!
                            .translate("reset_new_password")!,
                        style: styleW500(context, fontSize: 28),
                      ),
                      // name text form
              
                      // passowrd text form
                      AuthTextFormField(
                        hintText: AppLocalizations.of(context)!
                            .translate("password_hint"),
                        svgPath: ImagesPath.passwordIconSvg,
                        textEditingController: _oldPasswordController,
                        validationFunction: validatePassword,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) =>
                            FocusScope.of(context).nextFocus(),
                        isPassword: true,
                      ),
                      AuthTextFormField(
                        hintText: AppLocalizations.of(context)!
                            .translate("new_password"),
                        svgPath: ImagesPath.passwordIconSvg,
                        textEditingController: _newPasswordController,
                        validationFunction: validatePassword,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) =>
                            FocusScope.of(context).nextFocus(),
                        isPassword: true,
                      ),
                      AuthTextFormField(
                        hintText: AppLocalizations.of(context)!
                            .translate("confirm_new_password"),
                        svgPath: ImagesPath.passwordIconSvg,
                        validationFunction: validateConfirmPassword,
                        textInputAction: TextInputAction.done,
                        textEditingController: _confirmPasswordController,
                        onFieldSubmitted: (_) =>
                            FocusScope.of(context).unfocus(),
                        isPassword: true,
                      ),
              
                      const SizedBox(
                        height: 30,
                      ),
                      if (!context.watch<ResetPasswordCubit>().isloading)
                        GradientCenterTextButton(
                          buttonText:
                              AppLocalizations.of(context)!.translate('save'),
                          listOfGradient: [
                            HexColor("#DF23E1"),
                            HexColor("#3820B2"),
                            HexColor("#39BCE9"),
                          ],
                          onTap: () {
                            log(
                              context
                                  .read<LoginCubit>()
                                  .authenticatedUser!
                                  .accessToken!,
                            );
                            log(_newPasswordController.text);
                            log(_oldPasswordController.text);
                            BlocProvider.of<ResetPasswordCubit>(context)
                                .resetPassword(
                              formKey: _formKey,
                              accessToken: context
                                  .read<LoginCubit>()
                                  .authenticatedUser!
                                  .accessToken!,
                              newPassword: _newPasswordController.text,
                              oldPassword: _oldPasswordController.text,
                            );
                          },
                        )
                      else
                        const LoadingIndicator(),
                      // no account
                      SizedBox(
                        height: context.height * .01,
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
