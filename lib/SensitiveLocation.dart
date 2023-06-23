import 'package:geolocator/geolocator.dart';

class SensitiveLocation {
  late String block;
  //late Position sag_on;
  late Position sag_arka;
  late Position sol_on;
  late String roomID;
  late int floor;
  //late Position sol_arka;

  SensitiveLocation(
      String block, Position sag_arka, Position sol_on, String roomID,int floor) {
    this.block = block;
    this.sag_arka = sag_arka;
    this.sol_on = sol_on;
    this.roomID = roomID;
    this.floor=floor;
  }

  SensitiveLocation.fromSensitiveLocation() {}

  String get getBlock => this.block;
  set setBlock(String block) => this.block = block;

  Position get getSagArka => this.sag_arka;
  set getSagArka(Position sag_arka) => this.sag_arka = sag_arka;

  Position get getSolOn => this.sol_on;
  set getSolOn(Position sol_on) => this.sol_on = sol_on;

  String get getRoomID => this.roomID;
  set setRoomID(String roomID) => this.roomID = roomID;

  int get getFloor=>this.floor;
  set getFloor(int floor) =>this.floor=floor;
}
