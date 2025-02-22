import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:alamoody/features/main_layout/cubit/tab_cubit.dart';
import 'package:dio/dio.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../../core/helper/app_size.dart';
import '../../../../../core/helper/images.dart';
import '../../../../../core/models/song_share_model.dart';
import '../../../../home/presentation/widgets/icon_button_reuse.dart';
import '../../../../library/presentation/widgets/icon_button_of_play.dart';
import '../../../../profile/presentation/cubits/profile/profile_cubit.dart';

class FirstSectionPlayerScreen extends StatefulWidget {
  const FirstSectionPlayerScreen({
    Key? key,
    this.isPremium = false,
    required this.myAudio,
    required this.streamUrl,
  }) : super(key: key);
  final bool isPremium;

  final dynamic myAudio;
  final String streamUrl;

  @override
  State<FirstSectionPlayerScreen> createState() =>
      _FirstSectionPlayerScreenState();
}

class _FirstSectionPlayerScreenState extends State<FirstSectionPlayerScreen> {
  String? _linkMessage;
  bool _isCreatingLink = false;

  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;

  final String DynamicLink = 'https://alamoody.com/song';
  XFile? imageFile;
  String? filePath;
  Future<void> _createDynamicLink() async {
    setState(() {
      _isCreatingLink = true;
    });

    try {
      // log(widget.myAudio.metas.artist!);

      final SongsShareData songsShareData = SongsShareData(
        listened: widget.myAudio.extras['listened'] == null
            ? ''
            : widget.myAudio.extras['listened'].toString(),
        lyrics: widget.myAudio.extras['lyrics'] ?? '',
        favorite: widget.myAudio.extras['favorite'] ?? false,
        streamUrl: widget.streamUrl,
        id: widget.myAudio.id!,
        title: widget.myAudio.title!,
        artworkUrl: widget.myAudio.artUri!.toString(),
        artist: widget.myAudio.artist ?? '',
      );

      final Map<String, dynamic> songsShareDataMap = songsShareData.toJson();
      final String songsShareDataEncoded =
          Uri.encodeComponent(json.encode(songsShareDataMap));

      log('Encoded custom data: $songsShareDataEncoded');

      final DynamicLinkParameters parameters = DynamicLinkParameters(
        uriPrefix: 'https://alamoody.page.link',
        link: Uri.parse(DynamicLink).replace(
          queryParameters: {'parameters': songsShareDataEncoded},
        ),
        androidParameters: const AndroidParameters(
          packageName: 'com.Ala_Moody.app',
          minimumVersion: 0,
        ),
      );

      Uri url;

      final ShortDynamicLink shortLink =
          await dynamicLinks.buildShortLink(parameters);
      url = shortLink.shortUrl;
      final Dio dio = Dio();
      final Directory tempDir = await getTemporaryDirectory();
      filePath = '${tempDir.path}/temp_image.jpg';
      await dio.download(widget.myAudio.artUri.toString(), filePath);

      // Format the share message
      imageFile = XFile(filePath!);
      setState(() {
        _linkMessage = url.toString();
        _isCreatingLink = false;
      });

      // Format the share message
    } catch (e) {
      log('Error creating dynamic link: $e');
      setState(() {
        _isCreatingLink = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // drop icon
        ReusedIconButton(
          onPressed: () => Navigator.of(context).pop(),
          image: ImagesPath.dropIconSvg,
          width: AppSize.a18,
        ),

        Row(
          children: [
            if (widget.isPremium)
              context
                          .read<ProfileCubit>()
                          .userProfileData!
                          .user!
                          .subscription!
                          .serviceId ==
                      '1'
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(),
                        GestureDetector(
                          onTap: () {
                            context.read<TabCubit>().changeTab(4);
                          },
                          child: Image.asset(ImagesPath.premiumImage),
                        ),
                      ],
                    )
                  : const SizedBox(),
            IconButtonOfPlay(
              icon: _isCreatingLink
                  ? const CircularProgressIndicator()
                  : const Icon(Icons.share_outlined, color: Colors.white),
              width: AppSize.a22,
              widthOfBorder: 1,
              padding: AppPadding.p4 + 2,
              onPressed: () {
                log('data');

                _createDynamicLink().then((value) async {
                  final String shareMessage = ''''
🎶 Listen to "${widget.myAudio.title}" by ${widget.myAudio.artist} on Alamoody!

🔗 $_linkMessage

🎵 Enjoy your music!
''';
                  Share.shareXFiles([imageFile!], text: shareMessage)
                      .then((onValue) {
                    Future.delayed(const Duration(seconds: 30), () {
                      Navigator.of(context).pop();
                    });
                  });
                });
              },
            ),
          ],
        ),
      ],
    );
  }
}

Future<String> createDynamicLink(bool short, String path) async {
  final DynamicLinkParameters parameters = DynamicLinkParameters(
    uriPrefix: 'https://alamoody.page.link',
    link: Uri.parse('https://alamoody.page.link/$path'),
    androidParameters: const AndroidParameters(
      packageName: 'com.Ala_Moody.app',
      minimumVersion: 0,
    ),
    // iosParameters: IosParameters(
    //   bundleId: 'com.example.yourapp',
    //   minimumVersion: '0',
    // ),
  );

  Uri url;
  if (short) {
    final ShortDynamicLink shortLink =
        await FirebaseDynamicLinks.instance.buildShortLink(parameters);
    url = shortLink.shortUrl;
  } else {
    url = await FirebaseDynamicLinks.instance.buildLink(parameters);
  }

  return url.toString();
}
