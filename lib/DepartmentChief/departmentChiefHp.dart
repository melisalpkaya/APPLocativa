import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:locativa/DepartmentChief/assignedDepChiefDetail.dart';
import 'package:locativa/DepartmentChief/completedDepChiefDetail.dart';
import '../CustomLocation.dart';
import '../DatabaseHelper.dart';
import '../FaultReport/categories.dart';
import '../ChangePassword/changePassword.dart';
import '../ColorsClass/colors.dart';
import '../Task.dart';
import 'departmentChiefDetail.dart';
import '../loginPage.dart';
import '../notifications.dart';
import '../Chunk.dart';

class DepartmentChief extends StatefulWidget {
  Chunk chunk = Chunk.fromChunk();
  DepartmentChief(this.chunk, {Key? key}) : super(key: key);
  @override
  _DepartmentChiefState createState() => _DepartmentChiefState(this.chunk);
}

class _DepartmentChiefState extends State<DepartmentChief> {
  Chunk chunk = Chunk.fromChunk();
  _DepartmentChiefState(this.chunk, {Key? key});
  int _selectedIndex = 0;
  DatabaseHelper db = DatabaseHelper();
  List<Task> tasks = [];
  List<Task> tasksNew = [];
  List<Task> tasksAssigned = [];
  List<Task> tasksDone = [];

  @override
  void initState() {
    super.initState();
    loadTasks(this.chunk.currentUser.getEmployeeId)
        .then((value) => print("Task Loaded"));
    loadNewTasks(this.chunk.currentUser.getEmployeeId, "Yeni").then((value) =>
        print("TaskNew Loaded DepartmentChief: " + tasksNew.length.toString()));
    chunk.setTaskStatusID = "Yeni";
  }

  Future<void> loadNewTasks(int id, String status) async {
    List<Task> loadedTasks = await taskReloadForBeginning(id, status);
    setState(() {
      tasksNew = loadedTasks;
    });
  }

  Future<void> loadTasks(int id) async {
    List<Task> loadedTasks = await taskReloadForBeginning(id, "Yeni");
    setState(() {
      tasks = loadedTasks;
    });
  }

  Future<List<Task>> taskReloadForBeginning(int id, String status) async {
    return await db.getTasksStaffIDWithStatus(id, status);
  }

  Future<void> loadTasksStateRemaing(
      var selectedItem, String department) async {
    List<Task> loadedTasks = await loadTaskRemaining2(
        chunk.currentUser.getEmployeeId, selectedItem, department);
    setState(() {
      tasks = loadedTasks;
    });
  }

  Future<List<Task>> loadTaskRemaining2(
      int staffID, var selectedItem, String department) async {
    if (selectedItem == 0) {
      //tasks = await db.searchTasksStatusAndDepartment("Yeni",department);
      tasks = await db.getTasksStaffIDWithStatus(staffID, "Yeni");
      List<Task> tasks2 = [];
      if (tasks.length == 0) {
        setState(() {
          tasks = tasks2;
        });
      }
    }
    if (selectedItem == 1) {
      tasks = await db.searchTasksStatusAndDepartment(
          this.chunk.currentUser.getEmployeeId, "Assigned", department);
    }
    if (selectedItem == 2) {
      tasks = await db.searchTasksStatusAndDepartment(
          this.chunk.currentUser.getEmployeeId, "Done", department);
    }
    return tasks;
  }

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
                      "assets/images/profile.png",
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
                        this.chunk.currentUser.getEmployeeName +
                            " " +
                            this.chunk.currentUser.getEmployeeSurname,
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
          Center(
            child: Container(
              height: 42,
              width: 330,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.12),
                    spreadRadius: 3,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
                color: Colors.white,
                borderRadius: BorderRadius.circular(17),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildItem("Yeni", AppColors.egeNavy, 0),
                  _buildItem("Atanan", AppColors.egeYellow, 1),
                  _buildItem("Tamamlanan", AppColors.egeGreen, 2),
                ],
              ),
            ),
          ),

          // Listview eklendi
          Expanded(
            child: ListView.separated(
              physics: ClampingScrollPhysics(),
              padding: EdgeInsets.all(20.0),
              //DatabaseHelper db=new DatabaseHelper();
              //db.FindAssignedTaskWithEmployeeID(this.currentUser.getEmployeeId());
              //itemCount'a atama yukardaki gibi olacak
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
                          size: 33,
                          color: _getIconColor(tasks[index].getDepartment())),
                    ),
                    title: Text(
                      tasks[index].title,
                      style: TextStyle(
                        fontFamily: 'WorkSans',
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        color: AppColors.navy,
                      ),
                    ),
                    subtitle: Text(
                      tasks[index].getDescription(),
                      maxLines: 1,
                      style: TextStyle(
                        fontFamily: 'WorkSans',
                        color: AppColors.text2,
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    onTap: () async {
                      //print(index);
                      this.chunk.setTaskForDetailPage = tasks[index];
                      CustomLocation location = await db
                          .readLocationWithTaskID(tasks[index].getTaskID());
                      chunk.setLocation(location);
                      print("LocationID şef home: " +
                          chunk.getLocation().getlocationID.toString());
                      print("TaskID şef home: " +
                          chunk.getTaskForDetailPage.getTaskID().toString());
                      if (_selectedIndex == 0) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  DepChiefDetailPage(this.chunk)),
                        );
                      } else if (_selectedIndex == 1) {
                        chunk.setEmployeeForDetailPage =
                            await db.FindEmployeeWithTaskID(
                                chunk.getTaskForDetailPage.getTaskID());
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  AssignedDepChiefDetailPage(this.chunk)),
                        );
                      } else {
                        chunk.setEmployeeForDetailPage =
                            await db.FindEmployeeWithTaskID(
                                chunk.getTaskForDetailPage.getTaskID());
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  CompletedDepChiefDetailPage(this.chunk)),
                        );
                      }
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
                          // Icona tıklandığında yapılacak işlemler
                          chunk.setNewTasksNotification = tasksNew;
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

  Widget _buildItem(String text, Color backgroundColor, int index) {
    final isSelected = index == _selectedIndex;
    final textColor = isSelected ? Colors.white : AppColors.text2;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
          this.chunk.setTaskStatusID = _getTaskStatusId(_selectedIndex);
          print(this.chunk.getTaskStatusID);
          //this.chunk.setTaskStatusID(_selectedIndex);

          loadTasksStateRemaing(
              _selectedIndex, this.chunk.currentUser.getEmployeeDepartment);
        });
      },
      child: Container(
        height: 38,
        width: 110,
        decoration: BoxDecoration(
          color: isSelected ? backgroundColor : Colors.white,
          borderRadius: BorderRadius.circular(17),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontFamily: 'WorkSans',
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
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

String _getTaskStatusId(int id) {
  switch (id) {
    case 0:
      return "Yeni";
    case 1:
      return "Atandı";
    case 2:
      return "Tamamlandı";
    default:
      return "Tamamlanmadı";
  }
}
