import 'dart:async';
import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'addstore.dart';
import 'editstore.dart';

class seller extends StatefulWidget {
  const seller({Key? key}) : super(key: key);

  @override
  State<seller> createState() => _sellerState();
}

class _sellerState extends State<seller> with SingleTickerProviderStateMixin {
  final storageRef = FirebaseStorage.instance.ref();

  CollectionReference users = FirebaseFirestore.instance.collection('userdata');
  CollectionReference commodity =
      FirebaseFirestore.instance.collection('commodity');
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(750, 1334));
    final width = (750.w) * 3;
    final height = (1334.h) * 3;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              iconSize: 40,
              tooltip: ("新增賣場"),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => addstore()));
              },
              icon: const Icon(
                Icons.add_business_rounded,
              ),
            ),
          ],
          centerTitle: true,
          title: Column(
            children: [
              Row(
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
                    "賣家系統",
                    style: TextStyle(fontSize: 30),
                  ),
                ],
              ),
            ],
          ),
          backgroundColor: const Color.fromARGB(255, 57, 151, 123),
          bottom: const TabBar(indicatorColor: Colors.red,
              // isScrollable: true, //多個按鈕可以滑動
              tabs: <Widget>[
                Tab(text: "媒合系統"),
                Tab(text: "已結束訂單"),
                Tab(text: "我的賣場"),
              ]),
        ),
        body: TabBarView(
          children: <Widget>[
            //媒合系統
            Center(
              child: StreamBuilder(
                  stream: users.doc(user!.uid).collection("sell").snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: SizedBox(
                            width: 25,
                            height: 25,
                            child:
                                CircularProgressIndicator(color: Colors.white)),
                      );
                    }
                    return ListView(
                      children: snapshot.data!.docs.map((sell_commodity) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 0),
                          child: ListTile(
                            title: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: width / 3,
                                    child: Card(
                                      elevation: 15.0, //设置阴影
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(14.0))), //设置圆角
                                      child: TextButton(
                                          onPressed: () {},
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  SizedBox(
                                                    width: width / 3 * 0.2,
                                                    child: AutoSizeText(
                                                      sell_commodity[
                                                              "commodity_name"]
                                                          .toString(),
                                                      style: const TextStyle(
                                                          color: Color.fromARGB(
                                                              255,
                                                              255,
                                                              255,
                                                              255),
                                                          fontSize: 25),
                                                      textAlign:
                                                          TextAlign.center,
                                                      maxLines: 1,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: width / 3 * 0.2,
                                                    child: Column(
                                                      children: [
                                                        Text(
                                                            "數量:" +
                                                                sell_commodity["Purchase_quantity"]
                                                                    .toString(),
                                                            style:
                                                                const TextStyle(
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            255,
                                                                            255,
                                                                            255),
                                                                    fontSize:
                                                                        20),
                                                            textAlign: TextAlign
                                                                .center),
                                                        Text(
                                                            "金額:" +
                                                                sell_commodity["commodity_price"]
                                                                    .toString(),
                                                            style:
                                                                const TextStyle(
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            255,
                                                                            255,
                                                                            255),
                                                                    fontSize:
                                                                        20),
                                                            textAlign: TextAlign
                                                                .center)
                                                      ],
                                                    ),
                                                  ),
                                                  (sell_commodity[
                                                              "seller_agree"] ==
                                                          "checking")
                                                      ? Column(
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(0),
                                                              child:
                                                                  RaisedButton(
                                                                color: const Color
                                                                        .fromARGB(
                                                                    128,
                                                                    254,
                                                                    97,
                                                                    97),
                                                                child: const Text(
                                                                    "拒絕訂單",
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center),
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                ),
                                                                onPressed: () {
                                                                  _showrejectDialog(
                                                                      context,
                                                                      sell_commodity);
                                                                },
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(5),
                                                              child:
                                                                  RaisedButton(
                                                                color: const Color
                                                                        .fromARGB(
                                                                    255,
                                                                    57,
                                                                    151,
                                                                    123),
                                                                child: const Text(
                                                                    "接受訂單",
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center),
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                ),
                                                                onPressed: () {
                                                                  _showcheckDialog(
                                                                      context,
                                                                      sell_commodity);
                                                                },
                                                              ),
                                                            )
                                                          ],
                                                        )
                                                      : (sell_commodity[
                                                                  "commodity_state"] ==
                                                              "buyer_check"
                                                          ? Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(5),
                                                              child:
                                                                  RaisedButton(
                                                                color: const Color
                                                                        .fromARGB(
                                                                    255,
                                                                    57,
                                                                    151,
                                                                    123),
                                                                child: const Text(
                                                                    "完成訂單",
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center),
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                ),
                                                                onPressed: () {
                                                                  _showFinishDialog(
                                                                      context,
                                                                      sell_commodity);
                                                                },
                                                              ),
                                                            )
                                                          : SizedBox())
                                                ],
                                              ),
                                              (sell_commodity["seller_agree"] ==
                                                      "agree")
                                                  ? Column(
                                                      children: [
                                                        ((sell_commodity[
                                                                    "commodity_state"] !=
                                                                "buyer_check")
                                                            ? Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceAround,
                                                                children: [
                                                                  TextButton(
                                                                    child: const Text(
                                                                        "準備中"),
                                                                    onPressed:
                                                                        () {
                                                                      users
                                                                          .doc(user!
                                                                              .uid)
                                                                          .collection(
                                                                              "sell")
                                                                          .doc(sell_commodity
                                                                              .id)
                                                                          .update({
                                                                        'commodity_state':
                                                                            "preparing",
                                                                      });
                                                                      users
                                                                          .doc(sell_commodity[
                                                                              "buyer_ID"])
                                                                          .collection(
                                                                              "match")
                                                                          .doc(sell_commodity
                                                                              .id)
                                                                          .update({
                                                                        'commodity_state':
                                                                            "preparing",
                                                                      });

                                                                      ;
                                                                    },
                                                                  ),
                                                                  TextButton(
                                                                    child: Text(
                                                                        "已寄出"),
                                                                    onPressed:
                                                                        () {
                                                                      users
                                                                          .doc(user!
                                                                              .uid)
                                                                          .collection(
                                                                              "sell")
                                                                          .doc(sell_commodity
                                                                              .id)
                                                                          .update({
                                                                        'commodity_state':
                                                                            "mailed",
                                                                      });
                                                                      users
                                                                          .doc(sell_commodity[
                                                                              "buyer_ID"])
                                                                          .collection(
                                                                              "match")
                                                                          .doc(sell_commodity
                                                                              .id)
                                                                          .update({
                                                                        'commodity_state':
                                                                            "mailed",
                                                                      });

                                                                      ;
                                                                    },
                                                                  ),
                                                                  TextButton(
                                                                    child: Text(
                                                                        "已送達"),
                                                                    onPressed:
                                                                        () {
                                                                      users
                                                                          .doc(user!
                                                                              .uid)
                                                                          .collection(
                                                                              "sell")
                                                                          .doc(sell_commodity
                                                                              .id)
                                                                          .update({
                                                                        'commodity_state':
                                                                            "arrival",
                                                                      });
                                                                      users
                                                                          .doc(sell_commodity[
                                                                              "buyer_ID"])
                                                                          .collection(
                                                                              "match")
                                                                          .doc(sell_commodity
                                                                              .id)
                                                                          .update({
                                                                        'commodity_state':
                                                                            "arrival",
                                                                      });

                                                                      ;
                                                                    },
                                                                  ),
                                                                ],
                                                              )
                                                            : const SizedBox()),
                                                        LinearProgressIndicator(
                                                          backgroundColor:
                                                              Colors.grey[200],
                                                          valueColor:
                                                              const AlwaysStoppedAnimation(
                                                                  Color
                                                                      .fromARGB(
                                                                          255,
                                                                          94,
                                                                          251,
                                                                          204)),
                                                          value: sell_commodity[
                                                                      "commodity_state"] ==
                                                                  "preparing"
                                                              ? 0.17
                                                              : (sell_commodity[
                                                                          "commodity_state"] ==
                                                                      "mailed"
                                                                  ? 0.5
                                                                  : (sell_commodity[
                                                                              "commodity_state"] ==
                                                                          "arrival"
                                                                      ? 0.83
                                                                      : 1)),
                                                        )
                                                      ],
                                                    )
                                                  : SizedBox(),
                                            ],
                                          )),
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
            //已結束訂單
            Center(
              child: StreamBuilder(
                  stream: users
                      .doc(user!.uid)
                      .collection("sell_finish")
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: SizedBox(
                            width: 25,
                            height: 25,
                            child:
                                CircularProgressIndicator(color: Colors.white)),
                      );
                    }
                    return ListView(
                      children: snapshot.data!.docs.map((end_commodity) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 0),
                          child: ListTile(
                            title: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: width / 3,
                                    // height: 120,
                                    child: Card(
                                      elevation: 15.0, //设置阴影
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(14.0))), //设置圆角
                                      child: TextButton(
                                          onPressed: () {},
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  AutoSizeText(
                                                    end_commodity[
                                                            "commodity_name"]
                                                        .toString(),
                                                    style: const TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 255, 255, 255),
                                                        fontSize: 25),
                                                    textAlign: TextAlign.center,
                                                    maxLines: 1,
                                                  ),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          const Icon(
                                                            Icons
                                                                .attach_money_rounded,
                                                            color: Colors.white,
                                                          ),
                                                          Text(
                                                              (end_commodity[
                                                                          "commodity_price"] ==
                                                                      null
                                                                  ? ""
                                                                  : end_commodity[
                                                                          "commodity_price"]
                                                                      .toString()),
                                                              style: const TextStyle(
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          255,
                                                                          255,
                                                                          255),
                                                                  fontSize: 20),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center),
                                                          const SizedBox(
                                                            width: 20,
                                                          ),
                                                          Text(
                                                              end_commodity[
                                                                          "seller_agree"] ==
                                                                      "agree"
                                                                  ? "已完成"
                                                                  : "已拒絕",
                                                              style: TextStyle(
                                                                  color: (end_commodity[
                                                                              "seller_agree"] ==
                                                                          "agree"
                                                                      ? const Color
                                                                              .fromARGB(
                                                                          255,
                                                                          94,
                                                                          251,
                                                                          204)
                                                                      : const Color
                                                                              .fromARGB(
                                                                          255,
                                                                          255,
                                                                          92,
                                                                          92)),
                                                                  fontSize: 20),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center),
                                                        ],
                                                      ),
                                                      Text(
                                                          "完成日期:" +
                                                              end_commodity[
                                                                      "Finish_date"]
                                                                  .toString()
                                                                  .substring(
                                                                      0, 10),
                                                          style:
                                                              const TextStyle(
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          255,
                                                                          255,
                                                                          255),
                                                                  fontSize: 15),
                                                          textAlign:
                                                              TextAlign.center),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              LinearProgressIndicator(
                                                backgroundColor:
                                                    Colors.grey[200],
                                                valueColor: AlwaysStoppedAnimation(
                                                    (end_commodity[
                                                                "seller_agree"] ==
                                                            "agree"
                                                        ? const Color.fromARGB(
                                                            255, 94, 251, 204)
                                                        : Colors.red)),
                                                value: 1,
                                              )
                                            ],
                                          )),
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
            //我的賣場
            Center(
              child: RefreshIndicator(
                child: StreamBuilder(
                    stream: users
                        .doc(user!.uid)
                        .collection("seller_store")
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      imageCache.clear();
                      imageCache.clearLiveImages();
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
                        children: snapshot.data!.docs.map((seller_store) {
                          final mountainImagesRef =
                              storageRef.child("commodity/" + seller_store.id);
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 0),
                            child: ListTile(
                              title: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: width / 3,
                                      // height: height / 3 * 0.2,
                                      child: Card(
                                        elevation: 15.0, //设置阴影
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(14.0))), //设置圆角
                                        child: TextButton(
                                          onLongPress: () {
                                            seller_store["is_commodity"] ==
                                                    "true"
                                                ? _showButtonPressDialog(
                                                    context, "請先下架才能刪除商品", 10)
                                                : seller_store[
                                                            "is_commodity"] ==
                                                        "false"
                                                    ? _showdeleteDialog(
                                                        context, seller_store)
                                                    : null;
                                          },
                                          //todo
                                          onPressed: () {
                                            seller_store["is_commodity"] ==
                                                    "true"
                                                ? _showButtonPressDialog(
                                                    context, "請先下架才能編輯商品", 10)
                                                : seller_store[
                                                            "is_commodity"] ==
                                                        "false"
                                                    ? setState(() {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        editstore(
                                                                          commodity:
                                                                              seller_store,
                                                                        ))).then(
                                                            (asd) {
                                                          imageCache.clear();
                                                          imageCache
                                                              .clearLiveImages();
                                                          print(asd);
                                                        });
                                                      })
                                                    : null;
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              SizedBox(
                                                width: width / 3 * 0.85 * 0.3,
                                                height: height / 3 * 0.18,
                                                child: ClipRRect(
                                                  child: seller_store['img'] !=
                                                          ""
                                                      ? ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      15.0),
                                                          child: Image(
                                                            image: FirebaseImage(
                                                                seller_store[
                                                                    "img"],
                                                                shouldCache:
                                                                    true,
                                                                cacheRefreshStrategy:
                                                                    CacheRefreshStrategy
                                                                        .BY_METADATA_DATE),
                                                          ))
                                                      : Container(
                                                          alignment:
                                                              Alignment.center,
                                                          width: 130,
                                                          height: 130,
                                                          child: const Text(
                                                              "沒照片",
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      25)),
                                                          color: const Color
                                                                  .fromARGB(
                                                              255, 175, 76, 76),
                                                        ),
                                                ),
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  Row(
                                                    children: [
                                                      SizedBox(
                                                        width: width /
                                                            3 *
                                                            0.85 *
                                                            0.4,
                                                        child: Column(
                                                          children: [
                                                            SizedBox(
                                                              width: width /
                                                                  3 *
                                                                  0.4,
                                                              child:
                                                                  AutoSizeText(
                                                                (seller_store[
                                                                        "name"])
                                                                    .toString(),
                                                                style: const TextStyle(
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            255,
                                                                            255,
                                                                            255),
                                                                    fontSize:
                                                                        25),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                maxLines: 1,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: width /
                                                                  3 *
                                                                  0.4,
                                                              child:
                                                                  AutoSizeText(
                                                                ("價格: " +
                                                                    seller_store[
                                                                            "price"]
                                                                        .toString()),
                                                                style: const TextStyle(
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            255,
                                                                            255,
                                                                            255),
                                                                    fontSize:
                                                                        25),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                maxLines: 1,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                                width: width /
                                                                    3 *
                                                                    0.4,
                                                                child: SizedBox(
                                                                  width: width /
                                                                      3 *
                                                                      0.3,
                                                                  child:
                                                                      AutoSizeText(
                                                                    ("商品數量: " +
                                                                        seller_store["remaining_stock"]
                                                                            .toString() +
                                                                        " / " +
                                                                        seller_store["stock"]
                                                                            .toString()),
                                                                    style: const TextStyle(
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            255,
                                                                            255,
                                                                            255),
                                                                        fontSize:
                                                                            25),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    maxLines: 1,
                                                                  ),
                                                                )),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: width /
                                                            3 *
                                                            0.85 *
                                                            0.25,
                                                        child: Column(
                                                          children: [
                                                            seller_store["is_commodity"]
                                                                        .toString() ==
                                                                    "false"
                                                                ? SizedBox(
                                                                    // width: 0,
                                                                    height:
                                                                        height /
                                                                            3 *
                                                                            0.09,
                                                                    child:
                                                                        FlatButton(
                                                                      // borderSide: const BorderSide(
                                                                      //     width:
                                                                      //         2,
                                                                      //     color: Color.fromARGB(
                                                                      //         135,
                                                                      //         255,
                                                                      //         255,
                                                                      //         255)),
                                                                      color: const Color
                                                                              .fromARGB(
                                                                          255,
                                                                          57,
                                                                          151,
                                                                          123),
                                                                      child: const Text(
                                                                          "上架",
                                                                          textAlign:
                                                                              TextAlign.center),
                                                                      shape:
                                                                          RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(10),
                                                                      ),
                                                                      onPressed:
                                                                          () {
                                                                        commodity
                                                                            .doc(seller_store.id)
                                                                            .set({
                                                                          "Origin":
                                                                              seller_store["Origin"], //產地
                                                                          "introduce":
                                                                              seller_store["introduce"], //商品介紹
                                                                          "name":
                                                                              seller_store["name"], //商品名稱
                                                                          "owner":
                                                                              user!.uid, //賣家ID
                                                                          "price":
                                                                              seller_store["price"], //價格
                                                                          "remaining_stock":
                                                                              seller_store["remaining_stock"], //剩餘數量
                                                                          "stock":
                                                                              seller_store["stock"], //商品總數
                                                                          "time":
                                                                              seller_store["time"], //出貨時間
                                                                          "type":
                                                                              seller_store["type"], //種類1
                                                                          "img":
                                                                              seller_store["img"], //img
                                                                          "type2":
                                                                              "", //種類2
                                                                        });
                                                                        users
                                                                            .doc(user!
                                                                                .uid)
                                                                            .collection(
                                                                                "seller_store")
                                                                            .doc(seller_store
                                                                                .id)
                                                                            .update({
                                                                          "is_commodity":
                                                                              "true"
                                                                        });
                                                                      },
                                                                    ),
                                                                  )
                                                                : seller_store["is_commodity"]
                                                                            .toString() ==
                                                                        "true"
                                                                    ? SizedBox(
                                                                        height: height /
                                                                            3 *
                                                                            0.09,
                                                                        child:
                                                                            FlatButton(
                                                                          color: const Color.fromARGB(
                                                                              128,
                                                                              254,
                                                                              97,
                                                                              97),
                                                                          child: const Text(
                                                                              "下架",
                                                                              textAlign: TextAlign.center),
                                                                          shape:
                                                                              RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(10),
                                                                          ),
                                                                          onPressed:
                                                                              () {
                                                                            commodity.doc(seller_store.id).delete();
                                                                            users.doc(user!.uid).collection("seller_store").doc(seller_store.id).update({
                                                                              "is_commodity": "false"
                                                                            });
                                                                          },
                                                                        ),
                                                                      )
                                                                    : SizedBox(
                                                                        height: height /
                                                                            3 *
                                                                            0.09,
                                                                        child:
                                                                            FlatButton(
                                                                          color: const Color.fromARGB(
                                                                              128,
                                                                              254,
                                                                              97,
                                                                              97),
                                                                          child: const Text(
                                                                              "已刪除",
                                                                              textAlign: TextAlign.center),
                                                                          shape:
                                                                              RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(10),
                                                                          ),
                                                                          onPressed:
                                                                              null,
                                                                        ),
                                                                      )
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    width: width / 3 * 0.2,
                                                    height: height / 3 * 0.03,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        AutoSizeText(
                                                          seller_store["is_commodity"]
                                                                      .toString() ==
                                                                  "true"
                                                              ? "已上架"
                                                              : seller_store["is_commodity"]
                                                                          .toString() ==
                                                                      "false"
                                                                  ? "已下架"
                                                                  : "已刪除",
                                                          style: TextStyle(
                                                              color: (seller_store[
                                                                              "is_commodity"]
                                                                          .toString() ==
                                                                      "true"
                                                                  ? const Color
                                                                          .fromARGB(
                                                                      255,
                                                                      94,
                                                                      251,
                                                                      204)
                                                                  : seller_store["is_commodity"]
                                                                              .toString() ==
                                                                          "false"
                                                                      ? Colors
                                                                          .red
                                                                      : const Color
                                                                              .fromARGB(
                                                                          255,
                                                                          153,
                                                                          153,
                                                                          153)),
                                                              fontSize: 25),
                                                          textAlign:
                                                              TextAlign.center,
                                                          maxLines: 1,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: width / 3 * 0.53,
                                                    child:
                                                        LinearProgressIndicator(
                                                      valueColor: AlwaysStoppedAnimation((seller_store[
                                                                      "is_commodity"]
                                                                  .toString() ==
                                                              "true"
                                                          ? const Color
                                                                  .fromARGB(
                                                              255, 94, 251, 204)
                                                          : seller_store["is_commodity"]
                                                                      .toString() ==
                                                                  "false"
                                                              ? Colors.red
                                                              : Color.fromARGB(
                                                                  255,
                                                                  88,
                                                                  88,
                                                                  88))),
                                                      value: 1,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
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
                displacement: 20.0,
                onRefresh: _onRefresh,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> pages = [];
//所有提示頁面
//TODO:顯示SnackBar
  void _showButtonPressDialog(
      BuildContext context, String provider, int millisecond) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(provider),
      // backgroundColor: Colors.white38,
      duration: Duration(milliseconds: millisecond * 100),
    ));
  }

  Future<void> _showdeleteDialog(
      BuildContext context, QueryDocumentSnapshot<Object?> sell_commodity) {
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
          title: const Text("刪除",
              style: TextStyle(fontSize: 30), textAlign: TextAlign.center),
          content: SizedBox(
            height: height / 3 * 0.1,
            width: width / 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AutoSizeText(
                  "刪除這個商品？ 請注意此動作無法回覆",
                  maxLines: 1,
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
                        // final mountainImagesRef =
                        //     storageRef.child("commodity/" + sell_commodity.id);
                        // mountainImagesRef.delete();

                        // users
                        //     .doc(user!.uid)
                        //     .collection("seller_store")
                        //     .doc(sell_commodity.id)
                        //     .delete();
                        users
                            .doc(user!.uid)
                            .collection("seller_store")
                            .doc(sell_commodity.id)
                            .update({"is_commodity": "delete"});

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

  Future<void> _showrejectDialog(
      BuildContext context, QueryDocumentSnapshot<Object?> sell_commodity) {
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
          title: const Text("拒絕",
              style: TextStyle(fontSize: 30), textAlign: TextAlign.center),
          content: SizedBox(
            height: height / 3 * 0.2,
            width: width / 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("是否拒絕這個訂單？"),
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
                            .doc(sell_commodity["buyer_ID"])
                            .collection("match")
                            .doc(sell_commodity.id)
                            .update({"seller_agree": "reject"});

                        users
                            .doc(user!.uid)
                            .collection("sell_finish")
                            .doc(sell_commodity.id)
                            .set({
                          "Purchase_quantity":
                              sell_commodity["Purchase_quantity"], //購買數量
                          "commodity_ID": sell_commodity["commodity_ID"], //商品ID
                          "commodity_name":
                              sell_commodity["commodity_name"], //商品name
                          "commodity_price":
                              sell_commodity["commodity_price"], //商品價格
                          "commodity_img":
                              sell_commodity["commodity_img"], //商品圖片
                          "Buyer_first_name":
                              sell_commodity["Buyer_first_name"], //買家姓氏
                          "Buyer_last_name":
                              sell_commodity["Buyer_last_name"], //買家名字
                          "Buyer_phone": sell_commodity["Buyer_phone"], //買家電話
                          "Buyer_address":
                              sell_commodity["Buyer_address"], //買家地址
                          "Buyer_Pickup_method":
                              sell_commodity["Buyer_Pickup_method"], //買家取貨方式
                          "Buyer_message":
                              sell_commodity["Buyer_message"], //買家留言
                          "seller_agree": "reject", //賣家是否同意出貨
                          "sell_date": sell_commodity["sell_date"], //出貨日期
                          "seller_ID": sell_commodity["seller_ID"], //賣家ID
                          "buyer_ID": sell_commodity["buyer_ID"],
                          "commodity_state": "end",
                          "Finish_date": DateTime.now().toString(),
                        });

                        users
                            .doc(user.uid)
                            .collection("sell")
                            .doc(sell_commodity.id)
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

  Future<void> _showcheckDialog(
      BuildContext context, QueryDocumentSnapshot<Object?> sell_commodity) {
    CollectionReference users =
        FirebaseFirestore.instance.collection('userdata');
    User? user = FirebaseAuth.instance.currentUser;

    return showDialog<void>(
      context: context,
      builder: (BuildContext context1) {
        ScreenUtil.init(context, designSize: Size(750, 1334));
        final width = (750.w) * 3;
        final height = (1334.h) * 3;
        return CupertinoScrollbar(
            thickness: 6.0,
            thicknessWhileDragging: 10.0,
            radius: const Radius.circular(34.0),
            radiusWhileDragging: Radius.zero,
            child: AlertDialog(
              backgroundColor: const Color.fromARGB(255, 48, 48, 48),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              title: const Text("接受訂單",
                  style: TextStyle(fontSize: 30), textAlign: TextAlign.center),
              content: SizedBox(
                // height: height / 3,
                width: width / 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: sell_commodity['commodity_img'] != ""
                          ? Image(
                              image: FirebaseImage(
                                  sell_commodity['commodity_img'],
                                  shouldCache: true,
                                  cacheRefreshStrategy:
                                      CacheRefreshStrategy.BY_METADATA_DATE),
                              width: width / 3 * 0.9,
                              height: height / 3 * 0.14,
                            )
                          : SizedBox(),
                    ),
                    Column(
                      children: [
                        Text(
                          sell_commodity['commodity_name'],
                          style: DefaultTextStyle.of(context)
                              .style
                              .apply(fontSizeFactor: 1.5),
                        ),
                        SizedBox(
                          width: width / 3 * 0.9,
                          height: height / 3 * 0.1,
                          child: Card(
                            elevation: 15.0, //设置阴影
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(14.0))), //设置圆角
                            child: ListTile(
                              title: const Text("買家"),
                              subtitle: Text(
                                  (sell_commodity["Buyer_first_name"] +
                                          " " +
                                          sell_commodity["Buyer_last_name"])
                                      .toString()),
                              leading: Icon(
                                Icons.person,
                                color: Color.fromARGB(255, 97, 254, 207),
                                size: 40,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: width / 3 * 0.9,
                          height: height / 3 * 0.1,
                          child: Card(
                            elevation: 15.0, //设置阴影
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(14.0))), //设置圆角
                            child: ListTile(
                              title: const Text("買家電話"),
                              subtitle: Text(
                                  (sell_commodity["Buyer_phone"].toString())
                                      .toString()),
                              leading: const Icon(
                                Icons.phone_enabled_rounded,
                                color: Color.fromARGB(255, 97, 254, 207),
                                size: 40,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: width / 3 * 0.9,
                          height: height / 3 * 0.1,
                          child: Card(
                            elevation: 15.0, //设置阴影
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(14.0))), //设置圆角
                            child: ListTile(
                              title: const Text("取貨日期"),
                              subtitle: AutoSizeText(
                                sell_commodity["sell_date"].toString(),
                                maxLines: 1,
                              ),
                              leading: Icon(
                                Icons.date_range_rounded,
                                color: Color.fromARGB(255, 97, 254, 207),
                                size: 40,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: width / 3 * 0.9,
                          child: Card(
                            elevation: 15.0, //设置阴影
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(14.0))), //设置圆角
                            child: ListTile(
                              title: const Text("取貨方式"),
                              subtitle: AutoSizeText(
                                (sell_commodity["Buyer_Pickup_method"] != 1
                                        ? sell_commodity["Buyer_address"]
                                        : "自行取貨")
                                    .toString(),
                                maxLines: 2,
                              ),
                              leading: const Icon(
                                Icons.map_rounded,
                                color: Color.fromARGB(255, 97, 254, 207),
                                size: 40,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Text("是否接受這個訂單？"),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RaisedButton(
                          color: const Color.fromARGB(59, 97, 254, 207),
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(14.0))), //设置圆角
                          onPressed: () {
                            Navigator.pop(context1);
                          },
                          child: const Text("取消"),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        RaisedButton(
                          color: const Color.fromARGB(128, 254, 97, 97),
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(14.0))), //设置圆角
                          onPressed: () {
                            users
                                .doc(sell_commodity["buyer_ID"])
                                .collection("match")
                                .doc(sell_commodity.id)
                                .update({
                              "seller_agree": "agree",
                              "commodity_state": "preparing"
                            });
                            users
                                .doc(user!.uid)
                                .collection("sell")
                                .doc(sell_commodity.id)
                                .update({
                              "seller_agree": "agree",
                              "commodity_state": "preparing"
                            });

                            Navigator.pop(context1);
                          },
                          child: const Text("確定"),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ));
      },
    );
  }

  Future<void> _showFinishDialog(
      BuildContext context, QueryDocumentSnapshot<Object?> sell_commodity) {
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
          title: const Text("完成",
              style: TextStyle(fontSize: 30), textAlign: TextAlign.center),
          content: SizedBox(
            height: height / 3 * 0.2,
            width: width / 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("訂單完成？"),
                const Text("將移動到結束訂單頁面"),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RaisedButton(
                      color: Color.fromARGB(128, 254, 97, 97),
                      shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(14.0))), //设置圆角
                      onPressed: () {
                        users
                            .doc(user!.uid)
                            .collection("sell_finish")
                            .doc(sell_commodity.id)
                            .set({
                          "Purchase_quantity":
                              sell_commodity["Purchase_quantity"], //購買數量
                          "commodity_ID": sell_commodity["commodity_ID"], //商品ID
                          "commodity_name":
                              sell_commodity["commodity_name"], //商品name
                          "commodity_price":
                              sell_commodity["commodity_price"], //商品價格
                          "commodity_img":
                              sell_commodity["commodity_img"], //商品圖片
                          "Buyer_first_name":
                              sell_commodity["Buyer_first_name"], //買家姓氏
                          "Buyer_last_name":
                              sell_commodity["Buyer_last_name"], //買家名字
                          "Buyer_phone": sell_commodity["Buyer_phone"], //買家電話
                          "Buyer_address":
                              sell_commodity["Buyer_address"], //買家地址
                          "Buyer_Pickup_method":
                              sell_commodity["Buyer_Pickup_method"], //買家取貨方式
                          "Buyer_message":
                              sell_commodity["Buyer_message"], //買家留言
                          "seller_agree":
                              sell_commodity["seller_agree"], //賣家是否同意出貨
                          "sell_date": sell_commodity["sell_date"], //出貨日期
                          "seller_ID": sell_commodity["seller_ID"], //賣家ID
                          "buyer_ID": sell_commodity["buyer_ID"],
                          "commodity_state": "end",
                          "Finish_date": DateTime.now().toString(),
                        });
                        users
                            .doc(user.uid)
                            .collection("sell")
                            .doc(sell_commodity.id)
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

  Future<Null> _onRefresh() async {
    await Future.delayed(Duration(seconds: 1), () {
      print('refresh');
      setState(() {});
    });
  }
}
