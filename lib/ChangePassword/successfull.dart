import 'dart:async';
import 'package:flutter/material.dart';

import '../ColorsClass/colors.dart';
import '../Staff/staff.dart';
import '../homepage.dart';
import '../Chunk.dart';
import '../Employee.dart';
import '../homepage.dart';

class Successfull extends StatefulWidget {
  //Successfull({super.key});
  Chunk chunk=Chunk.fromChunk();
  Successfull(this.chunk);
  @override
  _SuccessfullState createState() => _SuccessfullState(this.chunk);
}

class _SuccessfullState extends State<Successfull> {
  Chunk chunk=Chunk.fromChunk();
  _SuccessfullState(this.chunk);
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
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
                'Şifreniz başarıyla değiştirildi!',
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
