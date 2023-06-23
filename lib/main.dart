import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:locativa/splash.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Locativa',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        unselectedWidgetColor: Colors.white,
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: MaterialColor(
          0xFFf5f5f9, // buradaki renk kodunu kendi istediğiniz renk kodu ile değiştirin
          {
            50: Color(0xFFFFEBEE),
            100: Color(0xFFFFCDD2),
            200: Color(0xFFEF9A9A),
            300: Color(0xFFE57373),
            400: Color(0xFFEF5350),
            500: Color(0xFFDB5E5E),
            600: Color(0xFFE53935),
            700: Color(0xFFD32F2F),
            800: Color(0xFFC62828),
            900: Color(0xFFB71C1C),
          },
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(
            fontFamily: 'WorkSans',
          ),
        ),
      ),
      home: const Splash(),
    );
  }
}
