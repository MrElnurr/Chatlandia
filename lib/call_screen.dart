import 'package:chatapp/feature/auth/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class CallPageNew extends ConsumerWidget {
  final String callID; // Call ID should be passed to this widget
  final bool isVideo;
  const CallPageNew({Key? key, required this.callID, required this.isVideo})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var user = ref.read(authControllerProvider).authRepository.auth.currentUser;
    String userID = user!.uid;

    String? userName = user.phoneNumber;

    return ZegoUIKitPrebuiltCall(
      appID: 657597766,
      appSign:
          '46096e250e35d124664a7b9cf60a92073ba5ba5e8dd09cf56894faf5fd554937',
      userID: userID,
      userName: userName!,
      callID: callID,
      config: ZegoUIKitPrebuiltCallConfig(turnOnCameraWhenJoining: isVideo),
    );
  }
}
