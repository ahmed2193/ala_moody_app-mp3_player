import 'package:alamoody/core/entities/songs.dart';
import 'package:alamoody/core/utils/botttom_sheet_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/auth/presentation/cubit/login/login_cubit.dart';
import '../../features/favorites/presentation/cubits/add_and_remove_from_favorite/add_and_remove_from_favorite_cubit.dart';
import 'hex_color.dart';

class MenuItemButtonWidget extends StatelessWidget {
  const MenuItemButtonWidget({
    super.key,
    required this.song,
    this.deleteIcon = const SizedBox(),
  });
  final Songs song;
  final Widget deleteIcon;

  @override
  Widget build(BuildContext context) {
    bool isFav = song.favorite! ?? false;
    return StatefulBuilder(
      builder: (BuildContext context, setState) {
        return BlocConsumer<AddAndRemoveFromFavoritesCubit,
            AddAndRemoveFromFavoritesState>(
          listener: (context, state) {
            if (state is AddAndRemoveFromFavoritesLoading) {
              if (state.id == song.id) {
                setState(() {
                  isFav = !isFav;
                });
              }
            }
            // else {
            //   setState(() {
            //     isFav = false;
            //   });
            // }

            if (state is AddAndRemoveFromFavoritesFailed) {
              if (state.id == song.id) {
                setState(() {
                  isFav = !isFav;
                });
              }
            }
          },
          builder: (context, state) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                deleteIcon,
                GestureDetector(
                  onTap: () {
                    BlocProvider.of<AddAndRemoveFromFavoritesCubit>(context)
                        .addAndRemoveFromFavorites(
                      id: song.id!,
                      accessToken: context
                          .read<LoginCubit>()
                          .authenticatedUser!
                          .accessToken!,
                      favtype: !isFav
                          ? BlocProvider.of<AddAndRemoveFromFavoritesCubit>(
                              context,
                            ).type = 1
                          : BlocProvider.of<AddAndRemoveFromFavoritesCubit>(
                              context,
                            ).type = 0,
                    );
                  },
                  child: Icon(
                    isFav ? Icons.favorite : Icons.favorite_border_sharp,
                    color: isFav
                        ? HexColor('#F915DE')
                        : Theme.of(context).listTileTheme.textColor,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                     useSafeArea: true,
                                  useRootNavigator: true,
                      builder: (_) => BottomSheetWidget(
                        // con: con,
                        song: song,
                      ),
                    );
                  },
                  icon: RotatedBox(
                    quarterTurns: 3,
                    child: Icon(
                      Icons.more_vert,
                      color: Theme.of(context).listTileTheme.textColor,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
