import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:locativa/Chunk.dart';
import 'package:locativa/DatabaseHelper.dart';
import 'package:locativa/DepartmentChief/departmentChiefHp.dart';
import '../FaultReport/categories.dart';
import '../ChangePassword/changePassword.dart';
import '../ColorsClass/colors.dart';
import '../loginPage.dart';
import '../notifications.dart';

class CompletedDepChiefDetailPage extends StatefulWidget {
  Chunk chunk = Chunk.fromChunk();
  CompletedDepChiefDetailPage(this.chunk);
  CompletedDepChiefDetail createState() => CompletedDepChiefDetail(this.chunk);
}

class CompletedDepChiefDetail extends State<CompletedDepChiefDetailPage> {
  Chunk chunk = Chunk.fromChunk();
  DatabaseHelper db = DatabaseHelper();
  CompletedDepChiefDetail(this.chunk);
  TextEditingController dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    dateController.text = "";
  }

  int _rating = 0;

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
        centerTitle: true,
        elevation: 0,
      ),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.background, // arka plan rengi
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 555,
                  //width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),

                  padding: EdgeInsets.all(5),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                                "Arıza Bildirimi Numarası: " +
                                    chunk.getTaskForDetailPage
                                        .getTaskID()
                                        .toString(),
                                style: TextStyle(
                                    fontFamily: 'WorkSans',
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.normal,
                                    color: AppColors.text2)),
                            SizedBox(
                              height: 5,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(this.chunk.getTaskForDetailPage.getTitle(),
                                style: TextStyle(
                                    fontFamily: 'WorkSans',
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xff171059))),
                          ],
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.arrow_right_rounded,
                              color: AppColors.egeGreen,
                            ),
                            SizedBox(width: 8.0),
                            Text(chunk.getTaskStatusID,
                                style: TextStyle(
                                  fontFamily: 'WorkSans',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                  color: AppColors.egeGreen,
                                )),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Image.asset("assets/images/worker.png",
                                width: 45, height: 45, fit: BoxFit.fill),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                                chunk.getEmployeeForDetailPage.getEmployeeName +
                                    " " +
                                    chunk.getEmployeeForDetailPage
                                        .getEmployeeSurname,
                                style: TextStyle(
                                  fontFamily: 'WorkSans',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                  color: AppColors.egeGreen,
                                )),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                            ),
                            SizedBox(width: 3.0),
                            Text("Beklenen - Teslim Edilen Tarih",
                                style: TextStyle(
                                  fontFamily: 'WorkSans',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                  color: AppColors.text,
                                )),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 20,
                            ),
                            Column(
                              children: [
                                Text(
                                    chunk.getTaskForDetailPage
                                            .getDueDate()
                                            .day
                                            .toString() +
                                        "/" +
                                        chunk.getTaskForDetailPage
                                            .getDueDate()
                                            .month
                                            .toString() +
                                        "/" +
                                        chunk.getTaskForDetailPage
                                            .getDueDate()
                                            .year
                                            .toString(),
                                    style: TextStyle(
                                        fontFamily: 'WorkSans',
                                        fontSize: 17.0,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.text)),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  chunk.getTaskForDetailPage
                                          .getDueDate()
                                          .hour
                                          .toString() +
                                      ":" +
                                      chunk.getTaskForDetailPage
                                          .getDueDate()
                                          .minute
                                          .toString(),
                                  style: TextStyle(
                                      fontFamily: 'WorkSans',
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.normal,
                                      color: AppColors.text2),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 50,
                            ),
                            Column(
                              children: [
                                Text(
                                    chunk.getTaskForDetailPage
                                            .getFinishDate()
                                            .day
                                            .toString() +
                                        "/" +
                                        chunk.getTaskForDetailPage
                                            .getFinishDate()
                                            .month
                                            .toString() +
                                        "/" +
                                        chunk.getTaskForDetailPage
                                            .getFinishDate()
                                            .year
                                            .toString(),
                                    style: TextStyle(
                                        fontFamily: 'WorkSans',
                                        fontSize: 17.0,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.text)),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  chunk.getTaskForDetailPage
                                          .getFinishDate()
                                          .hour
                                          .toString() +
                                      ":" +
                                      chunk.getTaskForDetailPage
                                          .getFinishDate()
                                          .minute
                                          .toString(),
                                  style: TextStyle(
                                      fontFamily: 'WorkSans',
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.normal,
                                      color: AppColors.text2),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.info,
                            ),
                            SizedBox(width: 8.0),
                            Text("Detay",
                                style: TextStyle(
                                  fontFamily: 'WorkSans',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                  color: AppColors.text,
                                )),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: SingleChildScrollView(
                                child: Text(
                                  chunk.getTaskForDetailPage.getDescription(),
                                  style: TextStyle(
                                    fontFamily: 'WorkSans',
                                    fontWeight: FontWeight.normal,
                                    fontSize: 13.0,
                                    color: AppColors.text2.withOpacity(0.9),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.insert_photo_rounded,
                              size: 20,
                            ),
                            SizedBox(width: 8.0),
                            Text("Fotoğraflar",
                                style: TextStyle(
                                  fontFamily: 'WorkSans',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                  color: AppColors.text,
                                )),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 70, // veya istediğiniz uygun bir değer
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount:
                                      chunk.getTaskForDetailPage.getUrls.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: EdgeInsets.only(right: 8.0),
                                      child: Container(
                                        width: 70,
                                        height: 70,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          image: DecorationImage(
                                            image: NetworkImage(chunk
                                                .getTaskForDetailPage
                                                .getUrls[index]),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 14,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 7),
                          child: Row(
                            children: [
                              Container(
                                height: 61,
                                width: 270,
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Center(
                                      child: Text(
                                        "Oyla",
                                        style: TextStyle(
                                          fontFamily: 'WorkSans',
                                          color: AppColors.text,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17,
                                        ),
                                      ),
                                    ),
                                    Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          for (int i = 1; i <= 5; i++)
                                            GestureDetector(
                                              onTap: () async {
                                                setState(() {
                                                  _rating = i;
                                                  db.updateTaskScore(
                                                      this
                                                          .chunk
                                                          .getTaskForDetailPage
                                                          .getTaskID(),
                                                      _rating);
                                                });
                                              },
                                              child: Icon(
                                                i <= _rating
                                                    ? Icons.star
                                                    : Icons.star_border,
                                                color: i <= _rating
                                                    ? AppColors.egeYellow
                                                    : AppColors.egeYellow,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 35, right: 35, top: 5),
                          child: ElevatedButton(
                            onPressed: () {
                              showDialogAndNavigate(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.egeGreen,
                              fixedSize: const Size(243, 43),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(17),
                              ),
                            ),
                            child: const Text(
                              'Kaydet',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'WorkSans',
                                color: AppColors.background,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 18,
                ),
                SizedBox(
                  height: 5,
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: GestureDetector(
              onTap: () {},
              child: Container(
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.navy,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(21),
                    topRight: Radius.circular(21),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChangePsw(this.chunk)),
                            );
                          },
                          child: Container(
                            width: 35,
                            height: 35,
                            margin: EdgeInsets.only(right: 25),
                            child: Icon(
                              Icons.key,
                              color: Colors.white,
                              size: 27,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Categories(this.chunk)),
                            );
                          },
                          child: Container(
                            width: 35,
                            height: 35,
                            margin: EdgeInsets.only(right: 25),
                            child: Icon(
                              Icons.add_circle_outline,
                              color: Colors.white,
                              size: 27,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            // Icona tıklandığında yapılacak işlemler
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Notifications(this.chunk)),
                            );
                          },
                          child: Container(
                            width: 35,
                            height: 35,
                            margin: EdgeInsets.only(right: 25),
                            child: Icon(
                              Icons.notifications_active,
                              color: Colors.white,
                              size: 27,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.INFO,
                              animType: AnimType.SCALE,
                              headerAnimationLoop: false,
                              title: 'ONAYLA',
                              desc: 'Çıkış yapmak istediğinize emin misiniz?',
                              btnOkText: 'EVET',
                              btnOkColor: AppColors.navy,
                              buttonsTextStyle: TextStyle(
                                color: AppColors.white, // Text color
                                fontFamily: 'WorkSans', // Font family
                                fontSize: 18, // Font size
                                fontWeight: FontWeight.bold, // Font weight
                              ),
                              titleTextStyle: TextStyle(
                                color: AppColors.navy, // Title text color
                                fontSize: 20, // Title text size
                                fontWeight:
                                    FontWeight.bold, // Title text weight
                              ),
                              buttonsBorderRadius: BorderRadius.circular(10),
                              showCloseIcon: true,
                              body: GestureDetector(
                                onTap: () {
                                  Navigator.pop(
                                      context); // Dismiss the dialog when tapped outside
                                },
                                child: Center(
                                  child: Text(
                                    'Çıkış yapmak istediğinize emin misiniz?',
                                    style:
                                        TextStyle(fontStyle: FontStyle.italic),
                                  ),
                                ),
                              ),
                              btnOkOnPress: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginPage()),
                                );
                              },
                            )..show();
                          },
                          child: Container(
                            width: 35,
                            height: 35,
                            margin: EdgeInsets.only(right: 25),
                            child: Icon(Icons.logout,
                                color: AppColors.yellow, size: 27),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void showDialogAndNavigate(BuildContext context) {
    AwesomeDialog(
      // Dialog settings
      context: context,
      dialogType: DialogType.SUCCES,
      animType: AnimType.SCALE,
      title: 'Başarılı',
      desc: 'Puanınız başarıyla kaydedildi. ',
      btnOkText: 'Tamam',
      btnOkColor: AppColors.purple,
      buttonsTextStyle: TextStyle(
        color: AppColors.white,
        fontFamily: 'WorkSans',
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      titleTextStyle: TextStyle(
        color: AppColors.egeGreen,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      buttonsBorderRadius: BorderRadius.circular(10),
    ).show();

    // Wait for 1-2 seconds before navigating to DepartmentChief page
    Future.delayed(Duration(seconds: 3), () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DepartmentChief(this.chunk)),
      );
    });
  }
}
