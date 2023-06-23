import 'dart:core';
import 'dart:core';

import 'Visitor.dart';
import 'Employee.dart';
import 'CustomLocation.dart';
import 'Task.dart';

class Chunk {
  late Employee currentUser;
  late Visitor visitor;
  late Task task;
  late CustomLocation location;

  late String taskType = "Electric"; //Electric Water etc.
  late String taskTitle = " ";
  late String taskExplanation = " ";
  late String optional;
  late double lon;
  late double lat;
  late String address;
  late List<Task> newTasksNotification;
  late Task taskForDetailPage;
  late DateTime dateTime;
  late String taskStatusID;
  late Employee employeeForDetailPage;

  Chunk.fromChunk() {}

  Chunk(Employee e, Visitor v, Task t, CustomLocation l) {
    this.currentUser = e;
    this.location = l;
    this.task = t;
    this.visitor = v;
  }

  // Getters and Setters

  Employee getEmployee() {
    return currentUser;
  }

  void setEmployee(Employee employee) {
    this.currentUser = employee;
  }

  Visitor getVisitor() {
    return visitor;
  }

  void setVisitor(Visitor visitor) {
    this.visitor = visitor;
  }

  Task getTask() {
    return task;
  }

  void setTask(Task task) {
    this.task = task;
  }

  CustomLocation getLocation() {
    return location;
  }

  void setLocation(CustomLocation location) {
    this.location = location;
  }

  // Getters and Setters

  set setTaskType(String value) => taskType = value;

  String get getTaskType => taskType;

  String get getTaskTitle => taskTitle;

  set setTaskTitle(String value) => taskTitle = value;

  String get getTaskExplanation => taskExplanation;

  set setTaskExplanation(String value) => taskExplanation = value;

  String get getOptional => optional;

  set setOptional(String value) => optional = value;

  double get getLon => lon;

  set setLon(double value) => lon = value;

  double get getLat => lat;

  set setLat(double value) => lat = value;

  String get getAddress => address;

  set setAddress(String value) => address = value;

  List<Task> get getNewTasksNotification => newTasksNotification;

  set setNewTasksNotification(List<Task> value) => newTasksNotification = value;

  Task get getTaskForDetailPage => taskForDetailPage;

  set setTaskForDetailPage(Task value) => taskForDetailPage = value;

  DateTime get getDateTime => dateTime;

  set setDateTime(DateTime value) => dateTime = value;

  String get getTaskStatusID => taskStatusID;

  set setTaskStatusID(String value) => taskStatusID = value;

  Employee get getEmployeeForDetailPage=> employeeForDetailPage;
  set setEmployeeForDetailPage(Employee e)=> employeeForDetailPage=e;
}
