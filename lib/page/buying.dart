import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:testfirebase/page/users-editpage.dart';

class buying extends StatefulWidget {
  final String commodity_ID;
  final String cart_ID;
  final QueryDocumentSnapshot<Object?> cart_commodity;
  const buying(
      {Key? key,
      required this.commodity_ID,
      required this.cart_ID,
      required this.cart_commodity})
      : super(key: key);
  @override
  State<buying> createState() => _buyingState();
}

class _buyingState extends State<buying> {
  final user_firstname = TextEditingController();
  final user_lastname = TextEditingController();
  CollectionReference users = FirebaseFirestore.instance.collection('userdata');
  bool Pick_name = false;
  bool Pick_adress = false;
  bool Pick_up = false;
  User? user = FirebaseAuth.instance.currentUser;
  var user_address_city = "";
  final user_address_detail = TextEditingController();
  final user_talk = TextEditingController();
  final user_phone_number = TextEditingController(); //0123456789

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
                "購買資訊",
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
                      AutoSizeText(
                        widget.cart_commodity['name'].toString(),
                        minFontSize: 50,
                        maxLines: 2,
                        maxFontSize: 51,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: width / 3 * 0.6,
                            height: 240,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(50.0),
                                child: Image(
                                  image: FirebaseImage(
                                      widget.cart_commodity['img'],
                                      shouldCache: true,
                                      cacheRefreshStrategy:
                                          CacheRefreshStrategy.BY_METADATA_DATE,
                                      maxSizeBytes: 1920 * 1080),
                                )),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: width / 3 * 0.4,
                                child: Card(
                                  elevation: 15.0, //设置阴影
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(14.0))), //设置圆角
                                  child: ListTile(
                                    title: const Text("規格"),
                                    subtitle: Text(widget
                                        .cart_commodity["type2"]
                                        .toString()),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: width / 3 * 0.4,
                                child: Card(
                                  elevation: 15.0, //设置阴影
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(14.0))), //设置圆角
                                  child: ListTile(
                                    title: const Text("預計出貨時間"),
                                    subtitle: Text(widget.cart_commodity["time"]
                                        .toString()),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: width / 3 * 0.4,
                                child: Card(
                                  elevation: 15.0, //设置阴影
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(14.0))), //设置圆角
                                  child: ListTile(
                                    title: const Text("價格(每件)"),
                                    subtitle: Text(widget
                                        .cart_commodity["price"]
                                        .toString()),
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
                      const Text("收件者訊息"),
                      Row(
                        children: [
                          Switch(
                              value: Pick_name,
                              onChanged: (value) => setState(() {
                                    Pick_name = value;
                                  })),
                          const Text("同使用者帳號"),
                        ],
                      ),
                      !Pick_name
                          ? Column(
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      // height: 100.0, //设置高度
                                      width: width / 3 * 0.4,
                                      child: Card(
                                        elevation: 15.0, //设置阴影
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(14.0))), //设置圆角
                                        child: ListTile(
                                          title: const Text("姓氏"),
                                          subtitle: TextFormField(
                                            controller: user_firstname,
                                          ),
                                          leading: const Icon(
                                            Icons.person_pin_rounded,
                                            color: Color.fromARGB(
                                                255, 97, 254, 207),
                                            size: 40,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      // height: 100.0, //设置高度
                                      width: width / 3 * 0.6,
                                      child: Card(
                                        elevation: 15.0, //设置阴影
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(14.0))), //设置圆角
                                        child: ListTile(
                                          title: const Text("名字"),
                                          subtitle: TextFormField(
                                            controller: user_lastname,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
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
                                        keyboardType: const TextInputType
                                            .numberWithOptions(decimal: true),
                                      ),
                                      leading: const Icon(
                                        Icons.phone_iphone_rounded,
                                        color:
                                            Color.fromARGB(255, 97, 254, 207),
                                        size: 40,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : SizedBox(),
                      const Divider(
                        thickness: 1,
                      ),
                      Text("地址"),
                      Row(
                        children: [
                          Switch(
                              value: Pick_up,
                              onChanged: (value) => setState(() {
                                    Pick_up = value;
                                  })),
                          const Text("自行取貨"),
                        ],
                      ),
                      !Pick_up
                          ? Column(
                              children: [
                                Row(
                                  children: [
                                    Switch(
                                        value: Pick_adress,
                                        onChanged: (value) => setState(() {
                                              Pick_adress = value;
                                            })),
                                    const Text("同使用者帳號"),
                                  ],
                                ),
                                !Pick_adress
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: width / 3 * 0.5,
                                            child: Card(
                                              elevation: 15.0, //设置阴影
                                              shape:
                                                  const RoundedRectangleBorder(
                                                      borderRadius: BorderRadius
                                                          .all(Radius.circular(
                                                              14.0))), //设置圆角
                                              child: ListTile(
                                                title: const Text("縣市"),
                                                subtitle: DropdownButton(
                                                  items: city_list,
                                                  hint: const Text(
                                                      "提示資訊"), // 當沒有初始值時顯示
                                                  onChanged: (as) {
                                                    //選中後的回撥
                                                    setState(() {
                                                      user_address_city =
                                                          as.toString();
                                                    });
                                                  },
                                                  value: user_address_city == ""
                                                      ? "臺北市"
                                                      : user_address_city, // 設定初始值，要與列表中的value是相同的
                                                  elevation: 10, //設定陰影
                                                  style: const TextStyle(
                                                      //設定文字框裡面文字的樣式
                                                      color: Color.fromARGB(
                                                          255, 181, 181, 181),
                                                      fontSize: 15),
                                                  iconSize: 15, //設定三角標icon的大小
                                                  underline: Container(
                                                    height: 1,
                                                    color: const Color.fromARGB(
                                                        255, 181, 181, 181),
                                                  ), // 下劃線
                                                ),
                                                leading: const Icon(
                                                  Icons.location_city_rounded,
                                                  color: Color.fromARGB(
                                                      255, 97, 254, 207),
                                                  size: 40,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: width / 3 * 0.5,
                                            child: Card(
                                              elevation: 15.0, //设置阴影
                                              shape:
                                                  const RoundedRectangleBorder(
                                                      borderRadius: BorderRadius
                                                          .all(Radius.circular(
                                                              14.0))), //设置圆角
                                              child: ListTile(
                                                title: const Text("詳細地址"),
                                                subtitle: TextFormField(
                                                  controller:
                                                      user_address_detail,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : SizedBox(),
                              ],
                            )
                          : SizedBox(),
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
                            title: const Text("給賣家的話"),
                            subtitle: TextFormField(
                              controller: user_talk,
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
                      SizedBox(
                        width: width / 3,
                        child: Card(
                          elevation: 15.0, //设置阴影
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(14.0))), //设置圆角
                          child: ListTile(
                            title: const Text("優惠卷"),
                            subtitle: DropdownButton(
                              items: const [
                                DropdownMenuItem(
                                    child: Text('沒有優惠卷'), value: "沒有優惠卷"),
                              ],
                              hint: const Text("沒有優惠卷"), // 當沒有初始值時顯示
                              elevation: 10, //設定陰影
                              style: const TextStyle(
                                  //設定文字框裡面文字的樣式
                                  color: Color.fromARGB(255, 181, 181, 181),
                                  fontSize: 15),
                              iconSize: 30, //設定三角標icon的大小
                              underline: Container(
                                height: 1,
                                color: const Color.fromARGB(255, 181, 181, 181),
                              ),
                              onChanged: (String? value) {}, // 下劃線
                            ),
                            leading: const Icon(
                              Icons.flip_to_back,
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RaisedButton(
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(14.0))), //设置圆角
                            child: const Text('取消媒合'),
                            color: const Color.fromARGB(128, 97, 254, 207),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          const Padding(padding: EdgeInsets.all(10.0)),
                          FutureBuilder<DocumentSnapshot>(
                              future: users.doc(user!.uid).get(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<DocumentSnapshot>
                                      userssnapshot) {
                                if (userssnapshot.hasError) {
                                  return const Text("出現了一些錯誤");
                                }
                                if (userssnapshot.hasData &&
                                    !userssnapshot.data!.exists) {
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Text("沒有找到你的資料 請聯繫管理員"),
                                    ],
                                  );
                                }
                                if (userssnapshot.connectionState ==
                                    ConnectionState.done) {
                                  Map<String, dynamic> usersdata =
                                      userssnapshot.data!.data()
                                          as Map<String, dynamic>;
                                  return RaisedButton(
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(14.0))), //设置圆角
                                    child: const Text('開始媒合'),
                                    color:
                                        const Color.fromARGB(128, 97, 254, 207),
                                    onPressed: () {
                                      addmatch(
                                          widget.cart_commodity[
                                              "Purchase_quantity"],
                                          widget.cart_commodity["commodity_ID"],
                                          widget.cart_commodity["name"],
                                          widget.cart_commodity["price"],
                                          widget.cart_commodity["img"],
                                          Pick_name
                                              ? usersdata["user_firstname"]
                                              : user_firstname.text,
                                          Pick_name
                                              ? usersdata["user_lastname"]
                                              : user_lastname.text,
                                          Pick_name
                                              ? usersdata["user_phone_number"]
                                              : user_phone_number.text,
                                          Pick_adress
                                              ? usersdata["user_address_city"] +
                                                  usersdata[
                                                      "user_address_detail"]
                                              : user_address_city +
                                                  user_address_detail.text,
                                          Pick_up ? 1 : 0,
                                          "checking",
                                          widget.cart_commodity["time"],
                                          user_talk.text,
                                          widget.cart_commodity["seller_ID"]);
                                      deletecart(widget.cart_ID);

                                      Navigator.of(context).pop();
                                    },
                                  );
                                }
                                return SizedBox();
                              }),
                        ],
                      ),
                      const Padding(padding: EdgeInsets.all(10.0)),
                    ],
                  ),
                ),
              ],
            )));
  }

//選擇城市選擇器
  List<DropdownMenuItem<String>> city_list = const [
    DropdownMenuItem(child: Text('臺北市'), value: "臺北市"),
    DropdownMenuItem(child: Text('新北市'), value: "新北市"),
    DropdownMenuItem(child: Text('桃園市'), value: "桃園市"),
    DropdownMenuItem(child: Text('臺中市'), value: "臺中市"),
    DropdownMenuItem(child: Text('臺南市'), value: "臺南市"),
    DropdownMenuItem(child: Text('高雄市'), value: "高雄市"),
    DropdownMenuItem(child: Text('基隆市'), value: "基隆市"),
    DropdownMenuItem(child: Text('新竹市'), value: "新竹市"),
    DropdownMenuItem(child: Text('嘉義市'), value: "嘉義市"),
    DropdownMenuItem(child: Text('新竹縣'), value: "新竹縣"),
    DropdownMenuItem(child: Text('宜蘭縣'), value: "宜蘭縣"),
    DropdownMenuItem(child: Text('苗栗縣'), value: "苗栗縣"),
    DropdownMenuItem(child: Text('彰化縣'), value: "彰化縣"),
    DropdownMenuItem(child: Text('南投縣'), value: "南投縣"),
    DropdownMenuItem(child: Text('雲林縣'), value: "雲林縣"),
    DropdownMenuItem(child: Text('嘉義縣'), value: "嘉義縣"),
    DropdownMenuItem(child: Text('屏東縣'), value: "屏東縣"),
    DropdownMenuItem(child: Text('花蓮縣'), value: "花蓮縣"),
    DropdownMenuItem(child: Text('臺東縣'), value: "臺東縣"),
    DropdownMenuItem(child: Text('澎湖縣'), value: "澎湖縣"),
  ];

//新增到購物車
  Future<void> addmatch(
    int Purchase_quantity,
    String commodity_ID,
    String commodity_name,
    int commodity_price,
    String commodity_img,
    String Buyer_first_name,
    String Buyer_last_name,
    String Buyer_phone,
    String Buyer_address,
    int Buyer_Pickup_method,
    String seller_agree,
    String sell_date,
    String Buyer_message,
    String seller_ID,
  ) {
    CollectionReference users =
        FirebaseFirestore.instance.collection('userdata');
    return users
        .doc(user!.uid)
        .collection("match")
        .add({
          "Purchase_quantity": Purchase_quantity, //購買數量
          "commodity_ID": commodity_ID, //商品ID
          "commodity_name": commodity_name, //商品name
          "commodity_price": commodity_price, //商品價格
          "commodity_img": commodity_img, //商品圖片
          "Buyer_first_name": Buyer_first_name, //買家姓氏
          "Buyer_last_name": Buyer_last_name, //買家名字
          "Buyer_phone": Buyer_phone, //買家電話
          "Buyer_address": Buyer_address, //買家地址
          "Buyer_Pickup_method": Buyer_Pickup_method, //買家取貨方式
          "Buyer_message": Buyer_message, //買家留言
          "seller_agree": seller_agree, //賣家是否同意出貨
          "sell_date": sell_date, //出貨日期
          "seller_ID": seller_ID, //賣家ID
          "buyer_ID": user!.uid,
          "commodity_state": "no"
        })
        .then((value) => addsell(
            value.id,
            Purchase_quantity,
            commodity_ID,
            commodity_name,
            commodity_price,
            commodity_img,
            Buyer_first_name,
            Buyer_last_name,
            Buyer_phone,
            Buyer_address,
            Buyer_Pickup_method,
            seller_agree,
            sell_date,
            Buyer_message,
            seller_ID))
        .catchError((error) => print("Failed to add user: $error"));
  }

  //新增到賣家
  Future<void> addsell(
    String match_ID,
    int Purchase_quantity,
    String commodity_ID,
    String commodity_name,
    int commodity_price,
    String commodity_img,
    String Buyer_first_name,
    String Buyer_last_name,
    String Buyer_phone,
    String Buyer_address,
    int Buyer_Pickup_method,
    String seller_agree,
    String sell_date,
    String Buyer_message,
    String seller_ID,
  ) {
    CollectionReference users =
        FirebaseFirestore.instance.collection('userdata');
    return users
        .doc(seller_ID)
        .collection("sell")
        .doc(match_ID)
        .set({
          "Purchase_quantity": Purchase_quantity, //購買數量
          "commodity_ID": commodity_ID, //商品ID
          "commodity_name": commodity_name, //商品name
          "commodity_price": commodity_price, //商品價格
          "commodity_img": commodity_img, //商品圖片
          "Buyer_first_name": Buyer_first_name, //買家姓氏
          "Buyer_last_name": Buyer_last_name, //買家名字
          "Buyer_phone": Buyer_phone, //買家電話
          "Buyer_address": Buyer_address, //買家地址
          "Buyer_Pickup_method": Buyer_Pickup_method, //買家取貨方式
          "Buyer_message": Buyer_message, //買家留言
          "seller_agree": seller_agree, //賣家是否同意出貨
          "sell_date": sell_date, //出貨日期
          "seller_ID": seller_ID, //賣家ID
          "buyer_ID": user!.uid,
          "commodity_state": "no"
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  } //新增到購物車

  Future<void> deletecart(String cart_ID) {
    CollectionReference users =
        FirebaseFirestore.instance.collection('userdata');
    return users
        .doc(user!.uid)
        .collection("cart")
        .doc(cart_ID)
        .delete()
        .then((value) => print("delete"))
        .catchError((error) => print("Failed to add user: $error"));
  }
}
