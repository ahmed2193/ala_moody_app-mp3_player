import 'package:flutter/material.dart';

import '../../../../config/locale/app_localizations.dart';
import '../../../../core/helper/font_style.dart';

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
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double responsiveFontSize = screenWidth * 0.04; // Reduced font size
    final double iconSize = screenWidth * 0.05; // Adjusted icon size
    final double paddingSize = screenWidth * 0.008; // Reduced padding

    return Center( // Aligns to the center
      child: SizedBox(
        width: screenWidth * 0.8, // 80% of the screen width
        height: 42, // Reduced height
        child: TextFormField(
          onFieldSubmitted: onFieldSubmitted,
          textInputAction: textInputAction,
          controller: searchController,
          onChanged: onChanged,
          validator: validator,
          onTap: onTap,
          readOnly: readOnly ?? false,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: responsiveFontSize),
          decoration: InputDecoration(
            suffixIcon: IconButton(
              icon: Icon(Icons.close, size: iconSize),
              onPressed: onClosePressed,
              color: Theme.of(context).listTileTheme.textColor,
            ),
            prefixIcon: IconButton(
              icon: Icon(Icons.search, size: iconSize),
              onPressed: onClosePressed,
              color: Theme.of(context).listTileTheme.textColor,
            ),
            filled: true,
            fillColor: Theme.of(context).listTileTheme.textColor!.withOpacity(.12),
            hintText: AppLocalizations.of(context)!.translate(hintText),
            hintStyle: styleW400(
              context,
              color: Theme.of(context).listTileTheme.textColor,
              fontSize: responsiveFontSize * 0.9, // Adjust hint size slightly
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: paddingSize * 1.5, vertical: 10), // Reduced padding
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).listTileTheme.textColor!.withOpacity(.4),
              ),
              borderRadius: BorderRadius.circular(10.0), // Slightly rounded edges
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).listTileTheme.textColor!.withOpacity(.4),
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
      ),
    );
  }
}
