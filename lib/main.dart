import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:r08fullmovieapp/firebase_options.dart';
import 'HomePage/HomePage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_register.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  SharedPreferences sp = await SharedPreferences.getInstance();
  Stripe.publishableKey =
      'pk_test_51QM8IxRwwGPjVJO2K9f2KjUZlMs6K91eJnQVcQ1bsGI9MPEspz6ouWEmObOxtlvCFp3CdDldwnOndQfYIqdHkzBe00qYbZNQPI';
  String imagepath = sp.getString('imagepath') ?? '';
  runApp(MyApp(
    imagepath: imagepath,
  ));

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom]);
}

class MyApp extends StatelessWidget {
  String imagepath;
  MyApp({
    super.key,
    required this.imagepath,
  });

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      initialRoute: '/',
      routes: {
        '/': (context) => LoginRegisterPage(), // Màn hình đăng nhập/đăng ký
        '/home': (context) => MyHomePage(), // Màn hình chính (HomePage)
        '/intermediate': (context) =>
            const intermediatescreen(), // Màn hình splash
      },
    );
  }
}

class intermediatescreen extends StatefulWidget {
  const intermediatescreen({super.key});

  @override
  State<intermediatescreen> createState() => _intermediatescreenState();
}

class _intermediatescreenState extends State<intermediatescreen> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      backgroundColor: const Color.fromRGBO(18, 18, 18, 1),
      duration: 2000,
      nextScreen: MyHomePage(), // Sau khi splash, chuyển đến HomePage
      splash: Container(
        child: Center(
          child: Column(
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('asset/icon.png'),
                          fit: BoxFit.contain)),
                ),
              ),
              const Expanded(
                child: Text(
                  'By Anh Tai',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      splashTransition: SplashTransition.fadeTransition,
      splashIconSize: 200,
    );
  }
}
