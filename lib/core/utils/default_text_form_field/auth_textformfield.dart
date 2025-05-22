import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/helper/font_style.dart';

class AuthTextFormField extends StatelessWidget {
  const AuthTextFormField({
    Key? key,
    required this.svgPath,
    required this.hintText,
    this.onSuffixPressed,
    this.allowPrefixIcon = true,
    this.suffixIcon,
    this.textEditingController,
    this.obscureText = false,
    this.inputData,
    this.validationFunction,
    this.textInputAction,
    this.onFieldSubmitted,
    this.isPassword = false,
    this.onTap,
  }) : super(key: key);

  final String? svgPath;
  final String? hintText;
  final VoidCallback? onSuffixPressed;
  final IconData? suffixIcon;
  final bool? obscureText;
  final TextEditingController? textEditingController;
  final TextInputType? inputData;
  final String? Function(String?)? validationFunction;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onFieldSubmitted;
  final bool isPassword;
  final bool allowPrefixIcon;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    bool obsecureText = true;

    return StatefulBuilder(
      builder: (context, setState) => TextFormField(
        controller: textEditingController ?? TextEditingController(),
        validator: validationFunction,
        // is text secure
        obscureText: isPassword ? obsecureText : false,
        keyboardType: inputData,
        textInputAction: textInputAction,
        onTap: onTap,
        style: Theme.of(context).textTheme.labelLarge,
        // cursor
        cursorColor: Theme.of(context).textTheme.bodyLarge!.color,
        // decoration
        decoration: InputDecoration(
          // all about hint hint
          hintText: hintText,
          hintStyle: styleW400(
            context,
            color: Theme.of(context).textTheme.bodyLarge!.color,
          ),
          // all about prefix
          prefixIconConstraints: const BoxConstraints(maxWidth: 40),
          prefixIcon: allowPrefixIcon
              ? Padding(
                  padding: const EdgeInsetsDirectional.only(end: 10.0),
                  child: SvgPicture.asset(
                    svgPath!,
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                  ),
                )
              : const SizedBox(),
          prefixIconColor: Theme.of(context).textTheme.bodyLarge!.color,
          // all about suffix
          suffixIcon: isPassword
              ? GestureDetector(
                  onTap: () {
                    setState(() {
                      obsecureText = !obsecureText;
                    });
                  },
                  child: Icon(
                    obsecureText ? Icons.remove_red_eye : Icons.visibility_off,
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                    size: 18,
                  ),
                )
              : Icon(
                  suffixIcon,
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                ),

          suffixIconColor: Theme.of(context).textTheme.bodyLarge!.color,
          // borders
          border: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).textTheme.bodyLarge!.color!,
            ),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).textTheme.bodyLarge!.color!,
            ),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).textTheme.bodyLarge!.color!,
            ),
          ),
          focusedErrorBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).textTheme.bodyLarge!.color!,
            ),
          ),
        ),
      ),
    );
  }
}
