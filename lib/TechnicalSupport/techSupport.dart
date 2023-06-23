import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:locativa/Employee.dart';
import 'package:flutter/services.dart';
import 'package:locativa/FaultReport/successfull2.dart';
import 'package:locativa/TransferManager/successfull3.dart';
import 'package:locativa/static_data.dart';
import '../Chunk.dart';
import '../ColorsClass/colors.dart';
import '../DatabaseHelper.dart';
import '../Task.dart';

class TechSupport extends StatefulWidget {
  @override
  TechSupportState createState() => TechSupportState();
}

class TechSupportState extends State<TechSupport> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _explanationController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _explanationController.dispose();

    super.dispose();
  }

  bool isFieldsEmpty() {
    final title = _titleController.text.trim();
    final description = _explanationController.text.trim();

    return title.isEmpty || description.isEmpty;
  }

  void onSubmitButtonPressed() async {
    if (isFieldsEmpty()) {
      AwesomeDialog(
        // Dialog ayarları
        context: context,
        dialogType: DialogType.ERROR,
        animType: AnimType.SCALE,
        title: 'Hata',
        desc: 'Lütfen tüm alanları doldurunuz.',
        btnOkText: 'Tamam',

        btnOkColor: AppColors.purple,
        buttonsTextStyle: TextStyle(
          color: AppColors.white, // Metin rengi
          fontFamily: 'WorkSans', // Yazı tipi
          fontSize: 18, // Font büyüklüğü
          fontWeight: FontWeight.bold, // Yazı kalınlığı
        ),
        titleTextStyle: TextStyle(
          color: AppColors.egeRed, // Başlık metni rengi
          fontSize: 20, // Başlık metni boyutu
          fontWeight: FontWeight.bold, // Başlık metni kalınlığı
        ),
        buttonsBorderRadius: BorderRadius.circular(10),
      ).show();
    } else {
      DatabaseHelper db=DatabaseHelper();
      await db.notifyError(_titleController.text,_explanationController.text);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SuccessfullThree()),
      );
    }
  }

  @override
  void initState() {
    super.initState();
  }

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
                    color: AppColors.navy,
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
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Sorun nedir?',
                style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'WorkSans',
                    color: AppColors.navy),
              ),
              const SizedBox(
                height: 40, //<-- SEE HERE
              ),
              const Text(
                'Başlık',
                style: TextStyle(
                  fontSize: 15.0,
                  color: AppColors.text,
                  fontFamily: 'WorkSans',
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 20, //<-- SEE HERE
              ),
              TextField(
                controller: _titleController,
                maxLines: 2,
                style: TextStyle(color: AppColors.text),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Sorun nedir?',
                  hintStyle: TextStyle(
                    color: AppColors.text.withOpacity(0.5),
                    fontFamily: 'WorkSans',
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(
                height: 30, //<-- SEE HERE
              ),
              const Text(
                'Açıklama',
                style: TextStyle(
                  fontSize: 15.0,
                  color: AppColors.text,
                  fontFamily: 'WorkSans',
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 20, //<-- SEE HERE
              ),
              TextField(
                controller: _explanationController,
                maxLines: 4,
                style: TextStyle(color: AppColors.text),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Sorunu birkaç cümle ile özetleyiniz.',
                  hintStyle: TextStyle(
                    color: AppColors.text.withOpacity(0.5),
                    fontFamily: 'WorkSans',
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 70),
              Center(
                child: ElevatedButton(
                  onPressed: onSubmitButtonPressed,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff171059),
                      fixedSize: const Size(300, 45),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(17))),
                  child: const Text(
                    'Sorun Bildir',
                    style: TextStyle(
                      fontFamily: 'WorkSans',
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: AppColors.background,
                    ),
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
