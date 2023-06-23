import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:locativa/FaultReport/stepTwo.dart';
import '../Chunk.dart';
import '../ColorsClass/colors.dart';
import '../DatabaseHelper.dart';
import '../CustomLocation.dart';

class Categories extends StatefulWidget {
  Chunk chunk = Chunk.fromChunk();
  Categories(this.chunk);
  @override
  _CategoriesState createState() => _CategoriesState(this.chunk);
}

class _CategoriesState extends State<Categories> {
  Chunk chunk = Chunk.fromChunk();
  int selectedBoxIndex = -1;
  _CategoriesState(this.chunk);
  Color _boxColor1 = AppColors.navy;
  Color _boxColor2 = AppColors.white;
  Color _boxColor3 = AppColors.white;
  Color _boxColor4 = AppColors.white;
  Color _boxColor5 = AppColors.white;
  Color _textColor1 = AppColors.white;
  Color _textColor2 = AppColors.text3;
  Color _textColor3 = AppColors.text3;
  Color _textColor4 = AppColors.text3;
  Color _textColor5 = AppColors.text3;
  Color _iconColor = AppColors.yellow;
  Color _iconColor2 = AppColors.navy;
  Color _iconColor3 = AppColors.navy;
  Color _iconColor4 = AppColors.navy;

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
            'Adım 1/3',
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 30, horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'En uygun',
                    style: TextStyle(
                      color: AppColors.text,
                      fontFamily: 'WorkSans',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'kategoriyi seçin',
                    style: TextStyle(
                      color: AppColors.text,
                      fontFamily: 'WorkSans',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (selectedBoxIndex != 1) {
                            _resetBoxColors(); // Reset colors of all boxes
                            _boxColor1 = AppColors.navy;
                            _textColor1 = AppColors.white;
                            _iconColor = AppColors.yellow;
                            this.chunk.setTaskType = "Electric";
                            print(chunk.getTaskType);
                            selectedBoxIndex = 1;
                          } else {
                            _resetBoxColors(); // Deselect the box
                            selectedBoxIndex = -1;
                          }
                          // _boxColor1 = _boxColor1 == AppColors.navy
                          //     ? AppColors.white
                          //     : AppColors.navy;
                          // _textColor1 = _textColor1 == AppColors.white
                          //     ? AppColors.text3
                          //     : AppColors.white;
                          // _iconColor = _iconColor == AppColors.navy
                          //     ? AppColors.yellow
                          //     : AppColors.navy;
                          // this.chunk.setTaskType = "Electric";
                          //print(chunk.getTaskType);
                        });
                      },
                      child: Container(
                        height: 177,
                        width: 153,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: _boxColor1,
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              top: 30,
                              left: 15,
                              child: Icon(
                                Icons.lightbulb_rounded,
                                color: _iconColor,
                                size: 50,
                              ),
                            ),
                            Positioned(
                              bottom: 40,
                              left: 20,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Elektrik',
                                    style: TextStyle(
                                      color: _textColor1,
                                      fontSize: 18,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    'Arızası',
                                    style: TextStyle(
                                      color: _textColor1,
                                      fontSize: 18,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    //yapı arızası butonu
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (selectedBoxIndex != 2) {
                            _resetBoxColors(); // Reset colors of all boxes
                            _boxColor2 = AppColors.navy;
                            _textColor2 = AppColors.white;
                            _iconColor2 = AppColors.construction;
                            this.chunk.setTaskType = "Yapı";
                            print(chunk.getTaskType);
                            selectedBoxIndex = 2;
                          } else {
                            _resetBoxColors(); // Deselect the box
                            selectedBoxIndex = -1;
                          }
                          // _boxColor2 = _boxColor2 == AppColors.navy
                          //     ? AppColors.white
                          //     : AppColors.navy;
                          // _textColor2 = _textColor2 == AppColors.white
                          //     ? AppColors.text3
                          //     : AppColors.white;
                          // _iconColor2 = _iconColor2 == AppColors.navy
                          //     ? AppColors.construction
                          //     : AppColors.navy;
                          // this.chunk.setTaskType = "Yapı";
                        });
                      },
                      child: Container(
                        height: 177,
                        width: 153,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: _boxColor2,
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              top: 40,
                              left: 15,
                              child: Icon(
                                Icons.construction_rounded,
                                color: _iconColor2,
                                size: 50,
                              ),
                            ),
                            Positioned(
                              bottom: 35,
                              left: 25,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Yapı',
                                    style: TextStyle(
                                      color: _textColor2,
                                      fontSize: 18,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    'Arızası',
                                    style: TextStyle(
                                      color: _textColor2,
                                      fontSize: 18,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    //talep - istek butonu
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (selectedBoxIndex != 3) {
                            _resetBoxColors(); // Reset colors of all boxes
                            _boxColor3 = AppColors.navy;
                            _textColor3 = AppColors.white;

                            this.chunk.setTaskType = "Request";
                            print(chunk.getTaskType);
                            selectedBoxIndex = 3;
                          } else {
                            _resetBoxColors(); // Deselect the box
                            selectedBoxIndex = -1;
                          }
                          // _boxColor3 = _boxColor3 == AppColors.navy
                          //     ? AppColors.white
                          //     : AppColors.navy;
                          // _textColor3 = _textColor3 == AppColors.white
                          //     ? AppColors.text3
                          //     : AppColors.white;
                          // this.chunk.setTaskType = "Request";
                          // print(chunk.getTaskType);
                        });
                      },
                      child: Container(
                        height: 113,
                        width: 153,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: _boxColor3,
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              top: 12,
                              left: 15,
                              child: Icon(
                                Icons.favorite,
                                color: AppColors.heart,
                                size: 50,
                              ),
                            ),
                            Positioned(
                              bottom: 20,
                              left: 20,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Talep / İstek',
                                    style: TextStyle(
                                      color: _textColor3,
                                      fontSize: 18,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //su arızası butonu
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (selectedBoxIndex != 4) {
                            _resetBoxColors(); // Reset colors of all boxes
                            _boxColor4 = AppColors.navy;
                            _textColor4 = AppColors.white;
                            _iconColor3 = AppColors.waterDrop;
                            this.chunk.setTaskType = "Water";
                            print(chunk.getTaskType);
                            selectedBoxIndex = 4;
                          } else {
                            _resetBoxColors(); // Deselect the box
                            selectedBoxIndex = -1;
                          }
                          // _boxColor4 = _boxColor4 == AppColors.navy
                          //     ? AppColors.white
                          //     : AppColors.navy;
                          // _textColor4 = _textColor4 == AppColors.white
                          //     ? AppColors.text3
                          //     : AppColors.white;
                          // _iconColor3 = _iconColor3 == AppColors.navy
                          //     ? AppColors.waterDrop
                          //     : AppColors.navy;
                          // this.chunk.setTaskType = "Water";
                          // print(chunk.getTaskType);
                        });
                      },
                      child: Container(
                        height: 181,
                        width: 153,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: _boxColor4,
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              top: 40,
                              left: 15,
                              child: Icon(
                                Icons.water_drop,
                                color: _iconColor3,
                                size: 50,
                              ),
                            ),
                            Positioned(
                              bottom: 35,
                              left: 25,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Su',
                                    style: TextStyle(
                                      color: _textColor4,
                                      fontSize: 18,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    'Arızası',
                                    style: TextStyle(
                                      color: _textColor4,
                                      fontSize: 18,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    //teknik arıza butonu
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (selectedBoxIndex != 5) {
                            _resetBoxColors(); // Reset colors of all boxes
                            _boxColor5 = AppColors.navy;
                            _textColor5 = AppColors.white;
                            _iconColor4 = AppColors.cable;
                            this.chunk.setTaskType = "Technical";
                            print(chunk.getTaskType);
                            selectedBoxIndex = 5;
                          } else {
                            _resetBoxColors(); // Deselect the box
                            selectedBoxIndex = -1;
                          }
                          // _boxColor5 = _boxColor5 == AppColors.navy
                          //     ? AppColors.white
                          //     : AppColors.navy;
                          // _textColor5 = _textColor5 == AppColors.white
                          //     ? AppColors.text3
                          //     : AppColors.white;
                          // _iconColor4 = _iconColor4 == AppColors.navy
                          //     ? AppColors.cable
                          //     : AppColors.navy;
                          // this.chunk.setTaskType = "Technical";
                        });
                      },
                      child: Container(
                        height: 181,
                        width: 153,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: _boxColor5,
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              top: 40,
                              left: 15,
                              child: Icon(
                                Icons.cable,
                                color: _iconColor4,
                                size: 50,
                              ),
                            ),
                            Positioned(
                              bottom: 35,
                              left: 25,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Teknik',
                                    style: TextStyle(
                                      color: _textColor5,
                                      fontSize: 18,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    'Arıza',
                                    style: TextStyle(
                                      color: _textColor5,
                                      fontSize: 18,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () async {
                DatabaseHelper db = DatabaseHelper();
                await db.getCurrentLocation().then((value) {
                  chunk.setLat = double.parse('${value.latitude}');
                  chunk.setLon = double.parse('${value.longitude}');
                });
                await db
                    .getAddressFromCoordinates(chunk.getLat, chunk.getLon)
                    .then((value) {
                  chunk.setAddress = value;
                });
                Position currentLocation;
                currentLocation = Position(
                    longitude: chunk.getLon,
                    latitude: chunk.getLat,
                    timestamp: null,
                    accuracy: 0,
                    altitude: 0,
                    heading: 0,
                    speed: 0,
                    speedAccuracy: 0);

                //
                List<String> result =
                    await db.findSensitiveLocation(currentLocation);
                //

                int locID = await db.variableGetAndUpdateLocationID();
                CustomLocation location;
                if (result.isNotEmpty/*result[0] == "true"*/) {
                  //
                  location = CustomLocation(locID, 0, result[1]+", Block:"+result[2],
                      int.parse(result[3]), result[4], currentLocation, " ");
                  //
                } else {
                  location = CustomLocation(locID, 0, "Unknown",
                      0, "Unknown", currentLocation, " ");
                }

                print("categories-->" + location.getAddress);
                chunk.setLocation(location);
                print(locID);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StepTwo(this.chunk)),
                );
              },
              child: Container(
                height: 51.2,
                decoration: BoxDecoration(
                  color: AppColors.navy,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 10),
                        child: Text(
                          "İlerle",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 35,
                      height: 35,
                      margin: EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        color: AppColors.yellow,
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: Icon(Icons.arrow_forward, color: Colors.white),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _resetBoxColors() {
    _boxColor1 = AppColors.white;
    _boxColor2 = AppColors.white;
    _boxColor3 = AppColors.white;
    _boxColor4 = AppColors.white;
    _boxColor5 = AppColors.white;
    _textColor1 = AppColors.text3;
    _textColor2 = AppColors.text3;
    _textColor3 = AppColors.text3;
    _textColor4 = AppColors.text3;
    _textColor5 = AppColors.text3;
    _iconColor = AppColors.navy;
    _iconColor2 = AppColors.navy;
    _iconColor3 = AppColors.navy;
    _iconColor4 = AppColors.navy;
  }
}
