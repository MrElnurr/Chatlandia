import 'package:chatapp/common/extension/custom_theme_extension.dart';
import 'package:chatapp/common/models/user_model.dart';
import 'package:chatapp/common/routes/routes.dart';
import 'package:chatapp/common/utils/coloors.dart';
import 'package:chatapp/common/widgets/custom_icon_button.dart';
import 'package:chatapp/feature/auth/contact/controllers/contacts_controller.dart';
import 'package:chatapp/feature/auth/contact/widgets/contact_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactPage extends ConsumerWidget {
  const ContactPage({super.key});

  shareSmsLink(phoneNumber) async {
    Uri sms = Uri.parse(
        'sms: ${phoneNumber} body: Lets study in Codelandia best course ever. Website: www.codelandia.edu.az');
    if (await launchUrl(sms)) {
    } else {}
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select contact',
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 3),
            ref.watch(contactControllerProvider).when(
              data: (allContacts) {
                return Text(
                  '${allContacts[0].length} Contact${allContacts[0].length == 1 ? '' : 's'}',
                  style: const TextStyle(fontSize: 13),
                );
              },
              error: (e, t) {
                return const SizedBox();
              },
              loading: () {
                return const Text(
                  'Counting',
                  style: TextStyle(fontSize: 12),
                );
              },
            ),
          ],
        ),
        actions: [
          CustomIconButton(onTap: () {}, icon: Icons.search),
          CustomIconButton(onTap: () {}, icon: Icons.more_vert),
        ],
      ),
      body: ref.watch(contactControllerProvider).when(
        data: (allContacts) {
          return ListView.builder(
            itemCount: allContacts[0].length + allContacts[1].length,
            itemBuilder: (context, index) {
              late UserModel firebaseContacts;
              late UserModel phoneContacts;

              if (index < allContacts[0].length) {
                firebaseContacts = allContacts[0][index];
              } else {
                phoneContacts = allContacts[1][index - allContacts[0].length];
              }
              return index < allContacts[0].length
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (index == 0)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                child: Text(
                                  'Contacts on Chatlandia',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: context.theme.greyColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ContactCard(
                            onTap: () {
                              Navigator.of(context).pushNamed(Routes.chat,
                                  arguments: firebaseContacts);
                            },
                            contactSource: firebaseContacts),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (index == allContacts[0].length)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: Text(
                              'Contacts on Phone',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: context.theme.greyColor,
                              ),
                            ),
                          ),
                        ContactCard(
                          contactSource: phoneContacts,
                          onTap: () => shareSmsLink(phoneContacts.phoneNumber),
                        ),
                      ],
                    );
            },
          );
        },
        error: (e, t) {
          return null;
        },
        loading: () {
          return CircularProgressIndicator(
            color: context.theme.authAppbarTextColor,
          );
        },
      ),
    );
  }

  ListTile myListTile({
    required IconData leading,
    required String text,
    IconData? trailing,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.only(top: 10, left: 20, right: 10),
      leading: CircleAvatar(
        radius: 20,
        backgroundColor: Coloors.greenDark,
        child: Icon(
          leading,
          color: Colors.white,
        ),
      ),
      title: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Icon(
        trailing,
        color: Coloors.greyDark,
      ),
    );
  }
}
