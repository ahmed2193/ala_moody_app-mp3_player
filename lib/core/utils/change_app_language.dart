//import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:alamoody/core/utils/media_query_values.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:provider/provider.dart';

import '../../config/locale/app_localizations.dart';
import '../../config/themes/colors.dart';
import '../../features/auth/presentation/widgets/gradient_auth_button.dart';
import '../../features/main/presentation/cubit/locale_cubit.dart';
import '../components/reused_background.dart';
import '../helper/font_style.dart';
import '../helper/images.dart';
import 'controllers/main_controller.dart';
import 'hex_color.dart';

class ChangeAppLanguage extends StatefulWidget {
  const ChangeAppLanguage({
    Key? key,
  }) : super(key: key);
  @override
  State<ChangeAppLanguage> createState() => _ChangeAppLanguageState();
}

class _ChangeAppLanguageState extends State<ChangeAppLanguage> {
  int _radioSelected = 1;

  _reloadAppFromScratch() {
    Navigator.pop(context);
    Phoenix.rebirth(context);
  }

  @override
  void initState() {
    _radioSelected =
        context.read<LocaleCubit>().currentLangCode == 'ar' ? 1 : 2;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ReusedBackground(
      lightBG: ImagesPath.homeBGLightBG,
      body: SingleChildScrollView(
        child: SizedBox(
          height: context.height * 0.45,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LayoutBuilder(
                  builder: (context, conatraints) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(),
                        Text(
                          AppLocalizations.of(context)!
                              .translate('change_language')!,
                          style: Theme.of(context).appBarTheme.titleTextStyle,
                        ),
                        GestureDetector(
                          child: const Icon(
                            Icons.close,
                            size: 22,
                          ),
                          onTap: () => Navigator.pop(context),
                        ),
                      ],
                    );
                  },
                ),
                SizedBox(
                  height: context.height * 0.03,
                ),
                ListTile(
                  title: Text(
                    AppLocalizations.of(context)!.translate('arabic')!,
                    // 'arabic',
                    style: styleW400(context, fontSize: 16),
                  ),
                  leading: Radio(
                    focusColor: AppColors.cPrimary,
                    fillColor: WidgetStateColor.resolveWith(
                      (states) => AppColors.cPrimary,
                    ),
                    value: 1,
                    groupValue: _radioSelected,
                    onChanged: (int? value) {
                      setState(() {
                        _radioSelected = value!;
                      });
                    },
                  ),
                ),
                const Divider(
                  color: AppColors.cViolet,
                ),
                ListTile(
                  title: Text(
                    AppLocalizations.of(context)!.translate('english')!,
                    // 'english',
                    style: styleW400(context, fontSize: 16),
                  ),
                  leading: Radio(
                    focusColor: AppColors.cPrimary,
                    fillColor: WidgetStateColor.resolveWith(
                      (states) => AppColors.cPrimary,
                    ),
                    value: 2,
                    groupValue: _radioSelected,
                    onChanged: (int? value) {
                      setState(() {
                        _radioSelected = value!;
                      });
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                GradientCenterTextButton(
                  buttonText: AppLocalizations.of(context)!.translate('save'),
                  listOfGradient: [
                    HexColor("#DF23E1"),
                    HexColor("#3820B2"),
                    HexColor("#39BCE9"),
                  ],
                  onTap: () {
                    Provider.of<MainController>(context, listen: false)
                        .player
                        .stop();
                    if (_radioSelected == 1 &&
                        AppLocalizations.of(context)!.isEnLocale) {
                      BlocProvider.of<LocaleCubit>(context).toArabic();
                      _reloadAppFromScratch();
                    } else if (_radioSelected == 2 &&
                        !AppLocalizations.of(context)!.isEnLocale) {
                      BlocProvider.of<LocaleCubit>(context).toEnglish();
                      _reloadAppFromScratch();
                    } else {
                      Navigator.pop(context);
                    }
                  },
                ),
                const SizedBox(),
                const SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
