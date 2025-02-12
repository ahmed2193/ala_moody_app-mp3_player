import 'package:alamoody/config/locale/app_localizations.dart';
import 'package:flutter/material.dart';

import '../../helper/font_style.dart';
import '../../utils/hex_color.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.4,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: LinearGradient(
            begin: AlignmentDirectional.topStart,
            end: AlignmentDirectional.bottomEnd,
            colors: [
              HexColor("#8D00FF"),
              HexColor("#CF3DFF"),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
            Text(
              AppLocalizations.of(context)!.translate("loading")!,
              style: styleW600(context),
              textAlign: TextAlign.center,
            ),
            Text(
   
               AppLocalizations.of(context)!.translate("your_data_is_loading")!,
              style: styleW400(context),
              textAlign: TextAlign.center,
            ),
          ]
              .map(
                (e) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: e,
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
