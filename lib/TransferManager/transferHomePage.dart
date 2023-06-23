import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:locativa/CustomLocation.dart';
import 'package:locativa/TransferManager/transferDetail.dart';
import '../Chunk.dart';
import '../../FaultReport/categories.dart';
import '../ChangePassword/changePassword.dart';
import '../ColorsClass/colors.dart';
import '../DatabaseHelper.dart';
import '../Task.dart';
import '../loginPage.dart';
import '../notifications.dart';

class TransferManager extends StatefulWidget {
  Chunk chunk = Chunk.fromChunk();
  TransferManager(this.chunk, {Key? key}) : super(key: key);
  @override
  _TransferManagerState createState() => _TransferManagerState(this.chunk);
}

class _TransferManagerState extends State<TransferManager> {
  var _selectedIndex = 0;
  Chunk chunk = Chunk.fromChunk();
  DatabaseHelper db = DatabaseHelper();
  List<Task> tasks = [];
  List<Task> tasksNew = [];
  _TransferManagerState(Chunk chunk) {
    this.chunk = chunk;
  }

  // Future<void> loadTasksStateRemaing(var selectedItem) async {
  //   List<Task> loadedTasks = await taskReloadForRemaining(selectedItem);
  //   setState(() {
  //     tasks = loadedTasks;
  //   });
  // }

  @override
  void initState() {
    super.initState();
    loadTasks().then((value) => print("Task Loaded"));
    loadNewTasks().then((value) => print("TaskNew Loaded"));
  }

  Future<void> loadNewTasks() async {
    List<Task> loadedTasks = await taskReloadForBeginning();
    setState(() {
      tasksNew = loadedTasks;
    });
  }

  Future<void> loadTasks() async {
    List<Task> loadedTasks = await taskReloadForBeginning();
    setState(() {
      tasks = loadedTasks;
    });
  }

  Future<List<Task>> taskReloadForBeginning() async {
    return await db.searchTaskWithStatusWithTransferManagerID(
        this.chunk.currentUser.getEmployeeId, 'Yeni');
  }

  Future<void> loadTasksStateRemaing(var selectedItem) async {
    List<Task> loadedTasks = await loadTaskRemaining2(selectedItem);
    setState(() {
      tasks = loadedTasks;
    });
  }

  Future<List<Task>> loadTaskRemaining2(int selectedItem) async {
    if (selectedItem == 0) {
      tasks = await db.searchTaskWithStatusWithTransferManagerID(
          this.chunk.currentUser.getEmployeeId, "Yeni");
    }
    if (selectedItem == 1) {
      tasks = await db.AssignedTasksForTransferManagerHp(
          this.chunk.currentUser.getEmployeeId);
    }
    if (selectedItem == 2) {
      tasks = await db.searchTaskWithStatus("Done");
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
                          size: 40,
                          color: _getIconColor(tasks[index].getDepartment())),
                    ),
                    title: Text(
                      tasks[index].getTitle(),
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
                      chunk.setTaskForDetailPage = tasks[index];
                      CustomLocation location = await db
                          .readLocationWithTaskID(tasks[index].getTaskID());
                      print("location.:" + location.getRoomID);
                      chunk.setLocation(location);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                TransferManagerDetailPage(this.chunk)),
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
            onTap: () {
              print("?");
            },
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
                          chunk.setNewTasksNotification = tasksNew;
                          print(chunk.getNewTasksNotification.length);
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

  Widget _buildItem(String text, Color backgroundColor, int index) {
    var isSelected = index == _selectedIndex;
    var textColor = isSelected ? Colors.white : AppColors.text2;

    return GestureDetector(
      onTap: () {
        // onTap olayına taşıdık
        setState(() {
          _selectedIndex = index;
          // chunk.setTaskStatusID = _selectedIndex;
          loadTasksStateRemaing(_selectedIndex);
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
