import 'dart:async';

import 'package:alamoody/config/locale/app_localizations.dart';
import 'package:alamoody/core/components/reused_background.dart';
import 'package:alamoody/core/components/screen_state/loading_screen.dart';
import 'package:alamoody/core/helper/font_style.dart';
import 'package:alamoody/core/utils/back_arrow.dart';
import 'package:alamoody/core/utils/controllers/main_controller.dart';
import 'package:alamoody/core/utils/loading_indicator.dart';
//import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:alamoody/core/utils/media_query_values.dart';
import 'package:alamoody/core/utils/menu_item_button.dart';
import 'package:alamoody/core/utils/no_data.dart';
import 'package:alamoody/core/utils/song_item.dart';
import 'package:alamoody/features/auth/presentation/cubit/login/login_cubit.dart';
import 'package:alamoody/features/genres/presentation/cubits/genres_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../../../core/helper/app_size.dart';
import '../../../../../core/utils/error_widget.dart' as error_widget;

class GenresScreen extends StatefulWidget {
  const GenresScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<GenresScreen> createState() => _GenresScreenState();
}

class _GenresScreenState extends State<GenresScreen> {
  ScrollController scrollController = ScrollController();

  getGetGenres() {
    BlocProvider.of<GenresCubit>(context).getGenres(
      accessToken: context.read<LoginCubit>().authenticatedUser!.accessToken,
    );
  }

  void _setupScrollControllerSongs(context) {
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        if (scrollController.position.pixels != 0 &&
            BlocProvider.of<GenresCubit>(context).pageNo <=
                BlocProvider.of<GenresCubit>(context).totalPages) {
          getGetGenres();
        }
      }
    });
  }

  @override
  void initState() {
    BlocProvider.of<GenresCubit>(context).clearData();

    getGetGenres();

    _setupScrollControllerSongs(context);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildBodyContent();
  }

  Widget _buildBodyContent() {
    // final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return SafeArea(
      child: Scaffold(
        // key: scaffoldKey,
        // drawer: const DrawerScreen(),
        body: ReusedBackground(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: context.height * 0.017,
              ),
              Row(
                children: [
                  const BackArrow(),
                  SizedBox(
                    width: context.height * 0.017,
                  ),
                  Center(
                    child: Text(
                      AppLocalizations.of(context)!.translate('genres')!,
                      style:
                          styleW600(context)!.copyWith(fontSize: FontSize.f18),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: BlocBuilder<GenresCubit, GenresState>(
                  builder: (context, state) {
                    if (state is GenresIsLoading && state.isFirstFetch) {
                      return const Center(child: LoadingScreen());
                    }
                    if (state is GenresIsLoading) {
                      BlocProvider.of<GenresCubit>(context).loadMore = true;
                    } else if (state is GenresError) {
                      return error_widget.ErrorWidget(
                        onRetryPressed: () => getGetGenres(),
                        msg: state.message!,
                      );
                    }

                    return BlocProvider.of<GenresCubit>(context)
                            .genres
                            .isNotEmpty
                        ? ListView.separated(
                            controller: scrollController,
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                              width: AppPadding.p20,
                            ),
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.only(bottom: 50),
                            itemCount: BlocProvider.of<GenresCubit>(context)
                                    .genres
                                    .length +
                                (BlocProvider.of<GenresCubit>(context).loadMore
                                    ? 1
                                    : 0),
                            itemBuilder: (context, index) {
                              if (index <
                                  BlocProvider.of<GenresCubit>(context)
                                      .genres
                                      .length) {
                                return
                                    //  FeaturedListSlider(
                                    //   con: con,
                                    //   index: index,
                                    //   GenresCubit:
                                    //       BlocProvider.of<GenresCubit>(context)
                                    //           .genresCubit[index],
                                    // );
                                    Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      final con = Provider.of<MainController>(
                                        context,
                                        listen: false,
                                      );
                                      final items =
                                          BlocProvider.of<GenresCubit>(
                                        context,
                                      ).genres;
                                      con.playSong(
                                        con.convertToAudio(items),
                                        items.indexOf(items[index]),
                                      );
                                    },
                                    child: SongItem(
                                      menuItem: MenuItemButtonWidget(
                                        song: BlocProvider.of<GenresCubit>(
                                          context,
                                        ).genres[index],
                                      ),
                                      songs: BlocProvider.of<GenresCubit>(
                                        context,
                                      ).genres[index],
                                    ),
                                  ),
                                );
                              } else if (BlocProvider.of<GenresCubit>(
                                    context,
                                  ).pageNo <=
                                  BlocProvider.of<GenresCubit>(context)
                                      .totalPages) {
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
                        : const Center(
                            child: NoData(),
                          );
                  },
                ),
              ),
              SizedBox(
                height: context.height * 0.129,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
