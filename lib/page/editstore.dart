// ignore_for_file: deprecated_member_use, non_constant_identifier_names, unnecessary_null_comparison

import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class editstore extends StatefulWidget {
  final QueryDocumentSnapshot commodity;
  const editstore({Key? key, required this.commodity}) : super(key: key);

  @override
  State<editstore> createState() => _editstoreState();
}

class _editstoreState extends State<editstore> {
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
                Center(
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
                                      borderRadius: BorderRadius.circular(50.0),
                                      child: TextButton(
                                        onPressed: () {
                                          showModalBottomSheet(
                                            context: context,
                                            backgroundColor:
                                                const Color.fromARGB(
                                                    255, 33, 33, 33),
                                            shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(20),
                                              topRight: Radius.circular(20),
                                            )),
                                            isScrollControlled: false,
                                            isDismissible: true,
                                            elevation: 40,
                                            builder: (BuildContext context) {
                                              return Container(
                                                height: 80,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    SingleChildScrollView(
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: <Widget>[
                                                          RaisedButton(
                                                            shape: const RoundedRectangleBorder(
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            14.0))), //????????????
                                                            child: const Text(
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
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            14.0))), //????????????
                                                            child: const Text(
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
                                        child: widget.commodity["img"] != ""
                                            ? (!(_imgPath == null)
                                                ? _ImageView(_imgPath)
                                                : Image(
                                                    image: FirebaseImage(
                                                        widget.commodity["img"],
                                                        shouldCache: true,
                                                        cacheRefreshStrategy:
                                                            CacheRefreshStrategy
                                                                .BY_METADATA_DATE)))
                                            : Container(
                                                alignment: Alignment.center,
                                                width: 130,
                                                height: 130,
                                                child: const Text("?????????",
                                                    style: TextStyle(
                                                        fontSize: 25)),
                                                color: const Color.fromARGB(
                                                    255, 175, 76, 76),
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
                                    title: const Text("??????"),
                                    subtitle: DropdownButton(
                                      items: type_list,
                                      hint: const Text("????????????"), // ???????????????????????????
                                      onChanged: (as) {
                                        //??????????????????
                                        setState(() {
                                          user_address_city = as.toString();
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
                                      iconSize: 30, //???????????????icon?????????
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
                                              Switch(
                                                  value: Pick_DateRange,
                                                  onChanged: (value) =>
                                                      setState(() {
                                                        Pick_DateRange = value;
                                                      })),
                                              const Text("????????????"),
                                            ],
                                          ),
                                          TextButton(
                                            child: Text(
                                              (Pick_DateRange
                                                  ? Rangetime == null
                                                      ? widget.commodity['time']
                                                      : Rangetime.toString()
                                                              .substring(
                                                                  0, 10) +
                                                          "~" +
                                                          Rangetime.toString()
                                                              .substring(25, 36)
                                                  : time == null
                                                      ? widget.commodity['time']
                                                      : time
                                                          .toString()
                                                          .substring(0, 10)),
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Color.fromARGB(
                                                      255, 181, 181, 181)),
                                            ),
                                            onPressed: () async {
                                              (Pick_DateRange
                                                  ? Rangetime =
                                                      await showDateRangePicker(
                                                          context: context,
                                                          firstDate:
                                                              DateTime(1900),
                                                          lastDate: DateTime(
                                                              DateTime.now()
                                                                      .year +
                                                                  1))
                                                  : time = await showDatePicker(
                                                      context: context,
                                                      initialDate:
                                                          DateTime.now(),
                                                      firstDate: DateTime(1900),
                                                      lastDate: DateTime(
                                                          DateTime.now().year +
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
                                      decoration: InputDecoration(
                                        hintText: widget.commodity['price']
                                            .toString(),
                                      ),
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
                                  decoration: InputDecoration(
                                    hintText: widget.commodity['Origin'],
                                  ),
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
                                  decoration: InputDecoration(
                                    hintText: widget.commodity['stock'],
                                  ),
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
                              decoration: InputDecoration(
                                hintText: widget.commodity['name'],
                              ),
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
                              decoration: InputDecoration(
                                hintText: widget.commodity['introduce'],
                              ),
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
                            child: const Text('????????????'),
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
                            color: const Color.fromARGB(128, 97, 254, 207),
                            onPressed: () {
                              edit_commodity_in_store()
                                  .then((value) => Navigator.of(context).pop());
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            )));
  }

  //???????????????
  Future<void> edit_commodity_in_store() {
    CollectionReference users =
        FirebaseFirestore.instance.collection('userdata');
    return users
        .doc(user!.uid)
        .collection("seller_store")
        .doc(widget.commodity.id)
        .update({
      "Origin": commodity_Origin.text == ""
          ? widget.commodity["Origin"]
          : commodity_Origin.text, //??????
      "introduce": commodity_introduce.text == ""
          ? widget.commodity["introduce"]
          : commodity_introduce.text, //????????????
      "name": commodity_name.text == ""
          ? widget.commodity["name"]
          : commodity_name.text, //????????????
      "price": commodity_price.text == ""
          ? widget.commodity["price"]
          : int.parse(commodity_price.text), //??????

      "stock": commodity_stock.text == ""
          ? widget.commodity["stock"]
          : commodity_stock.text, //????????????
      "time": (Pick_DateRange ? Rangetime : time) == null
          ? widget.commodity["time"]
          : (Pick_DateRange
              ? (Rangetime.toString().substring(0, 10) +
                  "~" +
                  Rangetime.toString().substring(25, 36))
              : time.toString().substring(0, 10)), //????????????
      "type": user_address_city.toString() == ""
          ? widget.commodity["type"]
          : user_address_city.toString(), //??????1
    }).then((value) {
      if (_imgPath != null) {
        final mountainImagesRef =
            storageRef.child("commodity/" + widget.commodity.id);

        mountainImagesRef.delete().then((value) {
          mountainImagesRef.putFile(_imgPath!).then((p0) => print(p0));
        });
        ;
      }
    }).catchError((error) => print("Failed to add user: $error"));
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
