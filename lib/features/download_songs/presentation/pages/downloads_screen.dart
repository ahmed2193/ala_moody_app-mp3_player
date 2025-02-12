import 'dart:developer';
import 'dart:io';

import 'package:alamoody/config/locale/app_localizations.dart';
import 'package:alamoody/core/helper/print.dart';
//import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:alamoody/core/utils/media_query_values.dart';
import 'package:alamoody/core/utils/no_data.dart';
import 'package:alamoody/features/download_songs/presentation/cubit/download_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../core/components/reused_background.dart';
import '../../../../core/helper/app_size.dart';
import '../../../../core/helper/font_style.dart';
import '../../../../core/helper/images.dart';
import '../../../../core/utils/back_arrow.dart';
import '../../../../core/utils/controllers/main_controller.dart';
import '../../../../core/utils/hex_color.dart';

class DownloadsScreen extends StatefulWidget {
  const DownloadsScreen({
    super.key,
  });

  @override
  State<DownloadsScreen> createState() => _DownloadsScreenState();
}

class _DownloadsScreenState extends State<DownloadsScreen> {
  Future<void> _getDownloadsData() =>
      BlocProvider.of<DownloadCubit>(context).getSavedDownloads();
  @override
  void initState() {
    _getDownloadsData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _bodyContent(context),
      ),
    );
  }

  ReusedBackground _bodyContent(BuildContext context) {
    return ReusedBackground(
      lightBG: ImagesPath.homeBGLightBG,
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: context.height * 0.017,
            ),
            const DownloadsBar(),
            const SizedBox(
              height: 30,
            ),
            const DownloadsListWidget(
              title: 'July',
              icon: ImagesPath.doneIcon,
            ),
            // DownloadsListWidget(
            //   title: 'august',
            //   icon: ImagesPath.stopIcon,
            // ),
          ],
        ),
      ),
    );
  }
}

class DownloadsListWidget extends StatelessWidget {
  const DownloadsListWidget({
    required this.icon,
    required this.title,
    Key? key,
  }) : super(key: key);
  final String icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocConsumer<DownloadCubit, DownloadState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is DownloadListLoading) {
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            );
          } else if (state is DownloadListLoaded) {
            final format = DateFormat('yyyy/MM/dd');
            return BlocProvider.of<DownloadCubit>(context)
                    .downloadedMusicList
                    .isNotEmpty
                ? ListView.builder(
                  
                  reverse: false,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 100),
                  itemCount: BlocProvider.of<DownloadCubit>(context)
                      .downloadedMusicList
                      .length,
                  itemBuilder: (context, index) {
                    log(BlocProvider.of<DownloadCubit>(
                      context,
                    ).downloadedMusicList[index].image!,);
                    printColored(BlocProvider.of<DownloadCubit>(
                      context,
                    ).downloadedMusicList[index].image,);
                    printColored(
                'downloadedMusicList'*10,
                
                
                    );
                    printColored(BlocProvider.of<DownloadCubit>(
                      context,
                    ).downloadedMusicList[index].path,);
                    printColored(BlocProvider.of<DownloadCubit>(
                      context,
                    ).downloadedMusicList[index].image,);
                    return GestureDetector(
                      onTap: () async {
                        final con = Provider.of<MainController>(
                          context,
                          listen: false,
                        );
                        con.playSong(
                          con.convertToAudioLocal(
                            BlocProvider.of<DownloadCubit>(context)
                                .downloadedMusicList,
                          ),
                          BlocProvider.of<DownloadCubit>(context)
                              .downloadedMusicList
                              .indexOf(
                                BlocProvider.of<DownloadCubit>(context)
                                    .downloadedMusicList[index],
                              ),
                        );
                
                        // downloadSong(context, song);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          children: [
                            Container(
                              height: 60,
                              width: 60,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: FileImage(
                                    File(
                                      BlocProvider.of<DownloadCubit>(
                                        context,
                                      ).downloadedMusicList[index].image!,
                                    ),
                                  ),
                                ),
                                border: GradientBoxBorder(
                                  gradient: LinearGradient(
                                    colors: [
                                      HexColor("#DC29E3"),
                                      HexColor("#5D8DFA"),
                                      HexColor("#C38EF9"),
                                    ],
                                  ),
                                  width: 1.5,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  BlocProvider.of<DownloadCubit>(context)
                                      .downloadedMusicList[index]
                                      .title!,
                                  style: styleW400(context, fontSize: 16),
                                ),
                                Text(
                                  '${BlocProvider.of<DownloadCubit>(context).downloadedMusicList[index].artists}, ${format.format(DateFormat("yyyy-MM-dd").parse(BlocProvider.of<DownloadCubit>(context).downloadedMusicList[index].date!))}',
                                  style: styleW400(
                                    context,
                                    fontSize: 12,
                                    color: HexColor('#8B8B8B'),
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Container(
                              height: 40,
                              width: 40,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: GradientBoxBorder(
                                  gradient: LinearGradient(
                                    colors: [
                                      HexColor("#16CCF7"),
                                      HexColor("#5878FF"),
                                      HexColor("#F915DE"),
                                    ],
                                  ),
                                  width: 2.5,
                                ),
                              ),
                              child: SvgPicture.asset(icon),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                )
                : const Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 150),
                      child: Center(child: NoData()),
                    ),
                  );
          } else {
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            );
          }
        },
      ),
    );
  }
}

class DownloadsBar extends StatelessWidget {
  const DownloadsBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const BackArrow(),
        SizedBox(
          width: context.height * 0.017,
        ),
        Center(
          child: Text(
            AppLocalizations.of(context)!.translate('download_list')!,
            style: styleW600(context)!.copyWith(fontSize: FontSize.f18),
          ),
        ),
      ],
    );
  }
}
