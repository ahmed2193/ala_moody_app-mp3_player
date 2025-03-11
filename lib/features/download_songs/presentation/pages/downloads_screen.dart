import 'dart:io';

import 'package:alamoody/config/locale/app_localizations.dart';
import 'package:alamoody/core/utils/custom_progrees_widget.dart';
import 'package:alamoody/core/utils/no_data.dart';
import 'package:alamoody/features/download_songs/presentation/cubit/download_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../core/components/reused_background.dart';
import '../../../../core/entities/songs.dart';
import '../../../../core/helper/font_style.dart';
import '../../../../core/helper/images.dart';
import '../../../../core/utils/back_arrow.dart';
import '../../../../core/utils/controllers/main_controller.dart';
import '../../../../core/utils/hex_color.dart';
import '../../data/models/downloaded_song_model.dart';

class DownloadsScreen extends StatefulWidget {
  const DownloadsScreen({super.key});

  @override
  State<DownloadsScreen> createState() => _DownloadsScreenState();
}

class _DownloadsScreenState extends State<DownloadsScreen> {
  Future<void> _getDownloadsData() =>
      BlocProvider.of<DownloadCubit>(context).getSavedDownloads();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return BlocListener<DownloadCubit, DownloadState>(
      listener: (context, state) {
        if (state is Downloaded) {
          _getDownloadsData();
        }
      },
      child: SafeArea(
        child: Scaffold(
          body: ReusedBackground(
            body: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenHeight * 0.02,
                vertical: screenHeight * 0.015,
              ),
              child: Column(
                children: [
                  const DownloadsBar(),
                  SizedBox(height: screenHeight * 0.02),
                  Expanded(
                    child: BlocBuilder<DownloadCubit, DownloadState>(
                      builder: (context, state) {
                        final cubit = context.read<DownloadCubit>();
                        final downloadingSongs = cubit.getDownloadingSongs();
                        final downloadedSongs = cubit.downloadedMusicList;

                        if (state is DownloadListLoading) {
                          return Center(
                            child: CircularProgressIndicator(
                              color: Theme.of(context).primaryColor,
                            ),
                          );
                        }

                        return   ListView(
                          physics: const BouncingScrollPhysics(),
                          children: [

                            if (downloadingSongs.isNotEmpty) ...[
                              _sectionTitle("currently_downloading"),
                              SizedBox(height: screenHeight * 0.01),
                              ...downloadingSongs.map((song) {
                                final double progress = cubit.getProgress(song.id);
                                return _buildDownloadingItem(song, progress);
                              }).toList(),
                              SizedBox(height: screenHeight * 0.03),
                            ],
                            if (downloadedSongs.isNotEmpty) ...[
                              _sectionTitle("completed_downloads"),
                              SizedBox(height: screenHeight * 0.01),
                              ...downloadedSongs
                                  .map((song) => _buildDownloadedItem(song))
                                  .toList(),
                            ]else Center(child: Padding(
                              padding:  EdgeInsets.only(top:screenHeight/4 ),
                              child: const NoData(),
                            ),),
                            SizedBox(
                              height: screenHeight * 0.17,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// **Header for Sections**
  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Text(
  AppLocalizations.of(context)!.translate(title)!,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  /// **Downloading Item UI**
  Widget _buildDownloadingItem(Songs song, double progress) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: screenWidth * 0.02),
      child: Row(
        children: [
          _buildSongImage(song.artworkUrl!),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  song.title!,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
                Text(
                  song.artists![0].name!,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(height: 5),
              ],
            ),
          ),
          DownloadProgressWidget(progress: progress),
        ],
      ),
    );
  }

  /// **Completed Download Item UI**
  Widget _buildDownloadedItem(DownloadedMusicModel song) {
    final screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        final con = Provider.of<MainController>(
          context,
          listen: false,
        );
        con.playSong(
          con.convertToAudio([song]),
          0,
        );
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: screenWidth * 0.02),
        child: Row(
          children: [
            _buildSongImage(song.image!),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    song.title!,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  Text(
                    '${song.artists}, ${DateFormat("yyyy/MM/dd").format(DateTime.parse(song.date!))}',
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
            _buildIcon(context),
          ],
        ),
      ),
    );
  }

  /// **Song Image with Responsive Size**
  Widget _buildSongImage(String imagePath) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      height: screenWidth * 0.12,
      width: screenWidth * 0.12,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: imagePath.contains('https:')
            ? DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(imagePath),
              )
            : DecorationImage(
                fit: BoxFit.cover,
                image: FileImage(File(imagePath)),
              ),
        border: GradientBoxBorder(
          gradient: LinearGradient(
            colors: [
              HexColor("#DC29E3"),
              HexColor("#5D8DFA"),
              HexColor("#C38EF9"),
            ],
          ),
          width: 1.2,
        ),
      ),
    );
  }

  /// **Download Complete Icon**
  Widget _buildIcon(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      height: screenWidth * 0.10,
      width: screenWidth * 0.10,
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
          width: 2.0,
        ),
      ),
      child: SvgPicture.asset(ImagesPath.doneIcon),
    );
  }
}

class DownloadsBar extends StatelessWidget {
  const DownloadsBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const BackArrow(),
        SizedBox(width: MediaQuery.of(context).size.height * 0.017),
        Center(
          child: Text(
            AppLocalizations.of(context)!.translate('download_list')!,
            style: styleW600(context)!.copyWith(fontSize: 18),
          ),
        ),
      ],
    );
  }
}
