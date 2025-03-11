import 'package:alamoody/config/locale/app_localizations.dart';
import 'package:alamoody/core/helper/app_size.dart';
import 'package:alamoody/core/helper/font_style.dart';
import 'package:alamoody/core/helper/print.dart';
import 'package:alamoody/core/utils/constants.dart';
import 'package:alamoody/features/membership/presentation/cubit/coupon_cubit/coupon_cubit.dart';
import 'package:alamoody/features/membership/presentation/cubit/plan_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/presentation/cubit/login/login_cubit.dart';
import '../../../profile/presentation/cubits/profile/profile_cubit.dart';

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
