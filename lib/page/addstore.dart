// ignore_for_file: deprecated_member_use, non_constant_identifier_names

import 'dart:io';
import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class addstore extends StatefulWidget {
  const addstore({Key? key}) : super(key: key);

  @override
  State<addstore> createState() => _addstoreState();
}

class _addstoreState extends State<addstore> {
  User? user = FirebaseAuth.instance.currentUser;
  CollectionReference all = FirebaseFirestore.instance.collection('all');
  final storage = FirebaseStorage.instance;
  File? _imgPath;
  var _all;

  late String user_address_city = "";
  DateTime? time;
  DateTimeRange? Rangetime;

  // Create a storage reference from our app
  final storageRef = FirebaseStorage.instance.ref();

  bool Pick_DateRange = false;
  final commodity_price = TextEditingController();
  final commodity_Origin = TextEditingController();
  final commodity_stock = TextEditingController();
  final commodity_name = TextEditingController();
  final commodity_introduce = TextEditingController();
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(750, 1334));
    final width = (750.w) * 3;
    final height = (1334.h) * 3;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 57, 151, 123),
          centerTitle: true,
          title: Row(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  const ImageIcon(
                    AssetImage('img/w.jpg'),
                    size: 45,
                    color: Colors.amberAccent,
                  ),
                  Image.asset(
                    ("img/w.jpg"),
                    height: 40.0,
                  ),
                ],
              ),
              const Text(
                "????????????",
                style: TextStyle(fontSize: 30),
              ),
            ],
          ),
        ),
        backgroundColor: Color.fromARGB(255, 48, 48, 48),
        body: CupertinoScrollbar(
            thickness: 6.0,
            thicknessWhileDragging: 10.0,
            radius: const Radius.circular(34.0),
            radiusWhileDragging: Radius.zero,
            child: ListView(
              children: [
                FutureBuilder<DocumentSnapshot>(
                    future: all.doc("type").get(),
                    builder: (BuildContext context,
                        AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return const Text("?????????????????????",
                            textAlign: TextAlign.center);
                      }
                      if (snapshot.hasData && !snapshot.data!.exists) {
                        return const Text("?????????????????? ??????????????????",
                            textAlign: TextAlign.center);
                      }
                      if (snapshot.connectionState == ConnectionState.done) {
                        Map<String, dynamic> data =
                            snapshot.data!.data() as Map<String, dynamic>;
                        _all = data;
                      }
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(
                                  width: width / 3 * 0.5,
                                  height: 240,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50.0),
                                    child: SizedBox(
                                        width: width / 3 * 0.5,
                                        height: 240,
                                        child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50.0),
                                            child: TextButton(
                                              onPressed: () {
                                                showModalBottomSheet(
                                                  context: context,
                                                  backgroundColor:
                                                      const Color.fromARGB(
                                                          255, 33, 33, 33),
                                                  shape:
                                                      const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(20),
                                                    topRight:
                                                        Radius.circular(20),
                                                  )),
                                                  isScrollControlled: false,
                                                  isDismissible: true,
                                                  elevation: 40,
                                                  builder:
                                                      (BuildContext context) {
                                                    return Container(
                                                      height: 80,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          SingleChildScrollView(
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceEvenly,
                                                              children: <
                                                                  Widget>[
                                                                RaisedButton(
                                                                  shape: const RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.all(
                                                                              Radius.circular(14.0))), //????????????
                                                                  child:
                                                                      const Text(
                                                                          '??????'),
                                                                  color: const Color
                                                                          .fromARGB(
                                                                      128,
                                                                      97,
                                                                      254,
                                                                      207),
                                                                  onPressed:
                                                                      _takePhoto,
                                                                ),
                                                                RaisedButton(
                                                                  shape: const RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.all(
                                                                              Radius.circular(14.0))), //????????????
                                                                  child:
                                                                      const Text(
                                                                          '????????????'),
                                                                  color: const Color
                                                                          .fromARGB(
                                                                      128,
                                                                      97,
                                                                      254,
                                                                      207),
                                                                  onPressed:
                                                                      _openGallery,
                                                                ),
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                              child: !(_imgPath == null)
                                                  ? _ImageView(_imgPath)
                                                  : const Icon(
                                                      Icons
                                                          .add_photo_alternate_outlined,
                                                      size: 60,
                                                    ),
                                            ))),
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: width / 3 * 0.5,
                                      child: Card(
                                        elevation: 15.0, //????????????
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(14.0))), //????????????
                                        child: ListTile(
                                          minLeadingWidth: width / 3,
                                          title: const Text("??????"),
                                          subtitle: DropdownButton(
                                            items: type_list,
                                            hint: const AutoSizeText(
                                              "????????????",
                                              maxLines: 1,
                                            ), // ???????????????????????????
                                            onChanged: (as) {
                                              //??????????????????
                                              setState(() {
                                                user_address_city =
                                                    as.toString();
                                              });
                                            },
                                            value: user_address_city == ""
                                                ? "?????? ????????????"
                                                : user_address_city, // ????????????????????????????????????value????????????
                                            elevation: 10, //????????????
                                            style: const TextStyle(
                                                //????????????????????????????????????
                                                color: Color.fromARGB(
                                                    255, 181, 181, 181),
                                                fontSize: 15),
                                            iconSize: 25, //???????????????icon?????????
                                            underline: Container(
                                              height: 1,
                                              color: const Color.fromARGB(
                                                  255, 181, 181, 181),
                                            ), // ?????????
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: width / 3 * 0.5,
                                      height: 140,
                                      child: Card(
                                        elevation: 15.0, //????????????
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(14.0))), //????????????
                                        child: ListTile(
                                            title: Text("??????????????????"),
                                            subtitle: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    SizedBox(
                                                      width: width /
                                                          3 *
                                                          0.4 *
                                                          0.27,
                                                      child: Switch(
                                                          value: Pick_DateRange,
                                                          onChanged: (value) =>
                                                              setState(() {
                                                                Pick_DateRange =
                                                                    value;
                                                              })),
                                                    ),
                                                    SizedBox(
                                                      width: width /
                                                          3 *
                                                          0.4 *
                                                          0.35,
                                                      child: const AutoSizeText(
                                                        "????????????",
                                                        maxLines: 1,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                TextButton(
                                                  child: AutoSizeText(
                                                    (Pick_DateRange
                                                        ? Rangetime == null
                                                            ? "??????????????????"
                                                            : Rangetime.toString()
                                                                    .substring(
                                                                        0, 10) +
                                                                "~" +
                                                                Rangetime
                                                                        .toString()
                                                                    .substring(
                                                                        25, 36)
                                                        : time == null
                                                            ? "????????????"
                                                            : time
                                                                .toString()
                                                                .substring(
                                                                    0, 10)),
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        color: Color.fromARGB(
                                                            255,
                                                            181,
                                                            181,
                                                            181)),
                                                    maxLines: 1,
                                                  ),
                                                  onPressed: () async {
                                                    (Pick_DateRange
                                                        ? Rangetime =
                                                            await showDateRangePicker(
                                                                context:
                                                                    context,
                                                                firstDate:
                                                                    DateTime(
                                                                        1900),
                                                                lastDate: DateTime(
                                                                    DateTime.now()
                                                                            .year +
                                                                        1))
                                                        : time =
                                                            await showDatePicker(
                                                            context: context,
                                                            initialDate:
                                                                DateTime.now(),
                                                            firstDate:
                                                                DateTime(1900),
                                                            lastDate: DateTime(
                                                                DateTime.now()
                                                                        .year +
                                                                    1),
                                                          ));
                                                    setState(() {});
                                                  },
                                                ),
                                              ],
                                            )),
                                      ),
                                    ),
                                    SizedBox(
                                      width: width / 3 * 0.5,
                                      child: Card(
                                        elevation: 15.0, //????????????
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(14.0))), //????????????
                                        child: ListTile(
                                          title: const Text("??????(??????)"),
                                          subtitle: TextFormField(
                                            controller: commodity_price,
                                            keyboardType: TextInputType.number,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const Divider(
                              thickness: 1,
                            ),
                            const Text("??????"),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                SizedBox(
                                  width: width / 3 * 0.5,
                                  child: Card(
                                    elevation: 15.0, //????????????
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(14.0))), //????????????
                                    child: ListTile(
                                      title: const Text("??????"),
                                      subtitle: TextFormField(
                                        controller: commodity_Origin,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: width / 3 * 0.5,
                                  child: Card(
                                    elevation: 15.0, //????????????
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(14.0))), //????????????
                                    child: ListTile(
                                      title: const Text("????????????"),
                                      subtitle: TextFormField(
                                        controller: commodity_stock,
                                        keyboardType: TextInputType.number,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: width / 3,
                              child: Card(
                                elevation: 15.0, //????????????
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(14.0))), //????????????
                                child: ListTile(
                                  title: const Text("????????????(??????6??????)"),
                                  subtitle: TextFormField(
                                    controller: commodity_name,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(6)
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: width / 3,
                              child: Card(
                                elevation: 15.0, //????????????
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(14.0))), //????????????
                                child: ListTile(
                                  title: const Text("??????"),
                                  subtitle: TextFormField(
                                    controller: commodity_introduce,
                                    keyboardType: TextInputType.multiline,
                                    maxLines: 50,
                                    minLines: 1,
                                  ),
                                  leading: const Icon(
                                    Icons.message_rounded,
                                    color: Color.fromARGB(255, 97, 254, 207),
                                    size: 40,
                                  ),
                                ),
                              ),
                            ),
                            const Divider(
                              thickness: 1,
                            ),
                            const Padding(padding: EdgeInsets.all(10.0)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                RaisedButton(
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(14.0))), //????????????
                                  child: const Text('??????'),
                                  color: const Color.fromARGB(255, 66, 66, 66),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                RaisedButton(
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(14.0))), //????????????
                                  child: const Text('????????????'),
                                  color:
                                      const Color.fromARGB(128, 97, 254, 207),
                                  onPressed: () {
                                    if (commodity_price != null &&
                                        commodity_Origin != null &&
                                        commodity_stock != null &&
                                        commodity_name != null &&
                                        commodity_introduce != null &&
                                        _imgPath != null &&
                                        user_address_city != "" &&
                                        (Pick_DateRange ? Rangetime : time) !=
                                            null) {
                                      add_commodity_in_store();
                                    }
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
              ],
            )));
  }

  //???????????????
  Future<void> add_commodity_in_store() {
    CollectionReference users =
        FirebaseFirestore.instance.collection('userdata');

    return users.doc(user!.uid).collection("seller_store").add({
      "Origin": commodity_Origin.text, //??????
      "introduce": commodity_introduce.text, //????????????
      "name": commodity_name.text, //????????????
      "img": "",
      "owner": user!.uid, //??????ID
      "price": int.parse(commodity_price.text), //??????
      "remaining_stock": int.parse(commodity_stock.text), //????????????
      "stock": commodity_stock.text, //????????????
      "time": Pick_DateRange
          ? Rangetime.toString().substring(0, 10) +
              "~" +
              Rangetime.toString().substring(25, 36)
          : time.toString().substring(0, 10), //????????????
      "type": user_address_city.toString(), //??????1
      "type2": "", //??????2
      "is_commodity": false
    }).then((value) {
      print("a");

      final mountainImagesRef = storageRef.child("commodity/" + value.id);
      mountainImagesRef.putFile(_imgPath!).then((p0) {
        print("a");
        users.doc(user!.uid).collection("seller_store").doc(value.id).update({
          "img": "gs://login-b6ad4.appspot.com/commodity/" + value.id,
        }).then((value) {
          print("a");
          Navigator.of(context).pop();
        }).catchError((error) => print("Failed to update img_path: $error"));
      }).catchError((error) => print("Failed to add img: $error"));
    }).catchError((error) => print("Failed to add commodity: $error"));
  } //??????????????????

  Widget _ImageView(imgPath) {
    if (imgPath == null) {
      return const Center(
        child: Text("????????????????????????"),
      );
    } else {
      return Image.file(
        File(_imgPath!.path),
      );
    }
  }

  /*??????*/
  _takePhoto() async {
    final image = await ImagePicker()
        .pickImage(source: ImageSource.camera, maxHeight: 1920, maxWidth: 1920);
    if (image == null) return;
    final imageTemporary = File(image.path);
    setState(() {
      _imgPath = imageTemporary;
    });
  }

  /*??????*/
  _openGallery() async {
    final image = await ImagePicker().pickImage(
        source: ImageSource.gallery, maxHeight: 1920, maxWidth: 1920);
    if (image == null) return;
    final imageTemporary = File(image.path);
    setState(() {
      _imgPath = imageTemporary;
    });
  }

  List<DropdownMenuItem<String>> type_list = const [
    DropdownMenuItem(child: Text('?????? ????????????'), value: "?????? ????????????"),
    DropdownMenuItem(child: Text('?????? ????????????'), value: "?????? ????????????"),
    DropdownMenuItem(child: Text('?????? ????????????'), value: "?????? ????????????"),
    DropdownMenuItem(child: Text('?????? ????????????'), value: "?????? ????????????"),
    DropdownMenuItem(child: Text('?????? ????????????'), value: "?????? ????????????"),
    DropdownMenuItem(child: Text('?????? ????????????'), value: "?????? ????????????"),
  ];
}
