import 'dart:io';
import 'dart:typed_data';

import 'package:chatapp/common/enum/message_type.dart';
import 'package:chatapp/common/extension/custom_theme_extension.dart';
import 'package:chatapp/common/helper/show_alert_dialogue.dart';
import 'package:chatapp/common/utils/coloors.dart';
import 'package:chatapp/common/widgets/custom_icon_button.dart';
import 'package:chatapp/feature/auth/pages/image_picker_page.dart';
import 'package:chatapp/feature/chat/controllers/chat_controller.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class ChatTextField extends ConsumerStatefulWidget {
  const ChatTextField({
    super.key,
    required this.receiverId,
    required this.scrollController,
  });

  final String receiverId;
  final ScrollController scrollController;

  @override
  ConsumerState<ChatTextField> createState() => _ChatTextFieldState();
}

class _ChatTextFieldState extends ConsumerState<ChatTextField> {
  late TextEditingController messageController;
  File? imageCamera;
  Uint8List? imageGallery;
  bool isMessageIconEnabled = false;
  double cardHeight = 0;
  PlatformFile? pickedFile;
  UploadTask? uploadTask;

  void sendImageMessageFromGallery() async {
    final image = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const ImagePickerPage(),
        ));

    if (image != null) {
      sendFileMessage(image, MessageType.image);
      setState(() => cardHeight = 0);
    }
  }

  pickImageFromCamera() async {
    Navigator.of(context).pop();
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      setState(
        () {
          imageCamera = File(image!.path);
          imageGallery = null;
        },
      );
      if (imageCamera != null) {
        sendFileMessage(imageCamera, MessageType.video);
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      showAlertDialog(context: context, message: e.toString());
    }
  }

  void sendFileMessage(var file, MessageType messageType) async {
    ref.read(chatControllerProvider).sendFileMessage(
          context,
          file,
          widget.receiverId,
          messageType,
        );
    await Future.delayed(const Duration(milliseconds: 500));
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      widget.scrollController.animateTo(
        widget.scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  void sendTextMessage() async {
    if (isMessageIconEnabled) {
      ref.read(chatControllerProvider).sendTextMessage(
            context: context,
            textMessage: messageController.text,
            receiverId: widget.receiverId,
          );
      messageController.clear();
    }

    await Future.delayed(const Duration(milliseconds: 100));
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      widget.scrollController.animateTo(
        widget.scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  iconWithText({
    required VoidCallback onPressed,
    required IconData icon,
    required String text,
    required Color background,
  }) {
    return Column(
      children: [
        CustomIconButton(
          onTap: onPressed,
          icon: icon,
          background: background,
          minWidth: 50,
          iconColor: Colors.white,
          border: Border.all(
            color: context.theme.greyColor!.withOpacity(.2),
            width: 1,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          text,
          style: TextStyle(
            color: context.theme.greyColor,
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    messageController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: cardHeight,
          width: double.maxFinite,
          margin: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: context.theme.receiverChatCardBg,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      iconWithText(
                        onPressed: () {},
                        icon: Icons.tab,
                        text: 'File',
                        background: Coloors.greenLight,
                      ),
                      iconWithText(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => pickImageFromCamera()),
                          );
                        },
                        icon: Icons.camera_alt,
                        text: 'Camera',
                        background: Coloors.greenLight,
                      ),
                      iconWithText(
                        onPressed: sendImageMessageFromGallery,
                        icon: Icons.photo,
                        text: 'Gallery',
                        background: Coloors.greenLight,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: messageController,
                  maxLines: 4,
                  minLines: 1,
                  onChanged: (value) {
                    value.isEmpty
                        ? setState(() => isMessageIconEnabled = false)
                        : setState(() => isMessageIconEnabled = true);
                  },
                  decoration: InputDecoration(
                    hintText: 'Message',
                    hintStyle: TextStyle(color: context.theme.greyColor),
                    filled: true,
                    fillColor: context.theme.chatTextFieldBg,
                    isDense: true,
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                        style: BorderStyle.none,
                        width: 0,
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        RotatedBox(
                          quarterTurns: 45,
                          child: CustomIconButton(
                            onTap: () => setState(
                              () => cardHeight == 0
                                  ? cardHeight = 220
                                  : cardHeight = 0,
                            ),
                            icon: cardHeight == 0
                                ? Icons.attach_file
                                : Icons.close,
                            iconColor:
                                Theme.of(context).listTileTheme.iconColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 5),
              CustomIconButton(
                onTap: sendTextMessage,
                icon: isMessageIconEnabled
                    ? Icons.send_outlined
                    : Icons.send_outlined,
                background: Coloors.greenDark,
                iconColor: Colors.white,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
