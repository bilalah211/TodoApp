import 'package:firebase_example/splash_services/splash_services.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SplashServices splashScreen = SplashServices();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    splashScreen.isLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset
            ('images/icon.png'),
          Center(
            child: Text(
              'Save Your Brain',
              style: TextStyle(
              color: Colors.pink.shade300, fontSize: 25, fontFamily: 'Noom'),
            ),
          ),
        ],
      ),
    );
  }
}
