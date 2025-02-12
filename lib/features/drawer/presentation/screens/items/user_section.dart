import 'package:alamoody/core/utils/navigator_reuse.dart';
import 'package:alamoody/features/account_seetings/presentation/screens/account_settings_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:provider/provider.dart';

import '../../../../../core/helper/app_size.dart';
import '../../../../../core/helper/font_style.dart';
import '../../../../../core/helper/images.dart';
import '../../../../../core/utils/constants.dart';
import '../../../../../core/utils/controllers/main_controller.dart';
import '../../../../../core/utils/hex_color.dart';
import '../../../../../core/utils/loading_indicator.dart';
import '../../../../auth/presentation/cubit/login/login_cubit.dart';
import '../../../../home/presentation/widgets/icon_button_reuse.dart';
import '../../../../profile/presentation/cubits/profile/profile_cubit.dart';

class UserSectionDrawer extends StatefulWidget {
  const UserSectionDrawer({
    Key? key,
  }) : super(key: key);

  @override
  State<UserSectionDrawer> createState() => _UserSectionDrawerState();
}

class _UserSectionDrawerState extends State<UserSectionDrawer> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state is ProfileIsLoading) {
          return const LoadingIndicator();
        } else if (state is ProfileError) {
          return Center(
            child: Text(
              state.message!,
            ),
          );
        } else if (state is ProfileLoaded) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // user pic
              const SizedBox(width: AppPadding.p10),
              GestureDetector(
                onTap: () => pushNavigate(
                  context,
                  const AccountSettingsScreen(),
                ),
                child: ClipOval(
                  child: Container(
                    height: MediaQuery.of(context).size.width *
                        0.15, // Adjust height as needed
                    width: MediaQuery.of(context).size.width *
                        0.15, // Adjust width as needed
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          HexColor("#1818B7"),
                          HexColor("#AE39A0"),
                        ],
                      ),
                      shape: BoxShape.circle,
                      border: GradientBoxBorder(
                        gradient: LinearGradient(
                          colors: [
                            HexColor("#A866AE"),
                            HexColor("#37C3EE"),
                          ],
                        ),
                        width: 2,
                      ),
                    ),
                    child: state.userProfile.user == null
                        ? Image.asset(
                            ImagesPath.defaultUserIcon,
                            fit: BoxFit.cover,
                            // height: 20,
                            // width: 20,
                          )
                        : CachedNetworkImage(
                            imageUrl: state.userProfile.user!.image!,
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                            errorWidget: (context, url, error) => Image.asset(
                              ImagesPath.defaultUserIcon,
                              fit: BoxFit.cover,
                            ),
                            fit: BoxFit.cover,
                          ),
                  ),
                ),

                // const CircleContainerWithGradientBorder(
                //   isMusic: false,
                //   width: 60,
                //   image: ImagesPath.singerImage,
                // ),
              ),

              const SizedBox(width: AppPadding.p10),
              // user name and mail'
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      state.userProfile.user!.name!,
                      style: styleW600(context),
                    ),
                    //TODO ADDED EMAIL
                    Text(
                      state.userProfile.user!.username!,
                      style: styleW600(
                        context,
                        fontSize: FontSize.f10,
                      ),
                    ),
                  ],
                ),
              ),
              // OFF
              BlocListener<LoginCubit, LoginState>(
                listener: (context, state) {
                  if (state is UnAuthenticated) {
                    Provider.of<MainController>(context, listen: false)
                        .closePlayer();
                  }
                },
                child: ReusedIconButton(
                  onPressed: () => Constants.showLogoutDialog(context),
                  image: ImagesPath.offIconSvg,
                ),
              ),
            ],
          );
        } else {
          return const LoadingIndicator();
        }
      },
    );
  }
}
