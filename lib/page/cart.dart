import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../smooth_page_indicator.dart';
import '../src/smooth_page_indicator.dart';
import 'buying.dart';
import 'commodity.dart';

class cart_page extends StatefulWidget {
  @override
  _cart_page createState() => _cart_page();
}

class _cart_page extends State<cart_page> {
  final controller = PageController(viewportFraction: 0.8, keepPage: true);

  var user_address_city = "";
  final user_address_detail = TextEditingController();

  final user_phone_number = TextEditingController(); //0123456789
  //TODO:顯示SnackBar
  void _showButtonPressDialog(
      BuildContext context, String provider, int millisecond) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(provider),
      // backgroundColor: Colors.white38,
      duration: Duration(milliseconds: millisecond * 100),
    ));
  }

  Future<void> _showdeleteDialog(BuildContext context, String cart_ID) {
    final width = window.physicalSize.width;
    CollectionReference users =
        FirebaseFirestore.instance.collection('userdata');
    User? user = FirebaseAuth.instance.currentUser;
    final height = window.physicalSize.height;
    return showDialog<void>(
      context: context,
      builder: (BuildContext context1) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 48, 48, 48),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15))),
          title: const Text("刪除",
              style: TextStyle(fontSize: 30), textAlign: TextAlign.center),
          content: SizedBox(
            height: height / 3 * 0.2,
            width: width / 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("是否刪除這個商品？"),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RaisedButton(
                      color: Color.fromARGB(59, 97, 254, 207),
                      shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(14.0))), //设置圆角
                      onPressed: () {
                        Navigator.pop(context1);
                      },
                      child: const Text("取消"),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    RaisedButton(
                      color: Color.fromARGB(128, 254, 97, 97),
                      shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(14.0))), //设置圆角
                      onPressed: () {
                        users
                            .doc(user!.uid)
                            .collection("cart")
                            .doc(cart_ID)
                            .delete();

                        Navigator.pop(context1);
                      },
                      child: const Text("確定"),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(1440, 3040));
    final width = (1440.w) * 2.5;
    final height = (3040.h) * 3;
    User? user = FirebaseAuth.instance.currentUser;
    CollectionReference users =
        FirebaseFirestore.instance.collection('userdata');
    CollectionReference commodity =
        FirebaseFirestore.instance.collection('commodity');
    bool isSign = (user == null ? false : true);
    var pages = List.generate(
        3,
        (index) => Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: const Color.fromARGB(255, 35, 35, 35),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
            child: SizedBox(
                child: (isSign == true
                    ?
                    //TODO:顯示購物車
                    (index == 0
                        ? Center(
                            child: StreamBuilder(
                                stream: users
                                    .doc(user!.uid)
                                    .collection("cart")
                                    .snapshots(),
                                builder: (context,
                                    AsyncSnapshot<QuerySnapshot> snapshot) {
                                  if (!snapshot.hasData) {
                                    return const Center(
                                      child: SizedBox(
                                          width: 25,
                                          height: 25,
                                          child: CircularProgressIndicator(
                                              color: Colors.white)),
                                    );
                                  }
                                  return ListTile(
                                    title: const Text("購物車",
                                        style: TextStyle(fontSize: 30),
                                        textAlign: TextAlign.center),
                                    subtitle: ListView(
                                      children: snapshot.data!.docs
                                          .map((cart_commodity) {
                                        return SizedBox(
                                          child: ListTile(
                                            title: Center(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  SizedBox(
                                                    width: width / 3,
                                                    // height: height / 3 * 0.15,
                                                    child: Card(
                                                      elevation: 15.0, //设置阴影
                                                      shape: const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(
                                                                      14.0))), //设置圆角
                                                      child: TextButton(
                                                          onPressed: () {
                                                            print(commodity.id);
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            commodity_page(
                                                                              commodity_ID: cart_commodity["commodity_ID"].toString(),
                                                                              mode: 1,
                                                                              seller_ID: cart_commodity["seller_ID"].toString(),
                                                                            )));
                                                          },
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceAround,
                                                            children: [
                                                              SizedBox(
                                                                width: width /
                                                                    3 *
                                                                    0.6 *
                                                                    0.8,
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    FutureBuilder<
                                                                            DocumentSnapshot>(
                                                                        future: commodity
                                                                            .doc(cart_commodity[
                                                                                "commodity_ID"])
                                                                            .get(),
                                                                        builder: (BuildContext
                                                                                context,
                                                                            AsyncSnapshot<DocumentSnapshot>
                                                                                snapshot1) {
                                                                          if (snapshot1
                                                                              .hasError) {
                                                                            return const Text("出現了一些錯誤");
                                                                          }
                                                                          if (snapshot1.hasData &&
                                                                              !snapshot1.data!.exists) {
                                                                            return Column(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              children: const [
                                                                                Text("沒有找到你的資料 請聯繫管理員"),
                                                                              ],
                                                                            );
                                                                          }

                                                                          if (snapshot1.connectionState ==
                                                                              ConnectionState.done) {
                                                                            Map<String, dynamic>
                                                                                commodity_item =
                                                                                snapshot1.data!.data() as Map<String, dynamic>;
                                                                            int price =
                                                                                cart_commodity["Purchase_quantity"] * commodity_item["price"];
                                                                            users.doc(user.uid).collection("cart").doc(cart_commodity.id).update({
                                                                              'price': price,
                                                                            });
                                                                          }
                                                                          return const SizedBox(
                                                                            width:
                                                                                0,
                                                                          );
                                                                        }),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        SizedBox(
                                                                          width: width /
                                                                              3 *
                                                                              0.6 *
                                                                              0.4,
                                                                          child: AutoSizeText(
                                                                              cart_commodity["name"].toString(),
                                                                              maxLines: 1,
                                                                              style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontSize: 25),
                                                                              textAlign: TextAlign.center),
                                                                        ),
                                                                        SizedBox(
                                                                          width: width /
                                                                              3 *
                                                                              0.6 *
                                                                              0.1,
                                                                          child:
                                                                              const Icon(
                                                                            Icons.attach_money_rounded,
                                                                            color:
                                                                                Colors.white,
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          width: width /
                                                                              3 *
                                                                              0.6 *
                                                                              0.2,
                                                                          child:
                                                                              AutoSizeText(
                                                                            (cart_commodity["price"] == null
                                                                                ? ""
                                                                                : cart_commodity["price"].toString()),
                                                                            style:
                                                                                const TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontSize: 25),
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            maxLines:
                                                                                1,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      width: width /
                                                                          3 *
                                                                          0.6 *
                                                                          0.8,
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          IconButton(
                                                                            icon:
                                                                                Icon(
                                                                              Icons.remove_circle_outline_rounded,
                                                                              color: ((cart_commodity["Purchase_quantity"] - 1) <= 0 ? const Color.fromARGB(255, 254, 97, 97) : const Color.fromARGB(255, 97, 254, 207)),
                                                                            ),
                                                                            onPressed:
                                                                                () {
                                                                              ((cart_commodity["Purchase_quantity"] - 1) <= 0
                                                                                  ? _showdeleteDialog(context, cart_commodity.id)
                                                                                  : users.doc(user.uid).collection("cart").doc(cart_commodity.id).update({
                                                                                      'Purchase_quantity': cart_commodity["Purchase_quantity"] - 1,
                                                                                    }));
                                                                            },
                                                                          ),
                                                                          Text(
                                                                              cart_commodity["Purchase_quantity"].toString(),
                                                                              style: const TextStyle(
                                                                                color: Color.fromARGB(255, 255, 255, 255),
                                                                              ),
                                                                              textAlign: TextAlign.right),
                                                                          IconButton(
                                                                            icon:
                                                                                const Icon(
                                                                              Icons.add_circle_outline_rounded,
                                                                              color: Color.fromARGB(255, 97, 254, 207),
                                                                            ),
                                                                            onPressed:
                                                                                () {
                                                                              users.doc(user.uid).collection("cart").doc(cart_commodity.id).update({
                                                                                'Purchase_quantity': cart_commodity["Purchase_quantity"] + 1,
                                                                              });
                                                                            },
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: width /
                                                                    3 *
                                                                    0.12,
                                                                height: height /
                                                                    3 *
                                                                    0.1,
                                                                child:
                                                                    RaisedButton(
                                                                  color: const Color
                                                                          .fromARGB(
                                                                      255,
                                                                      57,
                                                                      151,
                                                                      123),
                                                                  child: const Text(
                                                                      "購買",
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center),
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                  ),
                                                                  onPressed:
                                                                      () {
                                                                    print(user
                                                                        .uid);
                                                                    // Navigator.push(
                                                                    //     context,
                                                                    //     MaterialPageRoute(
                                                                    //         builder: (context) => buying(
                                                                    //               commodity_ID: cart_commodity.id,
                                                                    //               cart_ID: cart_commodity.id,
                                                                    //             )));
                                                                  },
                                                                ),
                                                              )
                                                            ],
                                                          )),
                                                    ),
                                                  ),
                                                  const Padding(
                                                      padding:
                                                          EdgeInsets.all(5)),
                                                  const Divider(
                                                    thickness: 1,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  );
                                }),
                          )
                        //TODO:顯示媒合系統
                        : (index == 1
                            ? Center(
                                child: StreamBuilder(
                                    stream: users
                                        .doc(user!.uid)
                                        .collection("match")
                                        .snapshots(),
                                    builder: (context,
                                        AsyncSnapshot<QuerySnapshot> snapshot) {
                                      if (!snapshot.hasData) {
                                        return const Center(
                                          child: SizedBox(
                                              width: 25,
                                              height: 25,
                                              child: CircularProgressIndicator(
                                                  color: Colors.white)),
                                        );
                                      }
                                      return ListTile(
                                        title: const Text("媒合系統",
                                            style: TextStyle(fontSize: 30),
                                            textAlign: TextAlign.center),
                                        subtitle: ListView(
                                          children: snapshot.data!.docs
                                              .map((match_commodity) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 0),
                                              child: ListTile(
                                                title: Center(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      SizedBox(
                                                        width: width / 3,
                                                        // height:
                                                        //     height / 3 * 0.12,
                                                        child: Card(
                                                          elevation:
                                                              15.0, //设置阴影
                                                          shape: const RoundedRectangleBorder(
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          14.0))), //设置圆角
                                                          child: TextButton(
                                                              onPressed: () {
                                                                print(commodity
                                                                    .id);
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (context) =>
                                                                            commodity_page(
                                                                              commodity_ID: match_commodity["commodity_ID"].toString(),
                                                                              mode: 1,
                                                                              seller_ID: match_commodity["seller_ID"].toString(),
                                                                            )));
                                                              },
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceAround,
                                                                children: [
                                                                  SizedBox(
                                                                    width: width /
                                                                        3 *
                                                                        0.6 *
                                                                        0.35,
                                                                    child: AutoSizeText(
                                                                        match_commodity["commodity_name"]
                                                                            .toString(),
                                                                        maxLines:
                                                                            1,
                                                                        style: const TextStyle(
                                                                            color: Color.fromARGB(
                                                                                255,
                                                                                255,
                                                                                255,
                                                                                255),
                                                                            fontSize:
                                                                                25),
                                                                        textAlign:
                                                                            TextAlign.center),
                                                                  ),
                                                                  SizedBox(
                                                                    width: width /
                                                                        3 *
                                                                        0.6 *
                                                                        0.25,
                                                                    child:
                                                                        Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Row(
                                                                          children: [
                                                                            SizedBox(
                                                                                width: width / 3 * 0.6 * 0.25 * 0.2,
                                                                                child: const Icon(
                                                                                  Icons.attach_money_rounded,
                                                                                  color: Colors.white,
                                                                                  size: 15,
                                                                                )),
                                                                            SizedBox(
                                                                              width: width / 3 * 0.6 * 0.25 * 0.8,
                                                                              child: AutoSizeText(
                                                                                (match_commodity["commodity_price"] == null ? "" : match_commodity["commodity_price"].toString()),
                                                                                style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontSize: 25),
                                                                                textAlign: TextAlign.center,
                                                                                maxLines: 1,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        AutoSizeText(
                                                                          match_commodity["seller_agree"] == "checking"
                                                                              ? "確認中"
                                                                              : (match_commodity["seller_agree"] == "reject" ? "已拒絕" : (match_commodity["seller_agree"] == "agree" ? (match_commodity["commodity_state"] == "no" ? "已同意" : (match_commodity["commodity_state"] == "preparing" ? "準備中" : (match_commodity["commodity_state"] == "mailed" ? "已寄出" : "已抵達"))) : "error")),
                                                                          style: const TextStyle(
                                                                              color: Color.fromARGB(255, 255, 92, 92),
                                                                              fontSize: 20),
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                          maxLines:
                                                                              1,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  (match_commodity["seller_agree"] ==
                                                                              "reject") ||
                                                                          (match_commodity["commodity_state"] ==
                                                                              "arrival")
                                                                      ? SizedBox(
                                                                          width: width /
                                                                              3 *
                                                                              0.6 *
                                                                              0.25,
                                                                          height: height /
                                                                              3 *
                                                                              0.1,
                                                                          child:
                                                                              RaisedButton(
                                                                            color: const Color.fromARGB(
                                                                                255,
                                                                                57,
                                                                                151,
                                                                                123),
                                                                            child:
                                                                                const AutoSizeText(
                                                                              "完成訂單",
                                                                              textAlign: TextAlign.center,
                                                                              maxLines: 2,
                                                                            ),
                                                                            shape:
                                                                                RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(10),
                                                                            ),
                                                                            onPressed:
                                                                                () {
                                                                              users
                                                                                  .doc(user.uid)
                                                                                  .collection("Finish")
                                                                                  .doc(match_commodity.id)
                                                                                  .set({
                                                                                    "Purchase_quantity": match_commodity["Purchase_quantity"], //購買數量
                                                                                    "commodity_ID": match_commodity["commodity_ID"], //商品ID
                                                                                    "commodity_name": match_commodity["commodity_name"], //商品name
                                                                                    "commodity_price": match_commodity["commodity_price"], //商品價格
                                                                                    "commodity_img": match_commodity["commodity_img"], //商品圖片
                                                                                    "Buyer_first_name": match_commodity["Buyer_first_name"], //買家姓氏
                                                                                    "Buyer_last_name": match_commodity["Buyer_last_name"], //買家名字
                                                                                    "Buyer_phone": match_commodity["Buyer_phone"], //買家電話
                                                                                    "Buyer_address": match_commodity["Buyer_address"], //買家地址
                                                                                    "Buyer_Pickup_method": match_commodity["Buyer_Pickup_method"], //買家取貨方式
                                                                                    "Buyer_message": match_commodity["Buyer_message"], //買家留言
                                                                                    "seller_agree": match_commodity["seller_agree"], //賣家是否同意出貨
                                                                                    "sell_date": match_commodity["sell_date"], //出貨日期
                                                                                    "seller_ID": match_commodity["seller_ID"], //賣家ID
                                                                                    "buyer_ID": user.uid,
                                                                                    "Finish_date": DateTime.now().toString(),
                                                                                  })
                                                                                  .then((value) => print("User Added"))
                                                                                  .catchError((error) => print("Failed to add user: $error"));
                                                                              users.doc(user.uid).collection("match").doc(match_commodity.id).delete().then((value) => print("match change")).catchError((error) => print("Failed to change match: $error"));
                                                                              users.doc(match_commodity["seller_ID"]).collection("sell").doc(match_commodity.id).update({"commodity_state": "buyer_check"}).then((value) => print("match change")).catchError((error) => print("Failed to change match: $error"));
                                                                            },
                                                                          ),
                                                                        )
                                                                      : SizedBox(),
                                                                ],
                                                              )),
                                                        ),
                                                      ),
                                                      const Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  5)),
                                                      const Divider(
                                                        thickness: 1,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      );
                                    }),
                              )
                            //TODO:顯示已完成
                            : Center(
                                child: StreamBuilder(
                                    stream: users
                                        .doc(user!.uid)
                                        .collection("Finish")
                                        .snapshots(),
                                    builder: (context,
                                        AsyncSnapshot<QuerySnapshot> snapshot) {
                                      if (!snapshot.hasData) {
                                        return const Center(
                                          child: SizedBox(
                                              width: 25,
                                              height: 25,
                                              child: CircularProgressIndicator(
                                                  color: Colors.white)),
                                        );
                                      }
                                      return ListTile(
                                        title: const Text("已完成",
                                            style: TextStyle(fontSize: 30),
                                            textAlign: TextAlign.center),
                                        subtitle: ListView(
                                          children: snapshot.data!.docs
                                              .map((match_commodity) {
                                            return SizedBox(
                                              child: ListTile(
                                                title: Center(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      SizedBox(
                                                        width: width / 3,
                                                        height:
                                                            height / 3 * 0.12,
                                                        child: Card(
                                                          elevation:
                                                              15.0, //设置阴影
                                                          shape: const RoundedRectangleBorder(
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          14.0))), //设置圆角
                                                          child: TextButton(
                                                              onPressed: () {
                                                                print(commodity
                                                                    .id);
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (context) => commodity_page(
                                                                            seller_ID:
                                                                                match_commodity["seller_ID"].toString(),
                                                                            commodity_ID: match_commodity["commodity_ID"].toString(),
                                                                            mode: 1)));
                                                              },
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceAround,
                                                                children: [
                                                                  Row(
                                                                    children: [
                                                                      SizedBox(
                                                                        width: width /
                                                                            3 *
                                                                            0.6 *
                                                                            0.4,
                                                                        child: AutoSizeText(
                                                                            match_commodity["commodity_name"]
                                                                                .toString(),
                                                                            maxLines:
                                                                                1,
                                                                            style:
                                                                                const TextStyle(
                                                                              color: Color.fromARGB(255, 255, 255, 255),
                                                                              fontSize: 50,
                                                                            ),
                                                                            textAlign:
                                                                                TextAlign.center),
                                                                      ),
                                                                      SizedBox(
                                                                        width: width /
                                                                            3 *
                                                                            0.6 *
                                                                            0.6,
                                                                        child:
                                                                            Column(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: [
                                                                            Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                              children: [
                                                                                Row(
                                                                                  children: [
                                                                                    SizedBox(
                                                                                      width: width / 3 * 0.6 * 0.08,
                                                                                      child: const Icon(
                                                                                        Icons.attach_money_rounded,
                                                                                        color: Colors.white,
                                                                                      ),
                                                                                    ),
                                                                                    SizedBox(
                                                                                      width: width / 3 * 0.6 * 0.2,
                                                                                      child: AutoSizeText((match_commodity["commodity_price"] == null ? "" : match_commodity["commodity_price"].toString()), style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontSize: 50), maxLines: 1, textAlign: TextAlign.center),
                                                                                    ),
                                                                                    SizedBox(
                                                                                      width: width / 3 * 0.6 * 0.07,
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceEvenly,
                                                                    children: [
                                                                      SizedBox(
                                                                        width: width /
                                                                            3 *
                                                                            0.6 *
                                                                            0.25,
                                                                        child: AutoSizeText(
                                                                            match_commodity["seller_agree"] == "reject"
                                                                                ? "已拒絕"
                                                                                : "已送達",
                                                                            maxLines:
                                                                                1,
                                                                            style:
                                                                                TextStyle(color: match_commodity["seller_agree"] == "reject" ? const Color.fromARGB(255, 255, 92, 92) : const Color.fromARGB(255, 57, 151, 123), fontSize: 50),
                                                                            textAlign: TextAlign.center),
                                                                      ),
                                                                      AutoSizeText(
                                                                          "完成日期:" +
                                                                              match_commodity["Finish_date"].toString().substring(0,
                                                                                  10),
                                                                          maxLines:
                                                                              1,
                                                                          style: const TextStyle(
                                                                              color: Color.fromARGB(255, 255, 255,
                                                                                  255),
                                                                              fontSize:
                                                                                  15),
                                                                          textAlign:
                                                                              TextAlign.center),
                                                                    ],
                                                                  ),
                                                                ],
                                                              )),
                                                        ),
                                                      ),
                                                      const Divider(
                                                        thickness: 1,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      );
                                    }),
                              )))
                    : Text("no sign")))));
    return (isSign == false
        ? const Center(
            child: Text(
              "請先登入",
              style: TextStyle(fontSize: 30),
            ),
          )
        : Scaffold(
            body: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SizedBox(
                    height: height / 3 * 0.85,
                    child: PageView.builder(
                      controller: controller,
                      itemCount: pages.length,
                      itemBuilder: (_, index) {
                        return pages[index % pages.length];
                      },
                    ),
                  ),
                  SizedBox(
                    height: height / 3 * 0.02,
                    child: SmoothPageIndicator(
                      controller: controller,
                      count: pages.length,
                      effect: const ExpandingDotsEffect(
                          activeDotColor: Color.fromARGB(255, 97, 254, 207)),
                    ),
                  ),
                ],
              ),
            ),
          ));
  }

  //顯示確認購買資訊
  Future _showbuyDialog(BuildContext context, String Commodity_ID) {
    final width = window.physicalSize.width;
    final height = window.physicalSize.height;
    CollectionReference users =
        FirebaseFirestore.instance.collection('userdata');
    User? user = FirebaseAuth.instance.currentUser;
    bool flag = true;
    return showDialog(
      context: context,
      builder: (BuildContext context1) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 48, 48, 48),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15))),
          title: const Text("購買",
              style: TextStyle(fontSize: 30), textAlign: TextAlign.center),
          content: SizedBox(
            height: height / 3,
            width: width / 3,
            child: FutureBuilder<DocumentSnapshot>(
                future: users
                    .doc(user!.uid)
                    .collection("cart")
                    .doc(Commodity_ID)
                    .get(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text("出現了一些錯誤", textAlign: TextAlign.center);
                  }
                  if (snapshot.hasData && !snapshot.data!.exists) {
                    return Text("沒有找到資料 請聯繫管理員", textAlign: TextAlign.center);
                  }
                  if (snapshot.connectionState == ConnectionState.done) {
                    Map<String, dynamic> data =
                        snapshot.data!.data() as Map<String, dynamic>;
                    return Scaffold(
                      backgroundColor: Color.fromARGB(255, 48, 48, 48),
                      body: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 190,
                                height: 300,
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50.0),
                                    child: Image(
                                      image: FirebaseImage(data['img'],
                                          shouldCache: true,
                                          cacheRefreshStrategy:
                                              CacheRefreshStrategy
                                                  .BY_METADATA_DATE,
                                          maxSizeBytes: 1920 * 1080),
                                    )),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    data['name'],
                                    style: DefaultTextStyle.of(context)
                                        .style
                                        .apply(fontSizeFactor: 1.8),
                                  ),
                                  SizedBox(
                                    width: 150,
                                    child: Card(
                                      elevation: 15.0, //设置阴影
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(14.0))), //设置圆角
                                      child: ListTile(
                                        title: const Text("規格"),
                                        subtitle:
                                            Text(data["price"].toString()),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 150,
                                    child: Card(
                                      elevation: 15.0, //设置阴影
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(14.0))), //设置圆角
                                      child: ListTile(
                                        title: const Text("預計出貨時間"),
                                        subtitle:
                                            Text(data["price"].toString()),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 150,
                                    child: Card(
                                      elevation: 15.0, //设置阴影
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(14.0))), //设置圆角
                                      child: ListTile(
                                        title: const Text("總額"),
                                        subtitle:
                                            Text(data["price"].toString()),
                                      ),
                                    ),
                                  ),
                                ],
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
                                title: const Text("取貨方式"),
                                subtitle: Switch(
                                    value: flag,
                                    onChanged: (value) {
                                      setState(() {
                                        flag = value;
                                      });
                                    }),
                                leading: Icon(
                                  Icons.location_city_rounded,
                                  color: Colors.blue[500],
                                  size: 40,
                                ),
                              ),
                            ),
                          ),
                          const Divider(
                            thickness: 1,
                          ),
                          SizedBox(
                            // height: 100.0, //设置高度
                            width: width / 3,
                            child: Card(
                              elevation: 15.0, //设置阴影
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(14.0))), //设置圆角
                              child: ListTile(
                                title: const Text("電話"),
                                subtitle: TextFormField(
                                  controller: user_phone_number,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          decimal: true),
                                  decoration: InputDecoration(
                                    hintText: data['user_phone_number'],
                                  ),
                                ),
                                leading: Icon(
                                  Icons.phone_iphone_rounded,
                                  color: Colors.blue[500],
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
}
