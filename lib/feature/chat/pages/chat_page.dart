import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/call_screen.dart';
import 'package:chatapp/common/extension/custom_theme_extension.dart';
import 'package:chatapp/common/models/user_model.dart';
import 'package:chatapp/common/routes/routes.dart';
import 'package:chatapp/common/widgets/custom_icon_button.dart';
import 'package:chatapp/feature/chat/widgets/chat_text_field.dart';
import 'package:chatapp/feature/chat/controllers/chat_controller.dart';
import 'package:chatapp/feature/chat/widgets/message_card.dart';
import 'package:chatapp/feature/chat/widgets/show_date_card.dart';
import 'package:chatapp/main.dart';
import 'package:custom_clippers/custom_clippers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

final pageStorageBucket = PageStorageBucket();

class ChatPage extends ConsumerWidget {
  ChatPage({super.key, required this.user});

  final UserModel user;
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: context.theme.chatPageBgColor,
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          borderRadius: BorderRadius.circular(20),
          child: Row(
            children: [
              const Icon(Icons.arrow_back),
              Hero(
                tag: 'profile',
                child: Container(
                  width: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(user.profileImageUrl),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        title: InkWell(
          onTap: () {
            Navigator.pushNamed(
              context,
              Routes.profile,
              arguments: user,
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.username,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 3),
              ],
            ),
          ),
        ),
        actions: [
          CustomIconButton(
            onTap: () {
              var callID = generateUniqueCallID();
              sendPushNotification(user, '', callID, true);
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (_) => CallPageNew(callID: callID, isVideo: true)),
              );
            },
            icon: Icons.video_call,
            iconColor: Colors.white,
          ),
          CustomIconButton(
            onTap: () {
              FlutterPhoneDirectCaller.callNumber(user.phoneNumber);
            },
            icon: Icons.call,
            iconColor: Colors.white,
          ),
          // CustomIconButton(
          //   onTap: () {
          //   },
          //   icon: Icons.more_vert,
          //   iconColor: Colors.white,
          // ),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 60),
            child: StreamBuilder(
              stream: ref
                  .watch(chatControllerProvider)
                  .getAllOneToOneMessage(user.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.active) {
                  return ListView.builder(
                    itemCount: 15,
                    itemBuilder: (_, index) {
                      final random = Random().nextInt(14);
                      return Container(
                        alignment: random.isEven
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        margin: EdgeInsets.only(
                          top: 5,
                          bottom: 5,
                          left: random.isEven ? 150 : 15,
                          right: random.isEven ? 15 : 150,
                        ),
                        child: ClipPath(
                          clipper: UpperNipMessageClipperTwo(
                            random.isEven
                                ? MessageType.send
                                : MessageType.receive,
                            nipWidth: 8,
                            nipHeight: 10,
                            bubbleRadius: 12,
                          ),
                          child: Shimmer.fromColors(
                            baseColor: random.isEven
                                ? context.theme.greyColor!.withOpacity(.3)
                                : context.theme.greyColor!.withOpacity(.2),
                            highlightColor: random.isEven
                                ? context.theme.greyColor!.withOpacity(.4)
                                : context.theme.greyColor!.withOpacity(.3),
                            child: Container(
                              height: 40,
                              width: 170 +
                                  double.parse(
                                    (random * 2).toString(),
                                  ),
                              color: Colors.red,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }

                return PageStorage(
                  bucket: pageStorageBucket,
                  child: ListView.builder(
                    key: const PageStorageKey('chat_page_list'),
                    itemCount: snapshot.data!.length,
                    shrinkWrap: true,
                    controller: scrollController,
                    itemBuilder: (_, index) {
                      final message = snapshot.data![index];
                      final isSender = message.senderId ==
                          FirebaseAuth.instance.currentUser!.uid;

                      final haveNip = (index == 0) ||
                          (index == snapshot.data!.length - 1 &&
                              message.senderId !=
                                  snapshot.data![index - 1].senderId) ||
                          (message.senderId !=
                                  snapshot.data![index - 1].senderId &&
                              message.senderId ==
                                  snapshot.data![index + 1].senderId) ||
                          (message.senderId !=
                                  snapshot.data![index - 1].senderId &&
                              message.senderId !=
                                  snapshot.data![index + 1].senderId);
                      final isShowDateCard = (index == 0) ||
                          ((index == snapshot.data!.length - 1) &&
                              (message.timeSent.day >
                                  snapshot.data![index - 1].timeSent.day)) ||
                          (message.timeSent.day >
                                  snapshot.data![index - 1].timeSent.day &&
                              message.timeSent.day <=
                                  snapshot.data![index + 1].timeSent.day);

                      return Column(
                        children: [
                          if (isShowDateCard)
                            ShowDateCard(date: message.timeSent),
                          MessageCard(
                            isSender: isSender,
                            haveNip: haveNip,
                            message: message,
                          ),
                        ],
                      );
                    },
                  ),
                );
              },
            ),
          ),
          Container(
            alignment: const Alignment(0, 1),
            child: ChatTextField(
              receiverId: user.uid,
              scrollController: scrollController,
            ),
          ),
        ],
      ),
    );
  }
}
