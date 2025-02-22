// import 'package:alamoody/features/main/presentation/cubit/bloc_observer.dart';
import 'dart:io';

import 'package:alamoody/bloc_observer.dart';
import 'package:alamoody/features/main/presentation/cubit/main_cubit.dart';
import 'package:device_preview/device_preview.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio_background/just_audio_background.dart';

import 'ala_moody_app.dart';
import 'core/helper/constants.dart';
import 'injection_container.dart' as di;

Future<void> onStartApp() async {
  final box = await Hive.openBox(mainBoxName);
  await Hive.openBox(downloadedMusic);
  await Hive.openBox('RecentlyPlayed');
  final isDark = await box.get(isDarkBox);
  MainCubit.isDark = isDark ?? true;
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  await Firebase.initializeApp();

  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  );
  await Hive.initFlutter();
  await di.init();

  HttpOverrides.global = MyHttpOverrides();
  await onStartApp();

  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  Bloc.observer = AppObserver();
  runApp(
    Phoenix(
      child: DevicePreview(
          builder: (context) => const AlaMoodyApp(),),
    ),
  );
}
// https://alamoody.page.link/
