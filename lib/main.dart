import 'package:symlercooksbake/splash.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      
      theme: ThemeData(
        textTheme: GoogleFonts.robotoTextTheme(),
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.pink,
          backgroundColor: Colors.pink[200],
        ),
      ),
      
      darkTheme: ThemeData.dark(),
      title: 'Symler Cooks & Bake',
      home: const Scaffold(
        
        body: Splash(),
      ),
    );
    
  }
}
