import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:locativa/DepartmentChief/departmentChiefHp.dart';
import 'package:locativa/Employee/employee.dart';
import 'package:locativa/TransferManager/transferHomePage.dart';
import '../Chunk.dart';
import 'DatabaseHelper.dart';
import 'Employee.dart';
import 'ColorsClass/colors.dart';
import 'Staff/staff.dart';
import 'ForgotPassword/forgotPassword.dart';
import 'Manager/manager.dart';
import 'Task.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  DatabaseHelper db = DatabaseHelper();
  Employee currentUser = Employee.fromEmployee();
  RegExp emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
  Chunk chunk = Chunk.fromChunk();

  @override
  void dispose() {
    // Dispose the controllers when the widget is removed from the tree
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool isFieldsEmpty() {
    final title = _emailController.text.trim();
    final description = _passwordController.text.trim();

    return title.isEmpty || description.isEmpty;
  }

  bool isEmailValid(String email) {
    return emailRegex.hasMatch(email);
  }

  Future<void> onSubmitButtonPressed() async {

    // print("Hey");
    //db.findSensitiveLocation();
    // print("hey");

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
    } else if (!isEmailValid(_emailController.text.trim())) {
      AwesomeDialog(
        // Dialog ayarları
        context: context,
        dialogType: DialogType.ERROR,
        animType: AnimType.SCALE,
        title: 'Hata',
        desc: 'Geçerli bir e-posta adresi giriniz.',
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
      String emailLogin = _emailController.text.toString();
      String passwordLogin = _passwordController.text.toString();
      print("email:"+emailLogin+"<--");
      if(emailLogin.endsWith(" ")){
        emailLogin=emailLogin.replaceAll(" ", "");
        print("email:"+emailLogin+"<--");
      }
      bool condition = false;
      currentUser = await db.login(emailLogin, passwordLogin);
      chunk.currentUser = currentUser;
      List<Task> noficationList = [];
      chunk.setNewTasksNotification = noficationList;
      if (currentUser.getEmployeeTitle.toString() == "Manager") {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ManagerHomePage(this.chunk)),
        );
        //sayfa geçişi manager için
      } else if (currentUser.getEmployeeTitle.toString() == "Staff") {
        //sayfa geçişi staff için
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Staff(this.chunk)),
        );
      } else if (currentUser.getEmployeeTitle.toString() == "Employee") {
        //sayfa geçişi transfer Manager için a
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => EmployeePage(this.chunk)),
        );
      } else if (currentUser.getEmployeeTitle.toString() ==
          "Transfer Manager") {
        //sayfa geçişi transfer Manager için a
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TransferManager(this.chunk)),
        );
      } else if (currentUser.getEmployeeTitle.toString() ==
          "Department Chief") {
        //sayfa geçişi transfer Manager için a
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DepartmentChief(this.chunk)),
        );
      }
      // Tüm alanlar dolu ise işlemlerinizi burada gerçekleştirebilirsiniz.
    }
  }

  @override
  Widget build(BuildContext context) {
    //variables

    //
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/images/bg.png",
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 469,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(40),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10.0),
                  const Text(
                    'Hoşgeldiniz',
                    style: TextStyle(
                      fontSize: 23.0,
                      color: AppColors.navy2,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Work Sans',
                    ),
                  ),
                  SizedBox(height: 8),
                  const Text(
                    'Lütfen bilgileriniz ile giriş yapınız',
                    style: TextStyle(
                      fontSize: 15.0,
                      color: AppColors.text2,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Work Sans',
                    ),
                  ),
                  const SizedBox(height: 50.0),
                  const Text(
                    'E-posta Adresiniz',
                    style: TextStyle(
                      fontSize: 14.0,
                      color: AppColors.text2,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Work Sans',
                    ),
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      hintText: 'email@adress.com',
                    ),
                    style:
                        const TextStyle(fontSize: 13.0, color: AppColors.text),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20.0),
                  const Text(
                    'Parola',
                    style: TextStyle(
                      fontSize: 14.0,
                      color: AppColors.text2,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Work Sans',
                    ),
                  ),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: '*****',
                    ),
                    style:
                        const TextStyle(fontSize: 13.0, color: AppColors.text),
                  ),
                  const SizedBox(height: 15.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(child: Container()),
                      TextButton(
                        style: TextButton.styleFrom(
                          textStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Work Sans'),
                          foregroundColor: AppColors.text2,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ForgotPsw()),
                          );
                        },
                        child: const Text('Şifremi unuttum'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  Center(
                    child: ElevatedButton(
                      //MELİS BURASIII
                      //      |
                      //      |
                      //      v
                      onPressed: onSubmitButtonPressed,

                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.navy,
                          fixedSize: const Size(289, 50),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(17))),
                      child: const Text(
                        'Giriş Yap',
                        style: TextStyle(
                            fontFamily: 'WorkSans',
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            color: AppColors.background),
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
