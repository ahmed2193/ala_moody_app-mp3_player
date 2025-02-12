import 'package:alamoody/config/locale/app_localizations.dart';
import 'package:alamoody/core/components/screen_state/loading_screen.dart';
import 'package:alamoody/core/helper/print.dart';
import 'package:alamoody/core/utils/constants.dart';
import 'package:alamoody/core/utils/loading_indicator.dart';
import 'package:alamoody/core/utils/media_query_values.dart';
import 'package:alamoody/core/utils/no_data.dart';
import 'package:alamoody/features/membership/domain/entities/plan_item_entity.dart';
import 'package:alamoody/features/membership/presentation/cubit/plan_cubit.dart';
import 'package:alamoody/features/membership/presentation/screen/strip_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../../core/utils/error_widget.dart' as error_widget;
import '../../../../core/components/reused_background.dart';
import '../../../../core/helper/app_size.dart';
import '../../../../core/helper/font_style.dart';
import '../../../../core/helper/images.dart';
import '../../../../core/utils/hex_color.dart';
import '../../../auth/presentation/cubit/login/login_cubit.dart';
import '../../../auth/presentation/widgets/gradient_auth_button.dart';
import '../../../main_layout/cubit/tab_cubit.dart';
import '../../../main_layout/presentation/pages/main_layout_screen.dart';
import '../../../profile/presentation/cubits/profile/profile_cubit.dart';
import '../cubit/coupon_cubit/coupon_cubit.dart';
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
    return BlocBuilder<CouponCubit, CouponState>(
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
                lightBG: ImagesPath.homeBGLightBG,
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
                                    .rxPlanNumber
                                    .sink
                                    .add(
                                      profileState.userProfile.user!
                                                  .subscription ==
                                              null
                                          ? ''
                                          : profileState.userProfile.user!
                                              .subscription!.serviceId!,
                                    );

                                return BlocConsumer<PlanCubit, PlanState>(
                                  listener: (context, state) {
                                    if (state is PlanDataError) {
                                      Constants.showError(
                                          context, state.message!,);
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
                                          message: state.message!,);

                                      BlocProvider.of<ProfileCubit>(context)
                                          .getUserProfile(
                                        accessToken: context
                                            .read<LoginCubit>()
                                            .authenticatedUser!
                                            .accessToken!,
                                      );

                                 context
                                                .read<TabCubit>()
                                                .changeTab(4);
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
                                                            context,)!
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
                                                              context,)!
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
                                                              context,)!
                                                          .translate(
                                                              "coupon_txt",)!,
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
                                                              context,)!
                                                          .translate('yearly')!,
                                                      AppLocalizations.of(
                                                              context,)!
                                                          .translate(
                                                              'monthly',)!,
                                                      AppLocalizations.of(
                                                              context,)!
                                                          .translate(
                                                              'more_plans',)!,
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
                                                                context,)
                                                            .rxPlanNumber
                                                            .value !=
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
                                                ).rxPlanTilte.value,
                                                AppLocalizations.of(context)!
                                                    .translate('selected_plan')!
                                                    .replaceFirst(
                                                      '{planTitle}',
                                                      BlocProvider.of<
                                                          PlanCubit>(
                                                        context,
                                                      ).rxPlanTilte.value,
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
                ),),
          ),
        );
      },
    );
  }
}

class MemberShipCardItems extends StatefulWidget {
  const MemberShipCardItems({Key? key, required this.planListData})
      : super(key: key);
  final List<PlanDataItemEntity> planListData;

  @override
  _MemberShipCardItemsState createState() => _MemberShipCardItemsState();
}

class _MemberShipCardItemsState extends State<MemberShipCardItems> {
  String? selectedPlanId='';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context)
              .viewInsets
              .bottom, // adjusts padding based on keyboard visibility
        ),
        child: Column(
          children: [
            const SizedBox(height: 8),
            StreamBuilder<String>(
              stream: BlocProvider.of<PlanCubit>(context).rxPlanNumber,
              builder: (context, rxPlanNumberSnapshot) {
                // Use the state from the stream, or fallback to `selectedPlanId` if not set
                final String selectedPlan =
                    selectedPlanId ?? rxPlanNumberSnapshot.data ?? '';

                return Column(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: widget.planListData.length,
                      itemBuilder: (context, index) {
                        final plan = widget.planListData[index];
                        final bool isSelected =
                            selectedPlan == plan.id.toString();

                        return Padding(
                          padding: EdgeInsets.fromLTRB(
                            6,
                            6,
                            6,
                            index == widget.planListData.length - 1 ? 20 : 9,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              // Handle plan selection
                              setState(() {
                                selectedPlanId = plan.id.toString();
                              });

                              // Update the stream with selected plan
                              BlocProvider.of<PlanCubit>(context)
                                  .rxPlanNumber
                                  .sink
                                  .add(plan.id.toString());
                              BlocProvider.of<PlanCubit>(context)
                                  .rxPlanTilte
                                  .sink
                                  .add(plan.title.toString());
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  gradient: isSelected
                                      ? const LinearGradient(
                                          colors: [
                                            Color(0xFFA007A8),
                                            Color(0xFF089EEE),
                                          ],
                                        )
                                      : null,
                                  border: isSelected
                                      ? Border.all(
                                          color: Colors.white, width: 2,)
                                      : Border.all(width: 0),
                                  borderRadius: BorderRadius.circular(30),
                                  image: !isSelected
                                      ? const DecorationImage(
                                          image: AssetImage(
                                            ImagesPath.subscriptionBgItem1,
                                          ),
                                          fit: BoxFit.fill,
                                        )
                                      : null,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          plan.title!,
                                          style: styleW400(
                                            context,
                                            fontSize: FontSize.f14,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              '${plan.price!} AED',
                                              style: styleW600(
                                                context,
                                                fontSize: FontSize.f18,
                                                color: Colors.white,
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Icon(
                                              isSelected
                                                  ? Icons.radio_button_checked
                                                  : Icons.radio_button_off,
                                              color: Colors.white,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: AppSize.a8),
                                    CustomTextWidget(text: plan.description!),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                     CouponForm(selectedPlanId: selectedPlanId??''),
                    const SizedBox(height: 120),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// class MemberShipCardItems extends StatelessWidget {
//   const MemberShipCardItems({Key? key, required this.planListData})
//       : super(key: key);
//   final List<PlanDataItemEntity> planListData;

//   // void _scrollToBottomOnFocus() {
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Padding(
//         padding: EdgeInsets.only(
//           bottom: MediaQuery.of(context).viewInsets.bottom,
//         ),
//         child: Column(
//           children: [
//             const SizedBox(height: 8),
//             StreamBuilder<String>(
//               stream: BlocProvider.of<PlanCubit>(context).rxPlanNumber,
//               builder: (context, rxPlanNumberSnapshot) {
//                 return !rxPlanNumberSnapshot.hasData
//                     ? Container()
//                     : Column(
//                         children: [
//                           ListView.builder(
//                             shrinkWrap: true,
//                             physics: const NeverScrollableScrollPhysics(),
//                             itemCount: planListData.length,
//                             itemBuilder: (context, index) {
//                               final bool isLastItem =
//                                   index == planListData.length - 1;
//                               return Padding(
//                                 padding: EdgeInsets.fromLTRB(
//                                   6,
//                                   6,
//                                   6,
//                                   isLastItem ? 20 : 9,
//                                 ),
//                                 child: GestureDetector(
//                                   onTap: () {
//                                     BlocProvider.of<PlanCubit>(context)
//                                         .rxPlanNumber
//                                         .sink
//                                         .add(
//                                           planListData[index].id.toString(),
//                                         );
//                                     BlocProvider.of<PlanCubit>(context)
//                                         .rxPlanTilte
//                                         .sink
//                                         .add(
//                                           planListData[index].title.toString(),
//                                         );
//                                   },
//                                   child: ClipRRect(
//                                     borderRadius: BorderRadius.circular(30),
//                                     child: Container(
//                                       padding: const EdgeInsets.all(20),
//                                       decoration: BoxDecoration(
//                                         gradient: rxPlanNumberSnapshot.data !=
//                                                 planListData[index]
//                                                     .id
//                                                     .toString()
//                                             ? null
//                                             : const LinearGradient(
//                                                 colors: [
//                                                   Color(0xFFA007A8),
//                                                   Color(0xFF089EEE),
//                                                 ],
//                                               ),
//                                         border: rxPlanNumberSnapshot.data ==
//                                                 planListData[index]
//                                                     .id
//                                                     .toString()
//                                             ? Border.all(
//                                                 color: Colors.white,
//                                                 width: 2,
//                                               )
//                                             : Border.all(width: 0),
//                                         borderRadius: BorderRadius.circular(30),
//                                         image: rxPlanNumberSnapshot.data !=
//                                                 planListData[index]
//                                                     .id
//                                                     .toString()
//                                             ? const DecorationImage(
//                                                 image: AssetImage(
//                                                   ImagesPath
//                                                       .subscriptionBgItem1,
//                                                 ),
//                                                 fit: BoxFit.fill,
//                                               )
//                                             : null,
//                                       ),
//                                       child: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           Row(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.spaceBetween,
//                                             children: [
//                                               Text(
//                                                 planListData[index].title!,
//                                                 style: styleW400(
//                                                   context,
//                                                   fontSize: FontSize.f14,
//                                                   color: Colors.white,
//                                                 ),
//                                               ),
//                                               Row(
//                                                 children: [
//                                                   Text(
//                                                     '${planListData[index].price!} AED',
//                                                     style: styleW600(
//                                                       context,
//                                                       fontSize: FontSize.f18,
//                                                       color: Colors.white,
//                                                     ),
//                                                   ),
//                                                   const SizedBox(width: 10),
//                                                   if (rxPlanNumberSnapshot
//                                                           .data ==
//                                                       planListData[index]
//                                                           .id
//                                                           .toString())
//                                                     const Icon(
//                                                       Icons
//                                                           .radio_button_checked,
//                                                       color: Colors.white,
//                                                     )
//                                                   else
//                                                     const Icon(
//                                                       Icons.radio_button_off,
//                                                       color: Colors.white,
//                                                     ),
//                                                 ],
//                                               ),
//                                             ],
//                                           ),
//                                           const SizedBox(height: AppSize.a8),
//                                           CustomTextWidget(
//                                             text: planListData[index]
//                                                 .description!,
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               );
//                             },
//                           ),
//                           const CouponForm(),
//                           const SizedBox(height: 120),
//                         ],
//                       );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class CouponForm extends StatelessWidget {
   CouponForm({Key? key , required this.selectedPlanId}) : super(key: key);
  String selectedPlanId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: BlocConsumer<CouponCubit, CouponState>(
        buildWhen: (previousState, state) {
        if (state is CouponLoading ||
            state is CouponError 
            ) {
          return true;
        }
        return false;
      },
        listener: (context, state) {
          if (state is CouponApplied) {
            final cubit = context.read<CouponCubit>();
            // printColored(cubit.couponModel!.msg!);
            // printColored(cubit.couponModel!.data!);
            String couponMessage(
              String couponCode,
              double discount,
              double originalPrice,
            ) {
              final double finalPrice = originalPrice - discount;
              final double discountPercentage =
                  (discount / originalPrice) * 100;

              return AppLocalizations.of(context)!
                  .translate('coupon_applied')!
                  .replaceFirst('{couponCode}', couponCode)
                  .replaceFirst('{discount}', discount.toStringAsFixed(2))
                  .replaceFirst(
                    '{discountPercentage}',
                    discountPercentage.toStringAsFixed(2),
                  )
                  .replaceFirst('{finalPrice}', finalPrice.toStringAsFixed(2))
                  .replaceFirst(
                    '{originalPrice}',
                    originalPrice.toStringAsFixed(2),
                  );

//                '''
// Coupon '$couponCode' applied:
// You saved ${discount.toStringAsFixed(2)}  AED (${discountPercentage.toStringAsFixed(2)}%)!
// Your final total is now ${finalPrice.toStringAsFixed(2)} AED (original price: AED ${originalPrice.toStringAsFixed(2)}).
// ''';
            }

            printColored(cubit.couponModel!.data!.discount);
            printColored(cubit.couponModel!.data!.price!.toString());

            Constants.subscribeToPlans(
              context,
              BlocProvider.of<PlanCubit>(context).rxPlanTilte.value,
              couponMessage(
                cubit.couponController.text,
                double.parse(cubit.couponModel!.data!.discount!.toString()),
                double.parse(cubit.couponModel!.data!.price!.toString()),
              ),
            );
            // ScaffoldMessenger.of(context).showSnackBar(
            //   SnackBar(
            //     content: Text('coupon added successfully '),
            //   ),
            // );
          } else if (state is CouponError) {
            Constants.showError(context, state.error);
          }
        },
        builder: (context, state) {
          final cubit = context.read<CouponCubit>();

          return Row(
            children: <Widget>[
              Expanded(
                child: TextFormField(
                  controller: cubit.couponController,
                  focusNode: cubit.couponFocusNode,
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(
                    labelStyle: styleW500(
                      context,
                      // color: Colors.white,
                      fontSize: FontSize.f12,
                    ),
                    labelText: AppLocalizations.of(context)!
                        .translate('enter_coupon_code'),
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!
                          .translate('please_enter_coupon_code');
                    }
                    return null;
                  },
                ),
              ),
            

              const SizedBox(width: 10),
              if (state is CouponLoading )
                const CircularProgressIndicator()
              else
                ElevatedButton(
                  onPressed: () {
                    printColored('id');
                    printColored(selectedPlanId);
                    printColored(BlocProvider.of<PlanCubit>(
                      context,
                    ).rxPlanNumber.value,);
                    if (cubit.formKey.currentState?.validate() ?? false) {
                      if (context
                                  .read<ProfileCubit>()
                                  .userProfileData!
                                  .user!
                                  .subscription ==
                              null ||
                       selectedPlanId !=
                                  '' &&
                            selectedPlanId !=
                                  context
                                      .read<ProfileCubit>()
                                      .userProfileData!
                                      .user!
                                      .subscription!
                                      .serviceId) {
                        {
                          FocusScope.of(context).unfocus();

                          // Apply the coupon
                          cubit.applyCoupon(
                            accessToken: context
                                .read<LoginCubit>()
                                .authenticatedUser!
                                .accessToken!,
                            planId: selectedPlanId,
                          );
                        }
                      } else {
                        Constants.showError(
                          context,
                   selectedPlanId.isEmpty?AppLocalizations.of(context)!
                                                    .translate(
                                                  'choose_plan_to_subscribe',
                                                )??'':       AppLocalizations.of(context)!
                              .translate('please_enter_coupon_code')!,
                        );
                      }

                      // Close the keyboard
                    }
                  },
                  child: Text(
                    AppLocalizations.of(context)!.translate('apply')!,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class CustomTextWidget extends StatelessWidget {
  final String text;

  const CustomTextWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final List<String> lines = text.split('\n');
    final List<String> capitalizedLines = lines.map((line) {
      if (line.isNotEmpty) {
        return line[0].toUpperCase() + line.substring(1);
      }
      return line;
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: capitalizedLines
          .map(
            (line) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 8.0, top: 6),
                    width: 8.0,
                    height: 8.0,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      line,
                      style: styleW700(context, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}
