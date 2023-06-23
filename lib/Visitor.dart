// ignore_for_file: file_names, prefer_initializing_formals

import 'dart:math';

class Visitor {
  late int visitorID;
  late int taskID;
  late String name;
  late String surname;
  late String phone;
  late String email;

  Visitor(int visitorID, int taskID, String name, String surname, String phone,
      String email) {
    this.visitorID = visitorID;
    this.taskID = taskID;
    this.name = name;
    this.surname = surname;
    this.phone = phone;
    this.email = email;
  }

  Visitor.fromVisitor() {}

  int getVisitorID() => visitorID;
  setVisitorID(int visitorID) => this.visitorID = visitorID;

  int getTaskID() => taskID;
  setTaskID(int taskID) => this.taskID = taskID;

  String getName() => name;
  setName(String name) => this.name = name;

  String getSurname() => surname;
  setSurname(String surname) => this.surname = surname;

  String getPhone() => phone;
  setPhone(String phone) => this.phone = phone;
}
