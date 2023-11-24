import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/common/extension/custom_theme_extension.dart';
import 'package:chatapp/common/models/user_model.dart';
import 'package:chatapp/common/utils/coloors.dart';
import 'package:chatapp/common/widgets/custom_icon_button.dart';
import 'package:chatapp/feature/chat/widgets/custom_list_tile.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key, required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.profilePageBg,
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            delegate: SliverPersistenDeleage(user),
            pinned: true,
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                Container(
                  color: Theme.of(context).backgroundColor,
                  child: Column(
                    children: [
                      Text(
                        user.username,
                        style: const TextStyle(fontSize: 24),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        user.phoneNumber,
                        style: TextStyle(
                          fontSize: 20,
                          color: context.theme.greyColor,
                        ),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          iconWithText(
                            icon: Icons.call,
                            text: 'Call',
                          ),
                          iconWithText(
                            icon: Icons.video_call,
                            text: 'Video call',
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 35),
                CustomListTile(
                  title: 'Mute notification',
                  leading: Icons.notifications,
                  trailing: Switch(
                    inactiveThumbColor: Coloors.greenLight,
                    value: false,
                    onChanged: (value) {},
                  ),
                ),
                const CustomListTile(
                  title: 'Custom notification',
                  leading: Icons.music_note,
                ),
                CustomListTile(
                  title: 'Media visibility',
                  leading: Icons.photo,
                  trailing: Switch(
                    inactiveThumbColor: Coloors.greenLight,
                    value: false,
                    onChanged: (value) {},
                  ),
                ),
                const SizedBox(height: 50),
                const CustomListTile(
                  title: 'Encryption',
                  leading: Icons.lock,
                ),
                const CustomListTile(
                  title: 'Disappearing messages',
                  subTitle: 'Off',
                  leading: Icons.timer,
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

iconWithText({required IconData icon, required String text}) {
  return Padding(
    padding: const EdgeInsets.all(20),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 30,
          color: Coloors.greenDark,
        ),
        const SizedBox(height: 10),
        Text(
          text,
          style: const TextStyle(
            color: Coloors.greenDark,
          ),
        ),
      ],
    ),
  );
}

class SliverPersistenDeleage extends SliverPersistentHeaderDelegate {
  final double maxHeaderHeight = 180;
  final double minHeaderHeight = kToolbarHeight + 35;
  final double maxImageSize = 130;
  final double minImageSize = 4;
  final UserModel user;

  SliverPersistenDeleage(this.user);
  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final size = MediaQuery.of(context).size;
    final percent = shrinkOffset / (maxHeaderHeight - 35);
    final percent2 = shrinkOffset / (maxHeaderHeight - 35);
    final currentImageSize = (maxImageSize * (1 - percent)).clamp(
      minImageSize,
      maxImageSize,
    );
    final currentImagePosition =
        (((size.width / 2) - 65) * (1 - percent)).clamp(
      minImageSize,
      maxImageSize,
    );
    return Container(
      color: Theme.of(context).backgroundColor,
      child: Container(
        color: Theme.of(context)
            .appBarTheme
            .backgroundColor!
            .withOpacity(percent2 * 2 < 1 ? percent2 * 2 : 1),
        child: Stack(
          children: [
            Positioned(
              top: MediaQuery.of(context).viewPadding.top + 15,
              left: currentImagePosition + 50,
              child: Text(
                user.username,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white.withOpacity(
                    percent2,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              top: MediaQuery.of(context).viewPadding.top + 5,
              child: BackButton(
                color:
                    percent2 > .3 ? Colors.white.withOpacity(percent2) : null,
              ),
            ),
            Positioned(
              right: 0,
              top: MediaQuery.of(context).viewPadding.top + 5,
              child: CustomIconButton(
                onTap: () {},
                icon: Icons.more_vert,
                iconColor: percent2 > .3
                    ? Colors.white.withOpacity(percent2)
                    : Theme.of(context).textTheme.bodyText2!.color,
              ),
            ),
            Positioned(
              left: currentImagePosition,
              top: MediaQuery.of(context).viewPadding.top + 5,
              bottom: 0,
              child: Hero(
                tag: 'profile',
                child: Container(
                  width: currentImageSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(user.profileImageUrl),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  double get maxExtent => maxHeaderHeight;

  @override
  double get minExtent => minHeaderHeight;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
