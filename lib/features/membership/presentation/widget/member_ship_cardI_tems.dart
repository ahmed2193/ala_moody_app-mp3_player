import 'package:alamoody/features/membership/domain/entities/plan_item_entity.dart';
import 'package:alamoody/features/membership/presentation/cubit/plan_cubit.dart';
import 'package:alamoody/features/membership/presentation/widget/coupon_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/helper/font_style.dart';
import '../../../../core/helper/images.dart';
import '../../../profile/presentation/cubits/profile/profile_cubit.dart';

class MemberShipCardItems extends StatefulWidget {
  const MemberShipCardItems({Key? key, required this.planListData}) : super(key: key);
  final List<PlanDataItemEntity> planListData;

  @override
  _MemberShipCardItemsState createState() => _MemberShipCardItemsState();
}

class _MemberShipCardItemsState extends State<MemberShipCardItems> {
  String? selectedPlanId = '';

  @override
  void initState() {
    super.initState();
    final userSubscription = context.read<ProfileCubit>().userProfileData?.user?.subscription;
    if (userSubscription != null) {
      setState(() {
        selectedPlanId = userSubscription.serviceId;
      });
      BlocProvider.of<PlanCubit>(context).rxPlanNumber.sink.add(userSubscription.serviceId!);
      BlocProvider.of<PlanCubit>(context).rxPlanTilte.sink.add(userSubscription.planName ?? '');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final padding = EdgeInsets.symmetric(horizontal: screenWidth * 0.036);

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          children: [
            const SizedBox(height: 7),
            StreamBuilder<String>(
              stream: BlocProvider.of<PlanCubit>(context).rxPlanNumber,
              builder: (context, rxPlanNumberSnapshot) {
                final String selectedPlan = selectedPlanId ?? rxPlanNumberSnapshot.data ?? '';
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.planListData.length,
                  itemBuilder: (context, index) {
                    final plan = widget.planListData[index];
                    final bool isSelected = selectedPlan == plan.id.toString();
                    return Padding(
                      padding: EdgeInsets.fromLTRB(5.4, 5.4, 5.4, index == widget.planListData.length - 1 ? 18 : 8.1),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedPlanId = plan.id.toString();
                          });
                          BlocProvider.of<PlanCubit>(context).rxPlanNumber.sink.add(plan.id.toString());
                          BlocProvider.of<PlanCubit>(context).rxPlanTilte.sink.add(plan.title.toString());
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Container(
                            padding: EdgeInsets.all(screenWidth * 0.036),
                            decoration: BoxDecoration(
                              gradient: isSelected
                                  ? const LinearGradient(colors: [Color(0xFFA007A8), Color(0xFF089EEE)])
                                  : null,
                              border: isSelected ? Border.all(color: Colors.white, width: 1.35) : null,
                              borderRadius: BorderRadius.circular(30),
                              image: !isSelected
                                  ? const DecorationImage(
                                      image: AssetImage(ImagesPath.subscriptionBgItem1),
                                      fit: BoxFit.fill,
                                    )
                                  : null,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      plan.title!,
                                      style: styleW400(context, fontSize: screenWidth * 0.036, color: Colors.white),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          '${plan.price!} AED',
                                          style: styleW600(context, fontSize: screenWidth * 0.045, color: Colors.white),
                                        ),
                                        SizedBox(width: screenWidth * 0.018),
                                        Icon(
                                          isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 7),
                                CustomTextWidget(text: plan.description!),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            CouponForm(selectedPlanId: selectedPlanId ?? ''),
            const SizedBox(height: 120),
          ],
        ),
      ),
    );
  }
}
