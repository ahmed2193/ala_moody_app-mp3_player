import 'package:alamoody/core/utils/controllers/main_controller.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../../../../occasions/presentation/widgets/icon_button_of_play.dart';
import '../../widgets/pause_player_screen.dart';

class ControlPlayerSection extends StatefulWidget {
  final AudioPlayer audioPlayer; // just_audio's AudioPlayer instance
  final bool isPlaying;

  final MainController con; // Your MainController

  const ControlPlayerSection({
    super.key,
    required this.audioPlayer,
    required this.isPlaying,
    required this.con,
  });

  @override
  State<ControlPlayerSection> createState() => _ControlPlayerSectionState();
}

class _ControlPlayerSectionState extends State<ControlPlayerSection> {
  bool isShuffled = false;
  // var controller;

  @override
  @override
  void initState() {
    super.initState();
    // controller = Provider.of<MainController>(context);
  }

  void toggleShuffle() {
    setState(() {
      isShuffled = !isShuffled;
      if (isShuffled) {
        widget.audioPlayer.setShuffleModeEnabled(true); // Enable shuffle mode
      } else {
        widget.audioPlayer.setShuffleModeEnabled(false); // Disable shuffle mode
      }
    });
  }

  Icon loopIcon() {
    // Define the loop icon based on the loop state
    return Icon(
      Icons.repeat_outlined,
      size: 24,
      color: widget.con.isLooping ? Colors.white : Colors.grey,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
      child: Column(
        children: [
          PauseInPlayerScreen(
            onPressed: widget.con.playOrPause,
            icon: widget.isPlaying ? Icons.pause : Icons.play_arrow,
            width: 34,
            padding: 22.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Shuffle button
              IconButtonOfPlay(
                onPressed: toggleShuffle,
                icon: Icon(
                  Icons.shuffle_outlined,
                  color: isShuffled ? Colors.green : Colors.grey,
                ),
                width: 30,
                widthOfBorder: 3,
                padding: 8,
              ),
              // Loop button
              IconButtonOfPlay(
                onPressed: widget.con.toggleLoop,
                icon: loopIcon(),
                width: 30,
                widthOfBorder: 3,
                padding: 8,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Previous button
              IconButtonOfPlay(
                onPressed: widget.con.onPrevious,
                icon: const Icon(
                  Icons.skip_previous_outlined,
                  color: Colors.white,
                ),
                width: 30,
                widthOfBorder: 3,
                padding: 8,
                // padding:  EdgeInsets.all(8.0),
              ),
              // Next button
              IconButtonOfPlay(
                onPressed: widget.con.onNext,
                icon: const Icon(
                  Icons.skip_next_outlined,
                  color: Colors.white,
                ),
                width: 30,
                widthOfBorder: 3,
                padding: 8,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
