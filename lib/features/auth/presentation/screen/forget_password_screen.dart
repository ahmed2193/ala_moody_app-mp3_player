
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/locale/app_localizations.dart';
import '../../../../core/components/reused_background.dart';
import '../../../../core/helper/font_style.dart';
import '../../../../core/helper/images.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/default_text_form_field/auth_textformfield.dart';
import '../../../../core/utils/default_text_form_field/validation_mixin.dart';
import '../../../../core/utils/hex_color.dart';
import '../../../../core/utils/loading_indicator.dart';
import '../../../../core/utils/media_query_values.dart';
import '../cubit/forget_password/forget_password_cubit.dart';
import '../widgets/gradient_auth_button.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen>
    with ValidationMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  AutovalidateMode autovalidateMode(ForgetPasswordState state) => state
          is ForgetPasswordValidatation
      ? (state.isValidate ? AutovalidateMode.always : AutovalidateMode.disabled)
      : AutovalidateMode.disabled;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ForgetPasswordCubit, ForgetPasswordState>(
      listener: (context, state) {
        if (state is ForgetPasswordSuccess) {
          Constants.showToast(message: state.message);
          Navigator.of(context).pop();
        } else if (state is ForgetPasswordFailed) {
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
    ForgetPasswordState state,
  ) {
    return Scaffold(
      body: ReusedBackground(
        body: Center(
          child: SingleChildScrollView(
            child: Form(
              autovalidateMode: autovalidateMode(state),
              key: _formKey,
              child: Column(
                children: [
                  Image.asset(
                    ImagesPath.logoImage,
                  ),
                  // signup text
                  Text(
                    AppLocalizations.of(context)!.translate("forget_password")!,
                    style: styleW500(context, fontSize: 28),
                  ),
                  // name text form

                  // passowrd text form
                  AuthTextFormField(
                    hintText: AppLocalizations.of(context)!.translate("email_hint"),
                    svgPath: ImagesPath.emailIconSvg,
                    inputData: TextInputType.emailAddress,
                    textEditingController: _emailController,
                    validationFunction: validateEmail,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => FocusScope.of(context).unfocus(),
                  ),

                  const SizedBox(
                    height: 30,
                  ),
                  if (!context.watch<ForgetPasswordCubit>().isloading)
                    GradientCenterTextButton(
                      buttonText: AppLocalizations.of(context)!.translate('save'),
                      listOfGradient: [
                        HexColor("#DF23E1"),
                        HexColor("#3820B2"),
                        HexColor("#39BCE9"),
                      ],
                      onTap: () {
                        BlocProvider.of<ForgetPasswordCubit>(context)
                            .forgetPassword(
                          formKey: _formKey,
                          email: _emailController.text,
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
            ),
          ),
        ),
      ),
    );
  }
}
