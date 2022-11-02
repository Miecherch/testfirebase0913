import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'buying.dart';
import 'commodity.dart';

class new_commodity extends StatefulWidget {
  const new_commodity({Key? key}) : super(key: key);

  @override
  State<new_commodity> createState() => _new_commodityState();
}

class _new_commodityState extends State<new_commodity> {
  final storageRef = FirebaseStorage.instance.ref();
  User? user = FirebaseAuth.instance.currentUser;
  CollectionReference users = FirebaseFirestore.instance.collection('userdata');
  CollectionReference commodity =
      FirebaseFirestore.instance.collection('commodity');

  @override
  Widget build(BuildContext context) {
    bool isSign = (user == null ? false : true);
    ScreenUtil.init(context, designSize: Size(750, 1334)); //Size(750, 1334)
    final width = (750.w) * 3;
    final height = (1334.h) * 3;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: isSign == false
            ? AppBar(
                backgroundColor: const Color.fromARGB(255, 57, 151, 123),
                centerTitle: true,
                title: Row(
                  children: [
                    const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 0, vertical: 0)),
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
              )
            : AppBar(
                backgroundColor: const Color.fromARGB(255, 57, 151, 123),
                centerTitle: true,
                title: Row(
                  children: [
                    const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 0, vertical: 0)),
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
                bottom:
                    const TabBar(indicatorWeight: 2, indicatorColor: Colors.red,
                        // isScrollable: true, //多個按鈕可以滑動
                        tabs: <Widget>[
                      AutoSizeText("購物車",
                          style: TextStyle(fontSize: 20),
                          textAlign: TextAlign.center),
                      AutoSizeText("媒合系統",
                          maxLines: 1,
                          style: TextStyle(fontSize: 20),
                          textAlign: TextAlign.center),
                      AutoSizeText("已完成",
                          maxLines: 1,
                          style: TextStyle(fontSize: 20),
                          textAlign: TextAlign.center),
                    ]),
              ),
        body: isSign == false
            ? const Center(
                child: Text(
                  "請先登入",
                  style: TextStyle(fontSize: 30),
                ),
              )
            : TabBarView(
                children: <Widget>[
                  //購物車
                  Center(
                    child: RefreshIndicator(
                      child: StreamBuilder(
                          stream: users
                              .doc(user?.uid)
                              .collection("cart")
                              .snapshots(),
                          builder:
                              (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (!snapshot.hasData) {
                              return const Center(
                                child: SizedBox(
                                    width: 25,
                                    height: 25,
                                    child: CircularProgressIndicator(
                                        color: Colors.white)),
                              );
                            }
                            return ListView(
                              children:
                                  snapshot.data!.docs.map((cart_commodity) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 0),
                                  child: ListTile(
                                    title: Center(
                                      child: Card(
                                        elevation: 15.0, //设置阴影
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0))), //设置圆角
                                        semanticContainer: true,
                                        child: TextButton(
                                            onPressed: () {
                                              print(commodity.id);
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => commodity_page(
                                                          seller_ID:
                                                              cart_commodity[
                                                                      "seller_ID"]
                                                                  .toString(),
                                                          commodity_ID:
                                                              cart_commodity[
                                                                      "commodity_ID"]
                                                                  .toString(),
                                                          mode: 1)));
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                SizedBox(
                                                  width: width / 3 * 0.85 * 0.4,
                                                  child: ClipRRect(
                                                    child: cart_commodity[
                                                                'img'] !=
                                                            ""
                                                        ? ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0),
                                                            child: Image(
                                                              image: FirebaseImage(
                                                                  cart_commodity[
                                                                      "img"],
                                                                  shouldCache:
                                                                      true,
                                                                  cacheRefreshStrategy:
                                                                      CacheRefreshStrategy
                                                                          .BY_METADATA_DATE),
                                                            ))
                                                        : Container(
                                                            alignment: Alignment
                                                                .center,
                                                            width: 130,
                                                            height: 130,
                                                            child: const Text(
                                                                "沒照片",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        25)),
                                                            color: const Color
                                                                    .fromARGB(
                                                                255,
                                                                175,
                                                                76,
                                                                76),
                                                          ),
                                                  ),
                                                ),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    FutureBuilder<
                                                            DocumentSnapshot>(
                                                        future: commodity
                                                            .doc(cart_commodity[
                                                                "commodity_ID"])
                                                            .get(),
                                                        builder: (BuildContext
                                                                context,
                                                            AsyncSnapshot<
                                                                    DocumentSnapshot>
                                                                snapshot1) {
                                                          if (snapshot1
                                                              .hasError) {
                                                            return const Text(
                                                                "出現了一些錯誤");
                                                          }
                                                          if (snapshot1
                                                                  .hasData &&
                                                              !snapshot1.data!
                                                                  .exists) {
                                                            return Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: const [
                                                                Text(
                                                                    "沒有找到你的資料 請聯繫管理員"),
                                                              ],
                                                            );
                                                          }

                                                          if (snapshot1
                                                                  .connectionState ==
                                                              ConnectionState
                                                                  .done) {
                                                            Map<String, dynamic>
                                                                commodity_item =
                                                                snapshot1.data!
                                                                        .data()
                                                                    as Map<
                                                                        String,
                                                                        dynamic>;
                                                            int price = cart_commodity[
                                                                    "Purchase_quantity"] *
                                                                commodity_item[
                                                                    "price"];
                                                            users
                                                                .doc(user?.uid)
                                                                .collection(
                                                                    "cart")
                                                                .doc(
                                                                    cart_commodity
                                                                        .id)
                                                                .update({
                                                              'price': price,
                                                            });
                                                          }
                                                          return const SizedBox(
                                                            width: 0,
                                                          );
                                                        }),
                                                    SizedBox(
                                                      width:
                                                          width / 3 * 0.6 * 0.4,
                                                      child: AutoSizeText(
                                                          cart_commodity["name"]
                                                              .toString(),
                                                          maxLines: 1,
                                                          style:
                                                              const TextStyle(
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          255,
                                                                          255,
                                                                          255),
                                                                  fontSize: 25),
                                                          textAlign:
                                                              TextAlign.center),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        SizedBox(
                                                          width: width /
                                                              3 *
                                                              0.6 *
                                                              0.1,
                                                          child: const Icon(
                                                            Icons
                                                                .attach_money_rounded,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: width /
                                                              3 *
                                                              0.6 *
                                                              0.2,
                                                          child: AutoSizeText(
                                                            (cart_commodity[
                                                                        "price"] ==
                                                                    null
                                                                ? ""
                                                                : cart_commodity[
                                                                        "price"]
                                                                    .toString()),
                                                            style: const TextStyle(
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        255,
                                                                        255,
                                                                        255),
                                                                fontSize: 25),
                                                            textAlign: TextAlign
                                                                .center,
                                                            maxLines: 1,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      width:
                                                          width / 3 * 0.6 * 0.8,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          IconButton(
                                                            icon: Icon(
                                                              Icons
                                                                  .remove_circle_outline_rounded,
                                                              color: ((cart_commodity[
                                                                              "Purchase_quantity"] -
                                                                          1) <=
                                                                      0
                                                                  ? const Color
                                                                          .fromARGB(
                                                                      255,
                                                                      254,
                                                                      97,
                                                                      97)
                                                                  : const Color
                                                                          .fromARGB(
                                                                      255,
                                                                      97,
                                                                      254,
                                                                      207)),
                                                            ),
                                                            onPressed: () {
                                                              ((cart_commodity[
                                                                              "Purchase_quantity"] -
                                                                          1) <=
                                                                      0
                                                                  ? _showdeleteDialog(
                                                                      context,
                                                                      cart_commodity
                                                                          .id)
                                                                  : users
                                                                      .doc(user
                                                                          ?.uid)
                                                                      .collection(
                                                                          "cart")
                                                                      .doc(cart_commodity
                                                                          .id)
                                                                      .update({
                                                                      'Purchase_quantity':
                                                                          cart_commodity["Purchase_quantity"] -
                                                                              1,
                                                                    }));
                                                            },
                                                          ),
                                                          Text(
                                                              cart_commodity[
                                                                      "Purchase_quantity"]
                                                                  .toString(),
                                                              style:
                                                                  const TextStyle(
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        255,
                                                                        255,
                                                                        255),
                                                              ),
                                                              textAlign:
                                                                  TextAlign
                                                                      .right),
                                                          IconButton(
                                                            icon: const Icon(
                                                              Icons
                                                                  .add_circle_outline_rounded,
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      97,
                                                                      254,
                                                                      207),
                                                            ),
                                                            onPressed: () {
                                                              users
                                                                  .doc(
                                                                      user?.uid)
                                                                  .collection(
                                                                      "cart")
                                                                  .doc(
                                                                      cart_commodity
                                                                          .id)
                                                                  .update({
                                                                'Purchase_quantity':
                                                                    cart_commodity[
                                                                            "Purchase_quantity"] +
                                                                        1,
                                                              });
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width:
                                                          width / 3 * 0.6 * 0.8,
                                                      height: height / 3 * 0.05,
                                                      child: RaisedButton(
                                                        color: const Color
                                                                .fromARGB(
                                                            255, 57, 151, 123),
                                                        child: const Text("購買",
                                                            textAlign: TextAlign
                                                                .center),
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        onPressed: () {
                                                          print(user?.uid);
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          buying(
                                                                            cart_commodity:
                                                                                cart_commodity,
                                                                            commodity_ID:
                                                                                cart_commodity.id,
                                                                            cart_ID:
                                                                                cart_commodity.id,
                                                                          )));
                                                        },
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            )),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            );
                          }),
                      displacement: 20.0,
                      onRefresh: _onRefresh,
                    ),
                  ),
                  //媒合系統
                  Center(
                    child: RefreshIndicator(
                      child: StreamBuilder(
                          stream: users
                              .doc(user?.uid)
                              .collection("match")
                              .snapshots(),
                          builder:
                              (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (!snapshot.hasData) {
                              return const Center(
                                child: SizedBox(
                                    width: 25,
                                    height: 25,
                                    child: CircularProgressIndicator(
                                        color: Colors.white)),
                              );
                            }
                            return ListView(
                              children:
                                  snapshot.data!.docs.map((match_commodity) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 0),
                                  child: ListTile(
                                    title: Center(
                                      child: Card(
                                        elevation: 15.0, //设置阴影
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0))), //设置圆角
                                        semanticContainer: true,
                                        child: TextButton(
                                            onPressed: () {
                                              print(commodity.id);
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => commodity_page(
                                                          seller_ID:
                                                              match_commodity[
                                                                      "seller_ID"]
                                                                  .toString(),
                                                          commodity_ID:
                                                              match_commodity[
                                                                      "commodity_ID"]
                                                                  .toString(),
                                                          mode: 1)));
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                SizedBox(
                                                  width: width / 3 * 0.85 * 0.4,
                                                  child: ClipRRect(
                                                    child: match_commodity[
                                                                'commodity_img'] !=
                                                            ""
                                                        ? ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0),
                                                            child: Image(
                                                              image: FirebaseImage(
                                                                  match_commodity[
                                                                      "commodity_img"],
                                                                  shouldCache:
                                                                      true,
                                                                  cacheRefreshStrategy:
                                                                      CacheRefreshStrategy
                                                                          .BY_METADATA_DATE),
                                                            ))
                                                        : Container(
                                                            alignment: Alignment
                                                                .center,
                                                            width: 130,
                                                            height: 130,
                                                            child: const Text(
                                                                "沒照片",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        25)),
                                                            color: const Color
                                                                    .fromARGB(
                                                                255,
                                                                175,
                                                                76,
                                                                76),
                                                          ),
                                                  ),
                                                ),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    FutureBuilder<
                                                            DocumentSnapshot>(
                                                        future: commodity
                                                            .doc(match_commodity[
                                                                "commodity_ID"])
                                                            .get(),
                                                        builder: (BuildContext
                                                                context,
                                                            AsyncSnapshot<
                                                                    DocumentSnapshot>
                                                                snapshot1) {
                                                          if (snapshot1
                                                              .hasError) {
                                                            return const Text(
                                                                "出現了一些錯誤");
                                                          }
                                                          if (snapshot1
                                                                  .hasData &&
                                                              !snapshot1.data!
                                                                  .exists) {
                                                            return Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: const [
                                                                Text(""),
                                                              ],
                                                            );
                                                          }

                                                          return const SizedBox(
                                                            width: 0,
                                                          );
                                                        }),
                                                    SizedBox(
                                                      width:
                                                          width / 3 * 0.6 * 0.4,
                                                      child: AutoSizeText(
                                                          match_commodity[
                                                                  "commodity_name"]
                                                              .toString(),
                                                          maxLines: 1,
                                                          style:
                                                              const TextStyle(
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          255,
                                                                          255,
                                                                          255),
                                                                  fontSize: 25),
                                                          textAlign:
                                                              TextAlign.center),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        SizedBox(
                                                          width: width /
                                                              3 *
                                                              0.6 *
                                                              0.1,
                                                          child: const Icon(
                                                            Icons
                                                                .attach_money_rounded,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: width /
                                                              3 *
                                                              0.6 *
                                                              0.2,
                                                          child: AutoSizeText(
                                                            (match_commodity[
                                                                        "commodity_price"] ==
                                                                    null
                                                                ? ""
                                                                : match_commodity[
                                                                        "commodity_price"]
                                                                    .toString()),
                                                            style: const TextStyle(
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        255,
                                                                        255,
                                                                        255),
                                                                fontSize: 25),
                                                            textAlign: TextAlign
                                                                .center,
                                                            maxLines: 1,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        SizedBox(
                                                          width: width /
                                                              3 *
                                                              0.6 *
                                                              0.1,
                                                          child: const Icon(
                                                            Icons
                                                                .card_travel_rounded,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: width /
                                                              3 *
                                                              0.6 *
                                                              0.2,
                                                          child: AutoSizeText(
                                                            (match_commodity[
                                                                        "Purchase_quantity"] ==
                                                                    null
                                                                ? ""
                                                                : match_commodity[
                                                                        "Purchase_quantity"]
                                                                    .toString()),
                                                            style: const TextStyle(
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        255,
                                                                        255,
                                                                        255),
                                                                fontSize: 25),
                                                            textAlign: TextAlign
                                                                .center,
                                                            maxLines: 1,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    AutoSizeText(
                                                      match_commodity[
                                                                  "seller_agree"] ==
                                                              "checking"
                                                          ? "確認中"
                                                          : (match_commodity[
                                                                      "seller_agree"] ==
                                                                  "reject"
                                                              ? "已拒絕"
                                                              : (match_commodity[
                                                                          "seller_agree"] ==
                                                                      "agree"
                                                                  ? (match_commodity[
                                                                              "commodity_state"] ==
                                                                          "no"
                                                                      ? "已同意"
                                                                      : (match_commodity["commodity_state"] ==
                                                                              "preparing"
                                                                          ? "準備中"
                                                                          : (match_commodity["commodity_state"] == "mailed"
                                                                              ? "已寄出"
                                                                              : "已抵達")))
                                                                  : "error")),
                                                      style: const TextStyle(
                                                          color: Color.fromARGB(
                                                              255, 255, 92, 92),
                                                          fontSize: 20),
                                                      textAlign:
                                                          TextAlign.center,
                                                      maxLines: 1,
                                                    ),
                                                    ((match_commodity[
                                                                    "seller_agree"] ==
                                                                "reject") ||
                                                            (match_commodity[
                                                                    "commodity_state"] ==
                                                                "arrival"))
                                                        ? SizedBox(
                                                            child: RaisedButton(
                                                              color: const Color
                                                                      .fromARGB(
                                                                  255,
                                                                  57,
                                                                  151,
                                                                  123),
                                                              child:
                                                                  const AutoSizeText(
                                                                "完成訂單",
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                maxLines: 2,
                                                              ),
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                              ),
                                                              onPressed: () {
                                                                users
                                                                    .doc(user
                                                                        ?.uid)
                                                                    .collection(
                                                                        "Finish")
                                                                    .doc(
                                                                        match_commodity
                                                                            .id)
                                                                    .set({
                                                                      "Purchase_quantity":
                                                                          match_commodity[
                                                                              "Purchase_quantity"], //購買數量
                                                                      "commodity_ID":
                                                                          match_commodity[
                                                                              "commodity_ID"], //商品ID
                                                                      "commodity_name":
                                                                          match_commodity[
                                                                              "commodity_name"], //商品name
                                                                      "commodity_price":
                                                                          match_commodity[
                                                                              "commodity_price"], //商品價格
                                                                      "commodity_img":
                                                                          match_commodity[
                                                                              "commodity_img"], //商品圖片
                                                                      "Buyer_first_name":
                                                                          match_commodity[
                                                                              "Buyer_first_name"], //買家姓氏
                                                                      "Buyer_last_name":
                                                                          match_commodity[
                                                                              "Buyer_last_name"], //買家名字
                                                                      "Buyer_phone":
                                                                          match_commodity[
                                                                              "Buyer_phone"], //買家電話
                                                                      "Buyer_address":
                                                                          match_commodity[
                                                                              "Buyer_address"], //買家地址
                                                                      "Buyer_Pickup_method":
                                                                          match_commodity[
                                                                              "Buyer_Pickup_method"], //買家取貨方式
                                                                      "Buyer_message":
                                                                          match_commodity[
                                                                              "Buyer_message"], //買家留言
                                                                      "seller_agree":
                                                                          match_commodity[
                                                                              "seller_agree"], //賣家是否同意出貨
                                                                      "sell_date":
                                                                          match_commodity[
                                                                              "sell_date"], //出貨日期
                                                                      "seller_ID":
                                                                          match_commodity[
                                                                              "seller_ID"], //賣家ID
                                                                      "buyer_ID":
                                                                          user?.uid,
                                                                      "Finish_date":
                                                                          DateTime.now()
                                                                              .toString(),
                                                                    })
                                                                    .then((value) =>
                                                                        print(
                                                                            "User Added"))
                                                                    .catchError(
                                                                        (error) =>
                                                                            print("Failed to add user: $error"));
                                                                users
                                                                    .doc(user
                                                                        ?.uid)
                                                                    .collection(
                                                                        "match")
                                                                    .doc(
                                                                        match_commodity
                                                                            .id)
                                                                    .delete()
                                                                    .then((value) =>
                                                                        print(
                                                                            "match change"))
                                                                    .catchError(
                                                                        (error) =>
                                                                            print("Failed to change match: $error"));
                                                                users
                                                                    .doc(match_commodity[
                                                                        "seller_ID"])
                                                                    .collection(
                                                                        "sell")
                                                                    .doc(
                                                                        match_commodity
                                                                            .id)
                                                                    .update({
                                                                      "commodity_state":
                                                                          "buyer_check"
                                                                    })
                                                                    .then((value) =>
                                                                        print(
                                                                            "match change"))
                                                                    .catchError(
                                                                        (error) =>
                                                                            print("Failed to change match: $error"));
                                                              },
                                                            ),
                                                          )
                                                        : SizedBox(),
                                                  ],
                                                ),
                                              ],
                                            )),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            );
                          }),
                      displacement: 20.0,
                      onRefresh: _onRefresh,
                    ),
                  ),
                  //已完成
                  Center(
                    child: RefreshIndicator(
                      child: StreamBuilder(
                          stream: users
                              .doc(user?.uid)
                              .collection("Finish")
                              .snapshots(),
                          builder:
                              (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (!snapshot.hasData) {
                              return const Center(
                                child: SizedBox(
                                    width: 25,
                                    height: 25,
                                    child: CircularProgressIndicator(
                                        color: Colors.white)),
                              );
                            }
                            return ListView(
                              children:
                                  snapshot.data!.docs.map((Finish_commodity) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 0),
                                  child: ListTile(
                                    title: Center(
                                      child: Card(
                                        elevation: 15.0, //设置阴影
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0))), //设置圆角
                                        semanticContainer: true,
                                        child: TextButton(
                                            onPressed: () {
                                              print(commodity.id);
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => commodity_page(
                                                          seller_ID:
                                                              Finish_commodity[
                                                                      "seller_ID"]
                                                                  .toString(),
                                                          commodity_ID:
                                                              Finish_commodity[
                                                                      "commodity_ID"]
                                                                  .toString(),
                                                          mode: 1)));
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                SizedBox(
                                                  width:
                                                      width / 3 * 0.85 * 0.35,
                                                  child: ClipRRect(
                                                    child: Finish_commodity[
                                                                'commodity_img'] !=
                                                            ""
                                                        ? ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0),
                                                            child: Image(
                                                              image: FirebaseImage(
                                                                  Finish_commodity[
                                                                      "commodity_img"],
                                                                  shouldCache:
                                                                      true,
                                                                  cacheRefreshStrategy:
                                                                      CacheRefreshStrategy
                                                                          .BY_METADATA_DATE),
                                                            ))
                                                        : Container(
                                                            alignment: Alignment
                                                                .center,
                                                            width: 130,
                                                            height: 130,
                                                            child: const Text(
                                                                "沒照片",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        25)),
                                                            color: const Color
                                                                    .fromARGB(
                                                                255,
                                                                175,
                                                                76,
                                                                76),
                                                          ),
                                                  ),
                                                ),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    FutureBuilder<
                                                            DocumentSnapshot>(
                                                        future: commodity
                                                            .doc(Finish_commodity[
                                                                "commodity_ID"])
                                                            .get(),
                                                        builder: (BuildContext
                                                                context,
                                                            AsyncSnapshot<
                                                                    DocumentSnapshot>
                                                                snapshot1) {
                                                          if (snapshot1
                                                              .hasError) {
                                                            return const Text(
                                                                "出現了一些錯誤");
                                                          }
                                                          if (snapshot1
                                                                  .hasData &&
                                                              !snapshot1.data!
                                                                  .exists) {
                                                            return Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: const [
                                                                Text(""),
                                                              ],
                                                            );
                                                          }

                                                          return const SizedBox(
                                                            width: 0,
                                                          );
                                                        }),
                                                    SizedBox(
                                                      width:
                                                          width / 3 * 0.6 * 0.4,
                                                      child: AutoSizeText(
                                                          Finish_commodity[
                                                                  "commodity_name"]
                                                              .toString(),
                                                          maxLines: 1,
                                                          style: const TextStyle(
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      255,
                                                                      255,
                                                                      255),
                                                              fontSize: 25),
                                                          textAlign:
                                                              TextAlign.center),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        SizedBox(
                                                          width: width /
                                                              3 *
                                                              0.6 *
                                                              0.1,
                                                          child: const Icon(
                                                            Icons
                                                                .attach_money_rounded,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: width /
                                                              3 *
                                                              0.6 *
                                                              0.2,
                                                          child: AutoSizeText(
                                                            (Finish_commodity[
                                                                        "commodity_price"] ==
                                                                    null
                                                                ? ""
                                                                : Finish_commodity[
                                                                        "commodity_price"]
                                                                    .toString()),
                                                            style: const TextStyle(
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        255,
                                                                        255,
                                                                        255),
                                                                fontSize: 25),
                                                            textAlign: TextAlign
                                                                .center,
                                                            maxLines: 1,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        SizedBox(
                                                          width: width /
                                                              3 *
                                                              0.6 *
                                                              0.1,
                                                          child: const Icon(
                                                            Icons
                                                                .card_travel_rounded,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: width /
                                                              3 *
                                                              0.6 *
                                                              0.2,
                                                          child: AutoSizeText(
                                                            (Finish_commodity[
                                                                        "Purchase_quantity"] ==
                                                                    null
                                                                ? ""
                                                                : Finish_commodity[
                                                                        "Purchase_quantity"]
                                                                    .toString()),
                                                            style: const TextStyle(
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        255,
                                                                        255,
                                                                        255),
                                                                fontSize: 25),
                                                            textAlign: TextAlign
                                                                .center,
                                                            maxLines: 1,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    AutoSizeText(
                                                        Finish_commodity[
                                                                    "seller_agree"] ==
                                                                "reject"
                                                            ? "已拒絕"
                                                            : "已送達",
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                            color: Finish_commodity["seller_agree"] ==
                                                                    "reject"
                                                                ? const Color
                                                                        .fromARGB(
                                                                    255,
                                                                    255,
                                                                    92,
                                                                    92)
                                                                : const Color
                                                                        .fromARGB(
                                                                    255,
                                                                    57,
                                                                    151,
                                                                    123),
                                                            fontSize: 20),
                                                        textAlign:
                                                            TextAlign.center),
                                                    AutoSizeText(
                                                        Finish_commodity["Finish_date"]
                                                            .toString()
                                                            .substring(0, 10),
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                            color: Finish_commodity["seller_agree"] ==
                                                                    "reject"
                                                                ? const Color
                                                                        .fromARGB(
                                                                    255,
                                                                    255,
                                                                    92,
                                                                    92)
                                                                : const Color
                                                                        .fromARGB(
                                                                    255,
                                                                    57,
                                                                    151,
                                                                    123),
                                                            fontSize: 20),
                                                        textAlign:
                                                            TextAlign.center),
                                                  ],
                                                ),
                                              ],
                                            )),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            );
                          }),
                      displacement: 20.0,
                      onRefresh: _onRefresh,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Future<Null> _onRefresh() async {
    await Future.delayed(Duration(seconds: 1), () {
      print('refresh');
      setState(() {});
    });
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
}
