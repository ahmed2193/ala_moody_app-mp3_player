import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/locale/app_localizations.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../../config/themes/colors.dart';
import '../../../../core/components/reused_background.dart';
import '../../../../core/helper/font_style.dart';
import '../../../../core/helper/images.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/default_text_form_field/auth_textformfield.dart';
import '../../../../core/utils/default_text_form_field/validation_mixin.dart';
import '../../../../core/utils/hex_color.dart';
import '../../../../core/utils/loading_indicator.dart';
import '../../../../core/utils/media_query_values.dart';
import '../../../../core/utils/navigator_reuse.dart';
import '../cubit/register/register_cubit.dart';
import '../widgets/gradient_auth_button.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> with ValidationMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  AutovalidateMode autovalidateMode(RegisterState state) => state
          is RegisterValidatation
      ? (state.isValidate ? AutovalidateMode.always : AutovalidateMode.disabled)
      : AutovalidateMode.disabled;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state is RegisterSuccess) {
          Constants.showToast(
              message: AppLocalizations.of(context)!
                  .translate('register_successfully')!,);
          Navigator.of(context).pushNamedAndRemoveUntil(
            Routes.loginRoute,
            (Route<dynamic> route) => false,
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
        // darKBG: ImagesPath.homeBGDarkBG,
        // lightBG: ImagesPath.homeBGLightBG,
        body: Center(
          child: SingleChildScrollView(
            child: Form(
              autovalidateMode: autovalidateMode(state),
              key: _formKey,
              child: Column(
                children: [
                  // welcome text
                  Text(
                    AppLocalizations.of(context)!.translate("welcome_to")!,
                    style: styleW500(
                      context,
                    ),
                  ),
                  Image.asset(
                    ImagesPath.logoImage,
                  ),
                  // signup text
                  Text(
                    AppLocalizations.of(context)!.translate("sign_up")!,
                    style: styleW500(context, fontSize: 28),
                  ),
                  // name text form
                  AuthTextFormField(
                    hintText:
                        AppLocalizations.of(context)!.translate("name_hint"),
                    svgPath: ImagesPath.userIconSvg,
                    inputData: TextInputType.text,
                    textEditingController: _nameController,
                    validationFunction: validateName,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                  ),
                  AuthTextFormField(
                    hintText:
                        AppLocalizations.of(context)!.translate("user_name"),
                    svgPath: ImagesPath.userIconSvg,
                    inputData: TextInputType.text,
                    textEditingController: _userNameController,
                    validationFunction: validateUserName,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                  ),
                  // email text form
                  AuthTextFormField(
                    hintText:
                        AppLocalizations.of(context)!.translate("email_hint"),
                    svgPath: ImagesPath.emailIconSvg,
                    inputData: TextInputType.emailAddress,
                    textEditingController: _emailController,
                    validationFunction: validateEmail,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                  ),
                  // passowrd text form
                  AuthTextFormField(
                    hintText: AppLocalizations.of(context)!
                        .translate("password_hint"),
                    svgPath: ImagesPath.passwordIconSvg,
                    textEditingController: _passwordController,
                    validationFunction: validatePassword,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                    isPassword: true,
                  ),
                  AuthTextFormField(
                    hintText: AppLocalizations.of(context)!
                        .translate("confirm_password"),
                    svgPath: ImagesPath.passwordIconSvg,
                    validationFunction: validateConfirmPassword,
                    textInputAction: TextInputAction.done,
                    textEditingController: _confirmPasswordController,
                    onFieldSubmitted: (_) => FocusScope.of(context).unfocus(),
                    isPassword: true,
                  ),
                  // checkbox
                  // Align(
                  //   alignment: AlignmentDirectional.centerStart,
                  //   child: ReuseCheckbox(
                  //     value: ,
                  //     onChanged: (value) {
                  //       authCubit.changeRememberMe();
                  //       // TODO: will import user_hive in signup function
                  //     },
                  //   ),
                  // ),
                  // signup button
                  const SizedBox(
                    height: 30,
                  ),
                  if (!context.watch<RegisterCubit>().isloading)
                    GradientCenterTextButton(
                      buttonText:
                          AppLocalizations.of(context)!.translate("sign_up"),
                      listOfGradient: [
                        HexColor("#DF23E1"),
                        HexColor("#3820B2"),
                        HexColor("#39BCE9"),
                      ],
                      onTap: () {
                        BlocProvider.of<RegisterCubit>(context).register(
                          formKey: _formKey,
                          name: _nameController.text,
                          userName: _userNameController.text,
                          email: _emailController.text,
                          password: _passwordController.text,
                        );
                      },
                    )
                  else
                    const LoadingIndicator(),
                  // no account
                  SizedBox(
                    height: context.height * .01,
                  ),
                  Column(
                    children: [
                      Text(
                        AppLocalizations.of(context)!
                            .translate("already_have_account")!,
                        style: styleW400(
                          context,
                        ),
                      ),
                      // go to sign up
                      TextButton(
                        child: Text(
                          AppLocalizations.of(context)!.translate("sign_in")!,
                          style: styleW500(
                            context,
                            color: AppColors.cPrimary,
                            fontSize: 14,
                          ),
                        ),
                        onPressed: () {
                          pushNavigateAndRemoveUntil(
                            context,
                            const LoginScreen(),
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
