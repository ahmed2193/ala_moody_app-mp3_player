import 'package:alamoody/features/profile/presentation/cubits/profile/profile_cubit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

import '../../../../core/helper/app_size.dart';
import '../../../../core/utils/hex_color.dart';

class CircleContainerWithGradientBorder extends StatelessWidget {
  const CircleContainerWithGradientBorder({
    Key? key,
    this.isMusic = true,
    this.width,
    required this.image,
  }) : super(key: key);

  final String? image;
  final bool? isMusic;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: width ?? 60,
      width: width ?? 60,
      padding: const EdgeInsets.all(AppPadding.p10),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: GradientBoxBorder(
          gradient: LinearGradient(
            colors: [
              HexColor("#A866AE"),
              HexColor("#37C3EE"),
            ],
          ),
          width: 2,
        ),
        gradient: LinearGradient(
          colors: [
            HexColor("#1818B7"),
            HexColor("#AE39A0"),
          ],
        ),
        image: DecorationImage(
          image: NetworkImage(
            image!,
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: isMusic!
            ? CachedNetworkImage(
                errorWidget: (context, url, error) => const Icon(Icons.error),
                imageUrl: context
                    .read<ProfileCubit>()
                    .userProfileData!
                    .user!
                    .artworkUrl!,
                fit: BoxFit.cover,
              )
            : null,
      ),
    );
  }
}
