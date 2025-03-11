import 'package:alamoody/core/utils/constants.dart';
import 'package:alamoody/core/utils/controllers/main_controller.dart';
import 'package:alamoody/core/utils/loading_indicator.dart';
import 'package:alamoody/features/home/presentation/cubits/set_ringtones/set_ringtones_cubit.dart';
import 'package:alamoody/features/main_layout/cubit/tab_cubit.dart';
import 'package:alamoody/features/player/presentation/screens/items/download.dart';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../../config/locale/app_localizations.dart';
import '../../../../../core/helper/font_style.dart';
import '../../../../../core/helper/images.dart';
import '../../../../../core/utils/hex_color.dart';
import '../../../../auth/presentation/cubit/login/login_cubit.dart';
import '../../../../favorites/presentation/cubits/add_and_remove_from_favorite/add_and_remove_from_favorite_cubit.dart';
import '../../../../profile/presentation/cubits/profile/profile_cubit.dart';

class FavoriteInPlayerSection extends StatelessWidget {
  const FavoriteInPlayerSection({
    Key? key,
    required this.myAudio,
    required this.con,
    required this.streamUrl,
  }) : super(key: key);

  final MediaItem myAudio;
  final String streamUrl;
  final MainController con;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // ✅ Reduce sizes by 10%
    final double textSize = screenWidth * 0.04;
    final double iconSize = screenWidth * 0.06;
    final double buttonSpacing = screenWidth * 0.02;

    bool isFav = myAudio.extras!['favorite'] ?? false;

    return StatefulBuilder(
      builder: (BuildContext context, setState) {
        return BlocListener<SetRingtonesCubit, SetRingtonesState>(
          listener: (context, state) {
            if (state is SetRingtonesSuccess) {
              Constants.showToast(message: state.message);
            }
            if (state is SetRingtonesFailed) {
              Constants.showToast(message: state.message);
            }
          },
          child: BlocConsumer<AddAndRemoveFromFavoritesCubit,
              AddAndRemoveFromFavoritesState>(
            listener: (context, state) {
              if (state is AddAndRemoveFromFavoritesLoading ||
                  state is AddAndRemoveFromFavoritesFailed) {
                setState(() {
                  isFav = !isFav;
                  myAudio.extras!['favorite'] = isFav;
                });
              }
            },
            builder: (context, state) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // ✅ Song Title and Artist
                    Expanded(
                      flex: 8,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            myAudio.title,
                            maxLines: 2,
                            overflow:TextOverflow.clip ,
                            style: styleW600(
                              context,
                              fontSize: textSize,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                                                        overflow:TextOverflow.clip ,
                            maxLines: 1,

                            myAudio.artist!,
                            style: styleW400(
                              context,
                              fontSize: textSize * 0.9, // Slightly smaller
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ✅ Buttons: Favorite & Download
                    Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ✅ Favorite Button
                            IconButton(
                              onPressed: () {
                                BlocProvider.of<AddAndRemoveFromFavoritesCubit>(
                                  context,
                                ).addAndRemoveFromFavorites(
                                  id: int.parse(myAudio.id),
                                  accessToken: context
                                      .read<LoginCubit>()
                                      .authenticatedUser!
                                      .accessToken!,
                                  favtype: !isFav
                                      ? BlocProvider.of<
                                          AddAndRemoveFromFavoritesCubit>(
                                          context,
                                        ).type = 1
                                      : BlocProvider.of<
                                          AddAndRemoveFromFavoritesCubit>(
                                          context,
                                        ).type = 0,
                                );
                              },
                              icon: Icon(
                                size: iconSize,
                                Icons.favorite_rounded,
                                color:
                                    isFav ? HexColor('#F915DE') : Colors.white,
                              ),
                            ),
                            SizedBox(width: buttonSpacing),

                            // ✅ Download Button
                            DownloadSection(
                              streamUrl: streamUrl,
                              con: con,
                              myAudio: myAudio,
                            ),
                          ],
                        ),

                        // ✅ Set as Ringtone Button
                        BlocBuilder<SetRingtonesCubit, SetRingtonesState>(
                          builder: (context, state) {
                            return TextButton(
                              child: state is SetRingtonesLoading
                                  ? const LoadingIndicator()
                                  : Row(
                                      children: [
                                        Text(
                                          AppLocalizations.of(context)!
                                              .translate("set_as_ringTone")!,
                                          style: styleW500(
                                            context,
                                            fontSize: textSize * 0.6, // Reduced font size
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(width: buttonSpacing),
                                        SvgPicture.asset(
                                          ImagesPath.musicIconSvg,
                                          width: iconSize * 0.8, // Reduced icon size
                                        ),
                                      ],
                                    ),
                              onPressed: () {
                                context
                                            .read<ProfileCubit>()
                                            .userProfileData!
                                            .user!
                                            .subscription!
                                            .serviceId ==
                                        '1'
                                    ? (context.read<TabCubit>().changeTab(4)
                                    
                                    )
                                    : BlocProvider.of<SetRingtonesCubit>(
                                        context,
                                      ).setRingtones(
                                        accessToken: context
                                            .read<LoginCubit>()
                                            .authenticatedUser!
                                            .accessToken!,
                                      );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
