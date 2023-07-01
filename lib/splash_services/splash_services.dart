import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../auth/login_screen.dart';
import '../ui/list_screen.dart';

class SplashServices{

  isLogin(context){
    Timer.periodic(const Duration(seconds: 4), (timer) {
      Navigator.push(context, MaterialPageRoute(builder: (context){
        return FirebaseAuth.instance.currentUser != null
            ? const ListScreen()
            : const LoginScreen();
      }));
    });
  }

}