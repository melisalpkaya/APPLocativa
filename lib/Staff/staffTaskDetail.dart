import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:locativa/DatabaseHelper.dart';
import 'package:locativa/Task.dart';
import 'package:locativa/static_data.dart';
import '../Chunk.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

import '../FaultReport/categories.dart';
import '../ChangePassword/changePassword.dart';
import '../ColorsClass/colors.dart';
import 'staff.dart';
import '../loginPage.dart';
import '../notifications.dart';

class TaskDetailStaff extends StatefulWidget {
  Chunk chunk = Chunk.fromChunk();
  TaskDetailStaff(this.chunk);
  TaskDetailStaffState createState() => TaskDetailStaffState(chunk);
}

class TaskDetailStaffState extends State<TaskDetailStaff> {
  Chunk chunk = Chunk.fromChunk();
  TaskDetailStaffState(this.chunk);
  TextEditingController dateController = TextEditingController();
  DatabaseHelper db = DatabaseHelper();
  bool isEditable = false;
  bool isDialogShowing = false;
  List<File> _imageFiles = [];
  List<String> urlToDB = [];
  final _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    List<XFile> pickedFiles = [];
    // Set maximum image count to 10
    final maxImageCount = 1;

    // Loop until the maximum image count is reached
    while (pickedFiles.length < maxImageCount) {
      final pickedFile = await _picker.pickImage(source: source);
      if (pickedFile == null) break;

      pickedFiles.add(pickedFile);
    }

    setState(() {
      isDialogShowing = true;
      _imageFiles = pickedFiles.map((e) => File(e.path)).toList();
      StaticData.selectedImages = _imageFiles;
    });
  }

  @override
  void initState() {
    super.initState();
    dateController.text = "";
  }

  int _selectedButton = 0;
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
        alignment: Alignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.background, // arka plan rengi
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 670,
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.only(left: 25, top: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Arıza Bildirimi",
                            style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.normal,
                                fontFamily: 'WorkSans',
                                color: AppColors.text.withOpacity(0.5)),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          //Burası Task Değişince Değişecek
                          //Task Title olacak
                          Text(this.chunk.getTask().getType(),
                              style: TextStyle(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'WorkSans',
                                  color: AppColors.navy)),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                          ),
                          SizedBox(width: 8.0),
                          Text("Konum",
                              style: TextStyle(
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'WorkSans',
                                  color: AppColors.text)),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                                //Özgenin Adresine çevrilecek Databasede Location (geopoint olarak tutmaktan vazgeçilebilir)
                                // this.chunk.getLocation().getCampus +
                                //     ", Floor: " +
                                //     this.chunk.getLocation().getFloor.toString() +
                                //     ", RoomID:" +
                                //     this
                                //         .chunk
                                //         .getLocation()
                                //         .getRoomID+"\n" +
                                this.chunk.getLocation().getAddress,
                                style: TextStyle(
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.normal,
                                    fontFamily: 'WorkSans',
                                    color: AppColors.text.withOpacity(0.7))),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                          ),
                          SizedBox(width: 8.0),
                          Text("Atanan Teslim Tarihi",
                              style: TextStyle(
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'WorkSans',
                                  color: AppColors.text)),
                        ],
                      ),
                      SizedBox(
                        height: 10,
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
                                  this
                                          .chunk
                                          .getTask()
                                          .getDueDate()
                                          .day
                                          .toString() +
                                      "." +
                                      this
                                          .chunk
                                          .getTask()
                                          .getDueDate()
                                          .month
                                          .toString() +
                                      "." +
                                      this
                                          .chunk
                                          .getTask()
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
                                this
                                        .chunk
                                        .getTask()
                                        .getDueDate()
                                        .hour
                                        .toString() +
                                    ":" +
                                    this
                                        .chunk
                                        .getTask()
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
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'WorkSans',
                                  color: AppColors.text)),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          //Taskın Descriptionı yazılacak
                          Text(this.chunk.getTask().getDescription(),
                              style: TextStyle(
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.normal,
                                  fontFamily: 'WorkSans',
                                  color: AppColors.text.withOpacity(0.7))),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.autorenew,
                          ),
                          SizedBox(width: 8.0),
                          Text("Durum",
                              style: TextStyle(
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'WorkSans',
                                  color: AppColors.text)),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildButton(0, AppColors.egeYellow, "Devam"),
                          _buildButton(1, AppColors.egeRed, "Reddet"),
                          _buildButton(2, AppColors.egeGreen, "Tamamlandı"),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.insert_photo_rounded,
                          ),
                          SizedBox(width: 8.0),
                          Text("Fotoğraflar",
                              style: TextStyle(
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'WorkSans',
                                  color: AppColors.text)),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 80,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (_imageFiles.isNotEmpty)
                              SizedBox(
                                height: 80,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: _imageFiles.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Padding(
                                      padding: EdgeInsets.all(0),
                                      child: Image.file(_imageFiles[index]),
                                    );
                                  },
                                ),
                              ),
                            if (_imageFiles.isEmpty)
                              SizedBox(
                                width: 80,
                                height: 80,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    OutlinedButton(
                                      onPressed: () =>
                                          _pickImage(ImageSource.camera),
                                      child: Icon(
                                        Icons.add,
                                        size: 20,
                                        color: Colors.black,
                                      ),
                                      style: OutlinedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                        ),
                                        padding: EdgeInsets.zero,
                                      ),
                                    ),
                                    // Diğer butonlar buraya eklenebilir
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 35, right: 35, top: 15),
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_selectedButton == 0) {
                              db.changeTaskStatusFromStaffPage(
                                  this.chunk.getTask(),
                                  "Assigned",
                                  this.chunk.currentUser.getEmployeeId);
                            }
                            if (_selectedButton == 1) {
                              db.changeTaskStatusFromStaffPage(
                                  this.chunk.getTask(),
                                  "Rejected",
                                  this.chunk.currentUser.getEmployeeId);
                            }
                            if (_selectedButton == 2) {
                              await db.sendResultImageToDb(
                                  StaticData.selectedImages,
                                  this.chunk.getTask().getTaskID());
                              urlToDB = StaticData.urls;
                              db.updateTaskPicturesInDone(
                                  chunk.getTask(), urlToDB);
                              db.changeTaskStatusFromStaffPage(
                                  this.chunk.getTask(),
                                  "Done",
                                  this.chunk.currentUser.getEmployeeId);
                            }
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Staff(this.chunk)),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.egeGreen,
                              fixedSize: const Size(243, 43),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(17))),
                          child: const Text('Kaydet',
                              style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'WorkSans',
                                  color: AppColors.background)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
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
          ),
        ],
      ),
    );
  }

  Widget _buildButton(int index, Color backgroundColor, String text) {
    var isSelected = index == _selectedButton;
    return Padding(
      padding: const EdgeInsets.only(right: 5),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor:
              isSelected ? backgroundColor : AppColors.text.withOpacity(0.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(17),
          ),
          elevation:
              0, // butonun gölgesini kaldırmak için elevation özelliğini 0'a ayarlayın
          minimumSize: Size(89, 37), // butonun minimum boyutunu ayarlayın
        ),
        onPressed: () {
          setState(() {
            _selectedButton = index;
          });
        },
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white, // yazı rengini beyaz olarak ayarlayın
          ),
        ),
      ),
    );
  }
}
