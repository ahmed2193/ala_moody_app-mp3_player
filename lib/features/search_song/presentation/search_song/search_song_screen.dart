import 'package:alamoody/core/utils/media_query_values.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/components/reused_background.dart';
import '../../../../core/entities/songs.dart';
import '../../../../core/helper/images.dart';
import '../../../../core/utils/back_arrow.dart';
import '../../../audio_playlists/presentation/cubit/audio_playlists_cubit.dart';
import '../../../home/presentation/widgets/search_bar_text_form.dart';
import '../cubit/search_song_cubit.dart';

class SearchSongScreen extends StatefulWidget {
  const SearchSongScreen({super.key, required this.songs});
  final List<Songs> songs;

  @override
  State<SearchSongScreen> createState() => _SearchSongScreenState();
}

class _SearchSongScreenState extends State<SearchSongScreen> {
  late final SearchSongCubit _searchCubit;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchCubit = SearchSongCubit();
    _searchCubit.setSongs(widget.songs); // Initialize the songs list here.
  }

  @override
  void dispose() {
    _searchCubit.close(); // Dispose of the Cubit when the screen is destroyed.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title:

      //    TextFormField(
      //     decoration: const InputDecoration(
      //       hintText: 'Search songs...',
      //       border: InputBorder.none,
      //       hintStyle: TextStyle(color: Colors.white70),
      //     ),
      //     style: const TextStyle(color: Colors.white),
      //     onChanged: (query) {
      //       _searchCubit.searchSongs(query);
      //     },
      //   ),
      // ),
      body: ReusedBackground(
        lightBG: ImagesPath.homeBGLightBG,
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
                Expanded(
                  child: SearchTextFormReuse(
                    textInputAction: TextInputAction.done,
                    searchController: _searchController,
                    hintText: 'search',
                    onChanged: (value) => _searchCubit.searchSongs(value),
                    onClosePressed: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      _searchCubit.setSongs(widget.songs);
                       _searchController.clear();
                    },
                  ),
                ),
                SizedBox(
                  width: context.height * 0.017,
                ),
              ],
            ),
            Expanded(
              child: BlocBuilder<SearchSongCubit, List<Songs>>(
                bloc:
                    _searchCubit, // Explicitly provide the Cubit to the BlocBuilder.
                builder: (context, filteredSongs) {
                  return ListView.separated(
                    padding: const EdgeInsetsDirectional.only(
                      top: 20,
                      bottom: 120,
                    ),
                    physics: const AlwaysScrollableScrollPhysics(),
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 20),
                    itemCount: filteredSongs.length,
                    itemBuilder: (context, i) {
                      return GestureDetector(
                        onTap: () {
                          BlocProvider.of<AudioPlayListsCubit>(
                            context,
                          ).playSongs(context, i, filteredSongs);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Row(
                                  children: [
                                    Text(
                                      (i + 1).toString(),
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Theme.of(context)
                                            .listTileTheme
                                            .iconColor,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(3),
                                      child: Image.network(
                                        filteredSongs[i].artworkUrl!,
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Flexible(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              filteredSongs[i].title!,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              filteredSongs[i]
                                                  .duration
                                                  .toString(),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
