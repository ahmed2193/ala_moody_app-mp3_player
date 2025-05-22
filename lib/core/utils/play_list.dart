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
  const AudioQueueWidget({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    return Scaffold(
      body: ReusedBackground(
        body: StreamBuilder<PlayerState>(
          stream: controller.player.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            final isPlaying = playerState?.playing ?? false;
            final currentIndex = controller.currentIndex;
            log(controller.isPlaying.toString());
            log(currentIndex.toString());

            if (controller.audios.isEmpty) {
              return const Center(child: Text('No audio in the queue.'));
            }

            final currentAudioSource = (currentIndex != null && currentIndex < controller.audios.length)
                ? controller.audios[currentIndex]
                : null;
            MediaItem? currentMediaItem;

            if (currentAudioSource is UriAudioSource) {
              currentMediaItem = currentAudioSource.tag as MediaItem?;
            }

            return Padding(
              padding: EdgeInsets.only(top: screenHeight * 0.05),
              child: Column(
                children: [
                  if (currentMediaItem != null) ...[
                    Container(
                      color: Colors.deepPurple.withOpacity(0.1),
                      padding: EdgeInsets.all(screenWidth * 0.02),
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: CachedNetworkImage(
                            imageUrl: currentMediaItem.artUri?.toString() ?? '',
                            placeholder: (context, url) => const CircularProgressIndicator(),
                            errorWidget: (context, url, error) => const Icon(Icons.music_note),
                            width: screenWidth * 0.12,
                            height: screenWidth * 0.12,
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Row(
                          children: [
                            Expanded(
                              child: Text(
                                currentMediaItem.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (isPlaying)
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.015),
                                child: Image.asset(
                                  ImagesPath.audioWave,
                                  scale: 3.5,
                                ),
                              ),
                          ],
                        ),
                        subtitle: Text(currentMediaItem.artist ?? 'Unknown Artist'),
                        trailing: Icon(
                          isPlaying ? Icons.pause : Icons.play_arrow,
                          color: Colors.deepPurple,
                        ),
                        onTap: () {
                          if (isPlaying) {
                            controller.player.pause();
                          } else {
                            controller.player.play();
                          }
                        },
                      ),
                    ),
                    const Divider(),
                  ],
                  Expanded(
                    flex: 3,
                    child: ListView.builder(
                      itemCount: controller.audios.length,
                      itemBuilder: (context, index) {
                        if (index == currentIndex) return const SizedBox.shrink();
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
                              placeholder: (context, url) => const CircularProgressIndicator(),
                              errorWidget: (context, url, error) => const Icon(Icons.music_note),
                              width: screenWidth * 0.1,
                              height: screenWidth * 0.1,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(
                            mediaItem?.title ?? 'Unknown Title',
                            style: const TextStyle(color: Colors.grey),
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(mediaItem?.artist ?? 'Unknown Artist'),
                          trailing: const Icon(CupertinoIcons.line_horizontal_3, color: Colors.grey),
                          onTap: () => controller.playAudio(index),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
