import 'package:alamoody/config/locale/app_localizations.dart';
import 'package:alamoody/core/components/reused_background.dart';
import 'package:alamoody/core/helper/app_size.dart';
import 'package:alamoody/core/helper/font_style.dart';
import 'package:alamoody/core/helper/images.dart';
import 'package:alamoody/core/utils/back_arrow.dart';
import 'package:alamoody/core/utils/constants.dart';
import 'package:alamoody/core/utils/hex_color.dart';
//import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:alamoody/core/utils/media_query_values.dart';
import 'package:alamoody/features/auth/presentation/cubit/login/login_cubit.dart';
import 'package:alamoody/features/auth/presentation/widgets/gradient_auth_button.dart';
import 'package:alamoody/features/contact_us/presentation/cubit/contact_us_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({
    super.key,
  });

  

  @override
  Widget build(BuildContext context) {
    const bool textFieldHasValue = false;
    BlocProvider.of<ContactUsCubit>(context).titleController.clear();
    BlocProvider.of<ContactUsCubit>(context).messageController.clear();
    BlocProvider.of<ContactUsCubit>(context).subjectTitle = null;
    return Scaffold(
      body: BlocConsumer<ContactUsCubit, ContactUsState>(
        listener: (context, state) {
          if (state is ContactUsLoaded) {
            BlocProvider.of<ContactUsCubit>(context).titleController.clear();
            BlocProvider.of<ContactUsCubit>(context).messageController.clear();
            Navigator.pop(context);

            Constants.showToast(message: 'your support message been send ');
          }
          if (state is ContactUsError) {
            Constants.showError(context, state.message!);
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: ReusedBackground(
              lightBG: ImagesPath.homeBGLightBG,
              body: SingleChildScrollView(
                child: Stack(
                  children: [
                    
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const BackArrow(),
                        ),
                        SizedBox(
                          width: context.height * 0.017,
                        ),
                        Center(
                          child: Text(
                            AppLocalizations.of(context)!.translate("support")!,
                            style: styleW600(context)!
                                .copyWith(fontSize: FontSize.f18),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: context.height * 0.045,
                    ),
                    

                    Padding(
                      padding: const EdgeInsets.only(top: 80),
                      child: Form(
                        key: BlocProvider.of<ContactUsCubit>(context).formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            SupportTextFormField(
                              hintText: AppLocalizations.of(context)!
                                  .translate('enter_title')!,
                              controller: BlocProvider.of<ContactUsCubit>(context)
                                  .titleController,
                              icon: Icons.person,
                              title: AppLocalizations.of(context)!
                                  .translate('title')!,
                              validator: (value) {
                                if (value!.isEmpty && value.length < 3) {
                                  return AppLocalizations.of(context)!
                                      .translate('title_cant_be_empty');
                                }
                                return null;
                              },
                            ),
                            _dropdownButtonFormField(textFieldHasValue),
                            SupportTextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return AppLocalizations.of(context)!
                                      .translate('message_cant_be_empty');
                                }
                                return null;
                              },
                              hintText: AppLocalizations.of(context)!
                                  .translate('enter_your_message')!,
                              controller: BlocProvider.of<ContactUsCubit>(context)
                                  .messageController,
                              icon: Icons.message_outlined,
                              title: AppLocalizations.of(context)!
                                  .translate('message')!,
                              maxLines: 8,
                              minLines: 5,
                            ),
                            SizedBox(
                              height: context.height * 0.05,
                            ),
                            if (state is ContactUsLoading)
                              const CircularProgressIndicator()
                            else
                              GradientCenterTextButton(
                                buttonText: AppLocalizations.of(context)!
                                    .translate('send'),
                                listOfGradient: [
                                  HexColor("#DF23E1"),
                                  HexColor("#3820B2"),
                                  HexColor("#39BCE9"),
                                ],
                                onTap: () {
                                  if (BlocProvider.of<ContactUsCubit>(context)
                                      .formKey
                                      .currentState!
                                      .validate()) {
                                    BlocProvider.of<ContactUsCubit>(context)
                                        .sendMessage(
                                      token: context
                                          .read<LoginCubit>()
                                          .authenticatedUser!
                                          .accessToken!,
                                    );
                                  }
                                },
                              ),
                          ]
                              .map(
                                (e) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  child: e,
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ),
                    
                  ],

                ),
              ),
            ),
          );
        },
      ),
    );
  }

  StatefulBuilder _dropdownButtonFormField(bool textFieldHasValue) {
    return StatefulBuilder(
      builder: (BuildContext context, setState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.subject,
                  color: Theme.of(context).textTheme.labelLarge!.color,
                ),
                const SizedBox(
                  width: 8,
                ), // add some spacing between the icon and text
                Text(
                  AppLocalizations.of(context)!.translate('subject')!,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.labelLarge!.color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              icon: Icon(
                Icons.arrow_drop_down_outlined,
                size: 30,
                color: Theme.of(context).textTheme.titleSmall!.color,
              ),
              value: BlocProvider.of<ContactUsCubit>(context).subjectTitle,
              onChanged: (String? newValue) {
                setState(() {
                  BlocProvider.of<ContactUsCubit>(context).subjectTitle =
                      newValue;
                  textFieldHasValue = newValue!.isNotEmpty;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select an option';
                }
                return null;
              },
              dropdownColor:
                  Theme.of(context).cupertinoOverrideTheme!.barBackgroundColor,
              items: <String>[
                ' -- ',
                'Feature Request',
                'Feedback',
                'Bug Report',
                'Account Issue',
                'Billing Or Subscription Issue ',
                'Music Suggestion',
                'Other',
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide(
                    color: Theme.of(context).textTheme.labelLarge!.color!,
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                hintStyle: Theme.of(context).textTheme.bodyLarge,
                hintText: textFieldHasValue ? '' : '--',
              ),
            ),
          ],
        );
      },
    );
  }
}

class SupportTextFormField extends StatelessWidget {
  const SupportTextFormField({
    super.key,
    this.maxLines = 2,
    this.minLines = 1,
    required this.controller,
    required this.title,
    required this.icon,
    required this.validator,
    required this.hintText,
  });
  final int maxLines;
  final int minLines;
  final TextEditingController controller;
  final String title;
  final String hintText;
  final IconData icon;
  final String? Function(String?)? validator;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: Theme.of(context).textTheme.labelLarge!.color,
            ),
            const SizedBox(
              width: 8,
            ), // add some spacing between the icon and text
            Text(
              title,
              style: TextStyle(
                color: Theme.of(context).textTheme.labelLarge!.color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 16,
        ), // add some spacing between the label and text field
        TextFormField(
          keyboardType: TextInputType.name,
          maxLines: maxLines,
          minLines: minLines,
          controller: controller,
          validator: validator,
          style: Theme.of(context).textTheme.labelLarge,
          // BlocProvider.of<ContactUsCubit>(context).titleController,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: Theme.of(context)
                .textTheme
                .bodySmall!
                .copyWith(color: Theme.of(context).textTheme.labelLarge!.color),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
              borderSide: BorderSide(
                color: Theme.of(context).textTheme.labelLarge!.color!,
              ),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).textTheme.labelLarge!.color!,
              ),
              borderRadius: BorderRadius.circular(20.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).textTheme.labelLarge!.color!,
              ),
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
        ),
      ],
    );
  }
}
