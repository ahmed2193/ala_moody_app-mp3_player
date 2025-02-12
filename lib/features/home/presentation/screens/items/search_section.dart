import 'package:alamoody/features/profile/presentation/cubits/profile/profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/helper/images.dart';
import '../../../../../core/utils/hex_color.dart';
import '../../../../../core/utils/navigator_reuse.dart';
import '../../../../notification/presentation/screen/notification_screen.dart';
import '../../widgets/icon_button_reuse.dart';
import '../../widgets/search_bar_text_form.dart';

class SearchSection extends StatelessWidget {
  SearchSection({
    required this.onFieldSubmitted,
    required this.searchController,
    this.onClosePressed,
    Key? key,
  }) : super(key: key);
  final ValueChanged<String>? onFieldSubmitted;
  Function()? onClosePressed;
  final TextEditingController searchController;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // sort
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ReusedIconButton(
            image: ImagesPath.sortIconSvg,
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),

        Expanded(
          child: SearchTextFormReuse(
            // textInputAction: TextInputAction.done,

            searchController: searchController,
            hintText: 'search_audio_here',
            onFieldSubmitted: onFieldSubmitted,
            onClosePressed: onClosePressed,
//              () {
//               onFieldSubmitted;

// // FocusManager.instance.primaryFocus?.unfocus();              print('object');
// //               if (searchController.text.isNotEmpty) {

// //                 searchController.clear();
// //               }
//             },
            // readOnly: true,
          ),
        ),
        // equalizer
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
        //   child: Container(
        //     decoration: BoxDecoration(
        //       color: HexColor("#58585847"),
        //       borderRadius: BorderRadius.circular(10),
        //     ),
        //     child:
        //     // ),
        //     // child: const ReusedIconButton(
        //     //   image: ImagesPath.equalizerIconSvg,
        //     // ),
        //   ),
        // ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: ReusedIconButton(
                  onPressed: () {
                    pushNavigate(context, const NotificationScreen());
                  },
                  image: ImagesPath.notificationIcon,
                ),
              ),
              BlocBuilder<ProfileCubit, ProfileState>(
                builder: (context, profileState) {
                  if (profileState is ProfileLoaded) {
                    return profileState.userProfile.user == null
                        ? Container()
                        : profileState.userProfile.user!.hasNotifications!
                            ? Positioned(
                                top: 10,
                                left: 6,
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: HexColor("#FF0000"),
                                  ),
                                ),
                              )
                            : Container();
                  } else {
                    return Container();
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
