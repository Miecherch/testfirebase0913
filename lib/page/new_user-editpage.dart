// ignore_for_file: non_constant_identifier_names, prefer_typing_uninitialized_variables, camel_case_types, deprecated_member_use, avoid_print, file_names

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class new_usereditpage extends StatefulWidget {
  final Map<String, dynamic> user;

  const new_usereditpage({Key? key, required this.user}) : super(key: key);

  @override
  State<new_usereditpage> createState() => _new_usereditpageState();
}

User? user = FirebaseAuth.instance.currentUser;
int is_change = 0;

class _new_usereditpageState extends State<new_usereditpage> {
  var user_sex = "3";
  bool birthbutton_change = true;
  var user_birth; //2000 00 00
  final user_firstname = TextEditingController();
  final user_lastname = TextEditingController();
  var user_address_city = "";
  final user_address_detail = TextEditingController();
  final user_phone_number = TextEditingController(); //0123456789

  CollectionReference users = FirebaseFirestore.instance.collection('userdata');
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(750, 1334));
    final width = (750.w) * 3;
    // final height = (1334.h) * 3;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 57, 151, 123),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.all(0),
              child: IconButton(
                icon: const Icon(Icons.app_registration_rounded),
                onPressed: () {},
              ),
            )
          ],
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
                "???    ???",
                style: TextStyle(fontSize: 30),
              ),
            ],
          ),
        ),
        body: CupertinoScrollbar(
            thickness: 6.0,
            thicknessWhileDragging: 10.0,
            radius: const Radius.circular(34.0),
            radiusWhileDragging: Radius.zero,
            child: ListView(children: [
              const Padding(padding: EdgeInsets.all(10.0)),
              Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                    const AutoSizeText(
                      "??????????????????????????????",
                      style:
                          TextStyle(color: Color.fromARGB(255, 187, 187, 187)),

                      maxLines: 2,
                      // maxFontSize: 15,
                    ),
                    const Padding(padding: EdgeInsets.all(5.0)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        widget.user["user_sex"] != ""
                            ? IconButton(
                                iconSize: 120,
                                onPressed: () {},
                                icon: ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: Image(
                                      image: FirebaseImage(
                                          'gs://login-b6ad4.appspot.com/head_stickers/' +
                                              user!.uid +
                                              '.jpg',
                                          shouldCache: true,
                                          cacheRefreshStrategy:
                                              CacheRefreshStrategy
                                                  .BY_METADATA_DATE),
                                    )))
                            : SizedBox(
                                width: double.infinity,
                                child: IconButton(
                                  icon: Icon(
                                    Icons.person_rounded,
                                    color: user_sex == "3"
                                        ? widget.user["user_sex"] == "0"
                                            ? Colors.red
                                            : Colors.blue
                                        : user_sex == "0"
                                            ? Colors.red
                                            : Colors.blue,
                                  ),
                                  iconSize: 100,
                                  onPressed: () {},
                                ),
                              ),
                        SizedBox(
                          width: width / 3 * 0.5,
                          child: Column(
                            children: [
                              Card(
                                  child: FlatButton(
                                onPressed: () async {
                                  user_birth = (await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime.now(),
                                  ));
                                  setState(() {});
                                },
                                child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(children: const [
                                          Icon(
                                            Icons.cake,
                                            color: Color.fromARGB(
                                                128, 97, 254, 207),
                                            size: 32,
                                          ),
                                          AutoSizeText(
                                            "??????",
                                            minFontSize: 20,
                                          ),
                                        ]),
                                        AutoSizeText(
                                          user_birth == null
                                              ? widget.user["user_birth"]
                                                  .toString()
                                                  .substring(5, 10)
                                              : user_birth
                                                  .toString()
                                                  .substring(5, 10),
                                          style: const TextStyle(
                                              color: Color.fromARGB(
                                                  255, 181, 181, 181)),
                                          maxFontSize: 50,
                                          maxLines: 2,
                                        ),
                                      ],
                                    )),
                              )),
                              // ignore: todo
                              //TODO:????????????
                              Card(
                                  child: FlatButton(
                                onPressed: () {
                                  chose_city_Picker();
                                  setState(() {});
                                },
                                child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(children: [
                                          Icon(
                                            Icons.person_rounded,
                                            color: user_sex == "3"
                                                ? (widget.user["user_sex"] ==
                                                        "0"
                                                    ? Colors.red
                                                    : Colors.blue)
                                                : (user_sex == "0"
                                                    ? Colors.red
                                                    : Colors.blue),
                                            size: 32,
                                          ),
                                          const AutoSizeText(
                                            "??????",
                                            minFontSize: 20,
                                          ),
                                        ]),
                                        AutoSizeText(
                                          user_sex == "3"
                                              ? widget.user["user_sex"] == "0"
                                                  ? "??? "
                                                  : "??? "
                                              : user_sex == "0"
                                                  ? "??? "
                                                  : "??? ",
                                          minFontSize: 20,
                                          style: const TextStyle(
                                              color: Color.fromARGB(
                                                  255, 181, 181, 181)),
                                        ),
                                      ],
                                    )),
                              )),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: Row(children: [
                              Padding(
                                padding: EdgeInsets.all(width / 3 * 0.02),
                              ),
                              const AutoSizeText(
                                "?????? ",
                                minFontSize: 20,
                              ),
                              SizedBox(
                                width: width / 3 * 0.2,
                                child: TextFormField(
                                  controller: user_firstname,
                                  decoration: InputDecoration(
                                    hintText: widget.user['user_firstname'],
                                  ),
                                ),
                              )
                            ]),
                          ),
                        ),
                        Card(
                          child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: SizedBox(
                                width: width / 3 * 0.51,
                                child: TextFormField(
                                  controller: user_lastname,
                                  decoration: InputDecoration(
                                    hintText: widget.user['user_lastname'],
                                  ),
                                ),
                              )),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Card(
                            child: FlatButton(
                          onPressed: () {},
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: Row(children: [
                              const AutoSizeText(
                                "?????? ",
                                minFontSize: 20,
                              ),
                              DropdownButton(
                                items: city_list,
                                hint: null, // ???????????????????????????
                                onChanged: (as) {
                                  // ??????????????????
                                  setState(() {
                                    user_address_city = as.toString();
                                  });
                                },
                                value: user_address_city == ""
                                    ? widget.user["user_address_city"]
                                    : user_address_city, // ????????????????????????????????????value????????????
                                style: const TextStyle(
                                    color: Color.fromARGB(255, 181, 181, 181)),
                                underline: Container(
                                  height: 0,
                                ), // ?????????
                              ),
                            ]),
                          ),
                        )),
                        Card(
                          child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: SizedBox(
                                width: width / 3 * 0.5,
                                child: TextFormField(
                                  controller: user_address_detail,
                                  decoration: InputDecoration(
                                    hintText:
                                        widget.user['user_address_detail'],
                                  ),
                                ),
                              )),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: Row(children: [
                              Padding(
                                padding: EdgeInsets.all(width / 3 * 0.02),
                              ),
                              const AutoSizeText(
                                "?????? ",
                                minFontSize: 20,
                              ),
                              SizedBox(
                                width: width / 3 * 0.76,
                                child: TextFormField(
                                  controller: user_phone_number,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          decimal: true),
                                  decoration: InputDecoration(
                                    hintText: widget.user['user_phone_number'],
                                  ),
                                ),
                              )
                            ]),
                          ),
                        ),
                      ],
                    ),
                    //??????
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        RaisedButton(
                          color: const Color.fromARGB(255, 66, 66, 66),
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(14.0))), //????????????
                          child: const Text('????????????'),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        RaisedButton(
                            color: const Color.fromARGB(128, 97, 254, 207),
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(14.0))), //????????????
                            child: const Text('????????????'),
                            onPressed: () {
                              // (passwordController.text != ""
                              //     ? (passwordController.text ==
                              //             DoublecheckpasswordController.text
                              //         ? _showButtonPressDialog(
                              //             context, " ??????????????????????????????", 50)
                              //         : _showButtonPressDialog(
                              //             context, "??????????????? ??????????????????", 50))
                              //     : null);
                              print(user_sex);
                              print("aa " + widget.user["user_sex"]);
                              users
                                  .doc(user!.uid)
                                  .update({
                                    'user_sex':
                                        // ignore: prefer_if_null_operators, unnecessary_null_comparison
                                        user_sex != "3"
                                            ? user_sex.toString()
                                            : widget.user["user_sex"],
                                    'user_address_city':
                                        // ignore: prefer_if_null_operators, unnecessary_null_comparison
                                        user_address_city != ""
                                            ? user_address_city
                                            : widget.user["user_address_city"],
                                    'user_address_detail':
                                        // ignore: prefer_if_null_operators, unnecessary_null_comparison
                                        user_address_detail.text != ""
                                            ? user_address_detail.text
                                            : widget
                                                .user["user_address_detail"],
                                    // ignore: prefer_if_null_operators, unnecessary_null_comparison
                                    'user_birth': user_birth != null
                                        ? user_birth.toString().substring(0, 10)
                                        : widget.user["user_birth"],
                                    'user_phone_number':
                                        user_phone_number.text != ""
                                            ? user_phone_number.text
                                            : widget.user["user_phone_number"],
                                  })
                                  .then((value) => setState(() {
                                        Navigator.pop(context);
                                      }))
                                  .catchError((error) =>
                                      print("Failed to add user: $error"));
                            })
                      ],
                    ),
                  ]))
            ])));
  }

  void chose_city_Picker() async {
    final width = (750.w) * 3;
    final height = (1334.h) * 3;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
                title: const Center(child: Text('????????????')),
                content: SizedBox(
                  height: height / 3 * 0.25,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: width / 3 * 0.25,
                            height: height / 3 * 0.13,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                ),
                                side: BorderSide(
                                    width: 2,
                                    color: user_sex == "1"
                                        ? const Color.fromARGB(
                                            128, 97, 254, 207)
                                        : const Color.fromARGB(
                                            255, 96, 96, 96)),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(
                                    Icons.female,
                                    color: Colors.blue,
                                    size: 50,
                                  ),
                                  AutoSizeText(
                                    "??????",
                                    maxFontSize: 50,
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 255, 255, 255)),
                                    maxLines: 1,
                                  )
                                ],
                              ),
                              onPressed: () => setState(() => user_sex = "1"),
                            ),
                          ),
                          const Padding(padding: EdgeInsets.all(10)),
                          SizedBox(
                            width: width / 3 * 0.25,
                            height: height / 3 * 0.13,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                ),
                                side: BorderSide(
                                    width: 2,
                                    color: user_sex == "0"
                                        ? const Color.fromARGB(
                                            128, 97, 254, 207)
                                        : const Color.fromARGB(
                                            255, 96, 96, 96)),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(
                                    Icons.female,
                                    color: Colors.red,
                                    size: 50,
                                  ),
                                  AutoSizeText(
                                    "??????",
                                    maxFontSize: 50,
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 255, 255, 255)),
                                    maxLines: 1,
                                  )
                                ],
                              ),
                              onPressed: () => setState(() => user_sex = "0"),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: width / 3 * 0.8,
                        child: RaisedButton(
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(5.0))), //????????????
                            child: const Text('??????'),
                            color: const Color.fromARGB(128, 97, 254, 207),
                            onPressed: () {
                              Navigator.pop(context, true);
                            }),
                      ),
                    ],
                  ),
                ));
          },
        );
      },
    );
  }
}

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
