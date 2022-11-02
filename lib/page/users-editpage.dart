// ignore_for_file: non_constant_identifier_names

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:ui';

CollectionReference userdata =
    FirebaseFirestore.instance.collection('userdata');

class users_editpage extends StatefulWidget {
  const users_editpage({Key? key}) : super(key: key);
  @override
  State<users_editpage> createState() => _users_editpageState();
}

class _users_editpageState extends State<users_editpage> {
  bool Loadingserver_login = false;
  bool citybutton_change = true;
  bool birthbutton_change = true;
  final emailController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  int _genderController = 0;
  var user_sex = ""; //0:女生 1:男生
  var user_address_city = "";
  final user_address_detail = TextEditingController();
  var user_birth; //2000 00 00
  final user_email = TextEditingController(); //w123@123.com
  final user_firstname = TextEditingController();
  final user_identity = TextEditingController(); //等級 1:一般 2:賣家 3:管理員
  final user_lastname = TextEditingController();
  final user_phone_number = TextEditingController(); //0123456789
  final passwordController = TextEditingController();
  final DoublecheckpasswordController = TextEditingController();
  FirebaseStorage storage = FirebaseStorage.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('userdata');
  File? _photo;
  final ImagePicker _picker = ImagePicker();
  bool Loadingserver_rigister = false;
  //TODO:顯示SnackBar
  _showButtonPressDialog(
      BuildContext context, String provider, int millisecond) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(provider),
      backgroundColor: Colors.white38,
      duration: Duration(milliseconds: millisecond * 100),
    ));
  }

  Future<void> _showAlertDialog(BuildContext context) {
    bool is_check = false;

    return showDialog<void>(
      context: context,
      builder: (BuildContext context1) {
        ScreenUtil.init(context, designSize: const Size(750, 1334));
        final width = (750.w) * 3;
        final height = (1334.h) * 3;
        return AlertDialog(
          title: Text('驗證帳號'),
          content: SizedBox(
            height: height / 3 / 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("由於您嘗試修改密碼 因此需要重新驗證您的身份"),
                const SizedBox(
                  height: 15,
                ),
                Text(user!.email.toString()),
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                  width: 300,
                  child: TextFormField(
                    controller: passwordController,
                    validator: validatePassword,
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: '密碼',
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        child: Loadingserver_login
                            ? const SizedBox(
                                width: 25,
                                height: 25,
                                child: CircularProgressIndicator(
                                    color: Colors.white))
                            : const Text('登入'),
                        onPressed: null),
                  ],
                ),
                Text("目前尚未更改密碼 因此請輸入以前的密碼"),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('取消', style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.of(context1).pop();
              },
            ),
            FlatButton(
              child: Text('確定'),
              onPressed: () {
                is_check ? Navigator.of(context1).pop() : null;
              },
            ),
          ],
        );
      },
    );
  }

  bool isedit = false;
  bool firebaseImage_check = false;
  User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(750, 1334));
    final width = (750.w) * 3;
    final height = (1334.h) * 3;

    CollectionReference users =
        FirebaseFirestore.instance.collection('userdata');
    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(user!.uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("出現了一些錯誤");
        }
        if (snapshot.hasData && !snapshot.data!.exists) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text("沒有找到你的資料 請聯繫管理員"),
            ],
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          //TODO:關於我畫面
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                "編輯",
                style: TextStyle(fontSize: 30),
              ),
              centerTitle: true,
            ),
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
                        const Padding(padding: EdgeInsets.all(10.0)),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: data['user_icon'] != ""
                              ? Image(
                                  image: FirebaseImage(
                                      'gs://login-b6ad4.appspot.com/head_stickers/' +
                                          user!.uid +
                                          '.jpg',
                                      shouldCache: true,
                                      cacheRefreshStrategy: CacheRefreshStrategy
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
                          style: const TextStyle(fontSize: 25),
                        ),
                        Text(
                          data['user_id'],
                          style: const TextStyle(
                            color: Color.fromARGB(171, 255, 255, 255),
                          ),
                        ),
                        const Padding(padding: EdgeInsets.all(5.0)),
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
                                    decoration: InputDecoration(
                                      hintText: data['user_firstname'],
                                    ),
                                  ),
                                  leading: Icon(
                                    Icons.person_pin_rounded,
                                    color: Colors.blue[500],
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
                                    decoration: InputDecoration(
                                      hintText: data['user_lastname'],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
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
                                  title: const Text("縣市"),
                                  subtitle: DropdownButton(
                                    items: city_list,
                                    hint: const Text("提示資訊"), // 當沒有初始值時顯示
                                    onChanged: (as) {
                                      //選中後的回撥
                                      setState(() {
                                        user_address_city = as.toString();
                                      });
                                    },
                                    value: user_address_city == ""
                                        ? data["user_address_city"]
                                        : user_address_city, // 設定初始值，要與列表中的value是相同的
                                    elevation: 10, //設定陰影
                                    style: const TextStyle(
                                        //設定文字框裡面文字的樣式
                                        color:
                                            Color.fromARGB(255, 181, 181, 181),
                                        fontSize: 15),
                                    iconSize: 30, //設定三角標icon的大小
                                    underline: Container(
                                      height: 1,
                                      color: const Color.fromARGB(
                                          255, 181, 181, 181),
                                    ), // 下劃線
                                  ),
                                  leading: Icon(
                                    Icons.location_city_rounded,
                                    color: Colors.blue[500],
                                    size: 40,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: width / 3 * 0.6,
                              child: Card(
                                elevation: 15.0, //设置阴影
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(14.0))), //设置圆角
                                child: ListTile(
                                  title: const Text("詳細地址"),
                                  subtitle: TextFormField(
                                    controller: user_address_detail,
                                    decoration: InputDecoration(
                                      hintText: data['user_address_detail'],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(
                              // height: 100.0, //设置高度
                              width: width / 3 * 0.45,
                              child: Card(
                                elevation: 15.0, //设置阴影
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(14.0))), //设置圆角
                                child: ListTile(
                                  title: const Text("生日"),
                                  subtitle: TextButton(
                                    child: Text(
                                      user_birth == null
                                          ? data["user_birth"]
                                              .toString()
                                              .substring(0, 10)
                                          : user_birth
                                              .toString()
                                              .substring(0, 10),
                                      style: const TextStyle(
                                          fontSize: 16,
                                          color: Color.fromARGB(
                                              255, 181, 181, 181)),
                                    ),
                                    onPressed: () async {
                                      user_birth = (await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(1900),
                                        lastDate: DateTime.now(),
                                      ));
                                      setState(() {});
                                    },
                                  ),
                                  leading: Icon(
                                    Icons.cake_rounded,
                                    color: Colors.blue[500],
                                    size: 40,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              // height: 100.0, //设置高度
                              width: width / 3 * 0.55,
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
                          ],
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
                              title: const Text("密碼"),
                              subtitle: TextFormField(
                                obscureText: true,
                                controller: passwordController,
                                decoration: const InputDecoration(
                                  hintText: "輸入密碼",
                                ),
                              ),
                              leading: Icon(
                                Icons.lock_outlined,
                                color: Colors.blue[500],
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
                              title: const Text("確認密碼"),
                              subtitle: TextFormField(
                                obscureText: true,
                                controller: DoublecheckpasswordController,
                                decoration: const InputDecoration(
                                  hintText: "再次輸入密碼",
                                ),
                              ),
                              leading: Icon(
                                Icons.lock_reset_outlined,
                                color: Colors.blue[500],
                                size: 40,
                              ),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RaisedButton(
                              color: Color.fromARGB(255, 66, 66, 66),
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(14.0))), //设置圆角
                              child: const Text('取消編輯'),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            const Padding(padding: EdgeInsets.all(5.0)),
                            const Padding(padding: EdgeInsets.all(5.0)),
                            RaisedButton(
                                color: const Color.fromARGB(128, 97, 254, 207),
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(14.0))), //设置圆角
                                child: const Text('完成編輯'),
                                onPressed: () {
                                  (passwordController.text != ""
                                      ? (passwordController.text ==
                                              DoublecheckpasswordController.text
                                          ? _showButtonPressDialog(
                                              context, " 目前尚無支援修改密碼", 50)
                                          : _showButtonPressDialog(
                                              context, "密碼不一致 沒有更新密碼", 50))
                                      : null);
                                  users
                                      .doc(user!.uid)
                                      .update({
                                        'user_address_city':
                                            // ignore: prefer_if_null_operators, unnecessary_null_comparison
                                            user_address_city != ""
                                                ? user_address_city
                                                : data["user_address_city"],
                                        'user_address_detail':
                                            // ignore: prefer_if_null_operators, unnecessary_null_comparison
                                            user_address_detail.text != ""
                                                ? user_address_detail.text
                                                : data["user_address_detail"],
                                        // ignore: prefer_if_null_operators, unnecessary_null_comparison
                                        'user_birth': user_birth != null
                                            ? user_birth
                                                .toString()
                                                .substring(0, 10)
                                            : data["user_birth"],
                                        'user_phone_number':
                                            user_phone_number.text != ""
                                                ? user_phone_number.text
                                                : data["user_phone_number"],
                                      })
                                      .then((value) => setState(() {
                                            Navigator.pop(context);
                                          }))
                                      .catchError((error) =>
                                          print("Failed to add user: $error"));
                                })
                          ],
                        ),
                      ],
                    ))
                  ],
                )),
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

  //註冊保護
//姓氏
  // ignore: non_constant_identifier_names
  String? validate_firstname(String? formEmail) {
    if (formEmail == null || formEmail.isEmpty) return '請輸入姓氏';
    return null;
  }

//名字
  // ignore: non_constant_identifier_names
  String? validate_lastname(String? formEmail) {
    if (formEmail == null || formEmail.isEmpty) return '請輸入名字';
    return null;
  }

//地址
  // ignore: non_constant_identifier_names
  String? validate_deteiladdress(String? formEmail) {
    if (formEmail == null || formEmail.isEmpty) return '請輸入地址';
    if (user_address_city == "選擇縣市") return '請選擇縣市';
    return null;
  }

//電話號碼
  String? validatephonenum(String? formEmail) {
    if (formEmail == null || formEmail.isEmpty) {
      return '請輸入電話';
    }
    String pattern = r'(?=.*?[0-9]).{8,}$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(formEmail)) return '錯誤的電話號碼格式';
    return null;
  }

  String? validateDoublecheckpassword(String? formPassword) {
    if (formPassword == null || formPassword.isEmpty) {
      return '請再次輸入密碼';
    }
    String pattern = r'^(?=.*?[a-z])(?=.*?[0-9]).{8,}$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(formPassword)) {
      return "密碼必須至少8個字符，包括字母以及數字。";
    }
    // ignore: unrelated_type_equality_checks
    if (formPassword != passwordController.text) {
      return "與密碼不同 請重新輸入";
    }
    return null;
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
  void _changePassword(String password) async {
    //Pass in the password to updatePassword.
    user?.updatePassword(password).then((_) {
      print("Successfully changed password");
    }).catchError((error) {
      print("Password can't be changed" + error.toString());
      //This might happen, when the wrong password is in, the user isn't found, or if the user hasn't logged in recently.
    });
  }
}

String? validateEmail(String? formEmail) {
  if (formEmail == null || formEmail.isEmpty) {
    return '請輸入帳號';
  }
  String pattern = r'\w+@\w+\.\w+';
  RegExp regex = RegExp(pattern);
  if (!regex.hasMatch(formEmail)) return '錯誤的電子郵件地址格式';
  return null;
}

String? validatePassword(String? formPassword) {
  if (formPassword == null || formPassword.isEmpty) {
    return '請輸入密碼';
  }
  String pattern = r'^(?=.*?[a-z])(?=.*?[0-9]).{8,}$';
  RegExp regex = RegExp(pattern);
  if (!regex.hasMatch(formPassword)) {
    return "密碼必須至少8個字符，包括字母以及數字。";
  }
  return null;
}
