import 'dart:async';
import 'dart:developer';

//import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:alamoody/core/entities/songs.dart';
import 'package:alamoody/core/utils/app_strings.dart';
import 'package:alamoody/core/utils/media_query_values.dart';
import 'package:alamoody/core/utils/no_data.dart';
import 'package:alamoody/features/profile/presentation/cubits/profile/profile_cubit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/helper/app_size.dart';
import '../../../../../../core/utils/error_widget.dart' as error_widget;
import '../../../../config/locale/app_localizations.dart';
import '../../../../core/artist_details.dart';
import '../../../../core/components/reused_background.dart';
import '../../../../core/helper/font_style.dart';
import '../../../../core/utils/back_arrow.dart';
import '../../../../core/utils/hex_color.dart';
import '../../../../core/utils/loading_indicator.dart';
import '../../../../core/utils/navigator_reuse.dart';
import '../../../audio_playlists/presentation/cubit/audio_playlists_cubit.dart';
import '../../../auth/presentation/cubit/login/login_cubit.dart';
import '../cubits/get_notification/get_notification_cubit.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  ScrollController scrollController = ScrollController();

  getGetNotification() {
    log(context.read<LoginCubit>().authenticatedUser!.user!.id.toString());
    BlocProvider.of<GetNotificationCubit>(context).getNotification(
      accessToken: context.read<LoginCubit>().authenticatedUser!.accessToken,
    );
  }

  void _setupScrollControllerSongs(context) {
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        if (scrollController.position.pixels != 0 &&
            BlocProvider.of<GetNotificationCubit>(context).pageNo <=
                BlocProvider.of<GetNotificationCubit>(context).totalPages) {
          getGetNotification();
        }
      }
    });
  }

  @override
  void initState() {
    BlocProvider.of<GetNotificationCubit>(context).clearData();

    getGetNotification();

    _setupScrollControllerSongs(context);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildBodyContent();
  }

  Widget _buildBodyContent() {
    // final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    return WillPopScope(
      onWillPop: () {
        return BlocProvider.of<ProfileCubit>(context).getUserProfile(
          accessToken:
              context.read<LoginCubit>().authenticatedUser!.accessToken!,
        );
      },
      child: SafeArea(
        child: Scaffold(
          // key: scaffoldKey,
          // drawer: const DrawerScreen(),
          body: ReusedBackground(
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: context.height * 0.017,
                ),
                Row(
                  children: [
                    const BackArrow(),
                    SizedBox(
                      width: context.height * 0.017,
                    ),
                    Center(
                      child: Text(
                        AppLocalizations.of(context)!
                            .translate("notification")!,
                        style: styleW600(context)!
                            .copyWith(fontSize: FontSize.f18),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child:
                      BlocBuilder<GetNotificationCubit, GetNotificationState>(
                    builder: (context, state) {
                      if (state is GetNotificationIsLoading &&
                          state.isFirstFetch) {
                        return const LoadingIndicator();
                      }
                      if (state is GetNotificationIsLoading) {
                        BlocProvider.of<GetNotificationCubit>(context)
                            .loadMore = true;
                      } else if (state is GetNotificationError) {
                        return error_widget.ErrorWidget(
                          // onRetryPressed: () => _getAllGetNotification(),
                          msg: state.message!,
                        );
                      }

                      return BlocProvider.of<GetNotificationCubit>(context)
                              .notification
                              .isNotEmpty
                          ? ListView.separated(
                              // reverse: true,
                              // shrinkWrap: true,
                              padding: const EdgeInsetsDirectional.only(
                                top: AppPadding.p20,
                                bottom: AppPadding.p20 * 6,
                              ),
                              physics: const BouncingScrollPhysics(),
                              controller: scrollController,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(
                                height: AppPadding.p8,
                              ),
                              itemCount:
                                  BlocProvider.of<GetNotificationCubit>(context)
                                          .notification
                                          .length +
                                      (BlocProvider.of<GetNotificationCubit>(
                                        context,
                                      ).loadMore
                                          ? 1
                                          : 0),
                              itemBuilder: (context, index) {
                                final notification =
                                    BlocProvider.of<GetNotificationCubit>(
                                  context,
                                ).notification[index];
                                log(notification
                                    .details!.artistId
                                    .toString(),);

                                if (index <
                                    BlocProvider.of<GetNotificationCubit>(
                                      context,
                                    ).notification.length) {
                                  return GestureDetector(
                                    onTap: () {
                                      if (notification.action!
                                          .contains(AppStrings.shareSong)) {
                                        final List<Songs> audios = [];
                                        audios
                                            .add(notification.details!.object!);
                                        BlocProvider.of<AudioPlayListsCubit>(
                                          context,
                                        ).playSongs(
                                          context,
                                          0,
                                          audios,
                                        );
                                      }else{

                                         pushNavigate(context, ArtistDetails(artistId: notification.details!.artistId!));
                                      }

                                      print(
                                        notification.details!.object,
                                      );
                                      print(
                                        notification.details,
                                      );
                                      notification.read == 0
                                          ? BlocProvider.of<
                                              GetNotificationCubit>(
                                              context,
                                            ).changeStatus(
                                              nId: notification.id!,
                                              accessToken: context
                                                  .read<LoginCubit>()
                                                  .authenticatedUser!
                                                  .accessToken!,
                                            )
                                          : null;
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 9,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: BlocProvider.of<
                                                      GetNotificationCubit>(
                                                    context,
                                                  ).notification[index].read ==
                                                  0
                                              ? Theme.of(context)
                                                  .primaryIconTheme
                                                  .color!
                                              : Colors.transparent,
                                          width: 1.5,
                                        ),
                                        color: HexColor('#042667'),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          if (BlocProvider.of<
                                                  GetNotificationCubit>(
                                                context,
                                              ).notification[index].details ==
                                              null)
                                            const SizedBox()
                                          else
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: CachedNetworkImage(
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const Icon(Icons.error),
                                                imageUrl: BlocProvider.of<
                                                        GetNotificationCubit>(
                                                  context,
                                                )
                                                    .notification[index]
                                                    .details!
                                                    .object!
                                                    .artworkUrl!,
                                                width: context.height * 0.105,
                                                height: context.height * 0.105,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(6.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    '${BlocProvider.of<GetNotificationCubit>(context).notification[index].title}',
                                                    style: styleW700(context),
                                                  ),
                                                  Text(
                                                    '${BlocProvider.of<GetNotificationCubit>(context).notification[index].description}',
                                                    style: styleW400(context),
                                                  ),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      color: HexColor(
                                                        '#FF3743',
                                                      ),
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                        Radius.circular(
                                                          10,
                                                        ),
                                                      ),
                                                    ),
                                                    padding:
                                                        const EdgeInsets.all(3),
                                                    child: const Icon(
                                                      Icons.music_note,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                } else if (BlocProvider.of<
                                        GetNotificationCubit>(
                                      context,
                                    ).pageNo <=
                                    BlocProvider.of<GetNotificationCubit>(
                                      context,
                                    ).totalPages) {
                                  Timer(const Duration(milliseconds: 30), () {
                                    scrollController.jumpTo(
                                      scrollController.position.maxScrollExtent,
                                    );
                                  });

                                  return const LoadingIndicator();
                                }
                                return const SizedBox();
                              },
                            )
                          : const Center(
                              child: NoData(),
                            );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  // Widget _buildBodyContent() {
  //   // final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  //   return SafeArea(
  //     child: Scaffold(
  //         // key: scaffoldKey,
  //         // drawer: const DrawerScreen(),
  //         body: ReusedBackground(
  //       darKBG: ImagesPath.homeBGDarkBG,
  //
  //       body:
  //     ),),
  //   );
  // }
}
