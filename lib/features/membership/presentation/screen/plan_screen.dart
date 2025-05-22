import 'package:alamoody/config/locale/app_localizations.dart';
import 'package:alamoody/core/components/screen_state/loading_screen.dart';
import 'package:alamoody/core/helper/print.dart';
import 'package:alamoody/core/utils/constants.dart';
import 'package:alamoody/core/utils/loading_indicator.dart';
import 'package:alamoody/core/utils/media_query_values.dart';
import 'package:alamoody/core/utils/no_data.dart';
import 'package:alamoody/features/membership/presentation/cubit/plan_cubit.dart';
import 'package:alamoody/features/membership/presentation/screen/strip_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../../core/utils/error_widget.dart' as error_widget;
import '../../../../core/components/reused_background.dart';
import '../../../../core/helper/font_style.dart';
import '../../../../core/helper/images.dart';
import '../../../../core/utils/hex_color.dart';
import '../../../auth/presentation/cubit/login/login_cubit.dart';
import '../../../auth/presentation/widgets/gradient_auth_button.dart';
import '../../../main_layout/cubit/tab_cubit.dart';
import '../../../profile/presentation/cubits/profile/profile_cubit.dart';
import '../cubit/coupon_cubit/coupon_cubit.dart';
import '../widget/member_ship_cardI_tems.dart';
import '../widget/tab_member_view.dart';

class PlanScreen extends StatelessWidget {
  const PlanScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        body: BodyContentMembership(),
      ),
    );
  }
}

class BodyContentMembership extends StatefulWidget {
  const BodyContentMembership({
    Key? key,
  }) : super(key: key);

  @override
  State<BodyContentMembership> createState() => _BodyContentMembershipState();
}

class _BodyContentMembershipState extends State<BodyContentMembership>
    with WidgetsBindingObserver {
  Future<void> _getData() => BlocProvider.of<PlanCubit>(context).getPlans(
        accessToken: context.read<LoginCubit>().authenticatedUser!.accessToken!,
      );
  bool isKeyboardVisible = false;
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    BlocProvider.of<PlanCubit>(context).rxPlanNumber.sink.add('');
    _getData();

    super.initState();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    // Check if the keyboard is open or closed
    final bottomInset = WidgetsBinding.instance.window.viewInsets.bottom;
    final keyboardIsVisible = bottomInset > 0.0;

    if (isKeyboardVisible != keyboardIsVisible) {
      setState(() {
        isKeyboardVisible = keyboardIsVisible;
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PlanCubit, PlanState>(
      listener: (context, state) {
        if (state is PlanDataError) {
          Constants.showError(context, state.message!); //
        }
        if (state is PlanDataSuccess) {
          // Original logic for showing a dialog if a subscription exists
          if (context
                  .read<ProfileCubit>()
                  .userProfileData!
                  .user!
                  .subscription !=
              null) {
            // Constants.onPlanDialog(context); //
          }
        }
        if (state is PlanSelected) {
          // For payment gateway navigation
          Navigator.of(context, rootNavigator: true).push(
            MaterialPageRoute(
              builder: (context) => StripPage(
                value: state.htmlData,
              ),
            ),
          ); //
        }
        if (state is SubPlanSelected) {
          // After direct subscription success
          Constants.showToast(message: state.message!); //
          // Refresh profile to get the latest subscription status
          BlocProvider.of<ProfileCubit>(context).getUserProfile(
            accessToken:
                context.read<LoginCubit>().authenticatedUser!.accessToken!,
          ); //
          // The ProfileLoaded state will then trigger setInitialSubscriptionState in PlanCubit
          // with the new subscription details.
          context.read<TabCubit>().changeTab(4); //
        }
      },
      child: BlocBuilder<CouponCubit, CouponState>(
        builder: (context, state) {
          if (isKeyboardVisible) {
            state.isFocused = true;
          } else {
            state.isFocused = false;
          }
          printColored(state.isFocused);
          return WillPopScope(
            onWillPop: () async {
              state.isFocused = false;
              return true; // Change to `false` if you want to block the pop.
            },
            child: SafeArea(
              child: ReusedBackground(
                body: Padding(
                  padding: EdgeInsets.only(
                    bottom: state.isFocused ? 60 : 0,
                  ),
                  child: Form(
                    key: context.read<CouponCubit>().formKey,
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: BlocBuilder<ProfileCubit, ProfileState>(
                            builder: (context, profileState) {
                              if (profileState is ProfileIsLoading) {
                                return const LoadingIndicator();
                              } else if (profileState is ProfileError) {
                                return error_widget.ErrorWidget(
                                  msg: profileState.message!,
                                  onRetryPressed: () {
                                    BlocProvider.of<PlanCubit>(context)
                                        .rxPlanNumber
                                        .sink
                                        .add('');
                                    _getData();
                                  },
                                );
                              } else if (profileState is ProfileLoaded) {
                                BlocProvider.of<PlanCubit>(context)
                                    .setInitialSubscriptionState(
                                  subscribedPlanId: profileState.userProfile
                                      .user!.subscription?.serviceId,
                                  subscribedPlanName: profileState
                                      .userProfile.user!.subscription?.planName,
                                );

                                return BlocConsumer<PlanCubit, PlanState>(
                                  listener: (context, state) {
                                    if (state is PlanDataError) {
                                      Constants.showError(
                                        context,
                                        state.message!,
                                      );
                                    }
                                    if (state is PlanDataSuccess) {
                                      if (context
                                              .read<ProfileCubit>()
                                              .userProfileData!
                                              .user!
                                              .subscription !=
                                          null) {
                                        Constants.onPlanDialog(context);
                                      }
                                    }
                                    if (state is PlanSelected) {
                                      Navigator.of(context, rootNavigator: true)
                                          .push(
                                        MaterialPageRoute(
                                          builder: (context) => StripPage(
                                            value: state.htmlData,
                                          ),
                                        ),
                                      );
                                    }
                                    if (state is SubPlanSelected) {
                                      Constants.showToast(
                                        message: state.message!,
                                      );

                                      BlocProvider.of<ProfileCubit>(context)
                                          .getUserProfile(
                                        accessToken: context
                                            .read<LoginCubit>()
                                            .authenticatedUser!
                                            .accessToken!,
                                      );

                                      context.read<TabCubit>().changeTab(4);
                                    }
                                  },
                                  builder: (context, state) {
                                    if (state is PlanDataLoading) {
                                      return const LoadingScreen();
                                    } else if (state is PlanDataSuccess) {
                                      return Stack(
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                children: [
                                                  SvgPicture.asset(
                                                    ImagesPath.membershipLogo,
                                                    width:
                                                        context.height * 0.068,
                                                    color: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge!
                                                        .color,
                                                    fit: BoxFit.cover,
                                                  ),
                                                  Text(
                                                    AppLocalizations.of(
                                                      context,
                                                    )!
                                                        .translate(
                                                      'get_one_month_for_free',
                                                    )!,
                                                    style: styleW700(
                                                      context,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      horizontal: 20,
                                                    ),
                                                    child: Text(
                                                      AppLocalizations.of(
                                                        context,
                                                      )!
                                                          .translate(
                                                        'be_premium_and_enjoy',
                                                      )!,
                                                      style: styleW400(
                                                        context,
                                                        fontSize: 10,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(),
                                                    child: Text(
                                                      AppLocalizations.of(
                                                        context,
                                                      )!
                                                          .translate(
                                                        "coupon_txt",
                                                      )!,
                                                      style: styleW600(
                                                        context,
                                                        fontSize: 14,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                ]
                                                    .map(
                                                      (e) => Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                          vertical: 2,
                                                        ),
                                                        child: e,
                                                      ),
                                                    )
                                                    .toList(),
                                              ),
                                              const SizedBox(height: 10),
                                              Expanded(
                                                flex: 20,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(),
                                                  child: TabBarMembershipReuse(
                                                    names: [
                                                      AppLocalizations.of(
                                                        context,
                                                      )!
                                                          .translate('yearly')!,
                                                      AppLocalizations.of(
                                                        context,
                                                      )!
                                                          .translate(
                                                        'monthly',
                                                      )!,
                                                      AppLocalizations.of(
                                                        context,
                                                      )!
                                                          .translate(
                                                        'more_plans',
                                                      )!,
                                                    ],
                                                    body: [
                                                      MemberShipCardItems(
                                                        planListData: state
                                                            .planData.yearly!,
                                                      ),
                                                      MemberShipCardItems(
                                                        planListData: state
                                                            .planData.monthly!,
                                                      ),
                                                      MemberShipCardItems(
                                                        planListData: state
                                                            .planData.others!,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      );
                                    } else if (state is PlanDataError) {
                                      return error_widget.ErrorWidget(
                                        onRetryPressed: () => _getData(),
                                        msg: state.message!,
                                      );
                                    } else {
                                      return const Center(child: NoData());
                                    }
                                  },
                                );
                              } else {
                                return const LoadingIndicator();
                              }
                            },
                          ),
                        ),
                        if (!state.isFocused)
                          BlocBuilder<PlanCubit, PlanState>(
                            builder: (context, state) {
                              return Positioned(
                                bottom: 55,
                                left: 20,
                                right: 20,
                                child: state is PlanDataLoading ||
                                        state is PlanDataError
                                    ? const SizedBox()
                                    : Container(
                                        child: GradientCenterTextButton(
                                          width: 300,
                                          onTap: () {
                                            if (context
                                                        .read<ProfileCubit>()
                                                        .userProfileData!
                                                        .user!
                                                        .subscription ==
                                                    null ||
                                                BlocProvider.of<PlanCubit>(
                                                          context,
                                                        ).rxPlanNumber.value !=
                                                        '' &&
                                                    BlocProvider.of<PlanCubit>(
                                                          context,
                                                        ).rxPlanNumber.value !=
                                                        context
                                                            .read<
                                                                ProfileCubit>()
                                                            .userProfileData!
                                                            .user!
                                                            .subscription!
                                                            .serviceId) {
                                              Constants.subscribeToPlans(
                                                context,
                                                BlocProvider.of<PlanCubit>(
                                                  context,
                                                ).rxPlanTitle.value,
                                                AppLocalizations.of(context)!
                                                    .translate('selected_plan')!
                                                    .replaceFirst(
                                                      '{planTitle}',
                                                      BlocProvider.of<
                                                          PlanCubit>(
                                                        context,
                                                      ).rxPlanTitle.value,
                                                    ),

                                                // "The selected plan is ${BlocProvider.of<PlanCubit>(context).rxPlanTilte.value} Would you like to proceed with the subscription?"
                                              );
                                            } else {
                                              Constants.showError(
                                                context,
                                                AppLocalizations.of(context)!
                                                    .translate(
                                                  'choose_plan_to_subscribe',
                                                )!,
                                              );
                                            }
                                          },
                                          listOfGradientBorder: const [
                                            Colors.transparent,
                                            Colors.transparent,
                                          ],
                                          buttonText:
                                              AppLocalizations.of(context)!
                                                  .translate('continue'),
                                          listOfGradient: [
                                            HexColor("#DF23E1"),
                                            HexColor("#3820B2"),
                                            HexColor("#39BCE9"),
                                          ],
                                        ),
                                      ),
                              );
                            },
                          )
                        else
                          const SizedBox(),

                        //            BlocBuilder<PlanCubit, PlanState>(
                        //   builder: (context, state) {
                        //     return state is SubPlanSelectedLoading
                        //         ? Container(
                        //             color: Theme.of(context)
                        //                 .scaffoldBackgroundColor
                        //                 .withOpacity(0.9),
                        //             height: MediaQuery.of(context).size.height,
                        //             width: MediaQuery.of(context).size.width,
                        //             child: const CircularProgressIndicator(),
                        //           )
                        //         : const SizedBox();
                        //   },
                        // )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
