
import 'dart:async';
import 'dart:developer';
import 'package:alamoody/core/utils/controllers/main_controller.dart'
    show MainController;
import 'package:alamoody/features/player/presentation/screens/players_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../cubits/ads_cubit.dart'; // Assuming AdsCubit and AdsState are in this path
// If AdsData is in a different file, ensure it's imported if needed directly.
// For example: import '../data/models/ads_model.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FullScreenAds extends StatefulWidget {
  @override
  _FullScreenAdsState createState() => _FullScreenAdsState();
}

class _FullScreenAdsState extends State<FullScreenAds> {
  // Define the total duration for the ad. This could also come from ad data.
  static const int _initialAdDurationSeconds = 5;

  int _remainingTime = _initialAdDurationSeconds;
  Timer? _timer;
  bool _showCloseIcon = false;

  @override
  void initState() {
    super.initState();
    // Initialize remaining time with the total ad duration.
    _remainingTime = _initialAdDurationSeconds;

    final adsCubit = BlocProvider.of<AdsCubit>(context);
    // Fetch ads. The listener will start the timer when ads are loaded.
    adsCubit.getAds();
  }

  void _startTimer() {
    // Ensure any existing timer is cancelled before starting a new one.
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else {
        // Time is up, show the close icon and cancel the timer.
        setState(() {
          _showCloseIcon = true;
        });
        timer.cancel();
      }
    });
  }

  Future<void> _openAdLink(String? url) async {
    if (url == null || url.isEmpty) {
      // Fallback URL if the ad link is empty
      url = "https://alamoody.com/";
    }
    // ignore: deprecated_member_use
    if (await canLaunch(url)) {
      // ignore: deprecated_member_use
      await launch(url);
    } else {
      // Optionally, show a message to the user if the URL can't be launched.
      print("Could not launch $url");
    }
  }

  void _closeAd() {
    Future.delayed(Duration(milliseconds: 300), () {
      Navigator.of(context).pop(); // Close FullScreenAds

      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => Material(
            child: PlayerScreen(
              con: Provider.of<MainController>(context, listen: false)!,
            ),
          ),
        ),
      );
      Provider.of<MainController>(context, listen: false).player.play();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // Prevent manual dismissal of the ad screen via back button
      onWillPop: () async =>
          _showCloseIcon, // Allow pop only if close icon is shown
      child: BlocConsumer<AdsCubit, AdsState>(
        listener: (context, state) {
          log(state.toString());
          if (state is AdsLoaded) {
            if (state.ad != null) {
              // Optional: If your AdsData model has a duration, you could use it here:
              // _remainingTime = state.ad.duration ?? _initialAdDurationSeconds;
              // For now, we use the static _initialAdDurationSeconds.
              _remainingTime =
                  _initialAdDurationSeconds; // Reset timer for new ad
              _showCloseIcon = false; // Ensure close icon is hidden for new ad
              _startTimer();
            } else {
              // No ad data, or ad is null, prepare to close.
              // Calling _closeAd directly in listener might be okay if it only pops.
              // If it navigates, consider WidgetsBinding.instance.addPostFrameCallback
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _closeAd();
              });
            }
          } else if (state is AdsError) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _closeAd();
            });
          }
        },
        builder: (context, state) {
          if (state is AdsIsLoading) {
            return Scaffold(
              backgroundColor: Colors.black.withOpacity(0.9),
              body:
                  Center(child: CircularProgressIndicator(color: Colors.white)),
            );
          }

          if (state is AdsLoaded && state.ad != null) {
            _startTimer();

            final ad = state.ad!; // ad is guaranteed to be non-null here
            return Scaffold(
              backgroundColor: Colors.black.withOpacity(0.9),
              body: Stack(
                children: [
                  // Ad Image/Content
                  Positioned.fill(
                    child: GestureDetector(
                      onTap: () => _openAdLink(ad.link),
                      child: CachedNetworkImage(
                        imageUrl: ad.image ??
                            'https://placehold.co/600x400/000000/FFFFFF?text=Ad+Image', // Fallback placeholder
                        fit: BoxFit.fill,
                        placeholder: (context, url) => Center(
                            child:
                                CircularProgressIndicator(color: Colors.white)),
                        errorWidget: (context, url, error) => Center(
                            child: Icon(Icons.error,
                                color: Colors.white, size: 50)),
                      ),
                    ),
                  ),
                  // Timer and Close Button UI
                  Positioned(
                    top: 40, // Adjust for status bar or notch
                    right: 16,
                    child: _showCloseIcon
                        ? Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: Icon(Icons.close, color: Colors.white),
                              onPressed: _closeAd,
                              tooltip: "Close Ad",
                            ),
                          )
                        : TweenAnimationBuilder<double>(
                            tween: Tween<double>(begin: 1.0, end: 0.0),
                            // Duration of the animation is the total ad time
                            duration: const Duration(
                                seconds: _initialAdDurationSeconds),
                            builder: (context, progressValue, child) {
                              // progressValue goes from 1.0 down to 0.0
                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.5),
                                  shape: BoxShape.circle,
                                ),
                                width:
                                    48, // Increased size for better touch target
                                height: 48,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    SizedBox(
                                      // Ensure progress indicator is same size
                                      width: 40,
                                      height: 40,
                                      child: CircularProgressIndicator(
                                        value:
                                            progressValue, // Drives the progress circle
                                        strokeWidth: 3, // Slightly thinner
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white), // Progress color
                                        backgroundColor: Colors.white
                                            .withOpacity(0.3), // Track color
                                      ),
                                    ),
                                    Text(
                                      "$_remainingTime", // Display the current countdown
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14, // Ensure text fits
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          }

          // Fallback for AdsError, AdsLoaded with null ad, or any other unhandled state
          // The listener should ideally handle closing, but this is a safe fallback UI.
          return Scaffold(
            backgroundColor: Colors.black.withOpacity(0.8),
            body: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("No Ad Available or Ad Error",
                    style: TextStyle(color: Colors.white, fontSize: 16)),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _closeAd;
                  },
                  child: Text("Close"),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent),
                )
              ],
            )),
          );
        },
      ),
    );
  }
}
