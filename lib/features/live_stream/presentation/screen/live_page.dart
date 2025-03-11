import 'dart:developer';
import 'package:alamoody/features/live_stream/presentation/cubits/create_user_is_live/create_live_user_cubit.dart';
import 'package:alamoody/features/live_stream/presentation/cubits/live_users/live_users_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';
import '../../../../core/utils/controllers/main_controller.dart';
import '../../../auth/presentation/cubit/login/login_cubit.dart';
import '../../../profile/presentation/cubits/profile/profile_cubit.dart';

class LivePage extends StatelessWidget {
  const LivePage({Key? key, this.isHost = false, required this.liveID}) : super(key: key);
  final bool isHost;
  final String liveID;

  @override
  Widget build(BuildContext context) {
    const Color backgroundColor = Colors.black; // Set a dark background color
    
    // Ensure status bar color updates properly
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: backgroundColor, // Force match background color
        statusBarIconBrightness: Brightness.light, // Ensure icons are visible
      ),);
    });

    Provider.of<MainController>(context, listen: false).player.pause();
    final user = context.read<ProfileCubit>().userProfileData!.user;

    Future<void> createUserIsLive(isLive) {
      return BlocProvider.of<CreateUserIsLiveCubit>(context).createUserIsLive(
        isLive: isLive,
        accessToken: context.read<LoginCubit>().authenticatedUser!.accessToken!,
      );
    }

    Future<void> getLiveUsers() =>
        BlocProvider.of<LiveUsersCubit>(context).getLiveUsers(
          context: context,
          accessToken:
              context.read<LoginCubit>().authenticatedUser!.accessToken!,
        );

    return BlocConsumer<CreateUserIsLiveCubit, CreateUserIsLiveState>(
      listener: (context, state) {
        if (state is CreateUserIsLiveSuccess &&
            BlocProvider.of<CreateUserIsLiveCubit>(context).isLiveStream == '0') {
          getLiveUsers();
        } else {
          log(BlocProvider.of<CreateUserIsLiveCubit>(context).isLiveStream!);
          log('end');
        }
      },
      builder: (context, state) {
        return SizedBox(
          child: SafeArea(
            child: Scaffold(
              backgroundColor: backgroundColor,
              body: Center(
                child: ZegoUIKitPrebuiltLiveStreaming(
                  appID: 2139492409,
                  appSign: 'ba368acbf95c3809462675af10fd156442e74138b6e716c62599fb545703a769',
                  userID: user!.id!.toString(),
                  userName: user.username!,
                  liveID: liveID,
                  config: isHost
                      ? (ZegoUIKitPrebuiltLiveStreamingConfig.host(plugins: [])
                        ..turnOnCameraWhenJoining = false
                        ..audioVideoViewConfig.showUserNameOnView = false)
                      : (ZegoUIKitPrebuiltLiveStreamingConfig.audience()
                        ..rootNavigator = true
                        ..audioVideoViewConfig.showUserNameOnView = false),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
