import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:symlercooksbake/loginscreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;


class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  double screenHeight = 0.0, screenWidth = 0.0;
  @override
  void initState() {
    super.initState();
    checkAndLogin();
    Timer(
        const Duration(seconds: 5),
        () => Get.off(() => const LoginPage())
        );
    
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/sp.jpg'),
                    scale: 1,
                    fit: BoxFit.cover))),
      ],
    );
  }
  checkAndLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = (prefs.getString('email')) ?? '';
    String password = (prefs.getString('pass')) ?? '';
    if (email.length > 1 && password.length > 1) {
      http.post(Uri.parse("https://symlercooksbake.000webhostapp.com/directory/php/login_user.php"),
          body: {"email": email, "password": password}).then((response) {
        if (response.statusCode == 200 && response.body != "failed") {
          final jsonResponse = json.decode(response.body);
          Timer(
        const Duration(seconds: 5),
        () => Get.off(() => const LoginPage())
        );
        } 
      }).timeout(const Duration(seconds: 5));
    } else {
      Timer(
        const Duration(seconds: 5),
        () => Get.off(() => const LoginPage())
        );
    }
  }
}
