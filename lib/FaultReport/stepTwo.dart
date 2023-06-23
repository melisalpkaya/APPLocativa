import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:locativa/FaultReport/stepThree.dart';
import '../Chunk.dart';
import '../ColorsClass/colors.dart';
import '../static_data.dart';
import '../CustomLocation.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:wifi_info_plugin_plus/wifi_info_plugin_plus.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class StepTwo extends StatefulWidget {
  Chunk chunk = Chunk.fromChunk();
  StepTwo(this.chunk);
  StepTwoState createState() => StepTwoState(this.chunk);
}

class StepTwoState extends State<StepTwo> {
  Chunk chunk =Chunk.fromChunk();
  StepTwoState(this.chunk);
  List<File> _imageFiles = [];                                          // fotoğrafları chunka taşı daha sonra 
  bool isEditable = false;
  bool isDialogShowing = false;
  final _picker = ImagePicker();
  WifiInfoWrapper? _wifiObject;
  //Location l=Location(id, TaskID, campus, floor, roomID, location)

  Future<void> _pickImage(ImageSource source) async {
    List<XFile> pickedFiles = [];
    // Set maximum image count to 10
    final maxImageCount = 3;

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

  TextEditingController dateController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  Future<void> initPlatformState() async {
    WifiInfoWrapper? wifiObject;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      wifiObject = await WifiInfoPlugin.wifiDetails;
    } on PlatformException {}
    if (!mounted) return;

    setState(() {
      _wifiObject = wifiObject;
    });
  }

  @override
  void initState() {
    super.initState();
    dateController.text = "";
    locationController.text = chunk.getAddress;
    initPlatformState();
  }

  @override
  void dispose() {
    dateController.dispose();
    locationController.dispose();
    super.dispose();
  }

  int _rating = 0;

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
            'Adım 2/3',
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
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: const Text(
                      'Fotoğraf yükle',
                      style: TextStyle(
                        fontSize: 24,
                        color: AppColors.text,
                        fontFamily: 'WorkSans',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Center(
                    child: Container(
                      height: 230,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (_imageFiles.isNotEmpty)
                              SizedBox(
                                height: 200,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: _imageFiles.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Stack(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(8),
                                          child: Image.file(_imageFiles[index]),
                                        ),
                                        Positioned(
                                          top: 0,
                                          right: 0,
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _imageFiles.removeAt(index);
                                              });
                                            },
                                            child: Container(
                                              padding: EdgeInsets.all(4),
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.red,
                                              ),
                                              child: Icon(
                                                Icons.close,
                                                color: Colors.white,
                                                size: 18,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            if (_imageFiles.isEmpty)
                              const Icon(
                                Icons.insert_photo_outlined,
                              ),
                            if (_imageFiles.isEmpty) const SizedBox(height: 10),
                            if (_imageFiles.isEmpty)
                              Text(
                                "İstediğiniz fotoğrafları seçin",
                                style: TextStyle(
                                  color: AppColors.text.withOpacity(0.5),
                                  fontFamily: 'WorkSans',
                                  fontSize: 19,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            SizedBox(
                              height: 30,
                            ),
                            if (_imageFiles.isEmpty)
                              ElevatedButton(
                                onPressed: () => _pickImage(ImageSource.camera),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.purple,
                                  fixedSize: const Size(165, 41),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(9),
                                  ),
                                ),
                                child: const Text(
                                  'Yükle',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: AppColors.background,
                                    fontFamily: 'WorkSans',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    height: 235,
                    padding: EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: AppColors.text.withOpacity(0.4),
                                  size: 30,
                                ),
                                SizedBox(height: 15),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Stack(
                                      alignment: Alignment.topRight,
                                      children: [
                                        ConstrainedBox(
                                          constraints: BoxConstraints(
                                            maxHeight:
                                                200, // Metin alanının maksimum yüksekliğini belirleyin
                                          ),
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(top: 10),
                                            child: TextField(
                                              controller: locationController,
                                              enabled: isEditable,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: AppColors.text
                                                    .withOpacity(0.5),
                                                fontFamily: 'WorkSans',
                                                fontSize: 18,
                                                fontWeight: FontWeight.normal,
                                              ),
                                              maxLines: null,
                                              decoration: InputDecoration(
                                                border: InputBorder
                                                    .none, // Çizgiyi kaldırmak için
                                              ),
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              isEditable = true;
                                            });
                                          },
                                          child: Icon(
                                            Icons.edit,
                                            color:
                                                AppColors.navy.withOpacity(0.7),
                                            size: 18,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    if (isEditable)
                                      ElevatedButton(
                                        onPressed: () {
                                          print(
                                              "hey:" + locationController.text);
                                          CustomLocation location =
                                              chunk.getLocation();
                                          location.setAddress =
                                              locationController.text;
                                          //print("Address stepTwo"+location.getAddress);
                                          chunk.setLocation(location);
                                          print("Steptwo Chunk " +
                                              chunk.getAddress);
                                          setState(() {
                                            isEditable = false;
                                          });

                                          AwesomeDialog(
                                            // Dialog ayarları
                                            context: context,
                                            dialogType: DialogType.SUCCES,
                                            animType: AnimType.SCALE,
                                            title: 'Güncellendi',
                                            desc: locationController.text,
                                            btnOkText: 'Tamam',
                                            btnOkOnPress: () {
                                              print(locationController.text);
                                              setState(() {
                                                isDialogShowing = false;
                                              });
                                            },
                                            btnOkColor: AppColors.purple,
                                            buttonsTextStyle: TextStyle(
                                              color: AppColors
                                                  .white, // Metin rengi
                                              fontFamily:
                                                  'WorkSans', // Yazı tipi
                                              fontSize: 18, // Font büyüklüğü
                                              fontWeight: FontWeight
                                                  .bold, // Yazı kalınlığı
                                            ),
                                            titleTextStyle: TextStyle(
                                              color: AppColors
                                                  .egeGreen, // Başlık metni rengi
                                              fontSize:
                                                  20, // Başlık metni boyutu
                                              fontWeight: FontWeight
                                                  .bold, // Başlık metni kalınlığı
                                            ),
                                            buttonsBorderRadius:
                                                BorderRadius.circular(10),
                                          ).show();
                                        },
                                        child: Text(
                                          "Güncelle",
                                          style: TextStyle(
                                            fontFamily: 'WorkSans',
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        CustomLocation location = chunk.getLocation();
                        location.setAddress = locationController.text;

                        String ipAddress = _wifiObject != null
                            ? _wifiObject!.ipAddress.toString()
                            : "...";
                        String macAddress = _wifiObject != null
                            ? _wifiObject!.macAddress.toString()
                            : '...';
                        String connectionType = _wifiObject != null
                            ? _wifiObject!.connectionType.toString()
                            : 'unknown';
                        String signalStrength = _wifiObject != null
                            ? _wifiObject!.signalStrength.toString()
                            : 'unknown';
                        String frequency = _wifiObject != null
                            ? _wifiObject!.frequency.toString()
                            : 'unknown';
                            print(macAddress);
                        print(chunk.getTaskType);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => StepThree(this.chunk)),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.navy,
                        fixedSize: const Size(289, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(17),
                        ),
                      ),
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
                  ),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
