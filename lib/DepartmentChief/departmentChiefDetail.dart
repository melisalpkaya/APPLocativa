import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:locativa/DatabaseHelper.dart';
import 'package:locativa/DepartmentChief/departmentChiefHp.dart';
import '../Chunk.dart';
import '../Employee.dart';
import '../FaultReport/categories.dart';
import '../ChangePassword/changePassword.dart';
import '../ColorsClass/colors.dart';
import '../loginPage.dart';
import '../notifications.dart';

class DepChiefDetailPage extends StatefulWidget {
  Chunk chunk = Chunk.fromChunk();
  DepChiefDetailPage(this.chunk);
  DepChiefDetail createState() => DepChiefDetail(this.chunk);
}

class DepChiefDetail extends State<DepChiefDetailPage> {
  Chunk chunk = Chunk.fromChunk();
  DepChiefDetail(this.chunk);
  TextEditingController dateController = TextEditingController();
  DatabaseHelper db = DatabaseHelper();
  List<Employee> employeeList = [];
  //List<SimpleDialogItem> dialogItems = [];
  int? selectedStaff;
  @override
  void initState() {
    super.initState();
    dateController.text = "";
    //selectedStaff = chunk.currentUser.getEmployeeId;
    loadEmployeeList().then((value) => print("Employee List loaded"));
  }

  Future<void> loadEmployeeList() async {
    List<Employee> list = await taskReloadForBeginning();
    setState(() {
      employeeList = list;
    });
  }

  Future<List<Employee>> taskReloadForBeginning() async {
    return await db
        .employeesWithInDepartment(chunk.currentUser.getEmployeeDepartment);
  }

  //for calendar
  DateTime currentDate = DateTime.now();
  TimeOfDay currentTime = TimeOfDay.now();
  String? selectedDate;
  String? selectedTime;
  IconData? selectedIcon;
  Color selectedColor = Colors.transparent; // Başlangıçta seçili bir renk yok

  Future<void> dateTimePicker(context) async {
    final DateTime? userSelectedDate = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2025, 9, 20),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: AppColors.purple, // "OK" butonu rengi
            accentColor: AppColors.purple, // Seçilen tarih rengi
            colorScheme: ColorScheme.light(
                primary: AppColors.purple), // "Cancel" butonu rengi
            buttonTheme: ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (userSelectedDate != null) {
      final TimeOfDay? userSelectedTime = await showTimePicker(
        context: context,
        initialTime: currentTime,
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.light().copyWith(
              primaryColor: AppColors.purple, // "OK" butonu rengi
              accentColor: AppColors.purple, // Saat seçim rengi
              colorScheme: ColorScheme.light(
                  primary: AppColors.purple), // "Cancel" butonu rengi
              buttonTheme: ButtonThemeData(
                textTheme: ButtonTextTheme.primary,
              ),
            ),
            child: child!,
          );
        },
      );

      if (userSelectedTime != null) {
        setState(() {
          currentDate = DateTime(
            userSelectedDate.year,
            userSelectedDate.month,
            userSelectedDate.day,
            userSelectedTime.hour,
            userSelectedTime.minute,
          );
          this.chunk.setDateTime = currentDate;
          currentTime = userSelectedTime;
          selectedDate =
              "${currentDate.day}/${currentDate.month}/${currentDate.year} ";
          selectedTime = " ${currentTime.format(context)}";
          print("DateTime $selectedDate");
          print("DateTime $selectedTime ");
        });
      }
    }
  }

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
                  height: 440,
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
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text("Arıza Bildirimi",
                                style: TextStyle(
                                    fontFamily: 'WorkSans',
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.normal,
                                    color: AppColors.text2)),
                            SizedBox(
                              height: 25,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(chunk.getTaskForDetailPage.getTitle(),
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
                        Row(
                          children: [
                            Icon(
                              Icons.people,
                            ),
                            SizedBox(width: 8.0),
                            Padding(
                              padding: const EdgeInsets.only(left: 1.0),
                              child: DropdownButton<int>(
                                value: selectedStaff,
                                onChanged: (newValue) {
                                  setState(() {
                                    selectedStaff = newValue!;
                                  });
                                },
                                items: employeeList.map((employee) {
                                  return DropdownMenuItem(
                                    value: employee.getEmployeeId,
                                    child: Row(
                                      children: [
                                        // İkisi arasında bir boşluk bırakmak için SizedBox ekleyebilirsiniz
                                        Text(
                                            employee.getEmployeeName +
                                                " " +
                                                employee.getEmployeeSurname,
                                            style: TextStyle(
                                              fontFamily: 'WorkSans',
                                              fontWeight: FontWeight.normal,
                                              fontSize: 16.0,
                                              color: AppColors.text,
                                            )),
                                      ],
                                    ),
                                  );
                                }).toList(),
                                hint: Text(
                                  "Atanacak kişiyi seçiniz",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            )
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
                            SizedBox(width: 8.0),
                            Text("Teslim Tarihi",
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
                            GestureDetector(
                              onTap: () {
                                dateTimePicker(context);
                              },
                              child: Image.asset(
                                'assets/images/calendar3.png',
                                width: 40,
                                height: 40,
                              ),
                            ),
                            SizedBox(width: 10),
                            Column(
                              children: [
                                Text(" ${selectedDate ?? ''} ",
                                    style: TextStyle(
                                        fontFamily: 'WorkSans',
                                        fontSize: 17.0,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.text)),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  " ${selectedTime ?? ''}",
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
                          height: 20,
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
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: ElevatedButton(
                    onPressed: () {
                      db.assignTaskToStaff(
                          chunk.getTaskForDetailPage,
                          chunk.currentUser.getEmployeeId,
                          selectedStaff!,
                          chunk.getDateTime);
                      //print(selectedStaff);
                      // print(
                      //     "ata?");
                      ////duedate değiştirilmesi staffId değişikliği status değişikliği yapılacak start date de burada değişecek
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DepartmentChief(this.chunk)),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff8645ff),
                        fixedSize: const Size(311, 53),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(17))),
                    child: const Text(
                      'Ata',
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
