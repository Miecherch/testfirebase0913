import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class register extends StatefulWidget {
  register({Key? key}) : super(key: key);
  @override
  State<register> createState() => _registerState();
}

class _registerState extends State<register> {
  bool citybutton_change = true;
  bool birthbutton_change = true;
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  var user_sex = ""; //0:女生 1:男生
  var user_address_city = "選擇縣市";
  final user_address_detail = TextEditingController();
  var user_birth; //2000 00 00
  final user_email = TextEditingController(); //w123@123.com
  final user_firstname = TextEditingController();
  final user_icon = TextEditingController();
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

  Future<void> addUser(String uid) {
    return users
        .doc(uid)
        .set({
          'user_address_city': user_address_city,
          'user_address_detail': user_address_detail.text,
          'user_birth': user_birth.toString(),
          'user_email': user_email.text,
          'user_icon': user_icon.text,
          'user_id': uid,
          'user_identity': user_identity.text,
          'user_firstname': user_firstname.text,
          'user_lastname': user_lastname.text,
          'user_phone_number': user_phone_number.text,
          'user_sex': user_sex,
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
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

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    (user != null ? addUser(user.uid) : null);
    return Scaffold(
        appBar: AppBar(
          title: const Text("註冊"),
          centerTitle: true,
        ),
        body: Builder(
          builder: (context) => Form(
            key: _key,
            child: CupertinoScrollbar(
                thickness: 6.0,
                thicknessWhileDragging: 10.0,
                radius: const Radius.circular(34.0),
                radiusWhileDragging: Radius.zero,
                child: ListView(
                  children: [
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 120,
                      child: IconButton(
                        icon: Image.asset(
                          "img/app_icon.png",
                          fit: BoxFit.fitWidth,
                          height: 100.0,
                        ),
                        onPressed: () {
                          _showButtonPressDialog(context, "尚未開放 敬請期待", 15);
                        },
                      ),
                    ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("點換圖案設定頭像",
                              style: TextStyle(color: Colors.grey.shade500)),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(
                                //姓氏
                                width: 100,
                                height: 60,
                                child: TextFormField(
                                  controller: user_firstname,
                                  validator: validate_firstname,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: '姓氏',
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              SizedBox(
                                //名字
                                width: 150,
                                height: 60,
                                child: TextFormField(
                                  controller: user_lastname,
                                  validator: validate_lastname,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: '名字',
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              SizedBox(
                                width: 40,
                                height: 60,
                                child: IconButton(
                                  icon: Icon(
                                    Icons.person_rounded,
                                    //size: 40,
                                    color: user_sex == ""
                                        ? Colors.white
                                        : (user_sex == "1"
                                            ? Colors.blue
                                            : Colors.red),
                                  ),
                                  onPressed: () {
                                    if (user_sex == "0") {
                                      user_sex = "1";
                                    } else {
                                      user_sex = "0";
                                    }
                                    setState(() {});
                                    _showButtonPressDialog(
                                        context,
                                        "性別選擇:   " +
                                            (user_sex == "0" ? "女" : "男"),
                                        1);
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          SizedBox(
                            //帳號
                            width: 300,
                            height: 60,
                            child: TextFormField(
                              controller: user_email,
                              validator: validateEmail,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: '帳號',
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          SizedBox(
                            //密碼
                            width: 300,
                            height: 60,
                            child: TextFormField(
                              controller: passwordController,
                              validator: validatePassword,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: '密碼',
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          SizedBox(
                            //確認密碼
                            width: 300,
                            height: 60,
                            child: TextFormField(
                              controller: DoublecheckpasswordController,
                              validator: validateDoublecheckpassword,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: '確認密碼',
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                //縣市
                                width: 100,
                                height: 59,
                                child: OutlinedButton(
                                  child: Text(
                                    user_address_city,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        color:
                                            Color.fromARGB(255, 181, 181, 181)),
                                  ),
                                  onPressed: chose_city_Picker,
                                  style: OutlinedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    side: BorderSide(
                                        width: 0.8,
                                        color: (citybutton_change == true
                                            ? const Color.fromARGB(
                                                255, 181, 181, 181)
                                            : const Color.fromARGB(
                                                255, 242, 0, 0))),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              SizedBox(
                                //詳細地址
                                width: 195,
                                height: 60,
                                child: TextFormField(
                                  controller: user_address_detail,
                                  validator: validate_deteiladdress,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: '詳細地址',
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                //縣市
                                width: 100,
                                height: 59,
                                child: OutlinedButton(
                                  child: const Text(
                                    "生日",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color:
                                            Color.fromARGB(255, 181, 181, 181)),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    side: BorderSide(
                                        width: 0.8,
                                        color: (birthbutton_change == true
                                            ? const Color.fromARGB(
                                                255, 181, 181, 181)
                                            : const Color.fromARGB(
                                                255, 242, 0, 0))),
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
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              SizedBox(
                                //手機電話號碼
                                width: 195,
                                height: 60,
                                child: TextFormField(
                                  controller: user_phone_number,
                                  validator: validatephonenum,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(10)
                                  ],
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          decimal: true),
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: '手機電話號碼',
                                  ),
                                ),
                              ),
                            ],
                          ),
                          ElevatedButton(
                              child: Loadingserver_rigister
                                  ? const SizedBox(
                                      width: 25,
                                      height: 25,
                                      child: CircularProgressIndicator(
                                          color: Colors.white))
                                  : const Text('註冊'),
                              onPressed: (user != null
                                  ? null
                                  : () async {
                                      setState(
                                          () => Loadingserver_rigister = true);
                                      if (user_address_city == "選擇縣市") {
                                        setState(() {
                                          citybutton_change = false;
                                        });
                                      } else {
                                        setState(() {
                                          citybutton_change = true;
                                        });
                                      }
                                      ;
                                      if (user_birth == null) {
                                        setState(() {
                                          birthbutton_change = false;
                                        });
                                      } else {
                                        setState(() {
                                          birthbutton_change = true;
                                        });
                                      }
                                      if (_key.currentState!.validate()) {
                                        try {
                                          await FirebaseAuth.instance
                                              .createUserWithEmailAndPassword(
                                            email: user_email.text,
                                            password: passwordController.text,
                                          );
                                          Navigator.pop(context);
                                        } on FirebaseAuthException catch (error) {
                                          _showButtonPressDialog(
                                              context, "帳號已註冊 請直接登入或換一個帳號", 15);
                                        }
                                      }

                                      setState(
                                          () => Loadingserver_rigister = false);
                                    })),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('已有帳號？登入'),
                          ),
                          TextButton(
                            onPressed: () {
                              _showButtonPressDialog(
                                  context, "帳號或密碼錯誤 請重新登入", 15);
                            },
                            child: const Text('123123'),
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
          ),
        ));
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

//帳號
  String? validateEmail(String? formEmail) {
    if (formEmail == null || formEmail.isEmpty) {
      return '請輸入帳號';
    }
    String pattern = r'\w+@\w+\.\w+';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(formEmail)) return '錯誤的電子郵件地址格式';
    return null;
  }

//密碼
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
  List<String> city_list = [
    '臺北市',
    '新北市',
    '桃園市',
    '臺中市',
    '臺南市',
    '高雄市',
    '基隆市',
    '新竹市',
    '嘉義市',
    '宜蘭縣',
    '新竹縣',
    '苗栗縣',
    '彰化縣',
    '南投縣',
    '雲林縣',
    '嘉義縣',
    '屏東縣',
    '花蓮縣',
    '臺東縣',
    '澎湖縣',
  ];
  void chose_city_Picker() {
    showCupertinoModalPopup(
        context: context,
        builder: (_) => SizedBox(
              height: 210,
              child: CupertinoPicker(
                backgroundColor: const Color.fromARGB(255, 48, 48, 48),
                itemExtent: 30,
                scrollController: FixedExtentScrollController(initialItem: 0),
                children: const [
                  Text(
                    '臺北市',
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    '新北市',
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    '桃園市',
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    '臺中市',
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    '臺南市',
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    '高雄市',
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    '基隆市',
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    '新竹市',
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    '嘉義市',
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    '宜蘭縣',
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    '新竹縣',
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    '苗栗縣',
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    '彰化縣',
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    '南投縣',
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    '雲林縣',
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    '嘉義縣',
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    '屏東縣',
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    '花蓮縣',
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    '臺東縣',
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    '澎湖縣',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
                onSelectedItemChanged: (value) {
                  setState(() {
                    user_address_city = city_list[value];
                  });
                },
              ),
            ));
  }
}
