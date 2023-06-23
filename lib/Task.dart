/*final DateTime now = DateTime.now();
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  final String formatted = formatter.format(now);*/

// ignore: file_names
// ignore_for_file: prefer_initializing_formals

class Task {
  late int taskID;
  late int staffID;
  late int nominatorID;
  late int locationID;
  late int reporterID;
  late String status;
  late DateTime nominationDate;
  late DateTime dueDate;
  late DateTime startingDate;
  late DateTime finishDate;
  late String type;
  late String department;
  //late int photographID;
  late List<String> image_urls;
  late String title;
  late String description;
  late int score ;

  Task.fromTask() {}

  Task(
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
      //int photographID,
      List<String>urls,
      String title,
      String description,int score) {
    this.taskID = taskID;
    this.staffID = staffID;
    this.nominatorID = nominatorID;
    this.locationID = locationID;
    this.reporterID = reporterID;
    this.status = status;
    this.nominationDate = nominationDate;
    this.dueDate = dueDate;
    this.startingDate = startingDate;
    this.finishDate = finishDate;
    this.type = type;
    this.department = department;
    //this.photographID = photographID;
    this.image_urls=urls;
    this.title = title;
    this.description = description;
    this.score=score;
  }
  int getTaskID() => taskID;
  setTaskID(int taskID) => this.taskID = taskID;

  int getStaffID() => staffID;
  setStaffID(int staffID) => this.staffID = staffID;

  int getNominatorID() => nominatorID;
  setNominatorID(int nominatorID) => this.nominatorID = nominatorID;

  int getLocationID() => locationID;
  setLocationID(int locationID) => this.locationID = locationID;

  int getReporterID() => reporterID;
  setReporterID(int reporterID) => this.reporterID = reporterID;

  String getStatus() => status;
  setStatus(String status) => this.status = status;

  DateTime getNominationDate() => nominationDate;
  setNominationDate(DateTime nominationDate) =>
      this.nominationDate = nominationDate;

  DateTime getDueDate() => dueDate;
  setDueDate(DateTime dueDate) => this.dueDate = dueDate;

  DateTime getStartingDate() => startingDate;
  setStartingDate(DateTime startingDate) => this.startingDate = startingDate;

  DateTime getFinishDate() => finishDate;
  setFinishDate(DateTime finishDate) => this.finishDate = finishDate;

  String getType() => type;
  setType(String type) => this.type = type;

  String getDepartment() => department;
  setDepartment(String department) => this.department = department;

  // int getPhotographID() => photographID;
  // setPhotographID(int photographID) => this.photographID = photographID;

  List<String> get getUrls =>image_urls;
  set setUrls(List<String> urls)=>this.image_urls=urls;

  String getTitle() => title;
  setTitle(String title) => this.title = title;

  String getDescription() => description;
  setDescription(String description) => this.description = description;

  int getTaskScore() => score;
  setTaskScore(int score) => this.score = score;
}
