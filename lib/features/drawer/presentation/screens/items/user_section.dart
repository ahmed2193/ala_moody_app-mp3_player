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
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  state.message!,
                ),
              ),
              IconButton(
                  onPressed: () {
                    context.read<ProfileCubit>().getUserProfile(
                          accessToken: context
                              .read<LoginCubit>()
                              .authenticatedUser!
                              .accessToken!,
                        );
                  },
                  icon: const Icon(Icons.replay),),
            ],
          );
        } else if (state is ProfileLoaded) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // user pic
              const SizedBox(width: AppPadding.p10),
              ProfilePicture(hasUser: state.userProfile.user==null?false :true,imageUrl:state.userProfile.user!.image ,),
             
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


class ProfilePicture extends StatelessWidget {
  final String? imageUrl;
  final bool hasUser;
  const ProfilePicture({Key? key, required this.imageUrl, required this.hasUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double size = MediaQuery.of(context).size.width * 0.15; // Adjusted size

    return GestureDetector(
      onTap: () => pushNavigate(
        context,
        const AccountSettingsScreen(),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // **🔹 Gradient Circle Background**
          Container(
            height: size,
            width: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  HexColor("#1818B7"),
                  HexColor("#AE39A0"),
                ],
              ),
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
          ),

          // **🔹 Circular Profile Image**
          ClipOval(
            child: SizedBox(
              height: size * 0.92, // Slightly smaller than the outer container
              width: size * 0.92,
              child: hasUser && imageUrl != null
                  ? CachedNetworkImage(
                      imageUrl: imageUrl!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Image.asset(
                        ImagesPath.defaultUserIcon,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Image.asset(
                      ImagesPath.defaultUserIcon,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
