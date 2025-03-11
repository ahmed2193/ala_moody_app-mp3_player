import 'dart:developer';

import 'package:alamoody/core/utils/controllers/main_controller.dart';
import 'package:alamoody/core/utils/loading_indicator.dart';
//import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:alamoody/core/utils/media_query_values.dart';
import 'package:alamoody/core/utils/no_data.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:provider/provider.dart';

import '../../../../../../core/utils/error_widget.dart' as error_widget;
import '../../../../core/components/reused_background.dart';
import '../../../../core/components/screen_state/loading_screen.dart';
import '../../../../core/helper/app_size.dart';
import '../../../../core/helper/font_style.dart';
import '../../../../core/helper/images.dart';
import '../../../../core/utils/back_arrow.dart';
import '../../../auth/presentation/cubit/login/login_cubit.dart';
import '../../domain/entities/radio.dart' as radio;
import '../../domain/entities/radio_category.dart';
import '../cubits/radio_category/radio_category_cubit.dart';

class RadioChannels extends StatefulWidget {
  const RadioChannels({required this.radioData, super.key});
  final radio.Radio radioData;
  @override
  State<RadioChannels> createState() => _RadioChannelsState();
}

class _RadioChannelsState extends State<RadioChannels> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ReusedBackground(
        body: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: context.height * 0.017,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const BackArrow(),
                  Center(
                    child: Text(
                      widget.radioData.name!,
                      style:
                          styleW600(context)!.copyWith(fontSize: FontSize.f18),
                    ),
                  ),
                  SizedBox(
                    width: context.height * 0.017,
                  ),
                ],
              ),
              Expanded(
                child: RadioChannelBody(
                  radioData: widget.radioData,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RadioChannelBody extends StatefulWidget {
  const RadioChannelBody({
    required this.radioData,
    Key? key,
  }) : super(key: key);
  final radio.Radio radioData;
  @override
  State<RadioChannelBody> createState() => _RadioChannelBodyState();
}

class _RadioChannelBodyState extends State<RadioChannelBody> {
  Future<void> _getRadioCategory() =>
      BlocProvider.of<RadioCategoryCubit>(context).getRadioCategory(
        id: widget.radioData.id!,
        accessToken: context.read<LoginCubit>().authenticatedUser!.accessToken!,
      );

  @override
  void initState() {
    _getRadioCategory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final devicePexelRatio = MediaQuery.of(context).devicePixelRatio;

    final controller = Provider.of<MainController>(context);
    return BlocBuilder<RadioCategoryCubit, RadioCategoryState>(
      builder: (context, state) {
        if (state is RadioCategoryLoading) {
          return const LoadingScreen();
        } else if (state is RadioCategorySuccess) {
          final radioCategory =
              BlocProvider.of<RadioCategoryCubit>(context).radioCategory;
          return radioCategory.isEmpty
              ? const Center(
                  child: NoData(),
                )
              : GridView.builder(
                  itemCount: radioCategory.length,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 1.12,

                    // mainAxisExtent: 200,
                  ),
                  itemBuilder: (context, index) {
                    log(radioCategory[index].streamUrl.toString());
                    return GestureDetector(
                      onTap: () {
                        controller.playRadio(
                          controller.convertToAudio(radioCategory),
                          radioCategory.indexOf(radioCategory[index]),
                        );
                      },
                      child: Column(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              child: CachedNetworkImage(
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                                imageUrl: radioCategory[index].artworkUrl!,
                                memCacheHeight:
                                    (300 * devicePexelRatio).round(),
                                memCacheWidth: (300 * devicePexelRatio).round(),
                                maxHeightDiskCache:
                                    (300 * devicePexelRatio).round(),
                                maxWidthDiskCache:
                                    (300 * devicePexelRatio).round(),
                                progressIndicatorBuilder: (context, url, l) =>
                                    const LoadingIndicator(),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: context.height * 0.0060,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              RadioWave(
                                radio: radioCategory[index],
                              ),
                              Text(radioCategory[index].title!),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
        } else if (state is RadioCategoryError) {
          return error_widget.ErrorWidget(
            onRetryPressed: () => _getRadioCategory(),
            msg: state.message,
          );
        } else {
          return const Center(
            child: NoData(),
          );
        }
      },
    );
  }
}

class RadioWave extends StatelessWidget {
  const RadioWave({super.key, required this.radio});
  final RadioCategory radio;

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<MainController>(context);
    final isPlaying = controller.isPlaying;

    // Using StreamBuilder to listen to the current audio playing stream
    return StreamBuilder<PlayerState>(
      stream: controller.player.playerStateStream,
      builder: (context, snapshot) {
        final playerState = snapshot.data;
        final isPlaying = playerState?.playing ?? false;
        final currentIndex = controller.currentIndex;

        if (controller.audios.isEmpty) {
          return const Center(child: SizedBox());
        }

        final currentAudioSource =
            currentIndex != null && currentIndex < controller.audios.length
                ? controller.audios[currentIndex]
                : null;
        MediaItem? currentMediaItem;

        if (currentAudioSource is UriAudioSource) {
          currentMediaItem = currentAudioSource.tag as MediaItem?;
        }
        if (snapshot.connectionState == ConnectionState.active &&
            snapshot.hasData) {
          final currentAudio = snapshot.data;

          // Access the metadata of the current audio
          if (controller.isPlaying &&
              currentMediaItem != null &&
              currentMediaItem.id == radio.id.toString() &&
              radio.title == currentMediaItem.title) {
            return Image.asset(
              ImagesPath.audioWave,
              scale: 3.5,
            );
          }
        }

        // Return empty widget if no match or not playing
        return const SizedBox.shrink();
      },
    );
  }
}
