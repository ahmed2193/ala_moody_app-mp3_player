import 'package:alamoody/core/utils/navigator_reuse.dart';
import 'package:alamoody/features/mood/presentation/widgets/mood_songs_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/error_widget.dart' as error_widget;
import '../../../../config/locale/app_localizations.dart';
import '../../../../core/components/reused_background.dart';
import '../../../../core/components/screen_state/loading_screen.dart';
import '../../../../core/helper/app_size.dart';
import '../../../../core/helper/font_style.dart';
import '../../../../core/utils/hex_color.dart';
import '../../../../core/utils/media_query_values.dart';
import '../../../auth/presentation/cubit/login/login_cubit.dart';
import '../../../auth/presentation/widgets/gradient_auth_button.dart';
import '../../../drawer/presentation/screens/drawer_screen.dart';
import '../cubits/your_mood/your_mood_cubit.dart';
import '../cubits/your_mood/your_mood_state.dart';
import 'items/middle_section.dart';
import 'items/topbar_section.dart';

class MoodScreen extends StatefulWidget {
  const MoodScreen({
    Key? key,
  }) : super(key: key);


  @override
  State<MoodScreen> createState() => _MoodScreenState();
}

class _MoodScreenState extends State<MoodScreen> {
  getMood() {
    BlocProvider.of<YourMoodCubit>(context).getMood(
      accessToken: context.read<LoginCubit>().authenticatedUser!.accessToken,
    );
  }

  @override
  void initState() {
    getMood();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerScreen(),
      body: ReusedBackground(
        // darKBG: ImagesPath.homeBGDarkBG,
        // lightBG: ImagesPath.homeBGLightBG,
        body: BlocBuilder<YourMoodCubit, YourMoodState>(
          builder: (context, state) {
            if (state is YourMoodIsLoading) {
              BlocProvider.of<YourMoodCubit>(
                context,
              ).selectedMood = null;
              return const LoadingScreen();
            } else if (state is YourMoodError) {
              return error_widget.ErrorWidget(
                onRetryPressed: () => getMood(),
                msg: state.message!,
              );
            } else {
              return SingleChildScrollView(
                child: SafeArea(
                  bottom: false,
                  // will control all sections from here after api integration
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TobBarSectionMood(
                        name: context
                            .read<LoginCubit>()
                            .authenticatedUser!
                            .user!
                            .username,
                      ),
                      const SizedBox(
                        height: AppPadding.pDefault,
                      ),
                      BlocConsumer<YourMoodCubit, YourMoodState>(
                        listener: (context, state) {},
                        builder: (context, state) {
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                            child: Column(
                              children: [
                                const MoodsSection(),
                                if (BlocProvider.of<YourMoodCubit>(context)
                                        .selectedMood !=
                                    null)
                                  Column(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(
                                          AppPadding.p20,
                                        ),
                                        margin: const EdgeInsets.symmetric(
                                          horizontal: AppPadding.pDefault,
                                        ),
                                        width: context.width,
                                        decoration: BoxDecoration(
                                          color: BlocProvider.of<YourMoodCubit>(
                                                    context,
                                                  ).selectedMood!.color ==
                                                  null
                                              ? Colors.transparent
                                              : HexColor(
                                                  BlocProvider.of<
                                                      YourMoodCubit>(
                                                    context,
                                                  ).selectedMood!.color!,
                                                ),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            CachedNetworkImage(
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Icon(Icons.error),
                                              imageUrl: BlocProvider.of<
                                                      YourMoodCubit>(
                                                    context,
                                                  ).selectedMood!.artworkUrl ??
                                                  "",
                                              width: 170,
                                              height: 100,
                                              fit: BoxFit.fill,
                                            ),
                                            const SizedBox(
                                              height: AppPadding.pDefault,
                                            ),
                                            Text(
                                              "${BlocProvider.of<YourMoodCubit>(context).selectedMood!.name}",
                                              style: styleW500(
                                                context,
                                                color: Colors.black,
                                              ),
                                            ),
                                            Text(
                                              "${BlocProvider.of<YourMoodCubit>(context).selectedMood!.altName}",
                                              textAlign: TextAlign.center,
                                              style: styleW400(
                                                context,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: AppPadding.p30,
                                      ), // continue button
                                      GradientCenterTextButton(
                                        onTap: () {
                                          pushNavigate(
                                            context,
                                            const MoodSongsScreen(),
                                          );
                                        },
                                        buttonText:
                                            ' ${AppLocalizations.of(context)!.translate('listen')} ${BlocProvider.of<YourMoodCubit>(context).selectedMood!.name} ${AppLocalizations.of(context)!.translate('audio')}',
                                        width: context.width * .8,
                                        listOfGradient: [
                                          HexColor("#DF23E1"),
                                          HexColor("#3820B2"),
                                          HexColor("#39BCE9"),
                                        ],
                                        listOfGradientBorder: [
                                          HexColor("#2ABDF8"),
                                          HexColor("#FFD027"),
                                          HexColor("#F4D119"),
                                          HexColor("#F915DE"),
                                        ],
                                      ),
                                    ],
                                  )
                                else
                                  Text(
                                    AppLocalizations.of(context)!
                                        .translate('select_your_mood')!,
                                    style: styleW500(context),
                                  ),
                              ]
                                  .map(
                                    (e) => Padding(
                                      padding: const EdgeInsetsDirectional.only(
                                        bottom: AppPadding.pDefault,
                                      ),
                                      child: e,
                                    ),
                                  )
                                  .toList(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
