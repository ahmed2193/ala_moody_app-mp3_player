import 'dart:developer';

import 'package:alamoody/core/components/reused_background.dart';
import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../helper/images.dart';
import 'controllers/main_controller.dart';

class AudioQueueWidget extends StatelessWidget {
  final MainController controller;

  const AudioQueueWidget({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // appBar: AppBar(
        //   title: const Text('Audio Queue'),
        //   backgroundColor: Colors.deepPurple,
        // ),
        body: ReusedBackground(
          lightBG: ImagesPath.homeBGLightBG,
          body: StreamBuilder<PlayerState>(
            stream: controller.player!.playerStateStream,
            builder: (context, snapshot) {
              final playerState = snapshot.data;
              final isPlaying = playerState?.playing ?? false;
              final currentIndex = controller.currentIndex;
              log('controller.isPlaying.toString()');
              log(controller.isPlaying.toString());
              log(currentIndex.toString());
              if (controller.audios.isEmpty) {
                return const Center(child: Text('No audio in the queue.'));
              }

              final currentAudioSource = currentIndex != null &&
                      currentIndex < controller.audios.length
                  ? controller.audios[currentIndex]
                  : null;
              MediaItem? currentMediaItem;

              if (currentAudioSource is UriAudioSource) {
                currentMediaItem = currentAudioSource.tag as MediaItem?;
              }

              return Column(
                children: [
                  // Display the currently playing item at the top with a different UI
                  if (currentMediaItem != null) ...[
                    Container(
                      color: Colors.deepPurple.withOpacity(0.1),
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: CachedNetworkImage(
                            imageUrl: currentMediaItem.artUri?.toString() ?? '',
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.music_note),
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Row(
                          children: [
                            Text(
                              currentMediaItem.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple,
                              ),
                            ),
                            if (isPlaying) Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6,),
                                    child: Image.asset(
                                      ImagesPath.audioWave,
                                      scale: 3.5,
                                    ),) else const SizedBox(),
                          ],
                        ),
                        subtitle:
                            Text(currentMediaItem.artist ?? 'Unknown Artist'),
                        trailing: Icon(
                          isPlaying ? Icons.pause : Icons.play_arrow,
                          color: Colors.deepPurple,
                        ),
                        onTap: () {
                          if (isPlaying) {
                            controller.player!.pause();
                          } else {
                            controller.player!.play();
                          }
                        },
                      ),
                    ),
const Divider(),
                  ],

                  // Display the rest of the audio queue
            Expanded(child: 
            ListView(
              children: [
                      ...List.generate(controller.audios.length, (index) {
                    if (index == currentIndex) {
                      return const SizedBox
                          .shrink(); // Skip the currently playing item
                    }
                    final audioSource = controller.audios[index];
                    MediaItem? mediaItem;

                    if (audioSource is UriAudioSource) {
                      mediaItem = audioSource.tag as MediaItem?;
                    }

                    return ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: CachedNetworkImage(
                          imageUrl: mediaItem?.artUri?.toString() ?? '',
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.music_note),
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(
                        mediaItem?.title ?? 'Unknown Title',
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      subtitle: Text(mediaItem?.artist ?? 'Unknown Artist'),
                      trailing: const Icon(
                        CupertinoIcons.line_horizontal_3,
                        color: Colors.grey,
                      ),
                      onTap: () {
                        controller.playAudio(index);
                      },
                    );
                  }),
             
              ],
            ),
            
            ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
