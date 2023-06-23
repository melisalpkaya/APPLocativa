// ignore_for_file: slash_for_doc_comments

import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as fbStorage;
import 'package:geocoding/geocoding.dart';
import 'package:locativa/SensitiveLocation.dart';
import 'package:locativa/static_data.dart';
import 'Employee.dart';
import 'Visitor.dart';
import 'Task.dart';
import 'CustomLocation.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:geolocator/geolocator.dart';
import 'package:crypto/crypto.dart';

//import 'package:geolocator/geocoding.dart';

class DatabaseHelper {
  FirebaseFirestore _db = FirebaseFirestore.instance;

  late CollectionReference _todosRef;

  void init() {
    //todosRef = _db.collection('_employee');
  }
//******************************************************************************** */
  Future<void> notifyError(String title,String describtion)async{

    CollectionReference techs = FirebaseFirestore.instance.collection('_tech_');
    int id=await variableGetAndUpdateTechID();
    await techs.add({
      'ID': id,
      'Description':describtion,
      'Title':title,
      'Date':DateTime.now(),
      'Status':"Assigned"  
    });
    print('Sorun bildirildi sayfası başarılı.');
  }
  //******************************************************************************** */

  // Future<bool> isSchool() async {

  //   return true;
  // }

  Future<List<String>> findSensitiveLocation(Position ref) async {
    print("fonksiyon başladı");
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('_sensitivelocation_')
        .get();
    if (querySnapshot.docs.isEmpty) {
      throw Exception('Something Wrong for reading SensitveLocation');
    }
    bool isSchool = false;
    List<SensitiveLocation> sensitive_list = [];
    List<String> result = [];
    querySnapshot.docs.forEach((doc) {
      String block = doc['Block'];
      GeoPoint sag_arka_geo = doc['sag_arka'];
      GeoPoint sol_on_geo = doc['sol_on'];
      String roomID=doc['RoomID'];
      int floor=doc['Floor'];

      Position sag_arka = Position(
          longitude: sag_arka_geo.longitude,
          latitude: sag_arka_geo.latitude,
          timestamp: DateTime.now(),
          accuracy: 0,
          altitude: 0,
          heading: 0,
          speed: 0,
          speedAccuracy: 0);
      Position sol_on = Position(
          longitude: sol_on_geo.longitude,
          latitude: sol_on_geo.latitude,
          timestamp: DateTime.now(),
          accuracy: 0,
          altitude: 0,
          heading: 0,
          speed: 0,
          speedAccuracy: 0);

      SensitiveLocation s = SensitiveLocation(block, sag_arka, sol_on,roomID,floor);
      sensitive_list.add(s);
    });
    // Position ref = Position(
    //     longitude: 32.8178449,
    //     latitude: 39.971022,
    //     timestamp: DateTime.now(),
    //     accuracy: 0,
    //     altitude: 0,
    //     heading: 0,
    //     speed: 0,
    //     speedAccuracy: 0);
    for (int i = 0; i < sensitive_list.length; i++) {
      if (sensitive_list[i].getBlock == "okul") {
        if (sensitive_list[i].getSolOn.latitude < ref.latitude &&
            ref.latitude < sensitive_list[i].getSagArka.latitude &&
            sensitive_list[i].sag_arka.longitude < ref.longitude &&
            ref.longitude < sensitive_list[i].getSolOn.longitude) {
          //print("okuldasın ege");
          result.add("true");
          result.add("Etlik");
          sensitive_list.removeAt(i);
        }
      }
    }
    for (int i = 0; i < sensitive_list.length; i++) {
      if (sensitive_list[i].getSolOn.latitude < ref.latitude &&
          ref.latitude < sensitive_list[i].getSagArka.latitude &&
          sensitive_list[i].sag_arka.longitude < ref.longitude &&
          ref.longitude < sensitive_list[i].getSolOn.longitude) {
        print("Ege buradasın "+sensitive_list[i].getBlock);
        result.add(sensitive_list[i].getBlock);
        result.add(sensitive_list[i].getFloor.toString());
        result.add(sensitive_list[i].getRoomID);
        //sensitive_list.removeAt(i);
      }
    }
    return result;

  }

/*********************************************************************************** */

  Future<Position> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location...');
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location denied...');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permission are permanently denied...');
    }
    return await Geolocator.getCurrentPosition();
  }

  Future<String> getAddressFromCoordinates(
      double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      if (placemarks != null && placemarks.isNotEmpty) {
        Placemark placemark = placemarks[0]; // İlk yer işareti alınıyor
        String address =
            '${placemark.thoroughfare}, ${placemark.locality}, ${placemark.administrativeArea},${placemark.subAdministrativeArea} ,${placemark.postalCode}, ${placemark.country}';
        return address;
      }
    } catch (e) {
      print('Hata: $e');
    }
    return "";
  }

  //-----------------pictures

  Future<void> sendImageToDb(List<File> images, int taskID) async {
    final storageRef = fbStorage.FirebaseStorage.instance.ref();
    List<String> paths = [];
    if (images.length != 0) {
      for (int i = 0; i < images.length; i++) {
        String path = 'task$taskID/images/${i + 1}';
        var imageRef = storageRef.child(path);
        await imageRef.putFile(images[i]);
        String imageUrl = await imageRef.getDownloadURL();
        paths.add(imageUrl);
      }
    }
    StaticData.urls = paths;
  }

  Future<void> sendResultImageToDb(List<File> images, int taskID) async {
    final storageRef = fbStorage.FirebaseStorage.instance.ref();
    List<String> paths = [];
    if (images.length != 0) {
      for (int i = 0; i < images.length; i++) {
        String path = 'task$taskID/images/results/${i + 1}';
        var imageRef = storageRef.child(path);
        await imageRef.putFile(images[i]);
        String imageUrl = await imageRef.getDownloadURL();
        paths.add(imageUrl);
      }
    }
    StaticData.urls = paths;
  }

  //-----------------pictures

  /**
   * 
   *    Location START
   * 
  */
  /************************************************************************************************************************/
  Future<void> updateTaskID(int locationID, int taskID) async {
    //CHANGE PASSWORD
    // Kullanıcı adına göre kullanıcıyı bul
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('_location_')
        .where('ID', isEqualTo: locationID)
        .limit(1)
        .get();
    // Kullanıcı bulunamazsa hata mesajı göster ve fonksiyondan çık
    if (querySnapshot.docs.isEmpty) {
      print('Kullanıcı bulunamadı.');
      return;
    }
    // Kullanıcı varsa şifresini güncelle
    String docID = querySnapshot.docs.first.id;
    await FirebaseFirestore.instance
        .collection('_location_')
        .doc(docID)
        .update({'TaskID': taskID});

    print('taskID güncellendi.');
  }

  /************************************************************************************************************************/

  //readLocationWithTaskID(int taskID)
  Future<CustomLocation> readLocationWithTaskID(int taskID) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('_location_')
        .where('TaskID', isEqualTo: taskID)
        .limit(1)
        .get();
    if (querySnapshot.docs.isEmpty) {
      throw Exception('No Task found with id: $taskID');
    }
    CustomLocation x = CustomLocation.fromLocation();
    querySnapshot.docs.forEach((doc) {
      GeoPoint geoPoint = doc['Location'];
      Position position = Position(
          longitude: geoPoint.longitude,
          latitude: geoPoint.latitude,
          timestamp: DateTime.now(),
          accuracy: 0,
          altitude: 0,
          heading: 0,
          speed: 0,
          speedAccuracy: 0);
      String address = doc['Address'];
      //CustomLocation(int id,int TaskID,String campus,int floor,String roomID,Position location)
      CustomLocation e = CustomLocation(doc['ID'], doc['TaskID'], doc['Campus'],
          doc['Floor'], doc['RoomID'], position, address);
      e.setAddress = address;
      x = e;
    });
    return x;
  }

  /************************************************************************************************************************/
  Future<CustomLocation> readLocationWithLocationID(int locationID) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('_location_')
        .where('ID', isEqualTo: locationID)
        .limit(1)
        .get();
    if (querySnapshot.docs.isEmpty) {
      throw Exception('No Task found with id: $locationID');
    }
    CustomLocation x = CustomLocation.fromLocation();
    querySnapshot.docs.forEach((doc) {
      GeoPoint geoPoint = doc['Location'];
      Position position = Position(
          longitude: geoPoint.longitude,
          latitude: geoPoint.latitude,
          timestamp: DateTime.now(),
          accuracy: 0,
          altitude: 0,
          heading: 0,
          speed: 0,
          speedAccuracy: 0);
      String address = doc['Address'];
      //CustomLocation(int id,int TaskID,String campus,int floor,String roomID,Position location)
      CustomLocation e = CustomLocation(doc['ID'], doc['TaskID'], doc['Campus'],
          doc['Floor'], doc['RoomID'], position, address);
      e.setAddress = address;

      x = e;
    });
    return x;
  }
  /************************************************************************************************************************/
  //writeLocationToDatabase(Location location)

  Future<void> writeLocationToDatabase(CustomLocation location) async {
    CollectionReference tasks =
        FirebaseFirestore.instance.collection('_location_');
    GeoPoint geoPoint = GeoPoint(
        location.currentLocation.latitude, location.currentLocation.longitude);
    await tasks.add({
      'Campus': location.getCampus,
      'Floor': location.getFloor,
      'ID': location.getlocationID,
      'Location': geoPoint,
      'RoomID': location.getRoomID,
      'TaskID': location.getTaskID,
      'Address': location.getAddress
    });
    print('location added to Db successfully.');
  }

  /**
   * 
   *    Location END
   * 
  */
  /************************************************************************************************************************/

  /**
   * 
   *    Variables START
   * 
  */

    Future<int> variableGetAndUpdateTechID() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('_variables_').get();
    // collection bulamazsa durdurma
    if (querySnapshot.docs.isEmpty) {
      print("hata TechID");
      return 0;
    }
    int TechIDCounter = 0;
    // ID getirme
    querySnapshot.docs.forEach((doc) {
      TechIDCounter = doc['TechID'];
    });
    TechIDCounter++;
    //Arttırılmış ID'yi güncelleme
    String docId = querySnapshot.docs.first.id;
    await FirebaseFirestore.instance
        .collection('_variables_')
        .doc(docId)
        .update({'TechID': TechIDCounter});
    print('TechID getirilip arttırıldı. : ' + TechIDCounter.toString());
    return TechIDCounter;
  }

  /************************************************************************************************************************/

  /************************************************************************************************************************/
  //Bu fonksiyon _variables_ collectiondan VisitorID'yi alıp bir arttırır ve daha sonra kullanılmak üzere retrun eder.
  Future<int> variableGetAndUpdateVisitorID() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('_variables_').get();
    // collection bulamazsa durdurma
    if (querySnapshot.docs.isEmpty) {
      print("hata VisitorID");
      return 0;
    }
    int VisitorIDCounter = 0;
    // ID getirme
    querySnapshot.docs.forEach((doc) {
      VisitorIDCounter = doc['VisitorID'];
    });
    VisitorIDCounter++;
    //Arttırılmış ID'yi güncelleme
    String docId = querySnapshot.docs.first.id;
    await FirebaseFirestore.instance
        .collection('_variables_')
        .doc(docId)
        .update({'VisitorID': VisitorIDCounter});
    print('VisitorID getirilip arttırıldı. : ' + VisitorIDCounter.toString());
    return VisitorIDCounter;
  }

  /************************************************************************************************************************/
  //Bu fonksiyon _variables_ collectiondan TaskID'yi alıp bir arttırır ve daha sonra kullanılmak üzere retrun eder.
  Future<int> variableGetAndUpdateTaskID() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('_variables_').get();
    // collection bulamazsa durdurma
    if (querySnapshot.docs.isEmpty) {
      print("hata TaskID");
      return 0;
    }
    int TaskIDCounter = 0;
    // ID getirme
    querySnapshot.docs.forEach((doc) {
      TaskIDCounter = doc['TaskID'];
    });
    TaskIDCounter++;
    //Arttırılmış ID'yi update etme
    String docId = querySnapshot.docs.first.id;
    await FirebaseFirestore.instance
        .collection('_variables_')
        .doc(docId)
        .update({'TaskID': TaskIDCounter});
    print('TaskID getirilip arttırıldı. : ' + TaskIDCounter.toString());
    return TaskIDCounter;
  }

  /************************************************************************************************************************/
  //Bu fonksiyon _variables_ collectiondan EmployeeID'yi alıp bir arttırır ve daha sonra kullanılmak üzere retrun eder.
  Future<int> variableGetAndUpdateEmployeeID() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('_variables_').get();
    // collection bulamazsa durdurma
    if (querySnapshot.docs.isEmpty) {
      print("hata EmployeeID");
      return 0;
    }
    int EmployeeIDCounter = 0;
    // ID getirme
    querySnapshot.docs.forEach((doc) {
      EmployeeIDCounter = doc['EmployeeID'];
    });
    EmployeeIDCounter++;
    //Arttırılmış ID'yi update etme
    String docId = querySnapshot.docs.first.id;
    await FirebaseFirestore.instance
        .collection('_variables_')
        .doc(docId)
        .update({'EmployeeID': EmployeeIDCounter});
    print('Employee getirilip arttırıldı. : ' + EmployeeIDCounter.toString());
    return EmployeeIDCounter;
  }

  /************************************************************************************************************************/
  //Bu fonksiyon _variables_ collectiondan LocationID'yi alıp bir arttırır ve daha sonra kullanılmak üzere return eder.
  Future<int> variableGetAndUpdateLocationID() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('_variables_').get();
    // collection bulamazsa durdurma
    if (querySnapshot.docs.isEmpty) {
      print("hata LocationID");
      return 0;
    }
    int LocationIDCounter = 0;
    // ID getirme
    querySnapshot.docs.forEach((doc) {
      LocationIDCounter = doc['LocationID'];
    });
    LocationIDCounter++;
    //Arttırılmış ID'yi update etme
    String docId = querySnapshot.docs.first.id;
    await FirebaseFirestore.instance
        .collection('_variables_')
        .doc(docId)
        .update({'LocationID': LocationIDCounter});
    print('LocationID getirilip arttırıldı. : ' + LocationIDCounter.toString());
    return LocationIDCounter;
  }

  /************************************************************************************************************************/
  //Bu fonksiyon _variables_ collectiondan AdminID'yi alıp bir arttırır ve daha sonra kullanılmak üzere return eder.
  Future<int> variableGetAndUpdateAdminID() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('_variables_').get();
    // collection bulamazsa durdurma
    if (querySnapshot.docs.isEmpty) {
      print("hata adminID");
      return 0;
    }
    int AdminIDCounter = 0;
    //  ID yi getirme
    querySnapshot.docs.forEach((doc) {
      AdminIDCounter = doc['AdminID'];
    });
    AdminIDCounter++;
    //Arttırılmış ID'yi update etme
    String docId = querySnapshot.docs.first.id;
    await FirebaseFirestore.instance
        .collection('_variables_')
        .doc(docId)
        .update({'AdminID': AdminIDCounter});
    print('AdminID getirilip arttırıldı. : ' + AdminIDCounter.toString());
    return AdminIDCounter;
  }
  /************************************************************************************************************************/
  /**
   * 
   *    Variables END
   * 
  */

  /**
   * 
   *    TASK START               Task(int taskID,int staffID,int nominatorID,int locationID,int reporterID,String status,
   *                                  DateTime nominationDate,DateTime dueDate,DateTime startingDate,DateTime finishDate,
   *                                  String type,String department,int photographID) 
   * 
  */
  /************************************************************************************************************************/
  Future<List<Task>> rejectedTaskFromEmployee(int staffID) async {
    List<Task> tasks = [];
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('_task_')
        .where('NominatorID', isEqualTo: staffID)
        .get();

    if (querySnapshot.docs.isEmpty) {
      print("Could not Find Rejected Jobs");
      return tasks;
    }
    querySnapshot.docs.forEach((doc) {
      var nomDate = doc['NominationDate'].toDate();
      var startDate = doc['StartingDate'].toDate();
      var finishDate = doc['FinishDate'].toDate();
      var dueDate = doc['DueDate'].toDate();
      List<dynamic> urlsFromDb = doc['ImageUrls'];
      List<String> realUrls =
          urlsFromDb.map((dynamic item) => item.toString()).toList();
      Task e = Task(
          doc['TaskID'],
          doc['StaffID'],
          doc['NominatorID'],
          doc['LocationID'],
          doc['ReporterID'],
          doc['Status'],
          nomDate,
          dueDate,
          startDate,
          finishDate,
          doc['Type'],
          doc['Department'],
          realUrls,
          doc['Title'],
          doc['Description'],
          doc['Score']);
      if (e.getNominatorID() == staffID && e.getStatus() == "Rejected") {
        tasks.add(e);
      }
    });
    return tasks;
  }

  /************************************************************************************************************************/
  //(chunk.getTask(),chunk.currentUser.getEmployeeId,assigneeID,currentDate);
  Future<void> assignTaskToStaff(
      Task task, int currentUserID, int staffID, DateTime dateTime) async {
    print("Fonksiyonun başı");
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('_task_')
        .where('TaskID', isEqualTo: task.getTaskID())
        .get();
    print(task.getTaskID());
    if (querySnapshot.docs.isEmpty) {
      print('Task bulunamadı.');
      return;
    }
    String docId = querySnapshot.docs.first.id;
    DateTime now = DateTime.now();
    await FirebaseFirestore.instance
        .collection('_task_')
        .doc(docId)
        .update({'StaffID': staffID});
    await FirebaseFirestore.instance
        .collection('_task_')
        .doc(docId)
        .update({'DueDate': dateTime});
    await FirebaseFirestore.instance
        .collection('_task_')
        .doc(docId)
        .update({'NominationDate': now});
    await FirebaseFirestore.instance
        .collection('_task_')
        .doc(docId)
        .update({'NominatorID': currentUserID});
  }

  Future<void> updateTaskPicturesInDone(Task task, List<String> urls) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('_task_')
        .where('TaskID', isEqualTo: task.getTaskID())
        .get();
    if (querySnapshot.docs.isEmpty) {
      print('Task bulunamadı.');
      return;
    }
    List<String> list = task.getUrls;
    for (int i = 0; i < urls.length; i++) {
      list.add(urls[i]);
    }
    String docId = querySnapshot.docs.first.id;
    await FirebaseFirestore.instance
        .collection('_task_')
        .doc(docId)
        .update({'ImageUrls': list});
    print("Done a ait foto yüklendi");
  }

  /************************************************************************************************************************/
  Future<void> updateTaskScore(int taskID, int score) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('_task_')
        .where('TaskID', isEqualTo: taskID)
        .get();
    print(taskID);
    if (querySnapshot.docs.isEmpty) {
      print('Task bulunamadı.');
      return;
    }
    String docId = querySnapshot.docs.first.id;
    await FirebaseFirestore.instance
        .collection('_task_')
        .doc(docId)
        .update({'Score': score});
  }
  /************************************************************************************************************************/

  Future<List<Task>> getTasksStaffIDWithStatus(int id, String status) async {
    List<Task> allTasks = await searchTaskWithStaffID(id);
    List<Task> tasks = [];
    if (allTasks.length == 0) {
      return tasks;
    }
    for (var i = 0; i < allTasks.length; i++) {
      if (allTasks[i].getStatus() == status) {
        tasks.add(allTasks[i]);
      }
    }
    return tasks;
  }

  //İşçi işi tamamlama reddetme veya devam ediyor fonksiyonu
  Future<void> changeTaskStatusFromStaffPage(
      Task task, String status, int staffID) async {
    print("Fonksiyonun başı");
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('_task_')
        .where('TaskID', isEqualTo: task.getTaskID())
        .get();
    print(task.getTaskID());
    if (querySnapshot.docs.isEmpty) {
      print('Task bulunamadı.');
      return;
    }
    String docId = querySnapshot.docs.first.id;
    Employee transferManager = Employee.fromEmployee();
    print(docId);
    if (status == "Rejected") {
      List<Employee> empList = await readEmployees();
      for (int i = 0; i < empList.length; i++) {
        if (empList[i].getEmployeeTitle == "Transfer Manager") {
          transferManager = empList[i];
        }
      }
      await FirebaseFirestore.instance
          .collection('_task_')
          .doc(docId)
          .update({'Status': status});

      await FirebaseFirestore.instance
          .collection('_task_')
          .doc(docId)
          .update({'NominatorID': task.getStaffID()});

      await FirebaseFirestore.instance
          .collection('_task_')
          .doc(docId)
          .update({'StaffID': transferManager.getEmployeeId});
      await FirebaseFirestore.instance
          .collection('_task_')
          .doc(docId)
          .update({'NominationDate': DateTime.now()});
    } else if (status == "Done") {
      await FirebaseFirestore.instance
          .collection('_task_')
          .doc(docId)
          .update({'Status': status});
      await FirebaseFirestore.instance
          .collection('_task_')
          .doc(docId)
          .update({'FinishDate': DateTime.now()});
    } else if (status == "Assigned") {
      await FirebaseFirestore.instance
          .collection('_task_')
          .doc(docId)
          .update({'Status': status});
      await FirebaseFirestore.instance
          .collection('_task_')
          .doc(docId)
          .update({'StartingDate': DateTime.now()});
    }
  }

  /************************************************************************************************************************/
  Future<List<Task>> AssignedTasksForTransferManagerHp(
      int currentUserID) async {
    List<Task> newTasks = [];
    List<Task> newTasksTemp = await searchTaskWithStatus("Yeni");
    if (newTasksTemp.length == 0) {
      print("AssignedTasksForTransferManagerHp task.length = 0.");
      return newTasks;
    }
    for (int i = 0; i < newTasksTemp.length; i++) {
      if (newTasksTemp[i].getStaffID() != currentUserID) {
        newTasks.add(newTasksTemp[i]);
      }
    }
    return newTasks;
  }

/************************************************************************************************************************/
  //searchTaskWithStatus
  //searchTaskWithDepartment

  Future<List<Task>> searchTasksStatusAndDepartment(
      int departmentChiefID, String status, String department) async {
    List<Task> tasks = [];
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('_task_')
        .where('Department', isEqualTo: department)
        .get();
    if (querySnapshot.docs.isEmpty) {
      print("searchwithtasksstatusanddepartment boş");
      return tasks;
    }

    if (status == "Assigned") {
      querySnapshot.docs.forEach((doc) {
        var nomDate = doc['NominationDate'].toDate();
        var startDate = doc['StartingDate'].toDate();
        var finishDate = doc['FinishDate'].toDate();
        var dueDate = doc['DueDate'].toDate();
        List<dynamic> urlsFromDb = doc['ImageUrls'];
        List<String> realUrls =
            urlsFromDb.map((dynamic item) => item.toString()).toList();
        Task e = Task(
            doc['TaskID'],
            doc['StaffID'],
            doc['NominatorID'],
            doc['LocationID'],
            doc['ReporterID'],
            doc['Status'],
            nomDate,
            dueDate,
            startDate,
            finishDate,
            doc['Type'],
            doc['Department'],
            realUrls,
            doc['Title'],
            doc['Description'],
            doc['Score']);
        if (e.getStatus() == status ||
            (e.getStatus() == "Yeni" && e.getStaffID() != departmentChiefID)) {
          tasks.add(e);
        }
      });
    }
    if (status == "Done") {
      querySnapshot.docs.forEach((doc) {
        var nomDate = doc['NominationDate'].toDate();
        var startDate = doc['StartingDate'].toDate();
        var finishDate = doc['FinishDate'].toDate();
        var dueDate = doc['DueDate'].toDate();
        List<dynamic> urlsFromDb = doc['ImageUrls'];
        List<String> realUrls =
            urlsFromDb.map((dynamic item) => item.toString()).toList();
        Task e = Task(
            doc['TaskID'],
            doc['StaffID'],
            doc['NominatorID'],
            doc['LocationID'],
            doc['ReporterID'],
            doc['Status'],
            nomDate,
            dueDate,
            startDate,
            finishDate,
            doc['Type'],
            doc['Department'],
            realUrls,
            doc['Title'],
            doc['Description'],
            doc['Score']);
        if (e.getStatus() == status) {
          tasks.add(e);
        }
      });
    }

    print("Tasks loaded with status and department");
    return tasks;
  }

/************************************************************************************************************************/
  //Departman şefine atama
  Future<void> changeTaskDepartmentAndStaffID(
      Task task, String department, int assignerID, int nominatorID) async {
    print("Fonksiyonun başı");
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('_task_')
        .where('TaskID', isEqualTo: task.getTaskID())
        .get();
    // Kullanıcı bulunamazsa hata mesajı göster ve fonksiyondan çık
    print(task.getTaskID());
    if (querySnapshot.docs.isEmpty) {
      print('Task bulunamadı.');
      return;
    }
    // Kullanıcı varsa şifresini güncelle
    String docId = querySnapshot.docs.first.id;
    print(docId);
    await FirebaseFirestore.instance
        .collection('_task_')
        .doc(docId)
        .update({'Department': department});

    await FirebaseFirestore.instance
        .collection('_task_')
        .doc(docId)
        .update({'StaffID': assignerID});
    await FirebaseFirestore.instance
        .collection('_task_')
        .doc(docId)
        .update({'NominationDate': DateTime.now()});
    await FirebaseFirestore.instance
        .collection('_task_')
        .doc(docId)
        .update({'NominatorID': nominatorID});
    print('Task ilgili departmana ve şefe yönlendirildi.');
  }

  /************************************************************************************************************************/
  Future<void> createTask(
      //CREATE TASK
      int taskID,
      int staffID,
      int nominatorID,
      int locationID,
      int reporterID,
      String status,
      DateTime nominationDate,
      DateTime dueDate,
      DateTime startingDate,
      DateTime finishDate,
      String type,
      String department,
      List<String> imgUrls,
      String title,
      String description,
      int score) async {
    CollectionReference tasks = FirebaseFirestore.instance.collection('_task_');
    await tasks.add({
      'TaskID': taskID,
      'StaffID': staffID,
      'NominatorID': nominatorID,
      'LocationID': locationID,
      'ReporterID': reporterID,
      'Status': status,
      'NominationDate': nominationDate,
      'DueDate': dueDate,
      'StartingDate': startingDate,
      'FinishDate': finishDate,
      'Type': type,
      'Department': department,
      'ImageUrls': imgUrls,
      'Title': title,
      'Description': description,
      'Score': score,
    });
    print('task added successfully.');
  }

  /************************************************************************************************************************/
  Future<void> deleteTask(int id) async {
    //DELETE TASK
    final TaskSnapshot = await FirebaseFirestore.instance
        .collection('_task_')
        .where('TaskID', isEqualTo: id)
        .get();
    if (TaskSnapshot.size == 0) {
      // There is no visitor with given id
      print("There is not visitor with given ID");
      return;
    }
    final taskDoc = TaskSnapshot.docs.first;
    await FirebaseFirestore.instance
        .collection('task')
        .doc(taskDoc.id)
        .delete();

    print('task with  is deleted');
  }

  /************************************************************************************************************************/
  Future<List<Task>> readTasks() async {
    //READ TASKS
    List<Task> tasks = [];
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('_task_').get();
    querySnapshot.docs.forEach((doc) {
      var nomDate = doc['NominationDate'].toDate();
      var startDate = doc['StartingDate'].toDate();
      var finishDate = doc['FinishDate'].toDate();
      var dueDate = doc['DueDate'].toDate();
      List<dynamic> urlsFromDb = doc['ImageUrls'];
      List<String> realUrls =
          urlsFromDb.map((dynamic item) => item.toString()).toList();
      Task e = Task(
          doc['TaskID'],
          doc['StaffID'],
          doc['NominatorID'],
          doc['LocationID'],
          doc['ReporterID'],
          doc['Status'],
          nomDate,
          dueDate,
          startDate,
          finishDate,
          doc['Type'],
          doc['Department'],
          realUrls,
          doc['Title'],
          doc['Description'],
          doc['Score']);
      tasks.add(e);
    });
    print("read tasks: " + tasks.length.toString());
    return tasks;
  }

  /************************************************************************************************************************/
  Future<Task> searchTaskWithID(int taskID) async {
    //READ VISITOR WITH TASKID
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('_task_')
        .where('TaskID', isEqualTo: taskID)
        .limit(1)
        .get();
    if (querySnapshot.docs.isEmpty) {
      throw Exception('No Task found with id: $taskID');
    }
    Task x = Task.fromTask();
    querySnapshot.docs.forEach((doc) {
      var nomDate = doc['NominationDate'].toDate();
      var startDate = doc['StartingDate'].toDate();
      var finishDate = doc['FinishDate'].toDate();
      var dueDate = doc['DueDate'].toDate();
      List<dynamic> urlsFromDb = doc['ImageUrls'];
      List<String> realUrls =
          urlsFromDb.map((dynamic item) => item.toString()).toList();
      Task e = Task(
          doc['TaskID'],
          doc['StaffID'],
          doc['NominatorID'],
          doc['LocationID'],
          doc['ReporterID'],
          doc['Status'],
          nomDate,
          dueDate,
          startDate,
          finishDate,
          doc['Type'],
          doc['Department'],
          realUrls,
          doc['Title'],
          doc['Description'],
          doc['Score']);
      x = e;
    });
    print(x.status.toString());
    return x;
  }

  /************************************************************************************************************************/
  Future<Task> searchTaskWithDepartment(String department) async {
    //READ VISITOR WITH TASKID
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('_task_')
        .where('Department', isEqualTo: department)
        .limit(1)
        .get();
    if (querySnapshot.docs.isEmpty) {
      throw Exception('No Task found with id: $department');
    }
    Task x = Task.fromTask();
    querySnapshot.docs.forEach((doc) {
      var nomDate = doc['NominationDate'].toDate();
      var startDate = doc['StartingDate'].toDate();
      var finishDate = doc['FinishDate'].toDate();
      var dueDate = doc['DueDate'].toDate();
      List<dynamic> urlsFromDb = doc['ImageUrls'];
      List<String> realUrls =
          urlsFromDb.map((dynamic item) => item.toString()).toList();
      Task e = Task(
          doc['TaskID'],
          doc['StaffID'],
          doc['NominatorID'],
          doc['LocationID'],
          doc['ReporterID'],
          doc['Status'],
          nomDate,
          dueDate,
          startDate,
          finishDate,
          doc['Type'],
          doc['Department'],
          realUrls,
          doc['Title'],
          doc['Description'],
          doc['Score']);
      x = e;
    });
    print(x.department.toString());
    return x;
  }

  /************************************************************************************************************************/
  Future<List<Task>> searchTaskWithStaffID(int id) async {
    //READ VISITOR WITH TASKID
    List<Task> tasks = [];
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('_task_')
        .where('StaffID', isEqualTo: id)
        .get();
    if (querySnapshot.docs.isEmpty) {
      print('No Task found with id: $id');
      return tasks;
    }

    Task x = Task.fromTask();
    querySnapshot.docs.forEach((doc) {
      var nomDate = doc['NominationDate'].toDate();
      var startDate = doc['StartingDate'].toDate();
      var finishDate = doc['FinishDate'].toDate();
      var dueDate = doc['DueDate'].toDate();
      List<dynamic> urlsFromDb = doc['ImageUrls'];
      List<String> realUrls =
          urlsFromDb.map((dynamic item) => item.toString()).toList();
      Task e = Task(
          doc['TaskID'],
          doc['StaffID'],
          doc['NominatorID'],
          doc['LocationID'],
          doc['ReporterID'],
          doc['Status'],
          nomDate,
          dueDate,
          startDate,
          finishDate,
          doc['Type'],
          doc['Department'],
          realUrls,
          doc['Title'],
          doc['Description'],
          doc['Score']);
      x = e;
      tasks.add(x);
    });
    //print(x.getTaskID().toString());
    return tasks;
  }

  /************************************************************************************************************************/
  Future<List<Task>> searchTaskWithType(String type) async {
    //READ TASKS
    List<Task> tasks = [];
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('_task_').get();
    querySnapshot.docs.forEach((doc) {
      var nomDate = doc['NominationDate'].toDate();
      var startDate = doc['StartingDate'].toDate();
      var finishDate = doc['FinishDate'].toDate();
      var dueDate = doc['DueDate'].toDate();
      List<dynamic> urlsFromDb = doc['ImageUrls'];
      List<String> realUrls =
          urlsFromDb.map((dynamic item) => item.toString()).toList();
      Task e = Task(
          doc['TaskID'],
          doc['StaffID'],
          doc['NominatorID'],
          doc['LocationID'],
          doc['ReporterID'],
          doc['Status'],
          nomDate,
          dueDate,
          startDate,
          finishDate,
          doc['Type'],
          doc['Department'],
          realUrls,
          doc['Title'],
          doc['Description'],
          doc['Score']);
      if (e.getType().toString() == type) {
        tasks.add(e);
      }
    });
    return tasks;
  }

  /************************************************************************************************************************/
  Future<List<Task>> searchTaskWithStatusWithTransferManagerID(
      int transferManagerID, String status) async {
    //READ TASKS
    List<Task> tasks = [];
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('_task_').get();
    querySnapshot.docs.forEach((doc) {
      var nomDate = doc['NominationDate'].toDate();
      var startDate = doc['StartingDate'].toDate();
      var finishDate = doc['FinishDate'].toDate();
      var dueDate = doc['DueDate'].toDate();
      List<dynamic> urlsFromDb = doc['ImageUrls'];
      List<String> realUrls =
          urlsFromDb.map((dynamic item) => item.toString()).toList();
      Task e = Task(
          doc['TaskID'],
          doc['StaffID'],
          doc['NominatorID'],
          doc['LocationID'],
          doc['ReporterID'],
          doc['Status'],
          nomDate,
          dueDate,
          startDate,
          finishDate,
          doc['Type'],
          doc['Department'],
          realUrls,
          doc['Title'],
          doc['Description'],
          doc['Score']);
      e.setTaskScore(doc['Score']);
      if (e.getStatus().toString() == status &&
          e.staffID == transferManagerID) {
        tasks.add(e);
      }
    });
    return tasks;
  }

  /************************************************************************************************************************/

  Future<List<Task>> searchTasksWithFinishDate(DateTime finish) async {
    List<Task> doneTasks = await searchTaskWithStatus("Done");
    List<Task> result = [];
    finish =
        DateTime(finish.year, finish.month, 30, finish.hour, finish.minute);
    DateTime start = DateTime(finish.year, finish.month, 1, 0, 0);

    for (int i = 0; i < doneTasks.length; i++) {
      if (doneTasks[i].getFinishDate().compareTo(start) > 0 &&
          doneTasks[i].getFinishDate().compareTo(finish) < 0) {
        result.add(doneTasks[i]);
      }
    }
    return result;
  }

  /************************************************************************************************************************/

  Future<List<Task>> searchTaskWithStatus(String status) async {
    //READ TASKS
    List<Task> tasks = [];
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('_task_').get();
    querySnapshot.docs.forEach((doc) {
      var nomDate = doc['NominationDate'].toDate();
      var startDate = doc['StartingDate'].toDate();
      var finishDate = doc['FinishDate'].toDate();
      var dueDate = doc['DueDate'].toDate();
      List<dynamic> urlsFromDb = doc['ImageUrls'];
      List<String> realUrls =
          urlsFromDb.map((dynamic item) => item.toString()).toList();
      Task e = Task(
          doc['TaskID'],
          doc['StaffID'],
          doc['NominatorID'],
          doc['LocationID'],
          doc['ReporterID'],
          doc['Status'],
          nomDate,
          dueDate,
          startDate,
          finishDate,
          doc['Type'],
          doc['Department'],
          realUrls,
          doc['Title'],
          doc['Description'],
          doc['Score']);
      e.setTaskScore(doc['Score']);
      if (e.getStatus().toString() == status) {
        tasks.add(e);
      }
    });
    return tasks;
  }

  /************************************************************************************************************************/
  Future<List<Task>> FindAssignedTaskWithEmployeeID(int id) async {
    List<Task> tasks = [];
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('_employee_')
        .where('ID', isEqualTo: id)
        .limit(1)
        .get();
    if (querySnapshot.docs.isEmpty) {
      throw Exception('No employee found with id: $id');
    }
    Employee x = Employee.fromEmployee();
    querySnapshot.docs.forEach((doc) {
      Employee e = Employee(
          doc["ID"],
          doc["Name"],
          doc["Surname"],
          doc["Department"],
          doc["EMail"],
          doc["Password"],
          doc["Title"],
          doc["Phone"],
          doc["CampusAtWorking"],
          doc['Activation']);
      x = e;
    });
    QuerySnapshot querySnapshotTasks = await FirebaseFirestore.instance
        .collection("_task_")
        .where('StaffID', isEqualTo: x.getEmployeeId)
        .get();
    querySnapshotTasks.docs.forEach((doc) {
      var nomDate = doc['NominationDate'].toDate();
      var startDate = doc['StartingDate'].toDate();
      var finishDate = doc['FinishDate'].toDate();
      var dueDate = doc['DueDate'].toDate();
      List<dynamic> urlsFromDb = doc['ImageUrls'];
      List<String> realUrls =
          urlsFromDb.map((dynamic item) => item.toString()).toList();
      Task e = Task(
          doc['TaskID'],
          doc['StaffID'],
          doc['NominatorID'],
          doc['LocationID'],
          doc['ReporterID'],
          doc['Status'],
          nomDate,
          dueDate,
          startDate,
          finishDate,
          doc['Type'],
          doc['Department'],
          realUrls,
          doc['Title'],
          doc['Description'],
          doc['Score']);
      tasks.add(e);
    });
    return tasks;
  }
  /************************************************************************************************************************/
  /**
   * 
   *    TASK END
   * 
  */

  /**
   * 
   *    VISITOR START             Visitor(int visitorID, int taskID, String name, String surname, String phone,String Email)
   * 
  */
  /************************************************************************************************************************/
  Future<void> createVisitor(
      //CREATE VISITOR
      int id,
      String name,
      String surname,
      String email,
      String phone,
      int taskID) async {
    CollectionReference visitors =
        FirebaseFirestore.instance.collection('_visitor_');
    await visitors.add({
      'ID': id,
      'Name': name,
      'Surname': surname,
      'EMail': email,
      'Phone': phone,
      'TaskID': taskID
    });
    print('visitor added successfully.');
  }

  /************************************************************************************************************************/
  Future<Visitor> readVisitorWithTaskID(int taskID) async {
    //READ VISITOR WITH TASKID
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('_visitor_')
        .where('TaskID', isEqualTo: taskID)
        .limit(1)
        .get();
    if (querySnapshot.docs.isEmpty) {
      throw Exception('No visitor found with id: $taskID');
    }
    Visitor x = Visitor.fromVisitor();
    querySnapshot.docs.forEach((doc) {
      Visitor e = Visitor(
        doc["ID"],
        doc["TaskID"],
        doc["Name"],
        doc["Surname"],
        doc["Phone"],
        doc["EMail"],
      );
      x = e;
    });
    print(x.getName());
    return x;
  }

  /************************************************************************************************************************/
  Future<void> deleteVisitor(int id) async {
    //DELETE VISITOR
    final visitorSnapshot = await FirebaseFirestore.instance
        .collection('_visitor_')
        .where('ID', isEqualTo: id)
        .get();
    if (visitorSnapshot.size == 0) {
      // There is no visitor with given id
      print("There is not visitor with given ID");
      return;
    }
    final visitorDoc = visitorSnapshot.docs.first;
    await FirebaseFirestore.instance
        .collection('visitor')
        .doc(visitorDoc.id)
        .delete();

    print('Visitor with  is deleted');
  }
  /************************************************************************************************************************/
  /**
   * 
   *    VISITOR END
   * 
  */

  /**
   * 
   *    EMPLOYEE START
   * 
  */
  /************************************************************************************************************************/
  Future<void> addEmployee(
      //ADD
      int id,
      String name,
      String surname,
      String department,
      String email,
      String password,
      String title,
      String phone,
      String campusAtWorking) async {
    CollectionReference employees =
        FirebaseFirestore.instance.collection('_employee_');
    await employees.add({
      'ID': id,
      'Name': name,
      'Surname': surname,
      'Department': department,
      'EMail': email,
      'Password': password,
      'Title': title,
      'Phone': phone,
      'CampusAtWorking': campusAtWorking
    });
    print('Employee added successfully.');
  }

/************************************************************************************************************************/
  Future<void> changePassword(int id, String newPassword) async {
    //CHANGE PASSWORD
    // Kullanıcı adına göre kullanıcıyı bul
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('_employee_')
        .where('ID', isEqualTo: id)
        .get();
    // Kullanıcı bulunamazsa hata mesajı göster ve fonksiyondan çık
    if (querySnapshot.docs.isEmpty) {
      print('Kullanıcı bulunamadı.');
      return;
    }
    // Kullanıcı varsa şifresini güncelle
    String userId = querySnapshot.docs.first.id;
    await FirebaseFirestore.instance
        .collection('_employee_')
        .doc(userId)
        .update({'Password': newPassword});

    print('Şifre güncellendi.');
  }

/************************************************************************************************************************/
  Future<void> deleteEmployee(int id) async {
    //DELETE EMPLOYEE
    final employeeSnapshot = await FirebaseFirestore.instance
        .collection('_employee_')
        .where('ID', isEqualTo: id)
        .get();

    if (employeeSnapshot.size == 0) {
      // There is no employee with given name
      return;
    }

    final employeeDoc = employeeSnapshot.docs.first;

    await FirebaseFirestore.instance
        .collection('_employee_')
        .doc(employeeDoc.id)
        .delete();

    print('Employee with  is deleted');
  }

  /************************************************************************************************************************/
  Future<List<Employee>> employeesWithInDepartment(String department) async {
    List<Employee> employees = [];
    //READ WITH ID
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('_employee_')
        .where('Department', isEqualTo: department)
        .get();
    if (querySnapshot.docs.isEmpty) {
      throw Exception('No employee found with id: $department');
    }
    Employee x = Employee.fromEmployee();
    querySnapshot.docs.forEach((doc) {
      Employee e = Employee(
          doc["ID"],
          doc["Name"],
          doc["Surname"],
          doc["Department"],
          doc["EMail"],
          doc["Password"],
          doc["Title"],
          doc["Phone"],
          doc["CampusAtWorking"],
          doc['Activation']);
      x = e;
      if (x.getEmployeeTitle != "Department Chief") {
        employees.add(x);
      }
      // employees.add(x);
    });
    print(x.getEmployeeName);
    return employees;
  }

/************************************************************************************************************************/
  Future<Employee> FindEmployeeWithTaskID(int taskID) async {
    //print("TaskID" + taskID.toString());
    List<Task> tasks = [];
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('_task_')
        .where('TaskID', isEqualTo: taskID)
        .limit(1)
        .get();
    if (querySnapshot.docs.isEmpty) {
      throw Exception('No employee found with id: $taskID');
    }
    Task task = Task.fromTask();
    querySnapshot.docs.forEach((doc) {
      var nomDate = doc['NominationDate'].toDate();
      var startDate = doc['StartingDate'].toDate();
      var finishDate = doc['FinishDate'].toDate();
      var dueDate = doc['DueDate'].toDate();
      List<dynamic> urlsFromDb = doc['ImageUrls'];
      List<String> realUrls =
          urlsFromDb.map((dynamic item) => item.toString()).toList();
      Task e = Task(
          doc['TaskID'],
          doc['StaffID'],
          doc['NominatorID'],
          doc['LocationID'],
          doc['ReporterID'],
          doc['Status'],
          nomDate,
          dueDate,
          startDate,
          finishDate,
          doc['Type'],
          doc['Department'],
          realUrls,
          doc['Title'],
          doc['Description'],
          doc['Score']);
      task = e;
    });
    print("taskID2:" + task.getTaskID().toString());
    Employee x = await readEmployeeWithID(task.getStaffID());

    print("EmpID" + x.getEmployeeId.toString());
    return x;
  }

/************************************************************************************************************************/
  Future<Employee> readEmployeeWithID(int id) async {
    //READ WITH ID
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('_employee_')
        .where('ID', isEqualTo: id)
        .limit(1)
        .get();
    if (querySnapshot.docs.isEmpty) {
      throw Exception('No employee found with id: $id');
    }
    Employee x = Employee.fromEmployee();
    querySnapshot.docs.forEach((doc) {
      Employee e = Employee(
          doc["ID"],
          doc["Name"],
          doc["Surname"],
          doc["Department"],
          doc["EMail"],
          doc["Password"],
          doc["Title"],
          doc["Phone"],
          doc["CampusAtWorking"],
          doc['Activation']);
      x = e;
    });
    print(x.getEmployeeName);
    return x;
  }
/************************************************************************************************************************/

// Future <Employee> readEmployeewithTaskID(int task)async{
//   Employee employee=Employee.fromEmployee();
//       final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//         .collection('employee')
//         .where('ID', isEqualTo: id)
//         .limit(1)
//         .get();
// }

/************************************************************************************************************************/
  Future<List<Employee>> readEmployees() async {
    //READ EMPLOYEES
    List<Employee> employees = [];
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('_employee_').get();
    querySnapshot.docs.forEach((doc) {
      //Employee(int id, String name, String surname, String department, String email,string password, String title, String phone, String campusAtWorking)
      Employee e = Employee(
          doc["ID"],
          doc["Name"],
          doc["Surname"],
          doc["Department"],
          doc["EMail"],
          doc["Password"],
          doc["Title"],
          doc["Phone"],
          doc["CampusAtWorking"],
          doc['Activation']);
      employees.add(e);
    });
    return employees;
  }

  /************************************************************************************************************************/
  Future<Employee> login(String email, String password) async {
    //LOGIN
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    var hashHex = digest.toString();
    final result = await FirebaseFirestore.instance
        .collection('_employee_')
        .where('EMail', isEqualTo: email)
        .where('Password', isEqualTo: hashHex)
        .limit(1)
        .get();
    Employee e = Employee.fromEmployee();
    if (result.docs.isNotEmpty) {
      Employee x = await getCurrentUser(email, hashHex);
      print(x.getEmployeePassword);
      e = x;
    }
    //print("Activation:" + e.getActivation);
    return e;
  }

  Future<Employee> getCurrentUser(String email, String password) async {
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('_employee_')
        .where('EMail', isEqualTo: email)
        .where('Password', isEqualTo: password)
        .limit(1)
        .get();
    Employee x = Employee.fromEmployee();
    querySnapshot.docs.forEach((doc) {
      Employee e = Employee(
          doc["ID"],
          doc["Name"],
          doc["Surname"],
          doc["Department"],
          doc["EMail"],
          doc["Password"],
          doc["Title"],
          doc["Phone"],
          doc["CampusAtWorking"],
          doc['Activation']);
      if (e.getActivation == "Active") {
        x = e;
      }
      if (e.getActivation == "Passive") {
        print("There is Not any record email and password");
      }
    });
    //print(x.getEmployeeName);
    return x;
  }

  /************************************************************************************************************************/
  Future<Employee> findTransferManager() async {
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('_employee_')
        .where('Title', isEqualTo: "Transfer Manager")
        .limit(1)
        .get();
    if (querySnapshot.docs.isEmpty) {
      print("findTransferManager TransferManager Bulunamadı");
      Employee e = Employee.fromEmployee();
      e.setEmployeeId = -999;
      return e;
    }
    Employee x = Employee.fromEmployee();
    querySnapshot.docs.forEach((doc) {
      Employee e = Employee(
          doc["ID"],
          doc["Name"],
          doc["Surname"],
          doc["Department"],
          doc["EMail"],
          doc["Password"],
          doc["Title"],
          doc["Phone"],
          doc["CampusAtWorking"],
          doc['Activation']);
      x = e;
    });
    return x;
  }
  /************************************************************************************************************************/
  /**
   * 
   *               EMPLOYEE END
   * 
  */
}
