import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:locativa/CustomLocation.dart';
import 'package:locativa/DatabaseHelper.dart';
import 'package:locativa/Employee.dart';
import 'package:locativa/TransferManager/transferHomePage.dart';
import '../Chunk.dart';
import '../../FaultReport/categories.dart';
import '../ChangePassword/changePassword.dart';
import '../ColorsClass/colors.dart';
import '../Task.dart';
import '../loginPage.dart';
import '../notifications.dart';

class TransferManagerDetailPage extends StatefulWidget {
  Chunk chunk = Chunk.fromChunk();
  TransferManagerDetailPage(this.chunk);
  @override
  TransferManagerDetail createState() => TransferManagerDetail(this.chunk);
}

class TransferManagerDetail extends State<TransferManagerDetailPage> {
  bool _checkbox1 = false;
  bool _checkbox2 = false;
  bool _checkbox3 = false;
  bool _checkbox4 = false;
  Chunk chunk = Chunk.fromChunk();
  DatabaseHelper db = DatabaseHelper();
  TransferManagerDetail(this.chunk);

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
          padding: EdgeInsets.only(left: 10),
          child: Text(
            'Arıza Bildirimi',
            style: TextStyle(
              color: AppColors.navy,
              fontFamily: 'WorkSans',
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
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
                  height: 10,
                ),
                Container(
                  height: 475,
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
                  padding: EdgeInsets.all(10.0),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          // ignore: prefer_const_literals_to_create_immutables
                          children: [
                            const SizedBox(height: 20.0),
                            Icon(
                                _getDepartmentIcon(
                                    chunk.getTaskForDetailPage.getDepartment()),
                                color: _getIconColor(
                                    chunk.getTaskForDetailPage.getDepartment()),
                                size: 50),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              chunk.getTaskForDetailPage.getTitle(),
                              style: TextStyle(
                                  fontFamily: 'WorkSans',
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff1a1a1a)),
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Text(
                              chunk.getTaskForDetailPage.getDescription(),
                              style: TextStyle(
                                fontFamily: 'WorkSans',
                                fontSize: 17,
                                fontWeight: FontWeight.normal,
                                color: AppColors.text2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Container(
                          width: 330,
                          height: 240,
                          decoration: BoxDecoration(
                            color: Color(0xff171059),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              children: [
                                CheckboxListTile(
                                  value: _checkbox1,
                                  activeColor: Color(0xff8645ff),
                                  checkColor: AppColors.white,
                                  onChanged: (value) {
                                    setState(() {
                                      _checkbox1 = value!;
                                      if (value == true) {
                                        _checkbox2 = false;
                                        _checkbox3 = false;
                                        _checkbox4 = false;
                                      }
                                    });
                                  },
                                  title: const Text(
                                    'Su',
                                    style: TextStyle(
                                        fontFamily: 'WorkSans',
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  contentPadding: EdgeInsets.zero,
                                  dense: true,
                                ),
                                CheckboxListTile(
                                  title: const Text(
                                    'Elektrik',
                                    style: TextStyle(
                                        fontFamily: 'WorkSans',
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  value: _checkbox2,
                                  activeColor: Color(0xff8645ff),
                                  checkColor:
                                      _checkbox1 ? Color(0xff1a1a1a) : null,
                                  onChanged: (value) {
                                    setState(() {
                                      _checkbox2 = value!;
                                      if (value == true) {
                                        _checkbox1 = false;
                                        _checkbox3 = false;
                                        _checkbox4 = false;
                                      }
                                    });
                                  },
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  contentPadding: EdgeInsets.zero,
                                  dense: true,
                                ),
                                CheckboxListTile(
                                  title: const Text(
                                    'Yapı',
                                    style: TextStyle(
                                        fontFamily: 'WorkSans',
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  value: _checkbox3,
                                  activeColor: Color(0xff8645ff),
                                  checkColor:
                                      _checkbox1 ? Color(0xff1a1a1a) : null,
                                  onChanged: (value) {
                                    setState(() {
                                      _checkbox3 = value!;
                                      if (value == true) {
                                        _checkbox1 = false;
                                        _checkbox2 = false;
                                        _checkbox4 = false;
                                      }
                                    });
                                  },
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  contentPadding: EdgeInsets.zero,
                                  dense: true,
                                ),
                                CheckboxListTile(
                                  title: const Text(
                                    'Teknik',
                                    style: TextStyle(
                                      fontFamily: 'WorkSans',
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  value: _checkbox4,
                                  activeColor: Color(0xff8645ff),
                                  checkColor:
                                      _checkbox1 ? Color(0xff1a1a1a) : null,
                                  onChanged: (value) {
                                    setState(() {
                                      _checkbox4 = value!;
                                      if (value == true) {
                                        _checkbox1 = false;
                                        _checkbox2 = false;
                                        _checkbox3 = false;
                                      }
                                    });
                                  },
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  contentPadding: EdgeInsets.zero,
                                  dense: true,
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                // SizedBox(
                //   height: 5,
                // ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: ElevatedButton(
                    onPressed: () async {
                      Task task = chunk.getTaskForDetailPage;
                      String department = "";
                      //StaffID olarak eşitlenecek
                      if (_checkbox1) {
                        department = "Water";
                        int departmentChiefID = 1001;
                        db.changeTaskDepartmentAndStaffID(
                            task,
                            department,
                            departmentChiefID,
                            this.chunk.currentUser.getEmployeeId);
                      }
                      if (_checkbox2) {
                        department = "Electric";
                        int departmentChiefID = 77;
                        db.changeTaskDepartmentAndStaffID(
                            task,
                            department,
                            departmentChiefID,
                            this.chunk.currentUser.getEmployeeId);
                      }
                      if (_checkbox3) {
                        department = "Construction";
                        int departmentChiefID = 1002;
                        db.changeTaskDepartmentAndStaffID(
                            task,
                            department,
                            departmentChiefID,
                            this.chunk.currentUser.getEmployeeId);
                      }
                      if (_checkbox4) {
                        department = "Technic";
                        int departmentChiefID = 1003;
                        db.changeTaskDepartmentAndStaffID(
                            task,
                            department,
                            departmentChiefID,
                            this.chunk.currentUser.getEmployeeId);
                      }

                      //print("1"+_checkbox1.toString()+"\n"+"2"+_checkbox2.toString()+"\n"+"3"+_checkbox3.toString()+"\n"+"4"+_checkbox4.toString()+"\n");
                      // CustomLocation c= await db.readLocationWithTaskID(1);
                      // print("Ege"+c.getCampus);
                      // Position p=Position(longitude: 26.324, latitude: 40.132, timestamp: DateTime.now(), accuracy: 0, altitude: 0, heading: 0, speed: 0, speedAccuracy: 0);
                      //CustomLocation c=CustomLocation(id, TaskID, campus, floor, roomID, location);
                      // CustomLocation c=CustomLocation(16, 3, "Etlik", 1, "C555", p);
                      // db.writeLocationToDatabase(c);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TransferManager(this.chunk)),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff8645ff),
                        fixedSize: const Size(311, 53),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(17))),
                    child: const Text(
                      'Yönlendir',
                      style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                          fontFamily: 'WorkSans'),
                    ),
                  ),
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

IconData _getDepartmentIcon(String department) {
  switch (department) {
    case 'Electric':
      return Icons.lightbulb_rounded;
    case 'Construction':
      return Icons.construction_rounded;
    case 'Technic':
      return Icons.cable;
    case 'Water':
      return Icons.water_drop;
    case 'Request':
      return Icons.favorite;
    default:
      return Icons.help_outline;
  }
}

Color _getIconColor(String department) {
  switch (department) {
    case 'Electric':
      return AppColors.egeYellow;
    case 'Construction':
      return AppColors.construction;
    case 'Technic':
      return AppColors.cable;
    case 'Water':
      return AppColors.waterDrop;
    case 'Request':
      return AppColors.heart;
    default:
      return AppColors.egeNavy;
  }
}
