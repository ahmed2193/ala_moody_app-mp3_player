import 'package:alamoody/core/helper/font_style.dart';
import 'package:flutter/material.dart';

import '../../config/themes/colors.dart';

// ignore: must_be_immutable
class DefaultDropdownButtonFormField extends StatefulWidget {
  final List<DropdownMenuItem<dynamic>> items;
  final dynamic value;
  final String? hintTxt;
  final String? Function(dynamic)? validationFunction;
  final Function(dynamic)? onChangedFunction;
  final Widget? suffix;
  final Widget? suffixIcon;
  final Widget? icon;
  final Widget? prefix;
  final Widget? prefixIcon;
  String title = 'العنوان';
  final String? labelTxt;
  final bool isExpanded;
  final AutovalidateMode autovalidateMode;
  final Color? unfocusColor;
  final Color? hintColor;
  final Color? filledColor;
  final bool filled;
  bool withTitle = false;
  DefaultDropdownButtonFormField({
    Key? key,
    required this.items,
    this.value,
    this.icon,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.hintTxt,
    this.validationFunction,
    this.onChangedFunction,
    this.suffix,
    this.suffixIcon,
    this.prefix,
    this.prefixIcon,
    this.labelTxt,
    this.isExpanded = true,
    this.unfocusColor,
    this.hintColor,
    this.filled = true,
    this.filledColor,
  }) : super(key: key);
  DefaultDropdownButtonFormField.withTitle({
    Key? key,
    required this.items,
    this.value,
    this.icon,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.hintTxt,
    this.validationFunction,
    this.onChangedFunction,
    required this.title,
    this.suffix,
    this.suffixIcon,
    this.prefix,
    this.prefixIcon,
    this.labelTxt,
    this.isExpanded = true,
    this.unfocusColor,
    this.hintColor,
    this.filled = true,
    this.filledColor,
    this.withTitle = true,
  }) : super(key: key);

  @override
  State<DefaultDropdownButtonFormField> createState() =>
      _DefaultDropdownButtonFormFieldState();
}

class _DefaultDropdownButtonFormFieldState
    extends State<DefaultDropdownButtonFormField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.withTitle)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0.3, vertical: 0.3),
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Text(
                widget.title,
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          )
        else
          Container(),
        const SizedBox(height: 10),

        // margin: EdgeInsets.symmetric(
        //   horizontal: widget.withTitle ? 0 : 16,
        // ),
        DropdownButtonFormField(
          dropdownColor: Colors.transparent,
          autovalidateMode: widget.autovalidateMode,
          // style: const TextStyle(
          //     color: Colors.white, //<-- SEE HERE
          //     fontSize: 25,
          //     fontWeight: FontWeight.bold),

          icon: widget.icon ??
              const Icon(
                Icons.keyboard_arrow_down,
                size: 20,
                color: AppColors.cOffWhite,
              ),
          // style: Theme.of(context).textTheme.labelSmall,
          value: widget.value,
          isExpanded: widget.isExpanded,
          decoration: InputDecoration(
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
            helperStyle: styleW400(context),
            hoverColor: Colors.white,
            filled: widget.filled ? true : false,
            fillColor: widget.filledColor ?? Colors.transparent,
            suffix: widget.suffix,
            suffixIcon: widget.suffixIcon,
            prefix: widget.prefix,
            prefixIcon: widget.prefixIcon,
            hintText: widget.hintTxt,
            hintStyle: styleW400(context),
            labelText: widget.labelTxt,
          ),
          onChanged: widget.onChangedFunction,
          items: widget.items,
          validator: widget.validationFunction,
        ),
      ],
    );
  }
}
