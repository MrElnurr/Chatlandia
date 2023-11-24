import 'package:chatapp/feature/home/pages/call_home_page.dart';
import 'package:chatapp/feature/home/pages/chat_home_page.dart';
import 'package:chatapp/feature/welcome/widgets/random_emoji.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
