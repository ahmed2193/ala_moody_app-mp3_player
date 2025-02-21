import 'package:alamoody/features/main_layout/cubit/tab_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../config/locale/app_localizations.dart';
import '../../../../../../core/helper/app_size.dart';
import '../../../../../../core/helper/font_style.dart';
import '../../../../../../core/helper/images.dart';
import '../../../../../home/presentation/widgets/rounded_container_recently_section.dart';
import '../../../../../profile/presentation/cubits/profile/profile_cubit.dart';

class SearchSectionOfLibrary extends StatelessWidget {
  const SearchSectionOfLibrary({Key? key, this.isPremium = false})
      : super(key: key);
  final bool? isPremium;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(
        end: AppPadding.pDefault,
        start: AppPadding.pDefault,
        top: AppPadding.p10,
      ),
      child: Column(
        children: [
          // premium icon
          if (isPremium == true)
              context.read<ProfileCubit>().userProfileData != null &&
            context
                    .read<ProfileCubit>()
                    .userProfileData!
                    .user!
                    .subscription!
                    .serviceId ==
               
                    '1'
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment  

.spaceBetween  ,
                    children: [
                      const SizedBox(),
                      GestureDetector(
                        onTap: () {
                     context
                                                .read<TabCubit>()
                                                .changeTab(4);
                        },
                        child: Image.asset(
                          ImagesPath.premiumImage,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  )
                : const SizedBox(),

          const SizedBox(
            height: AppPadding.p20,
          ),
          // library text and user image and search icon
          Row(
            children: [
            if (context.read<ProfileCubit>().userProfileData != null &&
            context
                    .read<ProfileCubit>()
                    .userProfileData!
                    .user!
                    .subscription!
                    .serviceId ==
                '1') CircleContainerWithGradientBorder(
                isMusic: false,
                width: 50,
                image: context
                    .read<ProfileCubit>()
                    .userProfileData!
                    .user!
                    .artworkUrl,
              ) else const SizedBox(),
              const SizedBox(
                width: AppPadding.p10,
              ),
              Expanded(
                child: Text(
                  AppLocalizations.of(context)!.translate('your_library')!,
                  style: styleW600(context, fontSize: FontSize.f18),
                ),
              ),
              // GestureDetector(
              //   onTap: (){},
              //   child: SvgPicture.asset(ImagesPath.searchbarIconSvg),
              // ),
            ],
          ),
        ],
      ),
    );
  }
}
