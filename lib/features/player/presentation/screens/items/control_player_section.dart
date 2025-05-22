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

  @override
  void initState() {
    super.initState();
  }

  void toggleShuffle() {
    setState(() {
      isShuffled = !isShuffled;
      widget.audioPlayer.setShuffleModeEnabled(isShuffled);
    });
  }

  Icon loopIcon() {
    return Icon(
      Icons.repeat_outlined,
      size: 24,
      color: widget.con.isLooping ? Colors.white : Colors.grey,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // ✅ Responsive sizes
    final double buttonSize = screenWidth * 0.09; // Adjusts button size dynamically
    final double borderSize = buttonSize * 0.1;
    final double paddingSize = screenHeight * 0.015;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06, vertical: screenHeight * 0.015),
      child: Column(
        children: [
          // ✅ Play/Pause Button
          PauseInPlayerScreen(
            onPressed: widget.con.playOrPause,
            icon: widget.isPlaying ? Icons.pause : Icons.play_arrow,
            width: buttonSize,
            padding: paddingSize,
          ),

          SizedBox(height: screenHeight * 0.02), // Responsive spacing

          // ✅ Shuffle & Loop Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButtonOfPlay(
                onPressed: toggleShuffle,
                icon: Icon(
                  Icons.shuffle_outlined,
                  color: isShuffled ? Colors.green : Colors.grey,
                ),
                width: buttonSize,
                widthOfBorder: borderSize,
                padding: paddingSize * 0.6,
              ),
              IconButtonOfPlay(
                onPressed: widget.con.toggleLoop,
                icon: loopIcon(),
                width: buttonSize,
                widthOfBorder: borderSize,
                padding: paddingSize * 0.6,
              ),
            ],
          ),

          SizedBox(height: screenHeight * 0.02), // Responsive spacing

          // ✅ Previous & Next Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButtonOfPlay(
                onPressed: widget.con.onPrevious,
                icon: const Icon(Icons.skip_previous_outlined, color: Colors.white),
                width: buttonSize,
                widthOfBorder: borderSize,
                padding: paddingSize * 0.6,
              ),
              IconButtonOfPlay(
                onPressed: widget.con.onNext,
                icon: const Icon(Icons.skip_next_outlined, color: Colors.white),
                width: buttonSize,
                widthOfBorder: borderSize,
                padding: paddingSize * 0.6,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
