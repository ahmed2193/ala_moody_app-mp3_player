import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:alamoody/core/helper/font_style.dart';
import 'package:alamoody/core/models/artists_model.dart';
import 'package:alamoody/core/utils/artist_botttom_sheet_widget.dart';
import 'package:alamoody/core/utils/back_arrow.dart';
import 'package:alamoody/core/utils/constants.dart';
import 'package:alamoody/core/utils/navigator_reuse.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../features/search_song/presentation/search_song/search_song_screen.dart';
import '../entities/artists.dart';
import '../entities/songs.dart';

class MyDelegate extends SliverPersistentHeaderDelegate {
  final Artists user;
  final List<Songs> songs;
  MyDelegate({
    required this.user,
    required this.songs,
  });
  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final shrinkPercentage =
        min(1, shrinkOffset / (maxExtent - minExtent)).toDouble();

    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            color: Colors.transparent,
          ),
        ),
        Column(
          children: [
            Flexible(
              child: Stack(
                children: [
                  ClipRRect(
                    child: Container(
                      foregroundDecoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color.fromRGBO(
                                249, 21, 222, 0.3,), // Dark mode gradient
                            Color.fromRGBO(
                                249, 21, 222, 0.3,), // Dark mode gradient
                            Color.fromRGBO(25, 67, 244, 0.5),
                          ],
                        ),
                      ),
                      child: Stack(
                        children: [
                          CachedNetworkImage(
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                            imageUrl: user.artworkUrl!,
                            height: 40,
                            fit: BoxFit.cover,
                            maxHeightDiskCache: 40,
                            maxWidthDiskCache:
                                MediaQuery.of(context).size.width.round(),
                            memCacheHeight:
                                (40 * MediaQuery.of(context).devicePixelRatio)
                                    .round(),
                            memCacheWidth: (MediaQuery.of(context).size.width *
                                    MediaQuery.of(context).devicePixelRatio)
                                .round(),
                            width: MediaQuery.of(context).size.width,
                            alignment: Alignment.topLeft,
                          ),
                          BackdropFilter(
                            filter: ImageFilter.blur(),
                            child: Container(
                              decoration: BoxDecoration(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                                // gradient: LinearGradient(
                                //   colors: [
                                //     HexColor('#F915DE'),
                                //     HexColor('#1943F4'),
                                //     HexColor('#16CCF7'),
                                //   ],
                                // ),
                              ),
                              height: 50,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Opacity(
                    opacity: 1 - shrinkPercentage,
                    child: Container(
                      height: 400,
                      width: MediaQuery.of(context).size.width,
                      foregroundDecoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.center,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(.5),
                            Colors.transparent,
                          ],
                        ),
                      ),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          alignment: FractionalOffset.topCenter,
                          image: CachedNetworkImageProvider(user.artworkUrl!),
                        ),
                      ),
                      child: const Row(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Stack(
          // fit: StackFit.expand,
          children: [
            Positioned(
              top: 0,
              left: 1,
              right: 1,
              child: Container(
                color: Colors.transparent.withOpacity(0.04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const BackArrow(
                          color: Colors.white,
                        ),
                        Flexible(
                          child: Opacity(
                            opacity: shrinkPercentage,
                            child: Text(
                              user.name!,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium!
                                  .copyWith(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            ShareSongWidget(
                              artists: user,
                            ),
                            IconButton(
                              onPressed: () {
                                pushNavigate(
                                  context,
                                  SearchSongScreen(
                                    songs: songs,
                                  ),
                                );
                              },
                              icon: const Icon(
                                Icons.search,
                                color: Colors.white,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                showModalBottomSheet(
                                  useSafeArea: true,
                                  useRootNavigator: true,
                                  // isScrollControlled: true, // Allow the sheet to adjust height based on content
                                  elevation: 3,
                                  backgroundColor: Colors.black,
                                  context: context,
                                  builder: (context) {
                                    return SingleChildScrollView(
                                      child: FractionallySizedBox(
                                        alignment: Alignment.topCenter,
                                        child: ArtistBottomSheetWidget(
                                          artist: user,
                                          songs: songs,
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              icon: const Icon(
                                Icons.more_vert,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 18,
              child: Opacity(
                opacity: max(1 - shrinkPercentage * 6, 0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      user.name!,
                      textAlign: TextAlign.left,
                      maxLines: 1,
                      style: styleW600(
                        context,
                        fontSize: 34,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              child: Opacity(
                opacity: max(1 - shrinkPercentage * 6, 0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        Text(
                          '${Constants.formatNumber(songs.first.followerCount!)} FOLLOWERS',
                          textAlign: TextAlign.left,
                          style: styleW600(
                            context,
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Text(
                          '${Constants.formatNumber(int.tryParse(songs.first.plays.toString())! ?? 0)} PLAYS',
                          textAlign: TextAlign.left,
                          style: styleW600(
                            context,
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
           
          ],
        ),
      ],
    );
  }

  @override
  double get maxExtent => 400;

  @override
  double get minExtent => 110;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}

class ShareSongWidget extends StatefulWidget {
  const ShareSongWidget({super.key, required this.artists});
  final Artists artists;
  @override
  State<ShareSongWidget> createState() => _ShareSongWidgetState();
}

class _ShareSongWidgetState extends State<ShareSongWidget> {
  String? _linkMessage;
  bool _isCreatingLink = false;

  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;

  final String dynamicLink = 'https://alamoody.com/artistDetails';

  XFile? filePath;

  Future<void> _createDynamicLink() async {
    setState(() {
      _isCreatingLink = true;
    });

    try {
      final ArtistsModel songsShareData = ArtistsModel(
        allowComments: widget.artists.allowComments,
        artworkUrl: widget.artists.artworkUrl,
        commentCount: widget.artists.commentCount,
        favorite: widget.artists.favorite,
        id: widget.artists.id,
        impression: widget.artists.impression,
        loves: widget.artists.loves,
        name: widget.artists.name,
        permalinkUrl: widget.artists.permalinkUrl,
      );
      final Map<String, dynamic> songsShareDataMap = songsShareData.toJson();
      final String songsShareDataEncoded =
          Uri.encodeComponent(json.encode(songsShareDataMap));

      final DynamicLinkParameters parameters = DynamicLinkParameters(
        uriPrefix: 'https://alamoodyMusic.page.link',
        link: Uri.parse(dynamicLink).replace(
          queryParameters: {'parameters': songsShareDataEncoded},
        ),
        androidParameters: const AndroidParameters(
          packageName: 'com.Ala_Moody.app',
          minimumVersion: 0,
        ),
      );

      final ShortDynamicLink shortLink =
          await dynamicLinks.buildShortLink(parameters);
      final Uri url = shortLink.shortUrl;

      final Dio dio = Dio();
      final Directory tempDir = await getTemporaryDirectory();
      final String tempFilePath = '${tempDir.path}/temp_image.jpg';

      // Download the image to a temporary file
      await dio.download(widget.artists.artworkUrl.toString(), tempFilePath);

      // Convert the file path to an XFile
      filePath = XFile(tempFilePath);

      setState(() {
        _linkMessage = url.toString();
        _isCreatingLink = false;
      });
    } catch (e) {
      setState(() {
        _isCreatingLink = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        _createDynamicLink().then((_) async {
          if (filePath == null || _linkMessage == null) {
            debugPrint('File path or link message is missing');
            return;
          }

          final String shareMessage = '''
🎧 Check out the playlist "${widget.artists.name}" on Alamoody!

🔗 $_linkMessage

🎵 Enjoy your music!
''';

          Share.shareXFiles([filePath!], text: shareMessage).then((_) {
            Future.delayed(const Duration(seconds: 30), () {
              Navigator.of(context).pop();
            });
          });
        });
      },
      icon: _isCreatingLink
          ? const CircularProgressIndicator()
          : const Icon(
              Icons.share,
            ),
    );
  }
}
