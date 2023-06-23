class Employee {
  late int id;
  late String name;
  late String surname;
  late String department;
  late String email;
  late String password;
  late String title;
  late String phone;
  late String campusAtWorking;
  late String activation;

  Employee(
      int id,
      String name,
      String surname,
      String department,
      String email,
      String password,
      String title,
      String phone,
      String campusAtWorking,
      String activation) {
    this.id = id;
    this.name = name;
    this.surname = surname;
    this.department = department;
    this.email = email;
    this.password = password;
    this.title = title;
    this.phone = phone;
    this.campusAtWorking = campusAtWorking;
    this.activation = activation;
  }
  Employee.fromEmployee() {}

  int get getEmployeeId => id;
  set setEmployeeId(int id) => this.id = id;

  String get getEmployeeName => name;
  set setEmployeeName(String name) => this.name = name;

  String get getEmployeeSurname => surname;
  set setEmployeeSurname(String surname) => this.surname = surname;

  String get getEmployeeDepartment => department;
  set setEmployeeDepartment(String department) => this.department = department;

  String get getEmployeeEmail => email;
  set setEmployeeEmail(String email) => this.email = email;

  String get getEmployeePassword => password;
  set setEmployeePassword(String password) => this.password = password;

  String get getEmployeeTitle => title;
  set setEmployeeTitle(String title) => this.title = title;

  String get getEmployeePhone => phone;
  set setEmployeePhone(String phone) => this.phone = phone;

  String get getEmployeeCampusAtWorking => campusAtWorking;
  set setEmployeeCampusAtWorking(String campusAtWorking) =>
      this.campusAtWorking = campusAtWorking;

  String get getActivation => activation;
  set setActivation(String activation) => this.activation = activation;
}
