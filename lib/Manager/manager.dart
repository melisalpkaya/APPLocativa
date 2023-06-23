import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:locativa/ChangePassword/changePassword.dart';
import 'package:locativa/DatabaseHelper.dart';
import 'package:locativa/Manager/managerDetail.dart';
import 'package:locativa/homePage.dart';
import 'package:locativa/notifications.dart';
import '../Chunk.dart';
import '../CustomLocation.dart';
import '../FaultReport/categories.dart';
import '../ColorsClass/colors.dart';
import '../Task.dart';
import '../loginPage.dart';

class ManagerHomePage extends StatefulWidget {
  Chunk chunk = Chunk.fromChunk();
  ManagerHomePage(this.chunk);

  @override
  _ManagerHomePageState createState() => _ManagerHomePageState(this.chunk);
}

class _ManagerHomePageState extends State<ManagerHomePage> {
  Chunk chunk = Chunk.fromChunk();
  List<Task> allTasks = [];
  DatabaseHelper db = DatabaseHelper();
  _ManagerHomePageState(this.chunk);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadTasks(DateTime.now());
  }

  Future<void> loadTasks(DateTime dateTime) async {
    List<Task> loadedTasks = await taskReloadForBeginning(dateTime);
    setState(() {
      allTasks = loadedTasks;
    });
  }

  Future<List<Task>> taskReloadForBeginning(DateTime dateTime) async {
    return await db.searchTasksWithFinishDate(dateTime);
  }

  Future<void> loadTasksRemaining(DateTime dateTime) async {
    List<Task> loadedTasks = await taskReloadForRemaining(dateTime);
    setState(() {
      allTasks = loadedTasks;
    });
  }

  Future<List<Task>> taskReloadForRemaining(DateTime dateTime) async {
    return await db.searchTasksWithFinishDate(dateTime);
  }

  DateTime _selectedDate = DateTime.now();

  void _incrementDate() {
    setState(() {
      //loadTasksRemaining(_selectedDate);
      _selectedDate = DateTime(_selectedDate.year, _selectedDate.month + 1, 30);
      print(_selectedDate.month.toString());
      loadTasksRemaining(_selectedDate);
    });
  }

  void _decrementDate() {
    setState(() {
      //loadTasksRemaining(_selectedDate);
      _selectedDate = DateTime(_selectedDate.year, _selectedDate.month - 1, 30);
      print(_selectedDate.month.toString());
      loadTasksRemaining(_selectedDate);
    });
  }

  String _getMonthName(int month) {
    switch (month) {
      case 1:
        return "Ocak";
      case 2:
        return "Şubat";
      case 3:
        return "Mart";
      case 4:
        return "Nisan";
      case 5:
        return "Mayıs";
      case 6:
        return "Haziran";
      case 7:
        return "Temmuz";
      case 8:
        return "Ağustos";
      case 9:
        return "Eylül";
      case 10:
        return "Ekim";
      case 11:
        return "Kasım";
      case 12:
        return "Aralık";
      default:
        return "";
    }
  }

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
            decoration: const BoxDecoration(color: AppColors.navy),
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
                          height: 66,
                          width: 66,
                        )
                      ],
                    ),
                    SizedBox(height: 15),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Hoşgeldin,",
                            style: TextStyle(
                              fontFamily: 'WorkSans',
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          chunk.currentUser.getEmployeeName +
                              " " +
                              chunk.currentUser.getEmployeeSurname,
                          style: TextStyle(
                            fontFamily: 'WorkSans',
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
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
            top: size.height * 0.28,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(42),
                  topRight: Radius.circular(42),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: _decrementDate,
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            "${_getMonthName(_selectedDate.month)} , ${_selectedDate.year}",
                            style: TextStyle(
                              fontFamily: 'WorkSans',
                              color: AppColors.text,
                              fontWeight: FontWeight.bold,
                              fontSize: 19, // adjust the font size of the text
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.arrow_forward),
                        onPressed: _incrementDate,
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  Expanded(
                    child: ListView.separated(
                      physics: ClampingScrollPhysics(),
                      padding: EdgeInsets.all(8.0),
                      itemCount: allTasks.length,
                      itemBuilder: (context, index) {
                        return Container(
                          height: 184,
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
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10.0),
                                          child: Icon(
                                            _getDepartmentIcon(allTasks[index]
                                                .getDepartment()),
                                            size: 51,
                                            color: AppColors.navy,
                                          ),
                                        ),
                                        Icon(
                                          Icons.circle_rounded,
                                          size: 15,
                                          color: _getStatusColor(
                                              allTasks[index].getStatus()),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10.0),
                                          child: Row(
                                            children: List.generate(
                                              5,
                                              (starIndex) => Icon(
                                                starIndex <
                                                        allTasks[index]
                                                            .getTaskScore() //egeee 4 yerine dbden task rating gelsin
                                                    ? Icons.star
                                                    : Icons.star_border,
                                                color: AppColors.yellow,
                                                size: 18,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 16.0),
                                      child: Text(
                                        // "TaskID:"+allTasks[index].getTaskID().toString()+" "+
                                        allTasks[index].getTitle(),
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Work Sans',
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 16.0, top: 10.0),
                                      child: Text(
                                        // "Score:"+allTasks[index].getTaskScore().toString()+
                                        allTasks[index].getDescription() +
                                            "\n\nFinished on: " +
                                            allTasks[index]
                                                .getFinishDate()
                                                .day
                                                .toString() +
                                            "." +
                                            allTasks[index]
                                                .getFinishDate()
                                                .month
                                                .toString() +
                                            "." +
                                            allTasks[index]
                                                .getFinishDate()
                                                .year
                                                .toString(),
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w300,
                                          fontFamily: 'Work Sans',
                                          color: AppColors.text3,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    right: 10.0, top: 60.0),
                                child: ElevatedButton(
                                  onPressed: () async {
                                    CustomLocation location =
                                        await db.readLocationWithTaskID(
                                            allTasks[index].getTaskID());
                                    this.chunk.setLocation(location);
                                    this.chunk.setEmployeeForDetailPage =
                                        await db.FindEmployeeWithTaskID(
                                            allTasks[index].getTaskID());
                                    print("UStanın adı" +
                                        this
                                            .chunk
                                            .getEmployeeForDetailPage
                                            .getEmployeeName);
                                    this.chunk.setTaskForDetailPage =
                                        allTasks[index];
                                    print("ManagerTaskID:" +
                                        chunk.getTaskForDetailPage
                                            .getTaskID()
                                            .toString());
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ManagerDetailPage(this.chunk)),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.purple,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    minimumSize: Size(49, 40),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.arrow_forward,
                                        color: AppColors.background,
                                        size: 20,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(height: 30);
                      },
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppColors.background,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(25, 0, 15, 0),
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
                                        builder: (context) =>
                                            ChangePsw(this.chunk)),
                                  );
                                },
                                child: Container(
                                  width: 35,
                                  height: 35,
                                  margin: EdgeInsets.only(right: 25),
                                  child: Icon(
                                    Icons.key,
                                    color: AppColors.navy,
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
                                            Categories(this.chunk)),
                                  );
                                },
                                child: Container(
                                  width: 35,
                                  height: 35,
                                  margin: EdgeInsets.only(right: 25),
                                  child: Icon(
                                    Icons.add_circle_outline,
                                    color: AppColors.navy,
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
                                    color: AppColors.navy,
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
                                    desc:
                                        'Çıkış yapmak istediğinize emin misiniz?',
                                    btnOkText: 'EVET',
                                    btnOkColor: AppColors.navy,
                                    buttonsTextStyle: TextStyle(
                                      color: AppColors.white, // Text color
                                      fontFamily: 'WorkSans', // Font family
                                      fontSize: 18, // Font size
                                      fontWeight:
                                          FontWeight.bold, // Font weight
                                    ),
                                    titleTextStyle: TextStyle(
                                      color: AppColors.navy, // Title text color
                                      fontSize: 20, // Title text size
                                      fontWeight:
                                          FontWeight.bold, // Title text weight
                                    ),
                                    buttonsBorderRadius:
                                        BorderRadius.circular(10),
                                    showCloseIcon: true,
                                    body: GestureDetector(
                                      onTap: () {
                                        Navigator.pop(
                                            context); // Dismiss the dialog when tapped outside
                                      },
                                      child: Center(
                                        child: Text(
                                          'Çıkış yapmak istediğinize emin misiniz?',
                                          style: TextStyle(
                                              fontStyle: FontStyle.italic),
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
                                      color: AppColors.navy, size: 27),
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
            ),
          ),
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
    default:
      return AppColors.egeNavy;
  }
}
