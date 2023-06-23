import 'dart:ui';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:location/location.dart';
import 'package:locativa/Chunk.dart';
import 'package:locativa/DatabaseHelper.dart';

import '../CustomLocation.dart';
import '../FaultReport/categories.dart';
import '../ChangePassword/changePassword.dart';
import '../ColorsClass/colors.dart';
import '../Task.dart';
import '../loginPage.dart';
import '../notifications.dart';
import 'staffTaskDetail.dart';

class Staff extends StatefulWidget {
  Chunk chunk = Chunk.fromChunk();
  Staff(this.chunk);
  @override
  _StaffState createState() => _StaffState(this.chunk);
}

class _StaffState extends State<Staff> {
  Chunk chunk = Chunk.fromChunk();
  DatabaseHelper db = DatabaseHelper();
  _StaffState(this.chunk);
  List<Task> tasksAll = [];
  List<Task> tasks = [];
  List<Task> tasksRejected = [];
  List<Task> tasksNew = [];
  List<Task> tasksDone = [];
  List<Task> tasksAssigned = [];

  @override
  void initState() {
    loadTasks(this.chunk.currentUser.getEmployeeId);
    readTasksForPage(this.chunk.currentUser.getEmployeeId, "Assigned");
    readTasksForPage(this.chunk.currentUser.getEmployeeId, "Done");
    readTasksForPage(this.chunk.currentUser.getEmployeeId, "Rejected");
    readTasksForPage(this.chunk.currentUser.getEmployeeId, "Yeni");
  }

  Future<List<Task>> readTasksForCards(int id, String status) async {
    return await db.getTasksStaffIDWithStatus(id, status);
  }

  Future<void> readTasksForPage(int id, String status) async {
    List<Task> l1 = await readTasksForCards(id, status);
    List<Task> l2 =
        await db.rejectedTaskFromEmployee(chunk.currentUser.getEmployeeId);
    setState(() {
      if (status == "Yeni") {
        tasksNew = l1;
      }
      if (status == "Assigned") {
        tasksAssigned = l1;
      }
      if (status == "Rejected") {
        tasksRejected = l2;
      }
      if (status == "Done") {
        tasksDone = l1;
      }
    });
  }

  Future<void> loadTasks(int id) async {
    List<Task> loadedTasks =
        await taskReloadForBeginning(this.chunk.currentUser.getEmployeeId);
    setState(() {
      tasks = loadedTasks;
      tasksAll = loadedTasks;
    });
  }

  Future<List<Task>> taskReloadForBeginning(int id) async {
    return await db.searchTaskWithStaffID(id);
  }

  String? valueChoose = null;
  List<String> listItem = [
    'Tüm İşler',
    'Yeni',
    'Devam Eden',
    'Reddedilen',
    'Tamamlanan'
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 60),
          Container(
            decoration: BoxDecoration(
              color: AppColors.background,
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      "assets/images/worker.png",
                      fit: BoxFit.cover,
                      height: 64,
                      width: 64,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hoşgeldin,',
                        style: TextStyle(
                          color: AppColors.text3,
                          fontFamily: 'WorkSans',
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        chunk.currentUser.name +
                            " " +
                            chunk.currentUser.getEmployeeSurname,
                        style: TextStyle(
                          color: AppColors.text,
                          fontFamily: 'WorkSans',
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          //yeni butonu
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () async {
                      tasksNew = await db.getTasksStaffIDWithStatus(
                          chunk.currentUser.getEmployeeId, "Yeni");
                      setState(() {
                        tasks = tasksNew;
                      });
                    },
                    child: Container(
                      height: 133,
                      width: 166,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(17),
                        color: AppColors.egeNavy,
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 10,
                            left: 15,
                            child: Icon(
                              Icons.flag_outlined,
                              color: AppColors.white,
                              size: 50,
                            ),
                          ),
                          Positioned(
                            bottom: 23,
                            left: 20,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Yeni',
                                  style: TextStyle(
                                    color: AppColors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 3),
                                Text(
                                  tasksNew.length.toString() + ' iş',
                                  style: TextStyle(
                                    color: AppColors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  //devam eden butonu
                  GestureDetector(
                    onTap: () async {
                      tasksAssigned = await db.getTasksStaffIDWithStatus(
                          chunk.currentUser.getEmployeeId, "Assigned");
                      setState(() {
                        tasks = tasksAssigned;
                      });
                    },
                    child: Container(
                      height: 80,
                      width: 166,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(17),
                        color: AppColors.egeYellow,
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 10,
                            left: 125,
                            child: Icon(
                              Icons.autorenew,
                              color: AppColors.white,
                              size: 32,
                            ),
                          ),
                          Positioned(
                            bottom: 20,
                            left: 18,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Devam eden',
                                  style: TextStyle(
                                    color: AppColors.white,
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 3),
                                Text(
                                  tasksAssigned.length.toString() + ' iş',
                                  style: TextStyle(
                                    color: AppColors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal,
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
              Column(
                children: [
                  //reddedilen butonu
                  GestureDetector(
                    onTap: () async {
                      tasksRejected = await db.rejectedTaskFromEmployee(
                          chunk.currentUser.getEmployeeId);
                      setState(() {
                        tasks = tasksRejected;
                      });
                    },
                    child: Container(
                      height: 75,
                      width: 166,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(17),
                        color: AppColors.egeRed,
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 9,
                            left: 125,
                            child: Icon(
                              Icons.cancel_outlined,
                              color: AppColors.white,
                              size: 28,
                            ),
                          ),
                          Positioned(
                            bottom: 15,
                            left: 18,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Reddedilen',
                                  style: TextStyle(
                                    color: AppColors.white,
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 3),
                                Text(
                                  tasksRejected.length.toString() + ' iş',
                                  style: TextStyle(
                                    color: AppColors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  //tamamlanan butonu
                  GestureDetector(
                    onTap: () async {
                      tasksDone = await db.getTasksStaffIDWithStatus(
                          chunk.currentUser.getEmployeeId, "Done");
                      setState(() {
                        tasks = tasksDone;
                      });
                    },
                    child: Container(
                      height: 140,
                      width: 166,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(17),
                        color: AppColors.egeGreen,
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 30,
                            left: 15,
                            child: Icon(
                              Icons.check_circle_outline,
                              color: AppColors.white,
                              size: 45,
                            ),
                          ),
                          Positioned(
                            bottom: 15,
                            left: 18,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Tamamlanan',
                                  style: TextStyle(
                                    color: AppColors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 3),
                                Text(
                                  tasksDone.length.toString() + ' iş',
                                  style: TextStyle(
                                    color: AppColors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
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
            ],
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
            child: Column(
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  Container(
                    padding: EdgeInsets.only(left: 16, right: 16),
                    child: DropdownButton(
                      dropdownColor: Colors.white,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.navy,
                          fontSize: 15),
                      value: valueChoose,
                      onChanged: (newValue) async {
                        if (newValue == "Tüm İşler") {
                          tasks = tasksAll;
                          print(tasksAll.length);
                        }
                        if (newValue == "Yeni") {
                          readTasksForPage(
                              this.chunk.currentUser.getEmployeeId, "Yeni");
                          tasks = tasksNew;
                          tasksNew = await db.getTasksStaffIDWithStatus(
                              chunk.currentUser.getEmployeeId, "Yeni");
                        }
                        if (newValue == "Devam Eden") {
                          tasksAssigned = await db.getTasksStaffIDWithStatus(
                              chunk.currentUser.getEmployeeId, "Assigned");
                          readTasksForPage(
                              this.chunk.currentUser.getEmployeeId, "Assigned");
                          tasks = tasksAssigned;
                        }
                        if (newValue == "Reddedilen") {
                          tasksRejected = await db.rejectedTaskFromEmployee(
                              chunk.currentUser.getEmployeeId);
                          tasks = tasksRejected;
                        }
                        if (newValue == "Tamamlanan") {
                          tasksDone = await db.getTasksStaffIDWithStatus(
                              chunk.currentUser.getEmployeeId, "Done");
                          readTasksForPage(
                              this.chunk.currentUser.getEmployeeId, "Done");
                          tasks = tasksDone;
                        }
                        setState(() {
                          valueChoose = newValue!;
                          //tasksNew=tasksNew;
                          print(valueChoose);
                        });
                      },
                      items: listItem.map((valueItem) {
                        return DropdownMenuItem(
                          value: valueItem,
                          child: Text(valueItem),
                        );
                      }).toList(),
                      hint: Text(
                        listItem[0],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ])
              ],
            ),
          ),
          SizedBox(height: 2),
          // Listview eklendi
          Expanded(
            child: ListView.separated(
              physics: ClampingScrollPhysics(),
              padding: EdgeInsets.all(8.0),
              itemCount: tasks.length, // Örneğin 10 öğe olsun
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.12),
                        spreadRadius: 3,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(17),
                  ),
                  child: ListTile(
                    leading: Container(
                      height: 50.0,
                      width: 50.0,
                      child: Icon(
                          _getDepartmentIcon(tasks[index].getDepartment()),
                          size: 32,
                          color: _getIconColor(tasks[index].getDepartment())),
                    ),
                    title: Text(
                      tasks[index].getTitle(),
                      style: TextStyle(
                        fontFamily: 'WorkSans',
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: AppColors.navy,
                      ),
                    ),
                    subtitle: Text(
                      tasks[index].getDescription(),
                      style: TextStyle(
                        fontFamily: 'WorkSans',
                        color: AppColors.text2,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    trailing: Icon(
                      Icons.circle,
                      size: 15,
                      color: _getStatusColor(tasks[index].getStatus()),
                    ),
                    onTap: () async {
                      this.chunk.setTask(tasks[index]);
                      CustomLocation location = await db
                          .readLocationWithTaskID(tasks[index].getTaskID());
                      this.chunk.setLocation(location);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TaskDetailStaff(this.chunk)),
                      );
                    },
                    enabled: true,
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return SizedBox(height: 8);
              },
            ),
          ),
          GestureDetector(
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
                          // Icona tıklandığında yapılacak işlemler
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChangePsw(chunk)),
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
                          // Icona tıklandığında yapılacak işlemler
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
                          this.chunk.setNewTasksNotification = tasksNew;
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
    default:
      return Icons.help_outline;
  }
}

Color _getStatusColor(String status) {
  switch (status) {
    case 'Done':
      return AppColors.egeGreen;
    case 'Assigned':
      return AppColors.egeYellow;
    case 'Rejected':
      return AppColors.egeRed;
    case 'Yeni':
      return AppColors.egeNavy;
    default:
      return AppColors.egeNavy;
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
