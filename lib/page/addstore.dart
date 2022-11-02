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
                "新增賣場",
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
                        return const Text("出現了一些錯誤",
                            textAlign: TextAlign.center);
                      }
                      if (snapshot.hasData && !snapshot.data!.exists) {
                        return const Text("沒有找到資料 請聯繫管理員",
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
                                                                              Radius.circular(14.0))), //设置圆角
                                                                  child:
                                                                      const Text(
                                                                          '拍照'),
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
                                                                              Radius.circular(14.0))), //设置圆角
                                                                  child:
                                                                      const Text(
                                                                          '選擇照片'),
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
                                        elevation: 15.0, //设置阴影
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(14.0))), //设置圆角
                                        child: ListTile(
                                          minLeadingWidth: width / 3,
                                          title: const Text("種類"),
                                          subtitle: DropdownButton(
                                            items: type_list,
                                            hint: const AutoSizeText(
                                              "選擇種類",
                                              maxLines: 1,
                                            ), // 當沒有初始值時顯示
                                            onChanged: (as) {
                                              //選中後的回撥
                                              setState(() {
                                                user_address_city =
                                                    as.toString();
                                              });
                                            },
                                            value: user_address_city == ""
                                                ? "釋迦 鳳梨釋迦"
                                                : user_address_city, // 設定初始值，要與列表中的value是相同的
                                            elevation: 10, //設定陰影
                                            style: const TextStyle(
                                                //設定文字框裡面文字的樣式
                                                color: Color.fromARGB(
                                                    255, 181, 181, 181),
                                                fontSize: 15),
                                            iconSize: 25, //設定三角標icon的大小
                                            underline: Container(
                                              height: 1,
                                              color: const Color.fromARGB(
                                                  255, 181, 181, 181),
                                            ), // 下劃線
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: width / 3 * 0.5,
                                      height: 140,
                                      child: Card(
                                        elevation: 15.0, //设置阴影
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(14.0))), //设置圆角
                                        child: ListTile(
                                            title: Text("預計出貨時間"),
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
                                                        "日期區間",
                                                        maxLines: 1,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                TextButton(
                                                  child: AutoSizeText(
                                                    (Pick_DateRange
                                                        ? Rangetime == null
                                                            ? "選擇時間區間"
                                                            : Rangetime.toString()
                                                                    .substring(
                                                                        0, 10) +
                                                                "~" +
                                                                Rangetime
                                                                        .toString()
                                                                    .substring(
                                                                        25, 36)
                                                        : time == null
                                                            ? "選擇時間"
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
                                        elevation: 15.0, //设置阴影
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(14.0))), //设置圆角
                                        child: ListTile(
                                          title: const Text("價格(每件)"),
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
                            const Text("詳細"),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                SizedBox(
                                  width: width / 3 * 0.5,
                                  child: Card(
                                    elevation: 15.0, //设置阴影
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(14.0))), //设置圆角
                                    child: ListTile(
                                      title: const Text("產地"),
                                      subtitle: TextFormField(
                                        controller: commodity_Origin,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: width / 3 * 0.5,
                                  child: Card(
                                    elevation: 15.0, //设置阴影
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(14.0))), //设置圆角
                                    child: ListTile(
                                      title: const Text("商品數量"),
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
                                elevation: 15.0, //设置阴影
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(14.0))), //设置圆角
                                child: ListTile(
                                  title: const Text("商品名稱(最多6個字)"),
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
                                elevation: 15.0, //设置阴影
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(14.0))), //设置圆角
                                child: ListTile(
                                  title: const Text("介紹"),
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
                                          Radius.circular(14.0))), //设置圆角
                                  child: const Text('取消'),
                                  color: const Color.fromARGB(255, 66, 66, 66),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                RaisedButton(
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(14.0))), //设置圆角
                                  child: const Text('新增賣場'),
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

  //新增到賣家
  Future<void> add_commodity_in_store() {
    CollectionReference users =
        FirebaseFirestore.instance.collection('userdata');

    return users.doc(user!.uid).collection("seller_store").add({
      "Origin": commodity_Origin.text, //產地
      "introduce": commodity_introduce.text, //商品介紹
      "name": commodity_name.text, //商品名稱
      "img": "",
      "owner": user!.uid, //賣家ID
      "price": int.parse(commodity_price.text), //價格
      "remaining_stock": int.parse(commodity_stock.text), //剩餘數量
      "stock": commodity_stock.text, //商品總數
      "time": Pick_DateRange
          ? Rangetime.toString().substring(0, 10) +
              "~" +
              Rangetime.toString().substring(25, 36)
          : time.toString().substring(0, 10), //出貨時間
      "type": user_address_city.toString(), //種類1
      "type2": "", //種類2
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
  } //新增到購物車

  Widget _ImageView(imgPath) {
    if (imgPath == null) {
      return const Center(
        child: Text("請選擇圖片或拍照"),
      );
    } else {
      return Image.file(
        File(_imgPath!.path),
      );
    }
  }

  /*拍照*/
  _takePhoto() async {
    final image = await ImagePicker()
        .pickImage(source: ImageSource.camera, maxHeight: 1920, maxWidth: 1920);
    if (image == null) return;
    final imageTemporary = File(image.path);
    setState(() {
      _imgPath = imageTemporary;
    });
  }

  /*相冊*/
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
    DropdownMenuItem(child: Text('釋迦 鳳梨釋迦'), value: "釋迦 鳳梨釋迦"),
    DropdownMenuItem(child: Text('釋迦 傳統釋迦'), value: "釋迦 傳統釋迦"),
    DropdownMenuItem(child: Text('葡萄 傳統葡萄'), value: "葡萄 傳統葡萄"),
    DropdownMenuItem(child: Text('葡萄 無籽葡萄'), value: "葡萄 無籽葡萄"),
    DropdownMenuItem(child: Text('西瓜 小玉西瓜'), value: "西瓜 小玉西瓜"),
    DropdownMenuItem(child: Text('西瓜 一般西瓜'), value: "西瓜 一般西瓜"),
  ];
}
