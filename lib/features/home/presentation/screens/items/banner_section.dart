import 'package:alamoody/core/utils/hex_color.dart';
import 'package:alamoody/features/main/presentation/cubit/main_cubit.dart';
import 'package:alamoody/features/main_layout/cubit/tab_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../config/themes/colors.dart';
import '../../../../../core/helper/app_size.dart';
import '../../../../../core/helper/font_style.dart';
import '../../../../../core/helper/images.dart';
import '../../../../main_layout/presentation/pages/main_layout_screen.dart';
import '../../../../profile/presentation/cubits/profile/profile_cubit.dart';
import '../../widgets/banner_button.dart';

class BannerSection extends StatelessWidget {
  const BannerSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        if (state is ProfileIsLoading) {
          return const SizedBox();
        } else {
          return context.read<ProfileCubit>().userProfileData == null ||
                  context
                          .read<ProfileCubit>()
                          .userProfileData!
                          .user!
                          .subscription ==
                      null
              ? const SizedBox()
              : context
                          .read<ProfileCubit>()
                          .userProfileData!
                          .user!
                          .subscription!
                          .serviceId ==
                      '1'
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppPadding.p10,
                      ),
                      child: !MainCubit.isDark
                          ? Card(
                              color: HexColor(
                                  '#58257F',), // Set to transparent to show the background image
                              elevation: 0, // Remove shadow if needed
                              child: IntrinsicHeight(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8,),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      // Column of texts and premium now
                                      Expanded(
                                        child: Padding(
                                          padding:
                                              const EdgeInsetsDirectional.only(
                                            top: AppPadding.p4,
                                            start: AppPadding.p20,
                                            bottom: AppPadding.p4,
                                            end: AppPadding.p20 * 2,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Enjoy audio with no interruptions",
                                                style: styleW700(
                                                  context,
                                                  fontSize: FontSize.f16,
                                                  color: Colors
                                                      .white, // Change text color if needed
                                                ),
                                              ),
                                              Text(
                                                "Block all the ads on ala moody in just one click",
                                                style: styleW600(
                                                  context,
                                                  fontSize: FontSize.f12,
                                                  color: Colors
                                                      .white, // Change text color if needed
                                                ),
                                              ),
                                              const SizedBox(
                                                  height: AppPadding.p8,),
                                              BannerButton(
                                                backgroundColor:
                                                    HexColor('#8D00FF'),
                                                textColor: HexColor('#FFFFFF'),
                                                onTap: () {
                                               context
                                                .read<TabCubit>()
                                                .changeTab(4);
                                                },
                                                buttonText: 'premium_now',
                                              ),
                                            ]
                                                .map(
                                                  (e) => Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                            .only(
                                                      bottom: AppPadding.p4,
                                                    ),
                                                    child: e,
                                                  ),
                                                )
                                                .toList(),
                                          ),
                                        ),
                                      ),
                                      // Image
                                      Align(
                                        alignment:
                                            AlignmentDirectional.bottomEnd,
                                        child: Image.asset(
                                          ImagesPath.coupleImage,
                                          width: 100,
                                          height: 123,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : Card(
                              color: AppColors.cBannerColor,
                              child: IntrinsicHeight(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      // column of texts and premium now
                                      Expanded(
                                        child: Padding(
                                          padding:
                                              const EdgeInsetsDirectional.only(
                                            top: AppPadding.p4,
                                            start: AppPadding.p20,
                                            bottom: AppPadding.p4,
                                            end: AppPadding.p20 * 2,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Enjoy audio with no interruptions",
                                                style: styleW700(
                                                  context,
                                                  fontSize: FontSize.f16,
                                                  color: Colors
                                                      .white, // Change text color if needed
                                                ),
                                              ),
                                              Text(
                                                "Block all the ads on ala moody in just one click",
                                                style: styleW600(
                                                  context,
                                                  fontSize: FontSize.f12,
                                                  color: Colors
                                                      .white, // Change text color if needed
                                                ),
                                              ),
                                              const SizedBox(
                                                  height: AppPadding.p4,),
                                              BannerButton(
                                                onTap: () {
                                           context
                                                .read<TabCubit>()
                                                .changeTab(4);
                                                },
                                                buttonText: 'premium_now',
                                              ),
                                            ]
                                                .map(
                                                  (e) => Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                            .only(
                                                      bottom: AppPadding.p4,
                                                    ),
                                                    child: e,
                                                  ),
                                                )
                                                .toList(),
                                          ),
                                        ),
                                      ),
                                      // image
                                      Align(
                                        alignment:
                                            AlignmentDirectional.bottomEnd,
                                        child: Image.asset(
                                          ImagesPath.coupleImage,
                                          width: 100,
                                          height: 123,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                    )
                  : const SizedBox();
        }
      },
    );
  }
}
