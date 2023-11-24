import 'package:chatapp/common/routes/routes.dart';
import 'package:chatapp/common/theme/dark_theme.dart';
import 'package:chatapp/common/theme/light_theme.dart';
import 'package:chatapp/common/utils/coloors.dart';
import 'package:chatapp/feature/auth/controller/auth_controller.dart';
import 'package:chatapp/feature/home/pages/home_page.dart';
import 'package:chatapp/feature/welcome/pages/welcome_page.dart';
import 'package:chatapp/feature/welcome/widgets/language_button.dart';
import 'package:chatapp/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liquid_swipe/liquid_swipe.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      theme: lightTheme(),
      darkTheme: darkTheme(),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: ref.watch(userInfoAuthProvider).when(
        data: (user) {
          FlutterNativeSplash.remove();
          if (user == null) {
            return LiquidSwipe(
              waveType: WaveType.liquidReveal,
              enableLoop: false,
              enableSideReveal: true,
              slideIconWidget: const Icon(
                Icons.arrow_back_ios_new,
                size: 25,
              ),
              pages: [
                Container(
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 25),
                        child: Image.asset(
                          'assets/images/main_icon.png',
                          width: 300,
                          height: 300,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 10, bottom: 50),
                        child: Text(
                          textAlign: TextAlign.center,
                          "Please select your language and swipe to next screen",
                          style: TextStyle(
                              color: Coloors.greenLight,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const LanguageButton(),
                    ],
                  ),
                ),
                const WelcomePage(),
              ],
            );
          }
          return const HomePage();
        },
        error: (error, trace) {
          return const Scaffold(
            body: Center(
              child: Text('Something went wrong!'),
            ),
          );
        },
        loading: () {
          return const SizedBox();
        },
      ),
      onGenerateRoute: Routes.onGenerateRoute,
    );
  }
}
