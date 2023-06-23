import 'package:flutter/material.dart';
import 'package:locativa/Chunk.dart';
import 'package:locativa/homePage.dart';

import '../DepartmentChief/departmentChiefHp.dart';
import 'categories.dart';
import '../ColorsClass/colors.dart';
import '../Staff/staff.dart';

class SuccessfullTwo extends StatelessWidget {
  Chunk chunk = Chunk.fromChunk();
  SuccessfullTwo(this.chunk, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Başarılı!',
          style: TextStyle(
            color: AppColors.text,
            fontFamily: 'WorkSans',
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        automaticallyImplyLeading: false, // geri butonunu kaldırır
      ),
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/el.png",
              fit: BoxFit.cover,
              height: 200,
              width: 200,
            ),
            SizedBox(height: 30),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Sorun bildiriminiz\n',
                          style: TextStyle(
                            fontFamily: 'WorkSans',
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                            color: AppColors.text2,
                          ),
                        ),
                        TextSpan(
                          text: 'başarıyla tamamlandı!',
                          style: TextStyle(
                            fontFamily: 'WorkSans',
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                            color: AppColors.text2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 90),
                ElevatedButton(
                  onPressed: () {
                    print(chunk.getLocation().getCampus);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Categories(this.chunk)),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 24),
                    child: Text(
                      'Başka bir arıza bildiriminde bulun',
                      style: TextStyle(
                          fontFamily: 'WorkSans',
                          color: Colors.white, // Change the color here
                          fontSize: 16,
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: AppColors.purple, // Change the button color here
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          17), // Change the border radius here
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (chunk.currentUser.getEmployeeTitle ==
                        "Transfer Manager") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DepartmentChief(this.chunk)),
                      );
                    } else if (chunk.currentUser.getEmployeeTitle == "Staff") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Staff(this.chunk)),
                      );
                    } else if (chunk.currentUser.getEmployeeTitle ==
                        "Department Chief") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DepartmentChief(this.chunk)),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage()),
                      );
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 24),
                    child: Text(
                      'Anasayfa',
                      style: TextStyle(
                          fontFamily: 'WorkSans',
                          color: AppColors.background, // Change the color here
                          fontSize: 16,
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: AppColors.navy, // Change the button color here
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          17), // Change the border radius here
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
