// ignore_for_file: avoid_print, iterable_contains_unrelated_type, unused_local_variable
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:freelancerApp/core/localization/local.dart';
import 'package:freelancerApp/features/Home/views/main_view.dart';
import 'package:freelancerApp/firebase_api.dart';
import 'package:freelancerApp/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/resources/check_theme.dart';
import 'features/Home/views/home_view.dart';

final navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseApi().initNotifications();
  await GetStorage.init();
  // configureFirebaseMessaging();
  CheckTheme();
  AwesomeNotifications().initialize(null, [
    NotificationChannel(
        channelKey: 'basic-channel',
        channelName: 'Basic notifications',
        channelDescription: 'notification chanel for testing')
  ]);
  final box = GetStorage();
  String keylocal = box.read('locale') ?? 'x';
  ///en //ar //' '
  Locale lang = const Locale('ar');

  if (keylocal != 'x') {
    lang = Locale(keylocal);
  } else {
    box.write('locale', 'ar');
  }
  // if (defaultTargetPlatform == TargetPlatform.android) {
  //   WebView.platform = SurfaceAndroidWebView();
  // }
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});
  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  List<Map<String, dynamic>> tokenList = [];
  String? token = '';

  addTokenToFireBase() async {
    await FirebaseFirestore.instance.collection('tokens').add({
      'token': token,
    }).then((value) {
      print("Done");
    });
  }

  @override
  void initState() {
    super.initState();
    final box = GetStorage();
    String tokenData = box.read('token') ?? 'x';
    print("TOKENxx===$tokenData");
  }

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    //en //ar
    String keylocal = box.read('locale') ?? '';

    ///en //ar //' '
    String email = box.read('email') ?? 'x';
    Locale lang = const Locale('ar');
    if (keylocal != '') {
      lang = Locale(keylocal);
    } else {
      lang = const Locale('ar');
    }
    if (email == 'x') {
      return GetMaterialApp(
        locale: lang,
        translations: MyLocal(),
        navigatorKey: navigatorKey,
        title: "",
        home: const MainHome(),
        theme: ThemeData(
            // تطبيق خط Cairo كنوع النص الافتراضي
            textTheme: GoogleFonts.cairoTextTheme(
          Theme.of(context).textTheme,
        )),
        debugShowCheckedModeBanner: false,
        defaultTransition: Transition.cupertino,
        navigatorObservers: [BotToastNavigatorObserver()],
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        builder: (context, widget) {
          Function botToast = BotToastInit();
          Widget mWidget = botToast(context, widget);
          return MediaQuery(
            //Setting font does not change with system font size
            data: MediaQuery.of(context)
                .copyWith(textScaler: const TextScaler.linear(1.0)),
            child: mWidget,
          );
        },
        // fallbackLocale: lang,
      );
    } else {
      return GetMaterialApp(
        locale: lang,
        navigatorKey: navigatorKey,
        // translations: MyLocal(),
        //locale:lang,
        translations: MyLocal(),
        title: " ",
        home: const MainHome(),
        // locale: lang,
        //  supportedLocales: supportedLocales,
        // initialRoute: Theme1AppPages.INITIAL,
        // getPages: Theme1AppPages.routes,
        debugShowCheckedModeBanner: false,
        defaultTransition: Transition.cupertino,
        navigatorObservers: [BotToastNavigatorObserver()],
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        builder: (context, widget) {
          Function botToast = BotToastInit();
          Widget mWidget = botToast(context, widget);
          return MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: const TextScaler.linear(1.0)),
            child: mWidget,
          );
        },
        // fallbackLocale: lang,
      );
    }
  }
}

// FirebaseMessaging messaging = FirebaseMessaging.instance;
// Future<void> configureFirebaseMessaging() async {
//   print("NOTIF");
//   FirebaseMessaging.instance
//       .getInitialMessage()
//       .then((RemoteMessage? message) async {
//     print("HEREnotifications......");
//     // Handle the initial message when the app is opened from a notification
//     if (message != null) {
//       print("HEREnotifications....1111..");
//       print("MSG 2");
//       print(message..notification!.title.toString());

//       print("Initial message: ${message.notification?.title}");
//       triggerNotification(message.notification!.title.toString());
//     }
//   });
//   FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
//     print("MSG 1");
//     print(message..notification!.title.toString());
//     triggerNotification(message.notification!.title.toString());
//     print("Foreground message: ${message.notification?.title}");
//   });

//   FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
//     print("Opened app message: ${message.notification?.title}");
//     print("Opened app message22222: ${message.notification?.titleLocArgs}");

//     List nameList = message.notification!.title.toString().split(',');

//     print(nameList[0]);
//     print(nameList[1]);

//     // triggerNotification(message.notification!.title!);
//   });

//   // ignore: no_leading_underscores_for_local_identifiers
//   Future<void> _firebaseMessagingBackgroundHandler(
//       RemoteMessage message) async {
//     //  List nameList=
//     message.notification!.title.toString();
//     triggerNotification(message.notification!.title.toString());
//     //_showDialog(message.notification!.title!);
//     // Handle the received message here
//     print("OPEN APP: ${message.notification?.title}");
//     triggerNotification(message.notification!.title.toString());
//   }

//   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
// }

// triggerNotification(String msg) {
//   print("........TRIGGERR.....");
//   print("msg..$msg");
//   return AwesomeNotifications().createNotification(
//       content: NotificationContent(
//           id: 1, channelKey: 'basic-channel', title: 'EASY', body: msg));
// }
