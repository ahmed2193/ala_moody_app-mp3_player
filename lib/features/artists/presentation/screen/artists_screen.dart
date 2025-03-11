import 'package:alamoody/core/helper/app_size.dart';
import 'package:alamoody/core/utils/back_arrow.dart';
import 'package:alamoody/core/utils/media_query_values.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import '../../../../config/locale/app_localizations.dart';
import '../../../../core/artist_details.dart';
import '../../../../core/components/reused_background.dart';
import '../../../../core/components/screen_state/loading_screen.dart';
import '../../../../core/helper/font_style.dart';
import '../../../../core/utils/hex_color.dart';
import '../../../../core/utils/navigator_reuse.dart';
import '../../../../core/utils/no_data.dart';
import '../../../auth/presentation/cubit/login/login_cubit.dart';
import '../../../home/presentation/cubits/artists/artists_cubit.dart';

class ArtistsScreen extends StatefulWidget {
  const ArtistsScreen({Key? key}) : super(key: key);

  @override
  State<ArtistsScreen> createState() => _ArtistsScreenState();
}

class _ArtistsScreenState extends State<ArtistsScreen> {
  final ScrollController scrollController = ScrollController();

  void _fetchArtists() {
    BlocProvider.of<ArtistsCubit>(context).getArtists(
      accessToken: context.read<LoginCubit>().authenticatedUser!.accessToken,
    );
  }

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ArtistsCubit>(context).clearData();
    _fetchArtists();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ReusedBackground(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: context.height * 0.015),
              Row(
                children: [
                  const BackArrow(),
                  SizedBox(width: context.width * 0.02),
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context)!.translate("artists")!,
                      style: styleW600(context)!.copyWith(fontSize: FontSize.f16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: BlocBuilder<ArtistsCubit, ArtistsState>(
                  builder: (context, state) {
                    if (state is ArtistsIsLoading && state.isFirstFetch) {
                      return const Center(child: LoadingScreen());
                    }
                    if (state is ArtistsError) {
                      return Center(child: Text(state.message!, style: styleW600(context)));
                    }
                    final artists = BlocProvider.of<ArtistsCubit>(context).artists;
                    return artists.isNotEmpty
                        ? ListView.builder(
                            controller: scrollController,
                            physics: const BouncingScrollPhysics(),
                            padding: EdgeInsets.only(bottom: context.height * 0.2),
                            itemCount: artists.length,
                            itemBuilder: (context, index) => _buildArtistItem(context, artists[index]),
                          )
                        : const Center(child: NoData());
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildArtistItem(BuildContext context, artist) {
    return GestureDetector(
      onTap: () => pushNavigate(context, ArtistDetails(artistId: artist.id.toString())),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: GradientBoxBorder(
            gradient: LinearGradient(colors: [HexColor("#020024"), HexColor("#090979"), Colors.black26]),
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            ClipOval(
              child: CachedNetworkImage(
                imageUrl: artist.artworkUrl!,
                width: context.width * 0.15,
                height: context.width * 0.15,
                fit: BoxFit.cover,
                placeholder: (context, url) => const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error, size: 18),
              ),
            ),
            SizedBox(width: context.width * 0.03),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    artist.name!,
                    style: styleW700(context, fontSize: context.width * 0.04),
                  ),
                  Text(
                    AppLocalizations.of(context)!.translate("artists")!,
                    style: styleW400(context, fontSize: context.width * 0.035),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
