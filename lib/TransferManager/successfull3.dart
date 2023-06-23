import 'dart:async';
import 'package:flutter/material.dart';

import '../ColorsClass/colors.dart';
import '../homepage.dart';

class SuccessfullThree extends StatefulWidget {
  const SuccessfullThree({super.key});

  @override
  _SuccessfullThreeState createState() => _SuccessfullThreeState();
}

class _SuccessfullThreeState extends State<SuccessfullThree> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
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
              padding: const EdgeInsets.only(bottom: 40.0),
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
            SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.only(top: 28.0),
              child: Column(
                children: [
                  Text(
                    'Sorun bildiriminiz',
                    style: TextStyle(
                      fontFamily: 'WorkSans',
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                      color: AppColors.text2,
                    ),
                  ),
                  Text(
                    'başarıyla tamamlandı!',
                    style: TextStyle(
                      fontFamily: 'WorkSans',
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                      color: AppColors.text2,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Ekiplerimiz en kısa sürede sorunu çözüp',
                    style: TextStyle(
                      fontFamily: 'WorkSans',
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: AppColors.text2,
                    ),
                  ),
                  Text(
                    'size dönüş yapacaktır.',
                    style: TextStyle(
                      fontFamily: 'WorkSans',
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: AppColors.text2,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
