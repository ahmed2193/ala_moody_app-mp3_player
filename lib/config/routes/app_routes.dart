// import 'package:alamoody/core/artist_details.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import '../../core/models/artists_model.dart';
// import '../../core/utils/app_strings.dart';
// import '../../features/auth/presentation/cubit/forget_password/forget_password_cubit.dart';
// import '../../features/auth/presentation/cubit/login/login_cubit.dart';
// import '../../features/auth/presentation/cubit/register/register_cubit.dart';
// import '../../features/auth/presentation/screen/forget_password_screen.dart';
// import '../../features/auth/presentation/screen/login_screen.dart';
// import '../../features/auth/presentation/screen/register_screen.dart';
// // import '../../features/downloads/presentation/screens/downloads_screen.dart';
// import '../../features/main/presentation/screens/welcome_screen/welcome_screen.dart';
// import '../../features/main_layout/presentation/pages/main_layout_screen.dart';
// import '../../features/profile/presentation/cubits/update_profile/update_profile_cubit.dart';
// import '../../features/profile/presentation/screens/edit_profile_info_screen.dart';
// import '../../injection_container.dart' as di;

// class Routes {
//   static const String initialRoute = '/';
//   // static const String mainRoute = '/mainRoute';
//   // static const String unloginMainRoute = '/unloginMainRoute';
//   // static const String registerRoute = '/registerRoute';
//   // static const String loginRoute = '/loginRoute';
//   // static const String forgetPasswordRoute = '/forgetPasswordRoute';
//   static const String updteProfileRoute = '/updteProfileRoute';
//   static const String artistDetailsRoute = '/artistDetailsRoute';
// }
//           //           pushNavigate(context, BlocProvider(
//           // create: (_) => di.sl<UpdateProfileCubit>(),
//           //   child: const EditProfileInfoScreen(),
//           // ),);
//           //     pushNavigateAndRemoveUntil(context, MainLayoutScreen());
// mixin AppRoutes {
//   static Route? onGenerateRoute(RouteSettings routeSettings) {
//     switch (routeSettings.name) {
//       // case Routes.initialRoute:
//       //   return MaterialPageRoute(builder: (_) => const SizedBox());

//       case Routes.mainRoute:
//         return MaterialPageRoute(
//           builder: (_) => BlocBuilder<LoginCubit, LoginState>(
//             builder: (context, state) {
//               if (state is Authenticated) {
//                 return  const MainLayoutScreen();

//                 // App();
//               } else if (state is UnAuthenticated) {
//                 return const LoginScreen();
//               } else {
//                 return const WelcomeScreen();
//               }
//             },
//           ),
//         );

//       case Routes.unloginMainRoute:
//         return MaterialPageRoute(builder: (_) => const LoginScreen());

//       case Routes.loginRoute:
//         return MaterialPageRoute(builder: (_) => const LoginScreen());
//       // case Routes.downloadsRoute:
//       //   return MaterialPageRoute(builder: (_) => const DownloadsScreen());
//       case Routes.registerRoute:
//         return MaterialPageRoute(
//           builder: (_) => BlocProvider(
//             create: (_) => di.sl<RegisterCubit>(),
//             child: const RegisterScreen(),
//           ),
//         );

//       case Routes.forgetPasswordRoute:
//         return MaterialPageRoute(
//           builder: (_) => BlocProvider(
//             create: (_) => di.sl<ForgetPasswordCubit>(),
//             child: const ForgetPasswordScreen(),
//           ),
//         );
//       case Routes.updteProfileRoute:
//         return MaterialPageRoute(
//           builder: (_) => BlocProvider(
//             create: (_) => di.sl<UpdateProfileCubit>(),
//             child: const EditProfileInfoScreen(),
//           ),
//         );
//          case Routes.artistDetailsRoute:
//         final artistData = routeSettings.arguments as ArtistsModel?;
//         return MaterialPageRoute(
//           builder: (_) => ArtistDetails(artist: artistData!),
//         );

//       default:
//         return unDefinedRoute();
//     }
//     return unDefinedRoute();
//   }
// }
//    Route<dynamic> unDefinedRoute() {
//     return MaterialPageRoute(
//         builder: (_) => Scaffold(
//               appBar: AppBar(
//                 title: const Text(AppStrings.noRouteFound),
//               ),
//               body: const Center(child: Text(AppStrings.noRouteFound)),
//             ),);
//   }