import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:talki/layout/home_layout_screen.dart';
import 'package:talki/modules/login_Screen/Login_screen.dart';

class AuthenticationScreen extends StatelessWidget{
  final FirebaseAuth auth = FirebaseAuth.instance;
  AuthenticationScreen({super.key});
  @override
  Widget build(BuildContext context) {
    if(auth.currentUser != null){
      return HomeLayoutScreen();
    }else{
      return LoginScreen();
    }
  }
}

