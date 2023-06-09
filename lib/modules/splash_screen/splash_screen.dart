import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:talki/modules/authentication_screen/auth_screen.dart';
import 'package:talki/modules/login_Screen/Login_screen.dart';
import 'package:talki/shared/constants/colors.dart';

class SplashScreen extends StatefulWidget{
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds:3), (){
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) => AuthenticationScreen()), (route) => false);
    }
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        backwardsCompatibility: false,
        systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
            systemNavigationBarColor: Colors.transparent,
            systemNavigationBarIconBrightness: Brightness.dark
        ),
      ),
      body: const Center(child: Image(image: AssetImage('assets/images/splash_image.png')),),
    );
  }
}