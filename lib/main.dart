import 'dart:convert';
import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:chatapp/call_screen.dart';
import 'package:chatapp/common/models/user_model.dart';
import 'package:chatapp/common/routes/routes.dart';
import 'package:chatapp/common/theme/dark_theme.dart';
import 'package:chatapp/common/theme/light_theme.dart';
import 'package:chatapp/common/utils/coloors.dart';
import 'package:chatapp/feature/auth/controller/auth_controller.dart';
import 'package:chatapp/feature/home/pages/home_page.dart';
import 'package:chatapp/feature/welcome/pages/welcome_page.dart';
import 'package:chatapp/feature/welcome/widgets/language_button.dart';
import 'package:chatapp/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:liquid_swipe/liquid_swipe.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      dynamic callID = message.data['id'];
      dynamic isVideo = message.data['isVideo'];
      debugPrint('---------------------isVideo---------------');
      debugPrint(isVideo);
      String? title = message.notification!.title;
      String? body = message.notification!.body;

      AwesomeNotifications().createNotification(
          content: NotificationContent(
              id: 123,
              channelKey: "chats",
              color: Colors.white,
              title: title,
              body: body,
              category: callID != ''
                  ? NotificationCategory.Call
                  : NotificationCategory.Message,
              wakeUpScreen: true,
              fullScreenIntent: true,
              autoDismissible: true,
              backgroundColor: Colors.orange),
          actionButtons: callID != ''
              ? [
                  NotificationActionButton(
                    key: "ACCEPT",
                    label: "Accept Call",
                    color: Colors.green,
                    autoDismissible: true,
                  ),
                  NotificationActionButton(
                    key: "REJECT",
                    label: "Reject Call",
                    color: Colors.red,
                    autoDismissible: true,
                  ),
                ]
              : null);

      AwesomeNotifications().actionStream.listen((event) {
        if (event.buttonKeyPressed == "REJECT") {
          debugPrint("$callID Call Rejected");
        } else if (event.buttonKeyPressed == "ACCEPT") {
          debugPrint("$callID Call Accepted");
          debugPrint("isVideo: $isVideo");
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (_) => CallPageNew(
                    callID: callID, isVideo: isVideo.toLowerCase() != "false")),
          );
        } else {
          debugPrint("Clicked on notification");
        }
      });

      if (message.notification != null) {
        debugPrint(
            'Message also contained a notification: ${message.notification}');
      }
    });
    return MaterialApp(
      theme: lightTheme(),
      darkTheme: darkTheme(),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: ref.watch(userInfoAuthProvider).when(
        data: (user) {
          FlutterNativeSplash.remove();
          if (user == null) {
            return LiquidSwipe(
              waveType: WaveType.liquidReveal,
              enableLoop: false,
              enableSideReveal: true,
              slideIconWidget: const Icon(
                Icons.arrow_back_ios_new,
                size: 25,
              ),
              pages: [
                Container(
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 25),
                        child: Image.asset(
                          'assets/images/main_icon.png',
                          width: 300,
                          height: 300,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 10, bottom: 50),
                        child: Text(
                          textAlign: TextAlign.center,
                          "Please select your language and swipe to next screen",
                          style: TextStyle(
                              color: Coloors.greenLight,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const LanguageButton(),
                    ],
                  ),
                ),
                const WelcomePage(),
              ],
            );
          }
          return const HomePage();
        },
        error: (error, trace) {
          return const Scaffold(
            body: Center(
              child: Text('Something went wrong!'),
            ),
          );
        },
        loading: () {
          return const SizedBox();
        },
      ),
      onGenerateRoute: Routes.onGenerateRoute,
    );
  }
}

_initializeFirebase() async {
  await AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
          channelKey: 'chats',
          channelName: 'chats',
          channelDescription: 'For Showing Message Notification',
          importance: NotificationImportance.Max,
          defaultColor: Colors.redAccent,
          ledColor: Colors.white,
          locked: false,
          defaultRingtoneType: DefaultRingtoneType.Ringtone),
    ],
  );

  FirebaseMessaging.onBackgroundMessage(BackgroundHandler);
}

// ignore: non_constant_identifier_names
Future<void> BackgroundHandler(RemoteMessage message) async {
  dynamic callID = message.data['id'];

  String? title = message.notification!.title;
  String? body = message.notification!.body;

  AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: 123,
          channelKey: "chats",
          color: Colors.white,
          title: title,
          body: body,
          category: callID == ''
              ? NotificationCategory.Message
              : NotificationCategory.Call,
          wakeUpScreen: true,
          fullScreenIntent: true,
          autoDismissible: true,
          backgroundColor: Colors.orange),
      actionButtons: [
        NotificationActionButton(
          key: "ACCEPT",
          label: "Accept Call",
          color: Colors.green,
          autoDismissible: true,
        ),
        NotificationActionButton(
          key: "REJECT",
          label: "Reject Call",
          color: Colors.red,
          autoDismissible: true,
        ),
      ]);

  AwesomeNotifications().actionStream.listen((event) {
    if (event.buttonKeyPressed == "REJECT") {
      debugPrint("$callID Call Rejected");
    } else if (event.buttonKeyPressed == "ACCEPT") {
      debugPrint("$callID Call Accepted");
    } else {
      debugPrint("Clicked on notification");
    }
  });
  if (message.notification != null) {
    debugPrint(
        'Message also contained a notification: ${message.notification}');
  }
}

// for sending push notification
Future<void> sendPushNotification(
    UserModel user, String msg, String callID, bool isVideo) async {
  debugPrint('usertoken: ${user.pushToken}');
  try {
    final body = {
      "to": user.pushToken,
      "notification": {
        "title": user.username,
        "body": msg,
        "android_channel_id": "chats"
      },
      "data": {
        "some_data": "User ID: ${user.uid}",
        "id": callID,
        "isVideo": isVideo
      },
    };

    var res = await post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader:
              'key=AAAAOUw_GnM:APA91bH9zUo3lhvTeTOPaGnF3mcdWNolnVGiYPJlBr7Pz8Uov6F2uWXldbz9r8MY5ExWe-oSUkUhkApKTtIw5u-8mcZx9_OeTAWz4-t5GPz29KwALbT-RHh0y2fjMrSGqibpXHYWyqu2'
        },
        body: jsonEncode(body));
    debugPrint('Response status: ${res.statusCode}');
    debugPrint('Response body: ${res.body}');
  } catch (e) {
    debugPrint('\nsendPushNotificationE: $e');
  }
}

String generateUniqueCallID() {
  return '${DateTime.now().millisecondsSinceEpoch}_call';
}
