// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'dart:async';
// import 'dart:convert';
// import 'dart:developer';

// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:url_launcher/url_launcher.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(
//     MaterialApp(
//       title: 'Dynamic Links Example',
//       routes: <String, WidgetBuilder>{
//         '/': (BuildContext context) => _MainScreen(),
//         '/helloworld': (BuildContext context) => _DynamicLinkScreen(),
//       },
//     ),
//   );
// }

// class SongsShareData {
//   final String id;
//   final String title;
//   final String artworkUrl;
//   final String lyrics;
//   final String listened;
//   final String streamUrl;
//   final String favorite;
//   // final String title;
//   // final String title;
// // listened: widget.myAudio.metas.extra!['listened'],
// //       lyrics: widget.myAudio.metas.extra!['lyrics'],
// //       favorite: widget.myAudio.metas.extra!['favorite'],
// //       audio: widget.myAudio.path,
// //       // audio: json.encode(widget.myAudio.metas.extra!['audio']),
// //       streamUrl: widget.myAudio.path,
// //       id: int.parse(widget.myAudio.metas.id!),
// //       title: widget.myAudio.metas.title!,
// //       artworkUrl: widget.myAudio.metas.image!.path,
//   SongsShareData({
//     required this.id,
//     required this.title,
//     required this.artworkUrl,
//     required this.lyrics,
//     required this.listened,
//     required this.streamUrl,
//     required this.favorite,
//   });

//   Map<String, dynamic> toJson() => {
//         'id': id,
//         'title': title,
//         'artwork_url': artworkUrl,
//         'favorite': favorite,
//         'audio': streamUrl,
//         'listened': listened,
//         'lyrics': lyrics,
//       };

//   static SongsShareData fromJson(Map<String, dynamic> json) => SongsShareData(
//         id: json['id'] ?? '',
//         title: json['title'] ?? '',
//         artworkUrl: json['artwork_url'] ?? '',
//         streamUrl: json['audio'] ?? '',
//         favorite: json['favorite'] ?? '',
//         listened: json['listened'] ?? '',
//         lyrics: json['lyrics'] ?? '',
//       );
// }

// class _MainScreen extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() => _MainScreenState();
// }

// class _MainScreenState extends State<_MainScreen> {
//   String? _linkMessage;
//   bool _isCreatingLink = false;

//   FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
//   final String _testString =
//       'To test: long press link and then copy and click from a non-browser '
//       "app. Make sure this isn't being tested on iOS simulator and iOS xcode "
//       'is properly setup. Look at firebase_dynamic_links/README.md for more '
//       'details.';

//   final String DynamicLink = 'https://example/helloworld';
//   final String Link = 'https://alamoody.page.link/MEGs';

//   @override
//   void initState() {
//     super.initState();
//     initDynamicLinks();
//   }

//   Future<void> initDynamicLinks() async {
//     dynamicLinks.onLink.listen((dynamicLinkData) {
//       final Uri deepLink = dynamicLinkData.link;
//       if (deepLink != null) {
//         final SongsShareDataEncoded = deepLink.queryParameters['parameters'];
//         if (SongsShareDataEncoded != null) {
//           final Map<String, dynamic> SongsShareDataMap =
//               json.decode(Uri.decodeComponent(SongsShareDataEncoded));
//           final SongsShareData SongsShareData = SongsShareData.fromJson(SongsShareDataMap);

//           // Handle the custom data
//           Navigator.pushNamed(context, deepLink.path, arguments: SongsShareData);
//         }
//       }
//     }).onError((error) {
//       log('onLink error');
//       print(error.message);
//     });

//     final PendingDynamicLinkData? data =
//         await FirebaseDynamicLinks.instance.getInitialLink();
//     final Uri? deepLink = data?.link;

//     if (deepLink != null) {
//       final SongsShareDataEncoded = deepLink.queryParameters['parameters'];
//       if (SongsShareDataEncoded != null) {
//         final Map<String, dynamic> SongsShareDataMap =
//             json.decode(Uri.decodeComponent(SongsShareDataEncoded));
//         final SongsShareData SongsShareData = SongsShareData.fromJson(SongsShareDataMap);

//         // Handle the custom data
//         Navigator.pushNamed(context, deepLink.path, arguments: SongsShareData);
//       }
//     }
//   }

//   Future<void> _createDynamicLink(bool short) async {
//     setState(() {
//       _isCreatingLink = true;
//     });

//     final SongsShareData SongsShareData = SongsShareData(id: '324', name: 'Sample Data1');
//     final Map<String, dynamic> SongsShareDataMap = SongsShareData.toJson();
//     final String SongsShareDataEncoded =
//         Uri.encodeComponent(json.encode(SongsShareDataMap));

//     final DynamicLinkParameters parameters = DynamicLinkParameters(
//       uriPrefix: 'https://alamoody.page.link',
//       link: Uri.parse(DynamicLink)
//           .replace(queryParameters: {'parameters': SongsShareDataEncoded}),
//       androidParameters: const AndroidParameters(
//         packageName: 'com.alamoody.app',
//         minimumVersion: 0,
//       ),
//     );

//     Uri url;
//     if (short) {
//       final ShortDynamicLink shortLink =
//           await dynamicLinks.buildShortLink(parameters);
//       url = shortLink.shortUrl;
//     } else {
//       url = await dynamicLinks.buildLink(parameters);
//     }

//     setState(() {
//       _linkMessage = url.toString();
//       _isCreatingLink = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('Dynamic Links Example'),
//         ),
//         body: Builder(
//           builder: (BuildContext context) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   ButtonBar(
//                     alignment: MainAxisAlignment.center,
//                     children: <Widget>[
//                       ElevatedButton(
//                         onPressed: () async {
//                           final PendingDynamicLinkData? data =
//                               await dynamicLinks.getInitialLink();
//                           final Uri? deepLink = data?.link;
//                           if (deepLink != null) {
//                             log(deepLink.toString());
//                             Navigator.pushNamed(context, deepLink.path);
//                           }
//                         },
//                         child: const Text('getInitialLink'),
//                       ),
//                       ElevatedButton(
//                         onPressed: () async {
//                           final PendingDynamicLinkData? data =
//                               await dynamicLinks
//                                   .getDynamicLink(Uri.parse(Link));
//                           final Uri? deepLink = data?.link;

//                           if (deepLink != null) {
//                             Navigator.pushNamed(context, deepLink.path);
//                           }
//                         },
//                         child: const Text('getDynamicLink'),
//                       ),
//                       ElevatedButton(
//                         onPressed: !_isCreatingLink
//                             ? () => _createDynamicLink(false)
//                             : null,
//                         child: const Text('Get Long Link'),
//                       ),
//                       ElevatedButton(
//                         onPressed: !_isCreatingLink
//                             ? () => _createDynamicLink(true)
//                             : null,
//                         child: const Text('Get Short Link'),
//                       ),
//                     ],
//                   ),
//                   InkWell(
//                     onTap: () async {
//                       if (_linkMessage != null) {
//                         await launchUrl(Uri.parse(_linkMessage!));
//                       }
//                     },
//                     onLongPress: () {
//                       if (_linkMessage != null) {
//                         Clipboard.setData(ClipboardData(text: _linkMessage!));
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(content: Text('Copied Link!')),
//                         );
//                       }
//                     },
//                     child: Text(
//                       _linkMessage ?? '',
//                       style: const TextStyle(color: Colors.blue),
//                     ),
//                   ),
//                   Text(_linkMessage == null ? '' : _testString),
//                 ],
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

// class _DynamicLinkScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final SongsShareData SongsShareData =
//         ModalRoute.of(context)!.settings.arguments as SongsShareData;

//     return Material(
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('Hello World DeepLink'),
//         ),
//         body: Center(
//           child: Text('Custom Data: ${SongsShareData.name} (ID: ${SongsShareData.id})'),
//         ),
//       ),
//     );
//   }
// }

// // import 'dart:async';
// // import 'dart:convert'; // Add this import for JSON encoding/decoding

// // import 'package:firebase_core/firebase_core.dart';
// // import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter/services.dart';
// // import 'package:url_launcher/url_launcher.dart';

// // Future<void> main() async {
// //   WidgetsFlutterBinding.ensureInitialized();
// //   await Firebase.initializeApp();
// //   runApp(
// //     MaterialApp(
// //       title: 'Dynamic Links Example',
// //       routes: <String, WidgetBuilder>{
// //         '/': (BuildContext context) => _MainScreen(),
// //         '/helloworld': (BuildContext context) => _DynamicLinkScreen(),
// //       },
// //     ),
// //   );
// // }
// // class _MainScreen extends StatefulWidget {
// //   @override
// //   State<StatefulWidget> createState() => _MainScreenState();
// // }

// // class _MainScreenState extends State<_MainScreen> {
// //   String? _linkMessage;
// //   bool _isCreatingLink = false;

// //   FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
// //   final String _testString =
// //       'To test: long press link and then copy and click from a non-browser '
// //       "app. Make sure this isn't being tested on iOS simulator and iOS xcode "
// //       'is properly setup. Look at firebase_dynamic_links/README.md for more '
// //       'details.';

// //   final String DynamicLink = 'https://example/helloworld';
// //   final String Link = 'https://alamoody.page.link/MEGs';

// //   @override
// //   void initState() {
// //     super.initState();
// //     initDynamicLinks();
// //   }

// //   Future<void> initDynamicLinks() async {
// //     dynamicLinks.onLink.listen((dynamicLinkData) {
// //       final Uri deepLink = dynamicLinkData.link;
// //       final Map<String, dynamic> data = _parseSongsShareData(deepLink);
// //       // Use the custom data
// //       if ('screen'] == 'helloworld') {
// //         Navigator.pushNamed(context, '/helloworld', arguments: data);
// //       }
// //     }).onError((error) {
// //       print('onLink error');
// //       print(error.message);
// //     });
// //   }

// //   Map<String, dynamic> _parseSongsShareData(Uri uri) {
// //     final Map<String, String> queryParams = uri.queryParameters;
// //     final String? SongsShareDataString = queryParams['SongsShareData'];
// //     if (SongsShareDataString != null) {
// //       return jsonDecode(SongsShareDataString);
// //     }
// //     return {};
// //   }

// //   Future<void> _createDynamicLink(bool short) async {
// //     setState(() {
// //       _isCreatingLink = true;
// //     });

// //     // Create custom data
// //     final Map<String, dynamic> SongsShareData = {
// //       'screen': 'helloworld',
// //       'param1': 'value1',
// //       'param2': 'value2',
// //     };

// //     final Uri dynamicLinkUri = Uri(
// //       scheme: 'https',
// //       host: 'example.com',
// //       path: '/helloworld',
// //       queryParameters: {
// //         'SongsShareData': jsonEncode(SongsShareData),
// //       },
// //     );

// //     final DynamicLinkParameters parameters = DynamicLinkParameters(
// //       uriPrefix: 'https://alamoody.page.link',
// //       link: dynamicLinkUri,
// //       androidParameters: const AndroidParameters(
// //         packageName: 'com.alamoody.app',
// //         minimumVersion: 0,
// //       ),
// //       iosParameters: const IOSParameters(
// //         bundleId: 'com.alamoody.app',
// //         minimumVersion: '0',
// //       ),
// //     );

// //     Uri url;
// //     if (short) {
// //       final ShortDynamicLink shortLink =
// //           await dynamicLinks.buildShortLink(parameters);
// //       url = shortLink.shortUrl;
// //     } else {
// //       url = await dynamicLinks.buildLink(parameters);
// //     }

// //     setState(() {
// //       _linkMessage = url.toString();
// //       _isCreatingLink = false;
// //     });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Material(
// //       child: Scaffold(
// //         appBar: AppBar(
// //           title: const Text('Dynamic Links Example'),
// //         ),
// //         body: Builder(
// //           builder: (BuildContext context) {
// //             return Center(
// //               child: Column(
// //                 mainAxisAlignment: MainAxisAlignment.center,
// //                 children: <Widget>[
// //                   ButtonBar(
// //                     alignment: MainAxisAlignment.center,
// //                     children: <Widget>[
// //                       ElevatedButton(
// //                         onPressed: () async {
// //                           final PendingDynamicLinkData? data =
// //                               await dynamicLinks.getInitialLink();
// //                           final Uri? deepLink = data?.link;

// //                           if (deepLink != null) {
// //                             final Map<String, dynamic> SongsShareData = _parseSongsShareData(deepLink);
// //                             // ignore: unawaited_futures
// //                             Navigator.pushNamed(context, deepLink.path, arguments: SongsShareData);
// //                           }
// //                         },
// //                         child: const Text('getInitialLink'),
// //                       ),
// //                       ElevatedButton(
// //                         onPressed: () async {
// //                           final PendingDynamicLinkData? data =
// //                               await dynamicLinks
// //                                   .getDynamicLink(Uri.parse(Link));
// //                           final Uri? deepLink = data?.link;

// //                           if (deepLink != null) {
// //                             final Map<String, dynamic> SongsShareData = _parseSongsShareData(deepLink);
// //                             // ignore: unawaited_futures
// //                             Navigator.pushNamed(context, deepLink.path, arguments: SongsShareData);
// //                           }
// //                         },
// //                         child: const Text('getDynamicLink'),
// //                       ),
// //                       ElevatedButton(
// //                         onPressed: !_isCreatingLink
// //                             ? () => _createDynamicLink(false)
// //                             : null,
// //                         child: const Text('Get Long Link'),
// //                       ),
// //                       ElevatedButton(
// //                         onPressed: !_isCreatingLink
// //                             ? () => _createDynamicLink(true)
// //                             : null,
// //                         child: const Text('Get Short Link'),
// //                       ),
// //                     ],
// //                   ),
// //                   InkWell(
// //                     onTap: () async {
// //                       if (_linkMessage != null) {
// //                         await launchUrl(Uri.parse(_linkMessage!));
// //                       }
// //                     },
// //                     onLongPress: () {
// //                       if (_linkMessage != null) {
// //                         Clipboard.setData(ClipboardData(text: _linkMessage!));
// //                         ScaffoldMessenger.of(context).showSnackBar(
// //                           const SnackBar(content: Text('Copied Link!')),
// //                         );
// //                       }
// //                     },
// //                     child: Text(
// //                       _linkMessage ?? '',
// //                       style: const TextStyle(color: Colors.blue),
// //                     ),
// //                   ),
// //                   Text(_linkMessage == null ? '' : _testString),
// //                 ],
// //               ),
// //             );
// //           },
// //         ),
// //       ),
// //     );
// //   }
// // }

// // class _DynamicLinkScreen extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     final Map<String, dynamic>? SongsShareData = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
// //     return Material(
// //       child: Scaffold(
// //         appBar: AppBar(
// //           title: const Text('Hello World DeepLink'),
// //         ),
// //         body: Center(
// //           child: Text('Hello, World!\nCustom Data: ${SongsShareData!.entries}'),
// //         ),
// //       ),
// //     );
// //   }
// // }

