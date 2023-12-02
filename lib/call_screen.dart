import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class CallPageNew extends StatelessWidget {
  final String callID; // Call ID should be passed to this widget
  final bool isVideo;
  const CallPageNew({Key? key, required this.callID, required this.isVideo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String userID = 'Birincisi';

    String userName = 'Salam';

    return ZegoUIKitPrebuiltCall(
      appID: 657597766,
      appSign:
          '46096e250e35d124664a7b9cf60a92073ba5ba5e8dd09cf56894faf5fd554937',
      userID: userID,
      userName: userName,
      callID: callID,
      config: ZegoUIKitPrebuiltCallConfig(turnOnCameraWhenJoining: isVideo),
    );
  }
}
