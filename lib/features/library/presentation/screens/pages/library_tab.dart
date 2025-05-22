import 'dart:async';

import 'package:alamoody/config/locale/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../../../core/helper/app_size.dart';
import '../../../../../core/utils/controllers/main_controller.dart';
import '../../../../../core/utils/loading_indicator.dart';
import '../../cubits/library/library_cubit.dart';
import '../../widgets/reused_item_library_category.dart';

class TabPageOfLibrary extends StatelessWidget {
  TabPageOfLibrary({
    Key? key,
    required this.scrollController,
  }) : super(key: key);
  ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return _buildBodyContent();
  }

  Widget _buildBodyContent() {
    return BlocBuilder<LibraryCubit, LibraryState>(
      builder: (context, state) {
        if (state is LibraryIsLoading && state.isFirstFetch) {
          return const LoadingIndicator();
        }
        if (state is LibraryIsLoading) {
          BlocProvider.of<LibraryCubit>(context).loadMore = true;
        } else if (state is LibraryError) {
          return Center(
            child: Text(
              // onRetryPressed: () => _getAllLibrary(),
              state.message!,
            ),
          );
        }

        return BlocProvider.of<LibraryCubit>(context).library.isNotEmpty
            ? ListView.separated(
                scrollDirection: Axis.horizontal,
                controller: scrollController,
                padding: const EdgeInsetsDirectional.only(
                  start: AppPadding.p10,
                  end: AppPadding.p10,
                ),
                separatorBuilder: (BuildContext context, int index) =>
                    const SizedBox(
                  width: AppPadding.p4,
                ),
                itemCount: BlocProvider.of<LibraryCubit>(context)
                        .library
                        .length +
                    (BlocProvider.of<LibraryCubit>(context).loadMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index <
                      BlocProvider.of<LibraryCubit>(context).library.length) {
                    final songs =
                        BlocProvider.of<LibraryCubit>(context).library;
                    final song = songs[index];

                    return GestureDetector(
                      onTap: () {
                        final con =
                            Provider.of<MainController>(context, listen: false);
                        con.playSong(
                          con.convertToAudio(songs),
                          songs.indexOf(song),
                        );
                      },
                      child: ItemOfLibraryCategory(
                        library: BlocProvider.of<LibraryCubit>(context)
                            .library[index],
                      ),
                    );
                  } else if (BlocProvider.of<LibraryCubit>(context).pageNo <=
                      BlocProvider.of<LibraryCubit>(context).totalPages) {
                    Timer(const Duration(milliseconds: 30), () {
                      scrollController.jumpTo(
                        scrollController.position.maxScrollExtent,
                      );
                    });

                    return const LoadingIndicator();
                  }
                  return const SizedBox();
                },
              )
            :  Center(
                child: Text(AppLocalizations.of(context)!
                                  .translate("no_data")!,),
              );
      },
    );
  }
}
