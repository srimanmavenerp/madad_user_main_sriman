// // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // import 'package:get/get.dart';
// // import 'utils/core_export.dart';
// // import 'helper/get_di.dart' as di;

// // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

// // Future<void> main() async {
// //   WidgetsFlutterBinding.ensureInitialized();
// //   if(ResponsiveHelper.isMobilePhone()) {
// //     HttpOverrides.global = MyHttpOverrides();
// //     await FlutterDownloader.initialize(
// //     );
// //   }
// //   setPathUrlStrategy();
// //   if(GetPlatform.isWeb){
// //     await Firebase.initializeApp(
// //         options: const FirebaseOptions(
// //   apiKey: "AIzaSyDTURUJzMAYiyDO60jCBz5zb70jytshH2c",
// //   authDomain: "madad-4b373.firebaseapp.com",
// //   databaseURL: "https://madad-4b373-default-rtdb.firebaseio.com",
// //   projectId: "madad-4b373",
// //   storageBucket: "madad-4b373.firebasestorage.app",
// //   messagingSenderId: "199624523333",
// //   appId: "1:199624523333:web:6067c3b8b68937ff1fad2c",
// //   measurementId: "G-HB6LSNT8PJ"

// //         )
// //     );
// //     await FacebookAuth.instance.webAndDesktopInitialize(
// //       appId: "637072917840079",
// //       cookie: true,
// //       xfbml: true,
// //       version: "v15.0",
// //     );
// //   }else{
// //     await Firebase.initializeApp();
// //   }

// //   if(defaultTargetPlatform == TargetPlatform.android) {
// //     await FirebaseMessaging.instance.requestPermission();
// //   }

// //   // Request notification permission on iOS and Android
// //   NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
// //     alert: true,
// //     badge: true,
// //     sound: true,
// //   );

// //   if (kDebugMode) {
// //     print('iOS/Android push permission: ${settings.authorizationStatus}');
// //   }

// //   Map<String, Map<String, String>> languages = await di.init();
// //   NotificationBody? body;
// //   String? path;
// //   try {
// //     if (!kIsWeb) {
// //       path =  await initDynamicLinks();
// //     }

// //     final RemoteMessage? remoteMessage = await FirebaseMessaging.instance.getInitialMessage();
// //     if (remoteMessage != null) {
// //       body = NotificationHelper.convertNotification(remoteMessage.data);
// //     }
// //     await NotificationHelper.initialize(flutterLocalNotificationsPlugin);
// //     FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
// //   }catch(e) {
// //     if (kDebugMode) {
// //       print("");
// //     }
// //   }
// //   runApp(ProviderScope(child: MyApp(languages: languages, body: body, route: path,)));
// // }

// // class MyApp extends StatefulWidget {
// //   final Map<String, Map<String, String>>? languages;
// //   final NotificationBody? body;
// //   final String? route;
// //   const MyApp({super.key, @required this.languages, @required this.body, this.route});

// //   @override
// //   State<MyApp> createState() => _MyAppState();

// // }

// // Future<String?> initDynamicLinks() async {
// //   final appLinks = AppLinks();
// //   final uri = await appLinks.getInitialLink();
// //   String? path;
// //   if (uri != null) {
// //     path = uri.path;
// //   }else{
// //     path = null;
// //   }
// //   return path;

// // }

// // class _MyAppState extends State<MyApp> {
// //   void _route() async {

// //     Get.find<SplashController>().getConfigData().then((success) async {

// //       if(Get.find<LocationController>().getUserAddress() != null){
// //         AddressModel addressModel = Get.find<LocationController>().getUserAddress()!;
// //         ZoneResponseModel responseModel = await Get.find<LocationController>().getZone(addressModel.latitude.toString(), addressModel.longitude.toString(), false);
// //         addressModel.availableServiceCountInZone = responseModel.totalServiceCount;
// //         Get.find<LocationController>().saveUserAddress(addressModel);
// //       }
// //       if (Get.find<AuthController>().isLoggedIn()) {
// //         Get.find<AuthController>().updateToken();
// //       }

// //     });

// //   }
// //   @override
// //   void initState() {
// //     super.initState();

// //     if(kIsWeb || widget.route != null)  {
// //       Get.find<SplashController>().initSharedData();
// //       Get.find<SplashController>().getCookiesData();
// //       Get.find<CartController>().getCartListFromServer();

// //       if (Get.find<AuthController>().isLoggedIn()) {
// //         Get.find<UserController>().getUserInfo();
// //       }

// //       if( Get.find<SplashController>().getGuestId().isEmpty){
// //         var uuid = const Uuid().v1();
// //         Get.find<SplashController>().setGuestId(uuid);
// //       }
// //       _route();
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {

// //     return GetBuilder<ThemeController>(builder: (themeController) {
// //       return GetBuilder<LocalizationController>(builder: (localizeController) {
// //         return GetBuilder<SplashController>(builder: (splashController) {
// //           if ((GetPlatform.isWeb && splashController.configModel.content == null)) {
// //             return const SizedBox();
// //           } else {return GetMaterialApp(
// //             title: AppConstants.appName,
// //             debugShowCheckedModeBanner: false,
// //             navigatorKey: Get.key,
// //             scrollBehavior: const MaterialScrollBehavior().copyWith(
// //               dragDevices: {PointerDeviceKind.mouse, PointerDeviceKind.touch},
// //             ),
// //             theme: themeController.darkTheme ? dark : light,
// //             locale: localizeController.locale,
// //             translations: Messages(languages: widget.languages),
// //             fallbackLocale: Locale(AppConstants.languages[0].languageCode!, AppConstants.languages[0].countryCode),
// //             initialRoute: GetPlatform.isWeb ? RouteHelper.getInitialRoute() : RouteHelper.getSplashRoute(widget.body, widget.route),
// //             getPages: RouteHelper.routes,
// //             defaultTransition: Transition.fadeIn,
// //             transitionDuration: const Duration(milliseconds: 500),
// //             builder: (context, widget) => MediaQuery(
// //               data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1)),
// //               child: Material(
// //                 child: SafeArea(
// //                   top: false,
// //                   bottom: GetPlatform.isAndroid,
// //                   child: Stack(children: [
// //                     widget!,

// //                     GetBuilder<SplashController>(builder: (splashController){
// //                       if(!splashController.savedCookiesData || !splashController.getAcceptCookiesStatus(splashController.configModel.content?.cookiesText??"")){
// //                         return ResponsiveHelper.isWeb() ? const Align(alignment: Alignment.bottomCenter,child: CookiesView()) :const SizedBox();
// //                       }else{
// //                         return const SizedBox();
// //                       }
// //                     })
// //                   ],),
// //                 ),
// //               ),
// //             ),
// //           );
// //           }
// //         });
// //       });
// //     });
// //   }
// // }
// // class MyHttpOverrides extends HttpOverrides {
// //   @override
// //   HttpClient createHttpClient(SecurityContext? context) {
// //     return super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
// //   }
// // }

// import 'dart:io';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:get/get.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'utils/core_export.dart';
// import 'helper/get_di.dart' as di;

// // Background message handler
// Future<void> myBackgroundMessageHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   // handle background notification here
//   print("Handling a background message: ${message.messageId}");
// }

// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   if (ResponsiveHelper.isMobilePhone()) {
//     HttpOverrides.global = MyHttpOverrides();
//     await FlutterDownloader.initialize();
//   }

//   setPathUrlStrategy();

//   // Initialize Firebase
//   if (kIsWeb) {
//     await Firebase.initializeApp(
//       options: const FirebaseOptions(
//         apiKey: "AIzaSyDTURUJzMAYiyDO60jCBz5zb70jytshH2c",
//         authDomain: "madad-4b373.firebaseapp.com",
//         databaseURL: "https://madad-4b373-default-rtdb.firebaseio.com",
//         projectId: "madad-4b373",
//         storageBucket: "madad-4b373.firebasestorage.app",
//         messagingSenderId: "199624523333",
//         appId: "1:199624523333:web:6067c3b8b68937ff1fad2c",
//         measurementId: "G-HB6LSNT8PJ",
//       ),
//     );
//     await FacebookAuth.instance.webAndDesktopInitialize(
//       appId: "637072917840079",
//       cookie: true,
//       xfbml: true,
//       version: "v15.0",
//     );
//   } else {
//     await Firebase.initializeApp();
//   }

//   // Request permission for notifications
//   NotificationSettings settings =
//       await FirebaseMessaging.instance.requestPermission(
//     alert: true,
//     badge: true,
//     sound: true,
//   );
//   if (kDebugMode) {
//     print('Push notification permission: ${settings.authorizationStatus}');
//   }

//   // Initialize local notifications
//   const InitializationSettings initializationSettings = InitializationSettings(
//     android: AndroidInitializationSettings('@mipmap/ic_launcher'),
//     iOS: DarwinInitializationSettings(
//       requestAlertPermission: true,
//       requestBadgePermission: true,
//       requestSoundPermission: true,
//     ),
//   );

//   await flutterLocalNotificationsPlugin.initialize(
//     initializationSettings,
//     onDidReceiveNotificationResponse: (NotificationResponse response) {
//       // handle notification tapped logic
//       print('Notification tapped: ${response.payload}');
//     },
//   );

//   // Handle background messages
//   FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);

//   // Handle initial message if app launched from notification
//   NotificationBody? body;
//   String? path;
//   try {
//     if (!kIsWeb) {
//       path = await initDynamicLinks();
//     }
//     final RemoteMessage? remoteMessage =
//         await FirebaseMessaging.instance.getInitialMessage();
//     if (remoteMessage != null) {
//       body = NotificationHelper.convertNotification(remoteMessage.data);
//     }
//   } catch (e) {
//     if (kDebugMode) print(e);
//   }

//   Map<String, Map<String, String>> languages = await di.init();

//   runApp(ProviderScope(
//       child: MyApp(languages: languages, body: body, route: path)));
// }

// Future<String?> initDynamicLinks() async {
//   final appLinks = AppLinks();
//   final uri = await appLinks.getInitialLink();
//   return uri?.path;
// }

// class MyApp extends StatefulWidget {
//   final Map<String, Map<String, String>>? languages;
//   final NotificationBody? body;
//   final String? route;
//   const MyApp({super.key, this.languages, this.body, this.route});

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   void _route() async {
//     Get.find<SplashController>().getConfigData().then((success) async {
//       if (Get.find<LocationController>().getUserAddress() != null) {
//         AddressModel addressModel =
//             Get.find<LocationController>().getUserAddress()!;
//         ZoneResponseModel responseModel = await Get.find<LocationController>()
//             .getZone(addressModel.latitude.toString(),
//                 addressModel.longitude.toString(), false);
//         addressModel.availableServiceCountInZone =
//             responseModel.totalServiceCount;
//         Get.find<LocationController>().saveUserAddress(addressModel);
//       }
//       if (Get.find<AuthController>().isLoggedIn()) {
//         Get.find<AuthController>().updateToken();
//       }
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     if (kIsWeb || widget.route != null) {
//       Get.find<SplashController>().initSharedData();
//       Get.find<SplashController>().getCookiesData();
//       Get.find<CartController>().getCartListFromServer();

//       if (Get.find<AuthController>().isLoggedIn()) {
//         Get.find<UserController>().getUserInfo();
//       }

//       if (Get.find<SplashController>().getGuestId().isEmpty) {
//         var uuid = const Uuid().v1();
//         Get.find<SplashController>().setGuestId(uuid);
//       }
//       _route();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<ThemeController>(builder: (themeController) {
//       return GetBuilder<LocalizationController>(builder: (localizeController) {
//         return GetBuilder<SplashController>(builder: (splashController) {
//           if (kIsWeb && splashController.configModel.content == null) {
//             return const SizedBox();
//           } else {
//             return GetMaterialApp(
//               title: AppConstants.appName,
//               debugShowCheckedModeBanner: false,
//               navigatorKey: Get.key,
//               scrollBehavior: const MaterialScrollBehavior().copyWith(
//                 dragDevices: {PointerDeviceKind.mouse, PointerDeviceKind.touch},
//               ),
//               theme: themeController.darkTheme ? dark : light,
//               locale: localizeController.locale,
//               translations: Messages(languages: widget.languages),
//               fallbackLocale: Locale(AppConstants.languages[0].languageCode!,
//                   AppConstants.languages[0].countryCode),
//               initialRoute: kIsWeb
//                   ? RouteHelper.getInitialRoute()
//                   : RouteHelper.getSplashRoute(widget.body, widget.route),
//               getPages: RouteHelper.routes,
//               defaultTransition: Transition.fadeIn,
//               transitionDuration: const Duration(milliseconds: 500),
//               builder: (context, widget) => MediaQuery(
//                 data: MediaQuery.of(context)
//                     .copyWith(textScaler: const TextScaler.linear(1)),
//                 child: Material(
//                   child: SafeArea(
//                     top: false,
//                     bottom: GetPlatform.isAndroid,
//                     child: Stack(
//                       children: [
//                         widget!,
//                         GetBuilder<SplashController>(
//                             builder: (splashController) {
//                           if (!splashController.savedCookiesData ||
//                               !splashController.getAcceptCookiesStatus(
//                                   splashController
//                                           .configModel.content?.cookiesText ??
//                                       "")) {
//                             return ResponsiveHelper.isWeb()
//                                 ? const Align(
//                                     alignment: Alignment.bottomCenter,
//                                     child: CookiesView(),
//                                   )
//                                 : const SizedBox();
//                           } else {
//                             return const SizedBox();
//                           }
//                         }),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           }
//         });
//       });
//     });
//   }
// }

// class MyHttpOverrides extends HttpOverrides {
//   @override
//   HttpClient createHttpClient(SecurityContext? context) {
//     return super.createHttpClient(context)
//       ..badCertificateCallback =
//           (X509Certificate cert, String host, int port) => true;
//   }
// }
// // import 'dart:io';
// // import 'package:flutter/foundation.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // import 'package:get/get.dart';
// // import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// // import 'package:firebase_core/firebase_core.dart';
// // import 'package:firebase_messaging/firebase_messaging.dart';
// // import 'utils/core_export.dart';
// // import 'helper/get_di.dart' as di;

// // // Background message handler
// // Future<void> myBackgroundMessageHandler(RemoteMessage message) async {
// //   await Firebase.initializeApp();
// //   print("Handling a background message: ${message.messageId}");
// // }

// // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
// //     FlutterLocalNotificationsPlugin();

// // Future<void> main() async {
// //   WidgetsFlutterBinding.ensureInitialized();

// //   if (ResponsiveHelper.isMobilePhone()) {
// //     HttpOverrides.global = MyHttpOverrides();
// //     await FlutterDownloader.initialize();
// //   }

// //   setPathUrlStrategy();

// //   // Initialize Firebase
// //   if (kIsWeb) {
// //     await Firebase.initializeApp(
// //       options: const FirebaseOptions(
// //         apiKey: "AIzaSyDTURUJzMAYiyDO60jCBz5zb70jytshH2c",
// //         authDomain: "madad-4b373.firebaseapp.com",
// //         databaseURL: "https://madad-4b373-default-rtdb.firebaseio.com",
// //         projectId: "madad-4b373",
// //         storageBucket: "madad-4b373.firebasestorage.app",
// //         messagingSenderId: "199624523333",
// //         appId: "1:199624523333:web:6067c3b8b68937ff1fad2c",
// //         measurementId: "G-HB6LSNT8PJ",
// //       ),
// //     );
// //     await FacebookAuth.instance.webAndDesktopInitialize(
// //       appId: "637072917840079",
// //       cookie: true,
// //       xfbml: true,
// //       version: "v15.0",
// //     );
// //   } else {
// //     await Firebase.initializeApp();
// //   }

// //   // Request permission for notifications
// //   NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
// //     alert: true,
// //     badge: true,
// //     sound: true,
// //   );
// //   if (kDebugMode) {
// //     print('Push notification permission: ${settings.authorizationStatus}');
// //   }

// //   // Initialize local notifications
// //   const InitializationSettings initializationSettings = InitializationSettings(
// //     android: AndroidInitializationSettings('@mipmap/ic_launcher'),
// //     iOS: DarwinInitializationSettings(
// //       requestAlertPermission: true,
// //       requestBadgePermission: true,
// //       requestSoundPermission: true,
// //     ),
// //   );

// //   await flutterLocalNotificationsPlugin.initialize(
// //     initializationSettings,
// //     onDidReceiveNotificationResponse: (NotificationResponse response) {
// //       print('Notification tapped: ${response.payload}');
// //     },
// //   );

// //   // Handle background messages
// //   FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);

// //   // Foreground message handling for iOS and Android
// //   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
// //     RemoteNotification? notification = message.notification;
// //     AndroidNotification? android = message.notification?.android;

// //     if (notification != null) {
// //       flutterLocalNotificationsPlugin.show(
// //         notification.hashCode,
// //         notification.title,
// //         notification.body,
// //         NotificationDetails(
// //           android: android != null
// //               ? AndroidNotificationDetails(
// //                   'channel_id', 'channel_name',
// //                   importance: Importance.max,
// //                   priority: Priority.high,
// //                   icon: '@mipmap/ic_launcher',
// //                 )
// //               : null,
// //           iOS: const DarwinNotificationDetails(),
// //         ),
// //         payload: message.data.toString(),
// //       );
// //     }
// //   });

// //   // Handle initial message if app launched from notification
// //   NotificationBody? body;
// //   String? path;
// //   try {
// //     if (!kIsWeb) {
// //       path = await initDynamicLinks();
// //     }
// //     final RemoteMessage? remoteMessage =
// //         await FirebaseMessaging.instance.getInitialMessage();
// //     if (remoteMessage != null) {
// //       body = NotificationHelper.convertNotification(remoteMessage.data);
// //     }
// //   } catch (e) {
// //     if (kDebugMode) print(e);
// //   }

// //   Map<String, Map<String, String>> languages = await di.init();

// //   runApp(ProviderScope(child: MyApp(languages: languages, body: body, route: path)));
// // }

// // Future<String?> initDynamicLinks() async {
// //   final appLinks = AppLinks();
// //   final uri = await appLinks.getInitialLink();
// //   return uri?.path;
// // }

// // class MyApp extends StatefulWidget {
// //   final Map<String, Map<String, String>>? languages;
// //   final NotificationBody? body;
// //   final String? route;
// //   const MyApp({super.key, this.languages, this.body, this.route});

// //   @override
// //   State<MyApp> createState() => _MyAppState();
// // }

// // class _MyAppState extends State<MyApp> {
// //   void _route() async {
// //     Get.find<SplashController>().getConfigData().then((success) async {
// //       if (Get.find<LocationController>().getUserAddress() != null) {
// //         AddressModel addressModel = Get.find<LocationController>().getUserAddress()!;
// //         ZoneResponseModel responseModel = await Get.find<LocationController>()
// //             .getZone(addressModel.latitude.toString(),
// //                      addressModel.longitude.toString(),
// //                      false);
// //         addressModel.availableServiceCountInZone = responseModel.totalServiceCount;
// //         Get.find<LocationController>().saveUserAddress(addressModel);
// //       }
// //       if (Get.find<AuthController>().isLoggedIn()) {
// //         Get.find<AuthController>().updateToken();
// //       }
// //     });
// //   }

// //   @override
// //   void initState() {
// //     super.initState();
// //     if (kIsWeb || widget.route != null) {
// //       Get.find<SplashController>().initSharedData();
// //       Get.find<SplashController>().getCookiesData();
// //       Get.find<CartController>().getCartListFromServer();

// //       if (Get.find<AuthController>().isLoggedIn()) {
// //         Get.find<UserController>().getUserInfo();
// //       }

// //       if (Get.find<SplashController>().getGuestId().isEmpty) {
// //         var uuid = const Uuid().v1();
// //         Get.find<SplashController>().setGuestId(uuid);
// //       }
// //       _route();
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return GetBuilder<ThemeController>(builder: (themeController) {
// //       return GetBuilder<LocalizationController>(builder: (localizeController) {
// //         return GetBuilder<SplashController>(builder: (splashController) {
// //           if (kIsWeb && splashController.configModel.content == null) {
// //             return const SizedBox();
// //           } else {
// //             return GetMaterialApp(
// //               title: AppConstants.appName,
// //               debugShowCheckedModeBanner: false,
// //               navigatorKey: Get.key,
// //               scrollBehavior: const MaterialScrollBehavior().copyWith(
// //                 dragDevices: {PointerDeviceKind.mouse, PointerDeviceKind.touch},
// //               ),
// //               theme: themeController.darkTheme ? dark : light,
// //               locale: localizeController.locale,
// //               translations: Messages(languages: widget.languages),
// //               fallbackLocale: Locale(AppConstants.languages[0].languageCode!,
// //                   AppConstants.languages[0].countryCode),
// //               initialRoute: kIsWeb
// //                   ? RouteHelper.getInitialRoute()
// //                   : RouteHelper.getSplashRoute(widget.body, widget.route),
// //               getPages: RouteHelper.routes,
// //               defaultTransition: Transition.fadeIn,
// //               transitionDuration: const Duration(milliseconds: 500),
// //               builder: (context, widget) => MediaQuery(
// //                 data:
// //                     MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1)),
// //                 child: Material(
// //                   child: SafeArea(
// //                     top: false,
// //                     bottom: GetPlatform.isAndroid,
// //                     child: Stack(
// //                       children: [
// //                         widget!,
// //                         GetBuilder<SplashController>(builder: (splashController) {
// //                           if (!splashController.savedCookiesData ||
// //                               !splashController.getAcceptCookiesStatus(
// //                                   splashController.configModel.content?.cookiesText ?? "")) {
// //                             return ResponsiveHelper.isWeb()
// //                                 ? const Align(
// //                                     alignment: Alignment.bottomCenter,
// //                                     child: CookiesView(),
// //                                   )
// //                                 : const SizedBox();
// //                           } else {
// //                             return const SizedBox();
// //                           }
// //                         }),
// //                       ],
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //             );
// //           }
// //         });
// //       });
// //     });
// //   }
// // }

// // class MyHttpOverrides extends HttpOverrides {
// //   @override
// //   HttpClient createHttpClient(SecurityContext? context) {
// //     return super.createHttpClient(context)
// //       ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
// //   }
// // }
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'utils/core_export.dart';
import 'helper/get_di.dart' as di;

// ---------------------- BACKGROUND MESSAGE HANDLER ----------------------
Future<void> myBackgroundMessageHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

// ---------------------- FLUTTER LOCAL NOTIFICATIONS ----------------------
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// ---------------------- MAIN FUNCTION ----------------------
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (ResponsiveHelper.isMobilePhone()) {
    HttpOverrides.global = MyHttpOverrides();
    await FlutterDownloader.initialize();
  }

  setPathUrlStrategy();

  // Firebase initialization
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyDTURUJzMAYiyDO60jCBz5zb70jytshH2c",
        authDomain: "madad-4b373.firebaseapp.com",
        databaseURL: "https://madad-4b373-default-rtdb.firebaseio.com",
        projectId: "madad-4b373",
        storageBucket: "madad-4b373.firebasestorage.app",
        messagingSenderId: "199624523333",
        appId: "1:199624523333:web:6067c3b8b68937ff1fad2c",
        measurementId: "G-HB6LSNT8PJ",
      ),
    );
    await FacebookAuth.instance.webAndDesktopInitialize(
      appId: "637072917840079",
      cookie: true,
      xfbml: true,
      version: "v15.0",
    );
  } else {
    await Firebase.initializeApp();
  }

  // Request notification permissions
  NotificationSettings settings = await FirebaseMessaging.instance
      .requestPermission(alert: true, badge: true, sound: true);
  if (kDebugMode) {
    print('Push notification permission: ${settings.authorizationStatus}');
  }

  // ---------------------- ANDROID NOTIFICATION CHANNEL ----------------------
  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'madaduserWithoutsound',
      'Madad Notifications',
      importance: Importance.high,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
  }

  // ---------------------- INITIALIZE LOCAL NOTIFICATIONS ----------------------
  const InitializationSettings initializationSettings = InitializationSettings(
    android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    iOS: DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    ),
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      print('Notification tapped: ${response.payload}');
    },
  );

  // ---------------------- BACKGROUND HANDLER ----------------------
  FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);

  // ---------------------- FOREGROUND MESSAGE HANDLER ----------------------
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: android != null
              ? AndroidNotificationDetails(
                  'madaduserWithoutsound',
                  'Madad Notifications',
                  importance: Importance.max,
                  priority: Priority.high,
                  icon: '@mipmap/ic_launcher',
                )
              : null,
          iOS: const DarwinNotificationDetails(),
        ),
        payload: message.data.toString(),
      );
    }
  });

  // ---------------------- INITIAL MESSAGE ----------------------
  NotificationBody? body;
  String? path;
  try {
    if (!kIsWeb) {
      path = await initDynamicLinks();
    }
    final RemoteMessage? remoteMessage = await FirebaseMessaging.instance
        .getInitialMessage();
    if (remoteMessage != null) {
      body = NotificationHelper.convertNotification(remoteMessage.data);
    }
  } catch (e) {
    if (kDebugMode) print(e);
  }

  // ---------------------- GET FCM TOKEN ----------------------
  String? fcmToken = await FirebaseMessaging.instance.getToken();
  if (kDebugMode) print("FCM Token: $fcmToken");

  Map<String, Map<String, String>> languages = await di.init();
  runApp(
    ProviderScope(
      child: MyApp(languages: languages, body: body, route: path),
    ),
  );
}

// ---------------------- DYNAMIC LINKS ----------------------
Future<String?> initDynamicLinks() async {
  final appLinks = AppLinks();
  final uri = await appLinks.getInitialLink();
  return uri?.path;
}

// ---------------------- HTTP OVERRIDES ----------------------
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

// ---------------------- APP WIDGET ----------------------
class MyApp extends StatefulWidget {
  final Map<String, Map<String, String>>? languages;
  final NotificationBody? body;
  final String? route;
  const MyApp({super.key, this.languages, this.body, this.route});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void _route() async {
    Get.find<SplashController>().getConfigData().then((success) async {
      if (Get.find<LocationController>().getUserAddress() != null) {
        AddressModel addressModel = Get.find<LocationController>()
            .getUserAddress()!;
        ZoneResponseModel responseModel = await Get.find<LocationController>()
            .getZone(
              addressModel.latitude.toString(),
              addressModel.longitude.toString(),
              false,
            );
        addressModel.availableServiceCountInZone =
            responseModel.totalServiceCount;
        Get.find<LocationController>().saveUserAddress(addressModel);
      }
      if (Get.find<AuthController>().isLoggedIn()) {
        Get.find<AuthController>().updateToken();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    if (kIsWeb || widget.route != null) {
      Get.find<SplashController>().initSharedData();
      Get.find<SplashController>().getCookiesData();
      Get.find<CartController>().getCartListFromServer();

      if (Get.find<AuthController>().isLoggedIn()) {
        Get.find<UserController>().getUserInfo();
      }

      if (Get.find<SplashController>().getGuestId().isEmpty) {
        var uuid = const Uuid().v1();
        Get.find<SplashController>().setGuestId(uuid);
      }
      _route();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder: (themeController) {
        return GetBuilder<LocalizationController>(
          builder: (localizeController) {
            return GetBuilder<SplashController>(
              builder: (splashController) {
                if (kIsWeb && splashController.configModel.content == null) {
                  return const SizedBox();
                } else {
                  return GetMaterialApp(
                    title: AppConstants.appName,
                    debugShowCheckedModeBanner: false,
                    navigatorKey: Get.key,
                    theme: themeController.darkTheme ? dark : light,
                    locale: localizeController.locale,
                    translations: Messages(languages: widget.languages),
                    fallbackLocale: Locale(
                      AppConstants.languages[0].languageCode!,
                      AppConstants.languages[0].countryCode,
                    ),
                    initialRoute: kIsWeb
                        ? RouteHelper.getInitialRoute()
                        : RouteHelper.getSplashRoute(widget.body, widget.route),
                    getPages: RouteHelper.routes,
                  );
                }
              },
            );
          },
        );
      },
    );
  }
}
