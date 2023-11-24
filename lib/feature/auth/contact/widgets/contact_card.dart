import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/common/extension/custom_theme_extension.dart';
import 'package:chatapp/common/models/user_model.dart';
import 'package:chatapp/common/utils/coloors.dart';
import 'package:flutter/material.dart';

class ContactCard extends StatelessWidget {
  const ContactCard({
    super.key,
    required this.contactSource,
    required this.onTap,
  });

  final UserModel contactSource;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.only(
        left: 20,
        right: 10,
      ),
      leading: CircleAvatar(
        backgroundColor: context.theme.greyColor!.withOpacity(0.3),
        radius: 20,
        backgroundImage: contactSource.profileImageUrl.isNotEmpty
            ? CachedNetworkImageProvider(contactSource.profileImageUrl)
            : null,
        child: contactSource.profileImageUrl.isEmpty
            ? const Icon(Icons.person, size: 30, color: Colors.white)
            : null,
      ),
      title: Text(
        contactSource.username,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: contactSource.profileImageUrl.isEmpty
          ? null
          : Text(
              'Happiest student ever in Codelandia',
              style: TextStyle(
                color: context.theme.greyColor,
                fontWeight: FontWeight.w600,
              ),
            ),
      trailing: contactSource.profileImageUrl.isEmpty
          ? TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Coloors.greenDark,
              ),
              onPressed: onTap,
              child: const Text('INVITE'),
            )
          : null,
    );
  }
}
