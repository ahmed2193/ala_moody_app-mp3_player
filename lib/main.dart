import 'dart:io';
import 'package:alamoody/bloc_observer.dart';
import 'package:alamoody/core/helper/images.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'ala_moody_app.dart';
import 'core/helper/constants.dart';
import 'features/main/presentation/cubit/main_cubit.dart';
import 'injection_container.dart' as di;

/// Custom HTTP client to handle SSL certificates
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (_, __, ___) => true;
  }
}




void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Show loading UI while initializing services
  runApp(const LoadingScreen());

  Future.microtask(() async {
    await initializeCore();
    await initializeAudioBackground();
    await initializeStorage();

    Bloc.observer = AppObserver();
    HttpOverrides.global = MyHttpOverrides();

    // Load full app after initialization
    runApp(
      Phoenix(
        child: DevicePreview(
          enabled: false,
          builder: (ctx) => Builder(
            builder: (context) {
              return const AlaMoodyApp();
            },
          ),
        ),
      ),
    );
  });
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Center(
            child:
                Image.asset(ImagesPath.small_logo), // Your custom splash image
          ),

          // : Container(
          //   // padding: const EdgeInsets.all(8),
          //   // width: 200, // Adjust size as needed
          //   // height: 200,
          //   decoration: const BoxDecoration(
          //     shape: BoxShape.circle, // ✅ Circular shape
          //     color: Colors.black, // Optional background color
          //   ),
          //   child: ClipOval(
          //     child: Image.asset(
          //       ImagesPath.small_logo, // ✅ Your logo inside the circle
          //       fit: BoxFit
          //           .contain, // ✅ Ensures full coverage inside the circle
          //     ),
          //   ),
          // ),
        ),
      ),
    );
  }
}

/// Initialize Firebase, Hive, and Dependency Injection
Future<void> initializeCore() async {
  await Firebase.initializeApp();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await Hive.initFlutter();
  await di.init();
  // Future.microtask(() => MobileAds.instance.initialize());
}

/// Initialize background audio playback
Future<void> initializeAudioBackground() async {
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    // androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
 androidNotificationChannelName: 'Alamoody',            

    
  );
}

/// Initialize Hive storage
Future<void> initializeStorage() async {
  final box = await Hive.openBox(mainBoxName);
  await Hive.openBox(downloadedMusic);
  await Hive.openBox('RecentlyPlayed');
  final isDark = await box.get(isDarkBox);
  MainCubit.isDark = isDark ?? true;
}
