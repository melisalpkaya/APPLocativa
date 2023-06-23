import 'package:flutter/material.dart';
import 'package:locativa/ForgotPassword/successfull4.dart';

import '../ColorsClass/colors.dart';
import '../homePage.dart';
import '../loginPage.dart';

class ForgotPsw extends StatelessWidget {
  const ForgotPsw({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Padding(
          padding: EdgeInsets.only(right: 40),
          child: Row(
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.location_pin,
                    color: AppColors.text,
                    size: 32,
                  ),
                ),
              ),
            ],
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 30,
            ),
            const Text(
              'Şifrenizi mi unuttunuz?',
              style: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'WorkSans',
                  color: AppColors.text),
            ),
            const SizedBox(
              height: 60,
            ),
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  width: 60.0,
                  height: 60.0,
                  child: TextField(
                    obscureText: true,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      // Handle text field changes
                    },
                  ),
                ),
                const SizedBox(
                  width: 30,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  width: 60.0,
                  height: 60.0,
                  child: TextField(
                    obscureText: true,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      // Handle text field changes
                    },
                  ),
                ),
                const SizedBox(
                  width: 30,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  width: 60.0,
                  height: 60.0,
                  child: TextField(
                    obscureText: true,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      // Handle text field changes
                    },
                  ),
                ),
                const SizedBox(
                  width: 30,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  width: 60.0,
                  height: 60.0,
                  child: TextField(
                    obscureText: true,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      // Handle text field changes
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                    child: Column(
                  children: [
                    const SizedBox(
                      height: 35, //<-- SEE HERE
                    ),
                    Text(
                      'Kod mailinize gönderildi',
                      style: TextStyle(
                          fontSize: 17,
                          color: AppColors.text.withOpacity(0.5),
                          fontFamily: 'WorkSans',
                          fontWeight: FontWeight.normal),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'melis@dev4.com',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: AppColors.navy.withOpacity(0.5),
                        decorationColor: AppColors.purple,
                        fontWeight: FontWeight.normal,
                        fontFamily: 'WorkSans',
                        fontSize: 16,
                        decorationThickness: 1.0,
                      ),
                    ),
                    const SizedBox(
                      height: 100, //<-- SEE HERE
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SuccessfullFour()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.purple,
                          fixedSize: const Size(311, 53),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(17))),
                      child: const Text(
                        'Kodu Onayla',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: AppColors.background,
                          fontFamily: 'WorkSans',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30, //<-- SEE HERE
                    ),
                    ElevatedButton(
                      onPressed: () {
                        /*Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MyPage7()),
                        );*/
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.background,
                          fixedSize: const Size(200, 41),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(9)),
                          elevation: 0),
                      child: Text(
                        'Kodu Tekrar Yolla',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: AppColors.navy.withOpacity(0.5),
                          fontFamily: 'WorkSans',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
