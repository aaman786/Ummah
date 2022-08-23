import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ummah/screens/begin_screen.dart';
import 'package:ummah/screens/comments_screen.dart';
import 'package:ummah/screens/home_screen.dart';
import 'package:ummah/screens/login_screen.dart';
import 'package:ummah/screens/signup_screen.dart';
import 'package:ummah/providers/user_proider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        )
      ],
      child: MaterialApp(
        // theme:
        //     ThemeData.dark().copyWith(scaffoldBackgroundColor: kBackgroundClr),
        debugShowCheckedModeBanner: false,
        routes: {
          'begin': (context) => const BeginPage(),
          'signup': (context) => const SignupPage(),
          'login': (context) => LoginPage(),
          'home': (context) => const HomePage(),
          'comment': (context) => const CommentScreen(),
        },
        home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  return const HomePage();
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text("${snapshot.error}"),
                  );
                }
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.black),
                );
              }
              return const BeginPage();
            }),
      ),
    );
  }
}
