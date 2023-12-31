import 'package:chatapp/common/extension/custom_theme_extension.dart';
import 'package:chatapp/common/routes/routes.dart';
import 'package:chatapp/feature/welcome/widgets/privacy_and_terms.dart';
import 'package:flutter/material.dart';

import '../../../common/widgets/custom_elevated_button.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  navigateToLoginPage(context) {
    Navigator.of(context).pushNamedAndRemoveUntil(
      Routes.login,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                child: Image.asset(
                  'assets/images/main_icon.png',
                  color: context.theme.circleImageColor,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          Expanded(
            child: Column(
              children: [
                const Text(
                  'Welcome to Chatlandia',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const PrivacyAndTerms(),
                Padding(
                  padding: const EdgeInsets.only(top: 53),
                  child: CustomElevatedButton(
                    onPressed: () => navigateToLoginPage(context),
                    text: 'Agree and Continue',
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                // const LanguageButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
