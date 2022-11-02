import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class commodity_page extends StatefulWidget {
  final String commodity_ID;
  final String seller_ID;

  final int mode;

  const commodity_page(
      {Key? key,
      required this.commodity_ID,
      required this.seller_ID,
      required this.mode})
      : super(key: key);
  @override
  State<commodity_page> createState() => _commodity_pageState();
}

class _commodity_pageState extends State<commodity_page> {
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(750, 1334));
    final width = (750.w) * 3;
    final height = (1334.h) * 3;
    CollectionReference commodity = widget.mode == 1
        ? FirebaseFirestore.instance
            .collection('userdata')
            .doc(widget.seller_ID)
            .collection("seller_store")
        : FirebaseFirestore.instance.collection('commodity');

    return FutureBuilder<DocumentSnapshot>(
      future: commodity.doc(widget.commodity_ID).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("出現了一些錯誤");
        }
        if (snapshot.hasData && !snapshot.data!.exists) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text("沒有找到你的資料 請聯繫管理員dsf"),
            ],
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          print(width);

          return Scaffold(
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: (widget.mode == 0
                ? FloatingActionButton.extended(
                    backgroundColor: const Color.fromARGB(255, 73, 192, 157),
                    onPressed: () {
                      (user == null
                          ? _showButtonPressDialog(context, "請先登入", 10)
                          : (addcart(
                              widget.commodity_ID,
                              1,
                              data["name"],
                              data["price"],
                              data["img"],
                              data["time"],
                              data["type"] + data["type2"],
                              data["owner"])));
                      (user == null
                          ? null
                          : _showButtonPressDialog(context, "已加入購物車", 10));
                    },
                    label: Row(
                      children: [
                        const Icon(
                          Icons.shopping_cart_rounded,
                          size: 25,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: width / 2.75 * 0.25,
                          child: const AutoSizeText(
                            '加入購物車',
                            style: TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255),
                                fontSize: 20),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                          ),
                        )
                      ],
                    ),
                  )
                : null),
            appBar: AppBar(
              backgroundColor: const Color.fromARGB(255, 57, 151, 123),
              title: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    data["name"],
                    style: const TextStyle(fontSize: 30),
                  ),
                  Text(
                    widget.commodity_ID,
                    style: const TextStyle(
                        fontSize: 10,
                        color: Color.fromARGB(171, 255, 255, 255)),
                  ),
                ],
              ),
              centerTitle: true,
            ),
            body: RefreshIndicator(
              child: CupertinoScrollbar(
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
                            ClipRRect(
                              borderRadius: BorderRadius.circular(2.0),
                              child: data['img'] != ""
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(15.0),
                                      child: Image(
                                        image: FirebaseImage(data["img"],
                                            shouldCache: true,
                                            cacheRefreshStrategy:
                                                CacheRefreshStrategy
                                                    .BY_METADATA_DATE),
                                      ))
                                  : Container(
                                      alignment: Alignment.center,
                                      width: 400,
                                      height: 80,
                                      child:
                                          const Text("照片讀取錯誤 如一直顯示請聯繫管理員zxc"),
                                      color: const Color.fromARGB(
                                          255, 175, 76, 76),
                                    ),
                            ),
                            const Padding(padding: EdgeInsets.all(1)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                SizedBox(
                                  height: height / 3 * 0.12,
                                  width: width / 3 * 0.4,
                                  child: Card(
                                    elevation: 15.0, //设置阴影
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(14.0))), //设置圆角
                                    child: TextButton(
                                      onPressed: null,
                                      child: ListTile(
                                        dense: true,
                                        autofocus: true,
                                        title: const AutoSizeText("產地",
                                            style: TextStyle(fontSize: 15),
                                            maxLines: 1),
                                        subtitle: AutoSizeText(data["Origin"],
                                            style: TextStyle(fontSize: 18),
                                            maxLines: 1),
                                        leading: const Icon(
                                          Icons.call_split_rounded,
                                          color:
                                              Color.fromARGB(255, 97, 254, 207),
                                          size: 40,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: width / 3 * 0.6,
                                  height: height / 3 * 0.12,
                                  child: Card(
                                    elevation: 15.0, //设置阴影
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(14.0))), //设置圆角
                                    child: TextButton(
                                      onPressed: null,
                                      child: ListTile(
                                        dense: true,
                                        title: const AutoSizeText("種類",
                                            style: TextStyle(fontSize: 15),
                                            maxLines: 1),
                                        subtitle: AutoSizeText(
                                            data["type"] + "  " + data["type2"],
                                            style: TextStyle(fontSize: 18),
                                            maxLines: 1),
                                        leading: const Icon(
                                          Icons.data_thresholding_rounded,
                                          color:
                                              Color.fromARGB(255, 97, 254, 207),
                                          size: 40,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Padding(padding: EdgeInsets.all(1)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                SizedBox(
                                  height: height / 3 * 0.12,
                                  width: width / 3 * 0.4,
                                  child: Card(
                                    elevation: 15.0, //设置阴影
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(14.0))), //设置圆角
                                    child: TextButton(
                                      onPressed: null,
                                      child: ListTile(
                                        title: const AutoSizeText("價格",
                                            style: TextStyle(fontSize: 15),
                                            maxLines: 1),
                                        subtitle: AutoSizeText(
                                            data["price"].toString(),
                                            style: TextStyle(fontSize: 18),
                                            maxLines: 1),
                                        leading: const Icon(
                                          Icons.attach_money_rounded,
                                          color:
                                              Color.fromARGB(255, 97, 254, 207),
                                          size: 40,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: height / 3 * 0.12,
                                  width: width / 3 * 0.6,
                                  child: Card(
                                    elevation: 15.0, //设置阴影
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(14.0))), //设置圆角
                                    child: TextButton(
                                      onPressed: null,
                                      child: ListTile(
                                        title: const AutoSizeText("出貨時間",
                                            style: TextStyle(fontSize: 15),
                                            maxLines: 1),
                                        subtitle: AutoSizeText(data["time"],
                                            style: TextStyle(fontSize: 18),
                                            maxLines: 1),
                                        leading: const Icon(
                                          Icons.domain_verification_rounded,
                                          color:
                                              Color.fromARGB(255, 97, 254, 207),
                                          size: 42,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Padding(padding: EdgeInsets.all(1)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                SizedBox(
                                  width: width / 3 * 0.4,
                                  height: height / 3 * 0.12,
                                  child: Card(
                                    elevation: 15.0, //设置阴影
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(14.0))), //设置圆角
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: height / 3 * 0.095,
                                          child: TextButton(
                                            onPressed: null,
                                            child: ListTile(
                                              title: const AutoSizeText("剩餘",
                                                  style:
                                                      TextStyle(fontSize: 15),
                                                  maxLines: 1),
                                              subtitle: AutoSizeText(
                                                  data["remaining_stock"]
                                                          .toString() +
                                                      " / " +
                                                      data["stock"],
                                                  style:
                                                      TextStyle(fontSize: 18),
                                                  maxLines: 1),
                                              leading: const Icon(
                                                Icons.data_usage_rounded,
                                                color: Color.fromARGB(
                                                    255, 97, 254, 207),
                                                size: 40,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: width / 2.75 * 0.4 * 0.6,
                                          child: LinearProgressIndicator(
                                            value: data["remaining_stock"] /
                                                int.parse(data["stock"]),
                                            backgroundColor: Colors.grey[200],
                                            valueColor: AlwaysStoppedAnimation(
                                                ((data["remaining_stock"] /
                                                            int.parse(data[
                                                                "stock"])) <
                                                        0.2
                                                    ? Colors.red
                                                    : const Color.fromARGB(
                                                        255, 97, 254, 207))),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: height / 3 * 0.12,
                                  width: width / 3 * 0.6,
                                  child: Card(
                                    elevation: 15.0, //设置阴影
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(14.0))), //设置圆角
                                    child: TextButton(
                                      onPressed: () {
                                        _showAlertDialog(
                                            context, data["owner"].toString());
                                      },
                                      child: ListTile(
                                        title: const AutoSizeText("賣家ID",
                                            style: TextStyle(fontSize: 15),
                                            maxLines: 1),
                                        subtitle: AutoSizeText(
                                          data["owner"]
                                                  .toString()
                                                  .substring(0, 15) +
                                              "...",
                                          style: TextStyle(fontSize: 18),
                                          maxLines: 1,
                                        ),
                                        leading: const Icon(
                                          Icons.account_circle_rounded,
                                          color:
                                              Color.fromARGB(255, 97, 254, 207),
                                          size: 40,
                                        ),
                                        trailing: const Icon(
                                          Icons.keyboard_arrow_right,
                                          color:
                                              Color.fromARGB(255, 97, 254, 207),
                                          size: 40,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Padding(padding: EdgeInsets.all(1)),
                            SizedBox(
                              width: width / 2.75,
                              child: Card(
                                elevation: 15.0, //设置阴影
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(14.0))), //设置圆角
                                child: TextButton(
                                  onPressed: null,
                                  child: ListTile(
                                    title: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Icon(
                                          Icons.menu_book_rounded,
                                          color:
                                              Color.fromARGB(255, 97, 254, 207),
                                          size: 40,
                                        ),
                                        AutoSizeText("  介紹",
                                            style: TextStyle(fontSize: 15),
                                            maxLines: 1),
                                      ],
                                    ),
                                    subtitle: AutoSizeText(data["introduce"],
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: Color.fromARGB(
                                              255, 255, 255, 255),
                                        ),
                                        textAlign: TextAlign.center),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 70,
                            ),
                          ],
                        ),
                      )
                    ],
                  )),
              displacement: 40.0,
              onRefresh: _onRefresh,
            ),
          );
        }
        return Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  SizedBox(
                      width: 25,
                      height: 25,
                      child: CircularProgressIndicator(color: Colors.white))
                ],
              ),
            ],
          ),
        );
      },
    );
  }

//顯示賣家資訊
  Future<void> _showAlertDialog(BuildContext context, String owner) {
    CollectionReference users =
        FirebaseFirestore.instance.collection('userdata');
    User? user = FirebaseAuth.instance.currentUser;

    return showDialog<void>(
      context: context,
      builder: (BuildContext context1) {
        ScreenUtil.init(context, designSize: Size(750, 1334));
        final width = (750.w) * 3;
        final height = (1334.h) * 3;
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 48, 48, 48),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15))),
          title: const Text("賣家資訊",
              style: TextStyle(fontSize: 30), textAlign: TextAlign.center),
          content: SizedBox(
            // height: height / 3 / 2.4,
            width: width / 3,
            child: FutureBuilder<DocumentSnapshot>(
                future: users.doc(owner).get(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text("出現了一些錯誤", textAlign: TextAlign.center);
                  }
                  if (snapshot.hasData && !snapshot.data!.exists) {
                    return Text("沒有找到資料 請聯繫管理員qwe",
                        textAlign: TextAlign.center);
                  }
                  if (snapshot.connectionState == ConnectionState.done) {
                    Map<String, dynamic> data =
                        snapshot.data!.data() as Map<String, dynamic>;
                    return Scaffold(
                        backgroundColor: Color.fromARGB(255, 48, 48, 48),
                        body: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20.0),
                                child: data['user_icon'] != ""
                                    ? Image(
                                        image: FirebaseImage(data['user_icon'],
                                            shouldCache: true,
                                            cacheRefreshStrategy:
                                                CacheRefreshStrategy
                                                    .BY_METADATA_DATE),
                                        width: 100,
                                      )
                                    : SizedBox(
                                        width: double.infinity,
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.person_rounded,
                                            color: data['user_sex'] == "0"
                                                ? Colors.red
                                                : Colors.blue,
                                          ),
                                          iconSize: 100,
                                          onPressed: () {},
                                        ),
                                      ),
                              ),
                              Text(
                                "${data['user_firstname']}${data['user_lastname']}",
                                style: DefaultTextStyle.of(context)
                                    .style
                                    .apply(fontSizeFactor: 1.8),
                              ),
                              Text(
                                data['user_id'],
                                style: const TextStyle(
                                  color: Color.fromARGB(171, 255, 255, 255),
                                ),
                              ),
                              SizedBox(
                                child: Card(
                                  elevation: 15.0, //设置阴影
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(14.0))), //设置圆角
                                  child: ListTile(
                                    title: const Text("郵件"),
                                    subtitle:
                                        Text(data["user_email"].toString()),
                                    leading: Icon(
                                      Icons.email_outlined,
                                      color: Color.fromARGB(255, 97, 254, 207),
                                      size: 40,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                // height: 100.0, //设置高度
                                width: double.maxFinite,
                                child: Card(
                                  elevation: 15.0, //设置阴影
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(14.0))), //设置圆角
                                  child: ListTile(
                                    title: const Text("電話"),
                                    subtitle:
                                        Text('${data['user_phone_number']}'),
                                    leading: const Icon(
                                      Icons.phone_iphone_sharp,
                                      color: Color.fromARGB(255, 97, 254, 207),
                                      size: 40,
                                    ),
                                  ),
                                ),
                              ),
                              const Padding(padding: EdgeInsets.all(10.0)),
                              FlatButton(
                                child: Text('確定'),
                                onPressed: () {
                                  Navigator.of(context1).pop();
                                },
                              ),
                            ],
                          ),
                        ));
                  }
                  return Scaffold(
                    body: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            SizedBox(
                                width: 25,
                                height: 25,
                                child: CircularProgressIndicator(
                                    color: Colors.white))
                          ],
                        ),
                      ],
                    ),
                  );
                }),
          ),
        );
      },
    );
  }

//顯示SnackBar
  void _showButtonPressDialog(
      BuildContext context, String provider, int millisecond) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(provider),
      // backgroundColor: Color.fromARGB(255, 255, 255, 255),
      duration: Duration(milliseconds: millisecond * 100),
    ));
  }

//下滑重置
  Future<Null> _onRefresh() async {
    await Future.delayed(Duration(seconds: 0), () {
      print('refresh');
      setState(() {});
    });
  }

//新增到購物車
  Future<void> addcart(String commodity_ID, int Purchase_quantity, String name,
      int price, String img, String time, String type2, String seller_ID) {
    CollectionReference users =
        FirebaseFirestore.instance.collection('userdata');
    return users
        .doc(user!.uid)
        .collection("cart")
        .add({
          "Purchase_quantity": Purchase_quantity,
          "commodity_ID": commodity_ID,
          "name": name,
          "price": price,
          "img": img,
          "time": time,
          "type2": type2,
          "seller_ID": seller_ID,
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }
}
