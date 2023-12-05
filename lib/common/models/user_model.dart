// ignore_for_file: non_constant_identifier_names

class UserModel {
  final String username;
  final String uid;
  final String profileImageUrl;
  final bool active;
  final String phoneNumber;
  final List<String> groupId;
  late String push_token;

  UserModel({
    required this.username,
    required this.uid,
    required this.profileImageUrl,
    required this.active,
    required this.phoneNumber,
    required this.groupId,
    required this.push_token,
  });

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'uid': uid,
      'profileImageUrl': profileImageUrl,
      'active': active,
      'phoneNumber': phoneNumber,
      'groupId': groupId,
      'push_token': push_token,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
        username: map['username'] ?? '',
        uid: map['uid'] ?? '',
        profileImageUrl: map['profileImageUrl'] ?? '',
        active: map['active'] ?? false,
        phoneNumber: map['phoneNumber'] ?? '',
        groupId: List<String>.from(map['groupId']),
        push_token: map['push_token'] ?? '');
  }
}
