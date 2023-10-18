import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instaclone_ranavat/providers/user_provider.dart';
import 'package:instaclone_ranavat/responsive/mobile_screen_layout.dart';
import 'package:instaclone_ranavat/responsive/responsive_layout_screen.dart';
import 'package:instaclone_ranavat/responsive/web_screen_layout.dart';
import 'package:instaclone_ranavat/screens/login_screen.dart';
import 'package:instaclone_ranavat/screens/signup_screen.dart';
import 'package:instaclone_ranavat/utils/colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyDgYbUfQScrKtwgUgzxtrYfs77E8sXm4Qo",
            appId: "1:18385046807:web:3cd39bc39e16cb71f73b52",
            messagingSenderId: "18385046807",
            projectId: "insta-tut-90905",
            storageBucket: "insta-tut-90905.appspot.com"));
  } else {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Instagram Clone',
          theme: ThemeData.dark()
              .copyWith(scaffoldBackgroundColor: mobileBackgroundColor),
          home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  return const ResponsiveLayout(
                      webScreenLayout: WebScreenLayout(),
                      mobileScreenLayout: MobileScreenLayout());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text("${snapshot.error}"),
                  );
                }
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: primaryColor),
                );
              }
              return const Loginscreen();
            },
          )),
    );
  }
}
