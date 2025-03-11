//import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:alamoody/core/utils/back_arrow.dart';
import 'package:alamoody/core/utils/media_query_values.dart';
import 'package:alamoody/core/utils/no_data.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/utils/error_widget.dart' as error_widget;
import '../../../../config/locale/app_localizations.dart';
import '../../../../core/components/reused_background.dart';
import '../../../../core/components/screen_state/loading_screen.dart';
import '../../../../core/helper/app_size.dart';
import '../../../../core/helper/font_style.dart';
import '../../../../core/utils/navigator_reuse.dart';
import '../../../auth/presentation/cubit/login/login_cubit.dart';
import '../cubits/radio/radio_cubit.dart';
import 'radio_channels.dart';

// class RadioScreen extends StatefulWidget {
//   const RadioScreen({super.key});

//   @override
//   State<RadioScreen> createState() => _RadioScreenState();
// }

// class _RadioScreenState extends State<RadioScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: ReusedBackground(
//         body: SafeArea(
//           bottom: false,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(
//                 height: context.height * 0.017,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const BackArrow(),
//                   Center(
//                     child: Text(
//                       AppLocalizations.of(context)!.translate("radio")!,
//                       style:
//                           styleW600(context)!.copyWith(fontSize: FontSize.f18),
//                     ),
//                   ),
//                   SizedBox(
//                     width: context.height * 0.017,
//                   ),
//                 ],
//               ),
//               Center(
//                 child: Text(
//                   AppLocalizations.of(context)!
//                       .translate('listen_to_live_radio_stations')!,
//                   style: styleW500(context, fontSize: 16),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(12.0),
//                 child: Text(
//                   AppLocalizations.of(context)!.translate('categories')!,

//                   // 'Categories',
//                   style: styleW600(context, fontSize: 22),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//               const Expanded(
//                 child: GridViewWidget(),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


class RadioScreen extends StatefulWidget {
  const RadioScreen({super.key});

  @override
  State<RadioScreen> createState() => _RadioScreenState();
}

class _RadioScreenState extends State<RadioScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ReusedBackground(
        body: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              Row(
                children: [
                  const BackArrow(),
                    SizedBox(
                    width: context.height * 0.017,
                  ),
                  Center(
                    child: Text(
                      AppLocalizations.of(context)!.translate("live_Radio_Worldwide")!,
                      style: styleW700(context)!.copyWith(
                        fontSize: 26,
                        foreground: Paint()..shader = const LinearGradient(
                          colors: [Colors.blueAccent, Colors.purpleAccent],
                        ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 5),

              Center(
                child: Text(
                  
                               AppLocalizations.of(context)!
                      .translate('listen_to_live_radio_stations')!,
                  style: styleW500(context, fontSize: 16, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  AppLocalizations.of(context)!.translate('categories')!,
                  style: styleW600(context, fontSize: 22),
                  textAlign: TextAlign.start,
                ),
              ),

              const SizedBox(height: 10),

              const Expanded(
                child: GridViewWidget(),
              ),

   
            ],
          ),
        ),
      ),
    );
  }
}


class GridViewWidget extends StatefulWidget {
  const GridViewWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<GridViewWidget> createState() => _GridViewWidgetState();
}

class _GridViewWidgetState extends State<GridViewWidget> {
  Future<void> _getRadio() => BlocProvider.of<RadioCubit>(context).getRadio(
        accessToken: context.read<LoginCubit>().authenticatedUser!.accessToken!,
      );
  @override
  void initState() {
    _getRadio();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RadioCubit, RadioState>(
      builder: (context, state) {
        if (state is RadioLoading) {
          return const LoadingScreen();
        } else if (state is RadioSuccess) {
          final radio = BlocProvider.of<RadioCubit>(context).radio;
          return GridView.builder(
            itemCount: radio.length,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(
                AppPadding.p12, AppPadding.p12, AppPadding.p12, 120,),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1.12,

              // mainAxisExtent: 200,
            ),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  pushNavigate(
                    context,
                    RadioChannels(radioData: radio[index]),
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
                          imageUrl: radio[index].artworkUrl!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: context.height * 0.0145,
                    ),
                    Text(radio[index].name!),
                  ],
                ),
              );
            },
          );
        } else if (state is RadioError) {
          return error_widget.ErrorWidget(
            onRetryPressed: () => _getRadio(),
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

