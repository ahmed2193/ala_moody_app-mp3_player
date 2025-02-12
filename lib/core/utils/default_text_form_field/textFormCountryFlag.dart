import 'dart:developer';

import 'package:alamoody/core/helper/font_style.dart';
import 'package:alamoody/core/utils/default_text_form_field/auth_textformfield.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';

import '../../../config/locale/app_localizations.dart';

class TextFormWithFlag extends StatelessWidget {
  TextFormWithFlag(
      {Key? key,
      required this.textEditingController,
      required this.validationFunction,
      required this.countryName,
      this.countrycode,})
      : super(key: key);
  final TextEditingController textEditingController;
  String? countryName;
  String? countrycode;
  final String? Function(String?)? validationFunction;
  @override
  Widget build(BuildContext context) {
    const initialCountryCode = 'AE';
    return 
    Row(
      children: [
        Expanded(
          child: StatefulBuilder(
            builder: (BuildContext context, setState) {
              return CountryCodePicker(
                  searchStyle: styleW400(context),
                  flagWidth: 20,
                  boxDecoration: BoxDecoration(
                    color: Colors.transparent.withOpacity(0.6),
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
                  countrycode = countryCode.toString().replaceFirst("+", "");
                    countryName = countryCode.name;
                    });
         
                    log(countryName!);
                    log(countrycode!);
                  },
                  onInit: (code) {
                    countrycode = code.toString().replaceFirst("+", "");
                    log(countrycode!);
                  },);
            },
          ),
        ),
        Expanded(
          flex: 2,
          child: AuthTextFormField(
            hintText: AppLocalizations.of(context)!.translate("mobile_number"),
            svgPath: '',
            allowPrefixIcon: false,
            inputData: TextInputType.phone,
            textEditingController: textEditingController,
            validationFunction: validationFunction,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
          ),
        ),
      ],
    );
 
  }
}
