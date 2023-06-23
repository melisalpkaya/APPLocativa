import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:locativa/Chunk.dart';
import 'package:locativa/DepartmentChief/departmentChiefHp.dart';
import '../FaultReport/categories.dart';
import '../ChangePassword/changePassword.dart';
import '../ColorsClass/colors.dart';
import '../loginPage.dart';
import '../notifications.dart';

class AssignedDepChiefDetailPage extends StatefulWidget {
  Chunk chunk = Chunk.fromChunk();
  AssignedDepChiefDetailPage(this.chunk);
  AssignedDepChiefDetail createState() => AssignedDepChiefDetail(this.chunk);
}

class AssignedDepChiefDetail extends State<AssignedDepChiefDetailPage> {
  Chunk chunk = Chunk.fromChunk();
  AssignedDepChiefDetail(this.chunk);
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
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: 500,
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
                              height: 10,
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
                          height: 10,
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
                          height: 25,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.people,
                            ),
                            SizedBox(width: 8.0),
                            Text("Atanan Kişi",
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
                                  color: AppColors.egeNavy,
                                )),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                            ),
                            SizedBox(width: 8.0),
                            Text("Beklenen Teslim Tarihi",
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
                            Image.asset(
                              'assets/images/calendar3.png',
                              width: 40,
                              height: 40,
                            ),
                            SizedBox(width: 10),
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
                          ],
                        ),
                        SizedBox(
                          height: 15,
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
                          height: 10,
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
                                this.chunk=Chunk.fromChunk();
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
}
