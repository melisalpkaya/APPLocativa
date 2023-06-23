import 'package:geolocator/geolocator.dart';

class CustomLocation {
  late int LocationID;
  late int TaskID;
  late String Campus;
  late int Floor;
  late String RoomID;
  late Position currentLocation;
  late String address;

  CustomLocation(int id, int TaskID, String campus, int floor, String roomID,
      Position location, String address) {
    this.LocationID = id;
    this.TaskID = TaskID;
    this.Campus = campus;
    this.Floor = floor;
    this.RoomID = roomID;
    this.currentLocation = location;
    this.address = address;
  }
  CustomLocation.fromLocation() {}
  int get getlocationID => this.LocationID;
  set setLocationID(int value) => this.LocationID = value;

  int get getTaskID => this.TaskID;
  set setTaskID(int value) => this.TaskID = value;

  String get getCampus => this.Campus;
  set setCampus(String value) => this.Campus = value;

  int get getFloor => this.Floor;
  set setFloor(int value) => this.Floor = value;

  String get getRoomID => this.RoomID;
  set setRoomID(String value) => this.RoomID = value;

  Position get getCurrentLocation => this.currentLocation;
  set setCurrentLocation(Position value) => this.currentLocation = value;
  String get getAddress => this.address;
  set setAddress(String value) => this.address = value;

  /*var get currentLocation => _currentLocation;
  set currentLocation(var value) => _currentLocation = value;*/
}
