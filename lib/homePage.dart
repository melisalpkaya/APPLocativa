import 'package:flutter/material.dart';
import 'package:locativa/Chunk.dart';
import 'package:locativa/DatabaseHelper.dart';

import 'ColorsClass/colors.dart';
import 'Employee.dart';
import '../FaultReport/categories.dart';

import 'TechnicalSupport/techSupport.dart';
import 'loginPage.dart';

class HomePage extends StatelessWidget {
  Chunk chunk = Chunk.fromChunk();
  HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Arka plan rengi
          Container(
            color: AppColors.background,
          ),
          // Fotoğraf
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: MediaQuery.of(context).size.height / 3,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
              child: Image.asset(
                'assets/images/2.png',
                fit: BoxFit.cover,
              ),
            ),
          ),

          Positioned(
            left: 0,
            right: 0,
            bottom: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    DatabaseHelper db = DatabaseHelper();
                    //Ege fonksiyonlarını burada test et
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.navy,
                      fixedSize: const Size(289, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(17))),
                  child: const Text(
                    'Giriş Yap',
                    style: TextStyle(
                        fontFamily: 'WorkSans',
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        color: AppColors.background),
                  ),
                ),
                const SizedBox(
                  height: 15, //<-- SEE HERE
                ),
                TextButton(
                  style: TextButton.styleFrom(
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'WorkSans',
                      ),
                      foregroundColor: AppColors.purple),
                  onPressed: () async {
                    DatabaseHelper db = DatabaseHelper();
                    Employee e = await db.readEmployeeWithID(-1);
                    this.chunk.currentUser = e;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Categories(this.chunk)),
                    );
                  },
                  child: const Text('Misafir Olarak Devam Et'),
                ),
                const SizedBox(
                  height: 20, //<-- SEE HERE
                ),
                TextButton(
                  style: TextButton.styleFrom(
                      textStyle: const TextStyle(
                        fontSize: 17,
                        fontFamily: 'WorkSans',
                      ),
                      foregroundColor: AppColors.text2),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TechSupport()),
                    );
                  },
                  child: const Text('Sorun Bildir'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
