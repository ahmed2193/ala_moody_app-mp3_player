import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../config/locale/app_localizations.dart';
import '../../../../core/helper/font_style.dart';
import '../../../../core/helper/images.dart';

class SearchTextFormReuse extends StatelessWidget {
  final TextEditingController searchController;
  final String hintText;
  final bool? readOnly;
  final FormFieldValidator? validator;
  final GestureTapCallback? onTap;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final TextInputAction? textInputAction;
  final void Function()? onClosePressed;
  const SearchTextFormReuse({
    required this.searchController,
    required this.hintText,
    this.readOnly,
    this.validator,
    this.onTap,
    this.onChanged,
    this.onFieldSubmitted,
    this.textInputAction,
    this.onClosePressed,
    Key? key,
  }) : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onFieldSubmitted: onFieldSubmitted,
      textInputAction: textInputAction,
      controller: searchController,
      onChanged: onChanged,
      validator: validator,
      onTap: onTap,
      readOnly: readOnly ?? false,
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 16),
      decoration: InputDecoration(
        // prefixIcon: Icon(Icons.email),
        suffixIcon: IconButton(
          icon: const Icon(Icons.close),
          onPressed: 
           onClosePressed
          ,
          color: Theme.of(context).listTileTheme.textColor,
        ),
        prefixIcon: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SvgPicture.asset(
            ImagesPath.searchbarIconSvg,
            color: Theme.of(context).listTileTheme.textColor,
            width: 14,
          ),
        ),
        filled: true,
        fillColor: Theme.of(context).listTileTheme.textColor!.withOpacity(.12),
        hintText: AppLocalizations.of(context)!.translate(hintText),
        hintStyle: styleW400(
          context,
          color: Theme.of(context).listTileTheme.textColor,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
        enabledBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: Theme.of(context).listTileTheme.textColor!.withOpacity(.4), width: 2),
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: Theme.of(context).listTileTheme.textColor!.withOpacity(.4), width: 2),
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        ),
      ),
    );
  }
}
