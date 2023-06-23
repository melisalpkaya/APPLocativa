import 'package:flutter/material.dart';
import 'package:locativa/ChangePassword/successfull.dart';

import '../ColorsClass/colors.dart';
import '../Chunk.dart';
import '../DatabaseHelper.dart';

class ChangePsw extends StatelessWidget {
  Chunk chunk = Chunk.fromChunk();
  ChangePsw(this.chunk, {Key? key}) : super(key: key);
  final oldPassWordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final newPasswordAgainController = TextEditingController();

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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Şifre Sıfırlama',
                style: TextStyle(
                    fontFamily: 'WorkSans',
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text),
              ),
              const SizedBox(
                height: 50,
              ),
              const Text(
                'Eski şifre',
                style: TextStyle(
                    fontFamily: 'WorkSans',
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text2),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                height: 43,
                width: double.infinity,
                child: TextFormField(
                  controller: oldPassWordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                    ),
                    fillColor: Colors.white,
                    filled: true,
                    hintText: '•••••',
                    hintStyle: TextStyle(
                      color: AppColors.text,
                      fontFamily: 'WorkSans',
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Yeni şifre',
                style: TextStyle(
                    fontFamily: 'WorkSans',
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text2),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                height: 43,
                width: double.infinity,
                child: TextFormField(
                  controller: newPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                    ),
                    fillColor: Colors.white,
                    filled: true,
                    hintText: '•••••',
                    hintStyle: TextStyle(
                      color: AppColors.text,
                      fontFamily: 'WorkSans',
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Yeni şifre tekrar',
                style: TextStyle(
                    fontFamily: 'WorkSans',
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text2),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                height: 43,
                width: double.infinity,
                child: TextFormField(
                  controller: newPasswordAgainController,
                  obscureText: true,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                    ),
                    fillColor: Colors.white,
                    filled: true,
                    hintText: '•••••',
                    hintStyle: TextStyle(
                      color: AppColors.text,
                      fontFamily: 'WorkSans',
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 90),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    DatabaseHelper db = DatabaseHelper();
                    String oldPassWord = oldPassWordController.text.toString();
                    String newPassword = newPasswordController.text.toString();
                    String newPasswordAgain =
                        newPasswordAgainController.text.toString();

                    if (this.chunk.currentUser.getEmployeePassword ==
                        oldPassWord) {
                      if (newPassword == newPasswordAgain) {
                        //şifre değiştir
                        //Şifre uzunluğu ve boş karakter girilmesini engelleme zımbırtısı yap.
                        db.changePassword(
                            chunk.currentUser.getEmployeeId, newPassword);
                        print("şifreniz başarıyla değiştirildi");
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Successfull(this.chunk)),
                        );
                      } else {
                        //new password ile again aynı değil hatası dön.
                        print("New password ile Again hatası");
                      }
                    } else if (oldPassWord !=
                        this.chunk.currentUser.getEmployeePassword) {
                      print("Yanlış şifre girdiniz");
                      //eski şifrenizi yanlış girdiniz
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.navy,
                      fixedSize: const Size(289, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(17))),
                  child: const Text(
                    'Değiştir',
                    style: TextStyle(
                        fontFamily: 'WorkSans',
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                        color: AppColors.background),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
