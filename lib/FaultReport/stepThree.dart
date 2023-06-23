import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:locativa/Employee.dart';
import 'package:flutter/services.dart';
import 'package:locativa/FaultReport/successfull2.dart';
import 'package:locativa/static_data.dart';
import '../Chunk.dart';
import '../ColorsClass/colors.dart';
import '../DatabaseHelper.dart';
import '../Task.dart';

class StepThree extends StatefulWidget {
  Chunk chunk = Chunk.fromChunk();
  StepThree(this.chunk);
  @override
  StepThreeState createState() => StepThreeState(this.chunk);
}

class StepThreeState extends State<StepThree> {
  Chunk chunk = Chunk.fromChunk();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _explanationController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  List<String> urlToDB=[];
  StepThreeState(this.chunk);
  bool _isToggleOn = false;
  bool _showOptional = false;

  @override
  void dispose() {
    _titleController.dispose();
    _explanationController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  bool isFieldsEmpty() {
    final title = _titleController.text.trim();
    final description = _explanationController.text.trim();
    final email = _emailController.text.trim();

    return title.isEmpty ||
        description.isEmpty ||
        (_isToggleOn && email.isEmpty);
  }

  void onSubmitButtonPressed() async {
    if (isFieldsEmpty()) {
      AwesomeDialog(
        // Dialog ayarları
        context: context,
        dialogType: DialogType.ERROR,
        animType: AnimType.SCALE,
        title: 'Hata',
        desc: 'Lütfen tüm alanları doldurunuz.',
        btnOkText: 'Tamam',

        btnOkColor: AppColors.purple,
        buttonsTextStyle: TextStyle(
          color: AppColors.white, // Metin rengi
          fontFamily: 'WorkSans', // Yazı tipi
          fontSize: 18, // Font büyüklüğü
          fontWeight: FontWeight.bold, // Yazı kalınlığı
        ),
        titleTextStyle: TextStyle(
          color: AppColors.egeRed, // Başlık metni rengi
          fontSize: 20, // Başlık metni boyutu
          fontWeight: FontWeight.bold, // Başlık metni kalınlığı
        ),
        buttonsBorderRadius: BorderRadius.circular(10),
      ).show();
    } else {
      // Tüm alanlar dolu ise işlemlerinizi burada gerçekleştirebilirsiniz.
      DatabaseHelper db = DatabaseHelper();
      int taskID = await db.variableGetAndUpdateTaskID();
      Employee transferManager = await db.findTransferManager();
      await db.sendImageToDb(StaticData.selectedImages, taskID);
      print(StaticData.urls);
      urlToDB=StaticData.urls;
      DateTime now = DateTime.now();
      print(chunk.getTaskType);
      //  Task(int taskID,int staffID,int nominatorID,int locationID,int reporterID,String status,DateTime nominationDate,DateTime dueDate,
      //  DateTime startingDate,DateTime finishDate,String type,String department,int photographID,String title,String description)
      Task task = Task(
          taskID,
          transferManager.getEmployeeId, //TransferMenagerID olacak
          chunk.currentUser.getEmployeeId,
          chunk.getLocation().LocationID,
          chunk.currentUser.getEmployeeId,
          "Yeni",
          now,
          now,
          now,
          now,
          chunk.getTaskType,
          "",
          //Fotoğarafların url adresleri
          urlToDB,
          //0,
          chunk.getTaskTitle,
          chunk.getTaskExplanation,
          0);
      if (task.getType() == "Request") {
        task.setDepartment("Request");
      }
      chunk.setTask(task);

      await db.createTask(
          task.getTaskID(),
          task.getStaffID(),
          task.getNominatorID(),
          task.getLocationID(),
          task.getReporterID(),
          task.getStatus(),
          task.getNominationDate(),
          task.getDueDate(),
          task.getStartingDate(),
          task.getFinishDate(),
          task.getType(),
          task.getDepartment(),
          task.getUrls,
          //task.getPhotographID(),
          chunk.getTaskTitle,
          chunk.getTaskExplanation,
          task.getTaskScore());

      await db.writeLocationToDatabase(chunk.getLocation());
      await db.updateTaskID(
          chunk.getLocation().getlocationID, task.getTaskID());
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SuccessfullTwo(this.chunk)),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    print(chunk.currentUser.getEmployeeTitle.toString());
    // Assuming userType is the variable containing the user type
    if (chunk.currentUser.getEmployeeTitle.toString() == 'Visitor') {
      _showOptional = true;
      print(_showOptional);
    } else {
      // Check if the user is already filled from the database
      // and set _showOptional accordingly
      _showOptional = false;
      print(_showOptional);
    }
  }

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
          padding: EdgeInsets.only(left: 20),
          child: Text(
            'Adım 3/3',
            style: TextStyle(
              color: AppColors.text,
              fontFamily: 'WorkSans',
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Arıza bildirimini tamamla',
                      style: TextStyle(
                        fontSize: 18,
                        color: AppColors.text,
                        fontFamily: 'WorkSans',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(
                      height: 15, //<-- SEE HERE
                    ),
                    const Text(
                      'Başlık',
                      style: TextStyle(
                        fontSize: 15.0,
                        color: AppColors.text,
                        fontFamily: 'WorkSans',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(
                      height: 15, //<-- SEE HERE
                    ),
                    TextField(
                      controller: _titleController,
                      maxLines: 1,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(
                            20), // Maksimum 20 karakter
                      ],
                      style: TextStyle(color: AppColors.text),
                      decoration: InputDecoration(
                        //controllerlarını yazdır
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Sorun nedir?',
                        hintStyle: TextStyle(
                          color: AppColors.text.withOpacity(0.5),
                          fontFamily: 'WorkSans',
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (value) {
                        chunk.setTaskTitle = value;
                        print(chunk.getTaskTitle);
                      },
                    ),
                    const SizedBox(
                      height: 15, //<-- SEE HERE
                    ),
                    const Text(
                      'Açıklama',
                      style: TextStyle(
                        fontSize: 15.0,
                        color: AppColors.text,
                        fontFamily: 'WorkSans',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(
                      height: 15, //<-- SEE HERE
                    ),
                    TextField(
                      controller: _explanationController,
                      maxLines: 4,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(
                            100), // Maksimum 20 karakter
                      ],
                      style: TextStyle(color: AppColors.text),
                      decoration: InputDecoration(
                        //controllerlarını yazdır
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Sorunu birkaç cümle ile özetleyiniz.',
                        hintStyle: TextStyle(
                          color: AppColors.text.withOpacity(0.5),
                          fontFamily: 'WorkSans',
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (value) {
                        chunk.setTaskExplanation = value;
                        print(chunk.getTaskExplanation);
                      },
                    ),
                    const SizedBox(height: 16),
                    Visibility(
                      visible: _showOptional,
                      child: Row(
                        children: [
                          Text(
                            'Opsiyonel',
                            style: TextStyle(
                              fontSize: 15.0,
                              color: AppColors.text,
                              fontFamily: 'WorkSans',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 8),
                          Switch(
                            value: _isToggleOn,
                            onChanged: (value) {
                              setState(() {
                                _isToggleOn = value;
                              });
                            },
                            activeColor: AppColors.navy,
                          ),
                        ],
                      ),
                    ),
                    if (_isToggleOn == true) SizedBox(height: 16),
                    if (_isToggleOn == true)
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 10,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Arızanın sonucu hakkında bilgilendirilmek istiyorum.',
                              style: TextStyle(
                                color: AppColors.text.withOpacity(0.5),
                                fontFamily: 'WorkSans',
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextFormField(
                              controller: _emailController,
                              maxLines: 1,
                              style: TextStyle(color: AppColors.text),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                hintText: 'email@email.com',
                                hintStyle: TextStyle(
                                  color: AppColors.text.withOpacity(0.2),
                                  fontFamily: 'WorkSans',
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    SizedBox(
                      height: 16,
                    ),
                    Center(
                      child: ElevatedButton(
                        onPressed: onSubmitButtonPressed,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.navy,
                            fixedSize: const Size(289, 50),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(17))),
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                'İlerle',
                                style: TextStyle(
                                  fontFamily: 'WorkSans',
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.background,
                                ),
                              ),
                            ),
                            Positioned(
                              right: 10,
                              top: 8,
                              bottom: 8,
                              child: Container(
                                width: 35,
                                decoration: BoxDecoration(
                                  color: AppColors.yellow,
                                  borderRadius: BorderRadius.circular(11),
                                ),
                                child: Icon(Icons.arrow_forward,
                                    color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
