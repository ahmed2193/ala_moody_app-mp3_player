import 'dart:convert';
import 'dart:developer';
import 'package:alamoody/core/artist_details.dart';
import 'package:alamoody/core/models/artists_model.dart';
import 'package:alamoody/core/models/song_share_model.dart';
import 'package:alamoody/core/utils/controllers/main_controller.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'features/main_layout/cubit/tab_cubit.dart';

class DynamicLinkHandler {
  final MainController? _mainController;
  final BuildContext context;
  final List<SongsShareData> _songs = [];
  final FirebaseDynamicLinks _dynamicLinks = FirebaseDynamicLinks.instance;

  DynamicLinkHandler(this._mainController, this.context);

  Future<void> initDynamicLinks() async {
    _dynamicLinks.onLink.listen(
      (PendingDynamicLinkData dynamicLink) =>
          _handleDynamicLink(dynamicLink.link),
      onError: (error) => log('Dynamic link error: ${error.message}'),
    );

    final PendingDynamicLinkData? data = await _dynamicLinks.getInitialLink();
    if (data?.link != null) {
      _handleDynamicLink(data!.link);
    } else {
      _mainController?.init();
    }
  }

  void _handleDynamicLink(Uri deepLink) {
    _songs.clear();

    final String? screenName =
        deepLink.pathSegments.isNotEmpty ? deepLink.pathSegments.first : null;
    final String? shareDataEncoded = deepLink.queryParameters['parameters'];

    if (shareDataEncoded == null) return;

    try {
      final String decodedString = Uri.decodeComponent(shareDataEncoded);
      final Map<String, dynamic> shareDataMap = json.decode(decodedString);

      if (screenName?.contains('artistDetails') ?? false) {
        _mainController?.init();
        _navigateToArtistDetails(shareDataMap);
      } else {
        _handleSongShare(shareDataMap);
      }
    } catch (e) {
      log('Error processing dynamic link: $e');
    }
  }

  void _navigateToArtistDetails(Map<String, dynamic> data) {
    final ArtistsModel artist = ArtistsModel.fromJson(data);
  final tabCubit = context.read<TabCubit>();

  // Switch to Home tab (index 0)
  tabCubit.controller.index = 0;



    // Push screen onto Home tab's Navigator
    tabCubit.navigatorKeys[0].currentState?.push(
      MaterialPageRoute(
        builder: (context) => ArtistDetails(artistId: artist.id!.toString()),
      ),
    );
  }

  void _handleSongShare(Map<String, dynamic> data) {
    final SongsShareData song = SongsShareData.fromJson(data);
    _songs.add(song);
    _mainController?.playSong(_mainController!.convertToAudio(_songs), 0);
  }
}
