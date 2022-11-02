import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'commodity.dart';

class homepage extends StatefulWidget {
  const homepage({Key? key}) : super(key: key);
  @override
  State<homepage> createState() => _homepage();
}

class _homepage extends State<homepage> {
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    bool isSign = (user == null ? false : true);
    ScreenUtil.init(context, designSize: Size(1440, 3040));
    final width = (1440.w) * 2.5;
    final height = (3040.h) * 3;

    CollectionReference commodity =
        FirebaseFirestore.instance.collection('commodity');

    return MaterialApp(
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 57, 151, 123),
          centerTitle: true,
          title: Row(
            children: [
              const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0)),
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
                "果    時",
                style: TextStyle(fontSize: 30),
              ),
            ],
          ),
        ),
        body: Center(
          child: StreamBuilder(
              stream: commodity.snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: SizedBox(
                        width: 25,
                        height: 25,
                        child: CircularProgressIndicator(color: Colors.white)),
                  );
                }
                imageCache.clear();
                imageCache.clearLiveImages();
                return ListView(
                  children: snapshot.data!.docs.map((commodity) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 8),
                      child: ListTile(
                        title: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              RaisedButton(
                                color: Colors.transparent,
                                onPressed: () {
                                  print(commodity.id);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => commodity_page(
                                                seller_ID: "",
                                                commodity_ID: commodity.id,
                                                mode: 0,
                                              )));
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: width / 3 * 0.4,
                                      height: height / 3 * 0.18,
                                      child: ClipRRect(
                                        child: commodity['img'] != ""
                                            ? ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(15.0),
                                                child: Image(
                                                  image: FirebaseImage(
                                                      commodity["img"],
                                                      shouldCache: true,
                                                      cacheRefreshStrategy:
                                                          CacheRefreshStrategy
                                                              .BY_METADATA_DATE),
                                                ))
                                            : Container(
                                                alignment: Alignment.center,
                                                width: 130,
                                                height: 130,
                                                child: const Text("沒照片",
                                                    style: TextStyle(
                                                        fontSize: 25)),
                                                color: const Color.fromARGB(
                                                    255, 175, 76, 76),
                                              ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: width / 3 * 0.4,
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            width: width / 3 * 0.4,
                                            child: AutoSizeText(
                                              (commodity["name"]).toString(),
                                              style:
                                                  const TextStyle(fontSize: 50),
                                              maxLines: 1,
                                            ),
                                          ),
                                          SizedBox(
                                            width: width / 3 * 0.4,
                                            child: Row(
                                              children: [
                                                const Text("價格:",
                                                    style: TextStyle(
                                                        fontSize: 25)),
                                                const SizedBox(
                                                  width: 15,
                                                ),
                                                Text(
                                                    commodity["price"]
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontSize: 25)),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: width / 3 * 0.4,
                                            child: Row(
                                              children: [
                                                const Text("剩餘:",
                                                    style: TextStyle(
                                                        fontSize: 25)),
                                                const SizedBox(
                                                  width: 15,
                                                ),
                                                Text(
                                                    commodity["remaining_stock"]
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontSize: 25)),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              }),
        ),
        resizeToAvoidBottomInset: false,
      ),
    );
  }

  Future<Null> _onRefresh() async {
    await Future.delayed(Duration(seconds: 0), () {
      print('refresh');
      setState(() {});
    });
  }

  //TODO:顯示SnackBar
  void _showButtonPressDialog(
      BuildContext context, String provider, int millisecond) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(provider),
      backgroundColor: Colors.white38,
      duration: Duration(milliseconds: millisecond * 100),
    ));
  }
}

enum ConfirmAction { ACCEPT, CANCEL }

Future<ConfirmAction?> confirmDialog(BuildContext context) async {
  return showDialog<ConfirmAction>(
    context: context,
    barrierDismissible: false, //控制點擊對話框以外的區域是否隱藏對話框
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('確認取消對話視窗'),
        content: const Text('內容訊息'),
        actions: <Widget>[
          FlatButton(
            child: const Text('確認'),
            onPressed: () {
              Navigator.of(context).pop(ConfirmAction.ACCEPT);
            },
          ),
          FlatButton(
            child: const Text('取消'),
            onPressed: () {
              Navigator.of(context).pop(ConfirmAction.CANCEL);
            },
          )
        ],
      );
    },
  );
}
