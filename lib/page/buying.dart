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
                                  elevation: 15.0, //????????????
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(14.0))), //????????????
                                  child: ListTile(
                                    title: const Text("??????"),
                                    subtitle: Text(widget
                                        .cart_commodity["type2"]
                                        .toString()),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: width / 3 * 0.4,
                                child: Card(
                                  elevation: 15.0, //????????????
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(14.0))), //????????????
                                  child: ListTile(
                                    title: const Text("??????????????????"),
                                    subtitle: Text(widget.cart_commodity["time"]
                                        .toString()),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: width / 3 * 0.4,
                                child: Card(
                                  elevation: 15.0, //????????????
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(14.0))), //????????????
                                  child: ListTile(
                                    title: const Text("??????(??????)"),
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
                      const Text("???????????????"),
                      Row(
                        children: [
                          Switch(
                              value: Pick_name,
                              onChanged: (value) => setState(() {
                                    Pick_name = value;
                                  })),
                          const Text("??????????????????"),
                        ],
                      ),
                      !Pick_name
                          ? Column(
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      // height: 100.0, //????????????
                                      width: width / 3 * 0.4,
                                      child: Card(
                                        elevation: 15.0, //????????????
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(14.0))), //????????????
                                        child: ListTile(
                                          title: const Text("??????"),
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
                                      // height: 100.0, //????????????
                                      width: width / 3 * 0.6,
                                      child: Card(
                                        elevation: 15.0, //????????????
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(14.0))), //????????????
                                        child: ListTile(
                                          title: const Text("??????"),
                                          subtitle: TextFormField(
                                            controller: user_lastname,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  // height: 100.0, //????????????
                                  width: width / 3,
                                  child: Card(
                                    elevation: 15.0, //????????????
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(14.0))), //????????????
                                    child: ListTile(
                                      title: const Text("??????"),
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
                      Text("??????"),
                      Row(
                        children: [
                          Switch(
                              value: Pick_up,
                              onChanged: (value) => setState(() {
                                    Pick_up = value;
                                  })),
                          const Text("????????????"),
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
                                    const Text("??????????????????"),
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
                                              elevation: 15.0, //????????????
                                              shape:
                                                  const RoundedRectangleBorder(
                                                      borderRadius: BorderRadius
                                                          .all(Radius.circular(
                                                              14.0))), //????????????
                                              child: ListTile(
                                                title: const Text("??????"),
                                                subtitle: DropdownButton(
                                                  items: city_list,
                                                  hint: const Text(
                                                      "????????????"), // ???????????????????????????
                                                  onChanged: (as) {
                                                    //??????????????????
                                                    setState(() {
                                                      user_address_city =
                                                          as.toString();
                                                    });
                                                  },
                                                  value: user_address_city == ""
                                                      ? "?????????"
                                                      : user_address_city, // ????????????????????????????????????value????????????
                                                  elevation: 10, //????????????
                                                  style: const TextStyle(
                                                      //????????????????????????????????????
                                                      color: Color.fromARGB(
                                                          255, 181, 181, 181),
                                                      fontSize: 15),
                                                  iconSize: 15, //???????????????icon?????????
                                                  underline: Container(
                                                    height: 1,
                                                    color: const Color.fromARGB(
                                                        255, 181, 181, 181),
                                                  ), // ?????????
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
                                              elevation: 15.0, //????????????
                                              shape:
                                                  const RoundedRectangleBorder(
                                                      borderRadius: BorderRadius
                                                          .all(Radius.circular(
                                                              14.0))), //????????????
                                              child: ListTile(
                                                title: const Text("????????????"),
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
                        // height: 100.0, //????????????
                        width: width / 3,
                        child: Card(
                          elevation: 15.0, //????????????
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(14.0))), //????????????
                          child: ListTile(
                            title: const Text("???????????????"),
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
                          elevation: 15.0, //????????????
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(14.0))), //????????????
                          child: ListTile(
                            title: const Text("?????????"),
                            subtitle: DropdownButton(
                              items: const [
                                DropdownMenuItem(
                                    child: Text('???????????????'), value: "???????????????"),
                              ],
                              hint: const Text("???????????????"), // ???????????????????????????
                              elevation: 10, //????????????
                              style: const TextStyle(
                                  //????????????????????????????????????
                                  color: Color.fromARGB(255, 181, 181, 181),
                                  fontSize: 15),
                              iconSize: 30, //???????????????icon?????????
                              underline: Container(
                                height: 1,
                                color: const Color.fromARGB(255, 181, 181, 181),
                              ),
                              onChanged: (String? value) {}, // ?????????
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
                                    Radius.circular(14.0))), //????????????
                            child: const Text('????????????'),
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
                                  return const Text("?????????????????????");
                                }
                                if (userssnapshot.hasData &&
                                    !userssnapshot.data!.exists) {
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Text("???????????????????????? ??????????????????"),
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
                                            Radius.circular(14.0))), //????????????
                                    child: const Text('????????????'),
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

//?????????????????????
  List<DropdownMenuItem<String>> city_list = const [
    DropdownMenuItem(child: Text('?????????'), value: "?????????"),
    DropdownMenuItem(child: Text('?????????'), value: "?????????"),
    DropdownMenuItem(child: Text('?????????'), value: "?????????"),
    DropdownMenuItem(child: Text('?????????'), value: "?????????"),
    DropdownMenuItem(child: Text('?????????'), value: "?????????"),
    DropdownMenuItem(child: Text('?????????'), value: "?????????"),
    DropdownMenuItem(child: Text('?????????'), value: "?????????"),
    DropdownMenuItem(child: Text('?????????'), value: "?????????"),
    DropdownMenuItem(child: Text('?????????'), value: "?????????"),
    DropdownMenuItem(child: Text('?????????'), value: "?????????"),
    DropdownMenuItem(child: Text('?????????'), value: "?????????"),
    DropdownMenuItem(child: Text('?????????'), value: "?????????"),
    DropdownMenuItem(child: Text('?????????'), value: "?????????"),
    DropdownMenuItem(child: Text('?????????'), value: "?????????"),
    DropdownMenuItem(child: Text('?????????'), value: "?????????"),
    DropdownMenuItem(child: Text('?????????'), value: "?????????"),
    DropdownMenuItem(child: Text('?????????'), value: "?????????"),
    DropdownMenuItem(child: Text('?????????'), value: "?????????"),
    DropdownMenuItem(child: Text('?????????'), value: "?????????"),
    DropdownMenuItem(child: Text('?????????'), value: "?????????"),
  ];

//??????????????????
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
          "Purchase_quantity": Purchase_quantity, //????????????
          "commodity_ID": commodity_ID, //??????ID
          "commodity_name": commodity_name, //??????name
          "commodity_price": commodity_price, //????????????
          "commodity_img": commodity_img, //????????????
          "Buyer_first_name": Buyer_first_name, //????????????
          "Buyer_last_name": Buyer_last_name, //????????????
          "Buyer_phone": Buyer_phone, //????????????
          "Buyer_address": Buyer_address, //????????????
          "Buyer_Pickup_method": Buyer_Pickup_method, //??????????????????
          "Buyer_message": Buyer_message, //????????????
          "seller_agree": seller_agree, //????????????????????????
          "sell_date": sell_date, //????????????
          "seller_ID": seller_ID, //??????ID
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

  //???????????????
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
          "Purchase_quantity": Purchase_quantity, //????????????
          "commodity_ID": commodity_ID, //??????ID
          "commodity_name": commodity_name, //??????name
          "commodity_price": commodity_price, //????????????
          "commodity_img": commodity_img, //????????????
          "Buyer_first_name": Buyer_first_name, //????????????
          "Buyer_last_name": Buyer_last_name, //????????????
          "Buyer_phone": Buyer_phone, //????????????
          "Buyer_address": Buyer_address, //????????????
          "Buyer_Pickup_method": Buyer_Pickup_method, //??????????????????
          "Buyer_message": Buyer_message, //????????????
          "seller_agree": seller_agree, //????????????????????????
          "sell_date": sell_date, //????????????
          "seller_ID": seller_ID, //??????ID
          "buyer_ID": user!.uid,
          "commodity_state": "no"
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  } //??????????????????

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
