import 'dart:async';
import 'package:flutter/material.dart';

import '../ColorsClass/colors.dart';
import '../homepage.dart';
import '../loginPage.dart';

class SuccessfullFour extends StatefulWidget {
  const SuccessfullFour({super.key});

  @override
  _SuccessfullFourState createState() => _SuccessfullFourState();
}

class _SuccessfullFourState extends State<SuccessfullFour> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 50.0),
              child: Text(
                'Başarılı!',
                style: TextStyle(
                  fontFamily: 'WorkSans',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.text,
                ),
              ),
            ),
            SizedBox(height: 20),
            Image.asset(
              "assets/images/el.png",
              fit: BoxFit.cover,
              height: 200,
              width: 200,
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(top: 28.0),
              child: Text(
                'Şifreniz mailinize gönderildi!',
                style: TextStyle(
                  fontFamily: 'WorkSans',
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                  color: AppColors.text2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
