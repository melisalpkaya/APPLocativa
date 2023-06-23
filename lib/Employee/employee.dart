import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:locativa/ChangePassword/changePassword.dart';
import 'package:locativa/ChangePassword/successfull.dart';
import 'package:locativa/FaultReport/categories.dart';
import 'package:locativa/FaultReport/successfull2.dart';
import '../Chunk.dart';
import '../ColorsClass/colors.dart';
import '../DatabaseHelper.dart';
import '../Task.dart';
import '../homePage.dart';
import '../loginPage.dart';
import '../notifications.dart';

class EmployeePage extends StatefulWidget {
  Chunk chunk = Chunk.fromChunk();
  EmployeePage(this.chunk);
  @override
  State<EmployeePage> createState() => _MyEmployeePageState(this.chunk);
}

class _MyEmployeePageState extends State<EmployeePage> {
  Chunk chunk = Chunk.fromChunk();
  DatabaseHelper db = DatabaseHelper();
  _MyEmployeePageState(this.chunk);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(34),
            height: size.height,
            width: size.width,
            decoration: const BoxDecoration(color: AppColors.background),
            child: SafeArea(
              child: Align(
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/images/profile.png",
                          fit: BoxFit.cover,
                        )
                      ],
                    ),
                    SizedBox(height: 10),
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Hoşgeldin,",
                            style: TextStyle(
                              fontFamily: 'WorkSans',
                              fontSize: 20,
                              fontWeight: FontWeight.w100,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          chunk.currentUser.getEmployeeName +
                              " " +
                              chunk.currentUser.getEmployeeSurname,
                          style: TextStyle(
                            fontFamily: 'WorkSans',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
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
                    fontWeight: FontWeight.bold, // Title text weight
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
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                  btnOkOnPress: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                )..show();
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: size.height - (size.height / 2.5),
              width: size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                            this.chunk.setNewTasksNotification = [];
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Notifications(this.chunk)),
                            );
                          },
                          child: SizedBox(
                            height: 120,
                            width: 150,
                            child: Stack(
                              children: [
                                LongCard(
                                  background: AppColors.background,
                                  title: '',
                                  subTitle: '',
                                  image: '',
                                ),
                                Positioned(
                                  left: 16,
                                  bottom: 16,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.notifications,
                                        size: 42,
                                        color: AppColors.navy,
                                      ),
                                      SizedBox(height: 15),
                                      Text(
                                        'Bildirimler',
                                        style: TextStyle(
                                          color: AppColors.navy,
                                          fontWeight: FontWeight.w300,
                                          fontSize: 17,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 15),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Categories(this.chunk)),
                            );
                          },
                          child: SizedBox(
                            height: 120,
                            width: 150,
                            child: Stack(
                              children: [
                                LongCard(
                                  background: AppColors.background,
                                  title: 'Siparişler',
                                  subTitle: '4',
                                  image: 'assets/images/profile.png',
                                ),
                                Positioned(
                                  left: 16,
                                  bottom: 16,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.add_circle_outline,
                                        color: AppColors.navy,
                                        size: 42,
                                      ),
                                      SizedBox(height: 15),
                                      Text(
                                        'Arıza Bildir',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w300,
                                          color: AppColors.navy,
                                          fontSize: 17,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChangePsw(this.chunk)),
                      );
                    },
                    child: SizedBox(
                      height: 120,
                      child: Stack(
                        children: [
                          LongCard(
                            background: AppColors.background,
                            title: 'Siparişler',
                            subTitle: '4',
                            image: 'assets/images/profile.png',
                          ),
                          Positioned(
                            left: 16,
                            bottom: 16,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.key,
                                  size: 47,
                                  color: AppColors.navy,
                                ),
                                SizedBox(height: 15),
                                Text(
                                  'Şifremi Değiştir',
                                  style: TextStyle(
                                    color: AppColors.navy,
                                    fontWeight: FontWeight.w300,
                                    fontSize:
                                        17, // adjust the font size of the text
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              decoration: BoxDecoration(
                color: AppColors.navy,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(34),
                  topRight: Radius.circular(34),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LongCard extends StatelessWidget {
  final Color background;
  final String title;
  final String subTitle;
  final String image;
  const LongCard(
      {super.key,
      required this.background,
      required this.title,
      required this.subTitle,
      required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 155,
      width: 192,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(24),
      ),
    );
  }
}
