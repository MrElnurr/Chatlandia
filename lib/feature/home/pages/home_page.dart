import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:chatapp/call_screen.dart';
import 'package:chatapp/feature/home/pages/call_home_page.dart';
import 'package:chatapp/feature/home/pages/chat_home_page.dart';
import 'package:chatapp/feature/welcome/widgets/random_emoji.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

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
                builder: (context) =>
                    CallPageNew(callID: callID, isVideo: true)),
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
  }

  @override
  Widget build(BuildContext context) {
    RandomEmojiGenerator random = RandomEmojiGenerator();
    var emoji = random.getRandomEmoji();
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Chatlandia $emoji',
            style: const TextStyle(letterSpacing: 1),
          ),
          elevation: 1,
          actions: const [
            // CustomIconButton(onTap: () {}, icon: Icons.search),
            // CustomIconButton(onTap: () {}, icon: Icons.more_vert),
          ],
          bottom: const TabBar(
              indicatorWeight: 3,
              labelStyle: TextStyle(
                fontWeight: FontWeight.bold,
              ),
              splashFactory: NoSplash.splashFactory,
              tabs: [Tab(text: "CHAT"), Tab(text: "CALLS (Dont working)")]),
        ),
        body: const TabBarView(
          children: [
            ChatHomePage(),
            CallHomePage(),
          ],
        ),
      ),
    );
  }
}
