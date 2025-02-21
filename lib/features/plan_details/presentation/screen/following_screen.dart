import 'package:alamoody/config/locale/app_localizations.dart';
import 'package:alamoody/core/components/reused_background.dart';
import 'package:alamoody/core/components/screen_state/loading_screen.dart';
import 'package:alamoody/core/helper/font_style.dart';
import 'package:alamoody/core/helper/images.dart';
import 'package:alamoody/core/utils/back_arrow.dart';
import 'package:alamoody/core/utils/constants.dart';
import 'package:alamoody/core/utils/hex_color.dart';
import 'package:alamoody/core/utils/loading_indicator.dart';
import 'package:alamoody/core/utils/media_query_values.dart';
import 'package:alamoody/core/utils/no_data.dart';
import 'package:alamoody/features/auth/presentation/cubit/login/login_cubit.dart';
import 'package:alamoody/features/auth/presentation/widgets/gradient_auth_button.dart';
import 'package:alamoody/features/main_layout/presentation/pages/main_layout_screen.dart';
import 'package:alamoody/features/membership/presentation/cubit/plan_cubit.dart';
import 'package:alamoody/features/membership/presentation/cubit/unsubscribe_plan_cubit/unsubscribe_plan_cubit.dart';
import 'package:alamoody/features/profile/presentation/cubits/profile/profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/helper/app_size.dart';
import '../../../../../core/utils/error_widget.dart' as error_widget;
import '../../../main_layout/cubit/tab_cubit.dart';

class PlanDetailsScreen extends StatefulWidget {
  const PlanDetailsScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<PlanDetailsScreen> createState() => _PlanDetailsScreenState();
}

class _PlanDetailsScreenState extends State<PlanDetailsScreen> {
  ScrollController scrollController = ScrollController();

  // getGetPlan() {
  //   BlocProvider.of<PlanCubit>(context).getPlan(
  //     accessToken: context.read<LoginCubit>().authenticatedUser!.accessToken,
  //   );
  // }

  // void _setupScrollControllerSongs(context) {
  //   scrollController.addListener(() {
  //     if (scrollController.position.atEdge) {
  //       if (scrollController.position.pixels != 0 &&
  //           BlocProvider.of<PlanCubit>(context).pageNo <=
  //               BlocProvider.of<PlanCubit>(context).totalPages) {
  //         getGetPlan();
  //       }
  //     }
  //   });
  // }

  @override
  void initState() {
    // getGetPlan();

    // _setupScrollControllerSongs(context);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildBodyContent();
  }

  Widget _buildBodyContent() {
    // final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return BlocConsumer<UnsubscribePlanCubit, UnsubscribePlanState>(
      listener: (context, state) {
        if (state is UnsubscribePlanLoading) {
          // Navigator.of(context).pop();
        }
        if (state is UnsubscribePlanSuccess) {
          BlocProvider.of<ProfileCubit>(context).getUserProfile(
            accessToken:
                context.read<LoginCubit>().authenticatedUser!.accessToken!,
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Successfully unsubscribed from the plan ',
              ),
            ),
          );
          Navigator.of(context, rootNavigator: true).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const App(),
            ),
          );

          // Constants.showToast(message: 'Successfully unsubscribed from the plan');
        }
        if (state is UnsubscribePlanFailed) {
          // Navigator.of(context).pop(true);
          Constants.showToast(
            message: state.message,
          );
        }
      },
      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
            // key: scaffoldKey,
            // drawer: const DrawerScreen(),
            body: ReusedBackground(
              lightBG: ImagesPath.homeBGLightBG,
              body: Column(
                children: [
                  SizedBox(
                    height: context.height * 0.017,
                  ),
                  Row(
                    children: [
                      const BackArrow(),
                      SizedBox(
                        width: context.height * 0.017,
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            AppLocalizations.of(context)!
                                .translate('purchased_plan_details')!,
                            style: styleW600(context)!
                                .copyWith(fontSize: FontSize.f18),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 40,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: AppLocalizations.of(context)!
                                    .translate('your_current_plan'),
                                style: styleW600(context, fontSize: 18),
                              ),
                              TextSpan(
                                text:
                                    '  ${context.read<ProfileCubit>().userProfileData!.user!.subscription!.planName!} ',
                                style: styleW500(
                                  context,
                                  fontSize: 16,
                                ), // Customize color if  needed
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  BlocBuilder<ProfileCubit, ProfileState>(
                    builder: (context, profileState) {
                      if (profileState is ProfileIsLoading) {
                        return const LoadingIndicator();
                      } else if (profileState is ProfileError) {
                        return error_widget.ErrorWidget(
                          msg: profileState.message!,
                          onRetryPressed: () {
                            // BlocProvider.of<PlanCubit>(context).rxPlanNumber.sink.add('');
                            // _getData();
                          },
                        );
                      } else if (profileState is ProfileLoaded) {
                        BlocProvider.of<PlanCubit>(context)
                            .rxPlanNumber
                            .sink
                            .add(
                              profileState.userProfile.user!.subscription ==
                                      null
                                  ? ''
                                  : profileState.userProfile.user!.subscription!
                                      .serviceId!,
                            );
                        // if (profileState.userProfile.user!.subscription == null) {

                        // }
                        return BlocConsumer<PlanCubit, PlanState>(
                          listener: (context, state) {
                            if (state is SubPlanSelected) {
                              Constants.showToast(message: state.message!);

                              BlocProvider.of<ProfileCubit>(context)
                                  .getUserProfile(
                                accessToken: context
                                    .read<LoginCubit>()
                                    .authenticatedUser!
                                    .accessToken!,
                              );

                              // Navigator.of(context, rootNavigator: true).pushReplacement(
                              //   MaterialPageRoute(
                              //     builder: (context) => const App(
                              //       index: 4,
                              //     ),
                              //   ),
                              // );
                            }
                          },
                          builder: (context, state) {
                            if (state is PlanDataLoading) {
                              return const LoadingScreen();
                            } else if (state is PlanDataSuccess) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 20,
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!
                                          .translate('remaining_days')!,
                                      style: styleW600(context)!
                                          .copyWith(fontSize: FontSize.f18),
                                    ),
                                    SizedBox(
                                      height: context.height * 0.027,
                                    ),
                                    Text(
                                      state.planData.current!.remainingSDys
                                          .toString(),
                                      style: styleW700(context)!
                                          .copyWith(fontSize: 30),
                                    ),
                                    SizedBox(
                                      height: context.height * 0.027,
                                    ),
                                    Text(
                                      AppLocalizations.of(context)!
                                          .translate('days')!,
                                      style: styleW700(context)!
                                          .copyWith(fontSize: 30),
                                    ),
                                    SizedBox(
                                      height: context.height * 0.077,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        GradientCenterTextButton(
                                          width: context.width * 0.35,
                                          buttonText:
                                              AppLocalizations.of(context)!
                                                  .translate('renew'),
                                          listOfGradient: [
                                            HexColor("#DF23E1"),
                                            HexColor("#3820B2"),
                                            HexColor("#39BCE9"),
                                          ],
                                          onTap: () {
                                            BlocProvider.of<PlanCubit>(context)
                                                .subscribeToPlans(
                                              accessToken: context
                                                  .read<LoginCubit>()
                                                  .authenticatedUser!
                                                  .accessToken!,
                                              planId:
                                                  BlocProvider.of<PlanCubit>(
                                                context,
                                              ).rxPlanNumber.value,
                                            );
                                          },
                                        ),
                                        GradientCenterTextButton(
                                          width: context.width * 0.35,
                                          buttonText:
                                              AppLocalizations.of(context)!
                                                  .translate('upgrade'),
                                          listOfGradient: [
                                            HexColor("#DF23E1"),
                                            HexColor("#3820B2"),
                                            HexColor("#39BCE9"),
                                          ],
                                          onTap: () {
                                            context
                                                .read<TabCubit>()
                                                .changeTab(4);
                                         
                                          },
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: context.height * 0.027,
                                    ),
                                    GradientCenterTextButton(
                                      width: context.width * 0.38,
                                      buttonText: AppLocalizations.of(context)!
                                          .translate('unsubscribe'),
                                      listOfGradient: [
                                        HexColor("#DF23E1"),
                                        HexColor("#3820B2"),
                                        HexColor("#39BCE9"),
                                      ],
                                      onTap: () {
                                        Constants.cancelPlanDialog(context);
                                      },
                                    ),
                                  ],
                                ),
                              );
                            } else if (state is PlanDataError) {
                              return error_widget.ErrorWidget(
                                onRetryPressed: () {},
                                //_ getData(),
                                msg: state.message!,
                              );
                            } else {
                              return const Center(
                                child: NoData(),
                              );
                            }
                          },
                        );
                      } else {
                        return const LoadingIndicator();
                      }
                    },
                  ),
                  SizedBox(
                    height: context.height * 0.129,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
