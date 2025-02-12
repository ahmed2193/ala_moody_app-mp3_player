import 'package:alamoody/core/entities/songs.dart';
import 'package:alamoody/core/utils/hex_color.dart';
//import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:alamoody/core/utils/media_query_values.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';

import '../../config/locale/app_localizations.dart';
import '../../features/auth/presentation/widgets/gradient_auth_button.dart';
import '../../features/main_layout/cubit/tab_cubit.dart';
import '../../features/main_layout/presentation/pages/main_layout_screen.dart';
import '../../features/profile/presentation/cubits/profile/profile_cubit.dart';
import '../components/reused_background.dart';
import '../helper/font_style.dart';
import 'back_arrow.dart';

class LyricsScreen extends StatefulWidget {
  const LyricsScreen({super.key, required this.songs});
  final Songs songs;

  @override
  State<LyricsScreen> createState() => _LyricsScreenState();
}

class _LyricsScreenState extends State<LyricsScreen> {
  @override
  Widget build(BuildContext context) {
    final bool ispremium = context
                .read<ProfileCubit>()
                .userProfileData!
                .user!
                .subscription!
                .serviceId ==
            '1'
        ? false
        : true;
    return Scaffold(
      body: ReusedBackground(
        // darKBG: ImagesPath.homeBGDarkBG,
        // lightBG: ImagesPath.homeBGLightBG,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 16, 12, 20),
                child: Row(
                  children: [
                    const BackArrow(),
                    SizedBox(
                      width: context.height * 0.0145,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                        imageUrl: widget.songs.artworkUrl!,
                        width: context.width * 0.111,
                        height: context.height * 0.058,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(
                      width: context.height * 0.012,
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.songs.title!,
                            style: styleW700(context),
                          ),
                          SizedBox(
                            height: context.height * 0.0060,
                          ),
                          Text(
                            widget.songs.artists![0].name!,
                            style: styleW400(
                              context,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        Share.share(
                          '${widget.songs.artists![0].name!} - ${widget.songs.title}  \n ${widget.songs.streamUrl!}  ',
                          subject:
                              ' ${widget.songs.artists![0].name} On AlaMoody ',
                        );
                      },
                      icon: Icon(
                        Icons.share,
                        color: Theme.of(context).iconTheme.color,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(
                        widget.songs.lyrics!,
                        textAlign: TextAlign.center,
                        style: styleW700(context, fontSize: 18, height: 2),
                        maxLines: ispremium ? null : 6,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      if (!ispremium)
                        Center(
                          child: GradientCenterTextButton(
                            onTap: () {
                              // setState(() {
                              //   isPremium = !isPremium;
                              // });
 context
                                                .read<TabCubit>()
                                                .changeTab(4);
                            },
                            width: MediaQuery.of(context).size.width / 1.3,
                            buttonText: 
                            
                            AppLocalizations.of(context)!
                                .translate('unlock_full_lyrics'),
                            listOfGradient: [
                              HexColor("#DA00FF"),
                              HexColor("#FFB000"),
                            ],
                          ),
                        )
                      else
                        const SizedBox(),
                      const SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: context.height * 0.129,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
