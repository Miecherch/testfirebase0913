// ignore_for_file: deprecated_member_use, unnecessary_null_comparison, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:testfirebase/page/new_user-editpage.dart';
import 'package:testfirebase/page/register.dart';
import 'package:testfirebase/page/seller.dart';
import 'package:testfirebase/page/users-editpage.dart';

class AboutMe extends StatefulWidget {
  const AboutMe({Key? key}) : super(key: key);
  @override
  State<AboutMe> createState() => _AboutMe();
}

class _AboutMe extends State<AboutMe> {
  bool Loadingserver_login = false;
  bool Loadingserver_rigister = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  //TODO:顯示SnackBar
  void _showButtonPressDialog(BuildContext context, String provider) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(provider),
      backgroundColor: Colors.white38,
      duration: const Duration(milliseconds: 1500),
    ));
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    bool isSign = (user == null ? false : true); //是否有登入
    return MaterialApp(
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: isSign == false
          ?
          //TODO:未登入
          Scaffold(
              appBar: AppBar(
                backgroundColor: const Color.fromARGB(255, 57, 151, 123),
                title: const Text(" 未登入"),
                centerTitle: true,
              ),
              body: Form(
                key: _key,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 300,
                        child: TextFormField(
                          controller: emailController,
                          validator: validateEmail,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: '帳號',
                          ),
                        ),
                      ),
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
                          RaisedButton(
                            color: Color.fromARGB(255, 66, 66, 66),
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(14.0))), //设置圆角
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => register()));
                            },
                            child: Loadingserver_rigister
                                ? const SizedBox(
                                    width: 25,
                                    height: 25,
                                    child: CircularProgressIndicator(
                                        color: Colors.white))
                                : const Text('註冊'),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          RaisedButton(
                            color: const Color.fromARGB(128, 97, 254, 207),
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(14.0))), //设置圆角
                            onPressed: (user != null
                                ? null
                                : () async {
                                    setState(() {});
                                    setState(() => Loadingserver_login = true);
                                    if (_key.currentState!.validate()) {
                                      try {
                                        await FirebaseAuth.instance
                                            .signInWithEmailAndPassword(
                                          email: emailController.text,
                                          password: passwordController.text,
                                        );
                                      } on FirebaseAuthException catch (error) {
                                        _showButtonPressDialog(
                                            context, "帳號或密碼錯誤 請重新登入");
                                      }
                                    }
                                    setState(() => Loadingserver_login = false);
                                  }),
                            child: Loadingserver_login
                                ? const SizedBox(
                                    width: 25,
                                    height: 25,
                                    child: CircularProgressIndicator(
                                        color: Colors.white))
                                : const Text('登入'),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Text("或使用下列登入方式",
                          style: TextStyle(color: Colors.grey.shade500)),
                      Column(
                        children: [
                          RaisedButton(
                              color: Color.fromARGB(255, 66, 66, 66),
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(14.0))), //设置圆角
                              child: const Text('管理員測試 快速登入'),
                              onPressed: (user != null
                                  ? null
                                  : () async {
                                      setState(() {});
                                      setState(
                                          () => Loadingserver_login = true);
                                      emailController.text = '123456@123.com';
                                      passwordController.text = 'abc123456';
                                      if (_key.currentState!.validate()) {
                                        try {
                                          await FirebaseAuth.instance
                                              .signInWithEmailAndPassword(
                                            email: emailController.text,
                                            password: passwordController.text,
                                          );
                                        } on FirebaseAuthException catch (error) {
                                          _showButtonPressDialog(
                                              context, "帳號或密碼錯誤 請重新登入");
                                        }
                                      }
                                      setState(
                                          () => Loadingserver_login = false);
                                    })),
                          RaisedButton(
                              color: Color.fromARGB(255, 66, 66, 66),
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(14.0))), //设置圆角
                              child: const Text('買家測試 快速登入'),
                              onPressed: (user != null
                                  ? null
                                  : () async {
                                      setState(() {});
                                      setState(
                                          () => Loadingserver_login = true);
                                      emailController.text = 'LEELON@123.com';
                                      passwordController.text = 'wumax0005';
                                      if (_key.currentState!.validate()) {
                                        try {
                                          await FirebaseAuth.instance
                                              .signInWithEmailAndPassword(
                                            email: emailController.text,
                                            password: passwordController.text,
                                          );
                                        } on FirebaseAuthException catch (error) {
                                          _showButtonPressDialog(
                                              context, "帳號或密碼錯誤 請重新登入");
                                        }
                                      }
                                      setState(
                                          () => Loadingserver_login = false);
                                    })),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              resizeToAvoidBottomInset: false,
            )
          :
          //TODO:登入後
          Scaffold(
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
                      "關於我",
                      style: TextStyle(fontSize: 30),
                    ),
                  ],
                ),
              ),
              body: RefreshIndicator(
                child: CupertinoScrollbar(
                    thickness: 6.0,
                    thicknessWhileDragging: 10.0,
                    radius: const Radius.circular(34.0),
                    radiusWhileDragging: Radius.zero,
                    child: ListView(
                      children: [
                        getUser(),
                        RaisedButton(
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(14.0))), //设置圆角
                            child: const Text('登出'),
                            color: const Color.fromARGB(128, 97, 254, 207),
                            onPressed: isSign == true
                                ? () async {
                                    await FirebaseAuth.instance.signOut();
                                    setState(() {});
                                  }
                                : null),
                      ],
                    )),
                displacement: 20.0,
                onRefresh: _onRefresh,
              ),
            ),
    );
  }

  Future<Null> _onRefresh() async {
    await Future.delayed(Duration(seconds: 0), () {
      print('refresh');
      setState(() {});
    });
  }
}

class getUser extends StatefulWidget {
  const getUser({Key? key}) : super(key: key);

  @override
  State<getUser> createState() => _getUserState();
}

class _getUserState extends State<getUser> {
  bool isedit = false;
  bool firebaseImage_check = false;
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    bool isSign = (user == null ? false : true); //是否有登入
    final useremail = user?.email;
    CollectionReference users =
        FirebaseFirestore.instance.collection('userdata');
    setState(() {});
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
          return Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(padding: EdgeInsets.all(10.0)),
              ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: data['user_icon'] != ""
                    ? Image(
                        image: FirebaseImage(data['user_icon'],
                            shouldCache: true,
                            cacheRefreshStrategy:
                                CacheRefreshStrategy.BY_METADATA_DATE),
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
              const Padding(padding: EdgeInsets.all(5.0)),
              SizedBox(
                child: Card(
                  elevation: 15.0, //设置阴影
                  shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.all(Radius.circular(14.0))), //设置圆角
                  child: ListTile(
                    title: const Text("郵件"),
                    subtitle: Text(useremail!),
                    leading: Icon(
                      Icons.email_outlined,
                      color: Colors.blue[500],
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: double.maxFinite,
                child: Card(
                  elevation: 15.0, //设置阴影
                  shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.all(Radius.circular(14.0))), //设置圆角
                  child: ListTile(
                    title: const Text("地址"),
                    subtitle: Text(data["user_address_city"] +
                        "  " +
                        data['user_address_detail']),
                    leading: Icon(
                      Icons.ballot,
                      color: Colors.blue[500],
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: double.maxFinite,
                child: Card(
                  elevation: 15.0, //设置阴影
                  shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.all(Radius.circular(14.0))), //设置圆角
                  child: ListTile(
                    title: const Text("電話"),
                    subtitle: Text('${data['user_phone_number']}'),
                    leading: Icon(
                      Icons.phone_iphone_sharp,
                      color: Colors.blue[500],
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: double.maxFinite,
                child: Card(
                  elevation: 15.0, //设置阴影
                  shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.all(Radius.circular(14.0))), //设置圆角
                  child: ListTile(
                    title: const Text("等級"),
                    subtitle: Text(data['user_identity'] == 3
                        ? "管理員"
                        : data['user_identity'] == 2
                            ? "農夫"
                            : "一般"),
                    leading: Icon(
                      Icons.perm_contact_cal_outlined,
                      color: Colors.blue[500],
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: double.maxFinite,
                child: Card(
                  elevation: 15.0, //设置阴影
                  shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.all(Radius.circular(14.0))), //设置圆角
                  child: ListTile(
                    title: const Text("生日"),
                    subtitle:
                        Text(data["user_birth"].toString().substring(0, 10)),
                    leading: Icon(
                      Icons.ballot,
                      color: Colors.blue[500],
                    ),
                  ),
                ),
              ),
              const Text(
                "如果編輯完請下拉重新整理來更新資訊",
                style: TextStyle(
                  color: Color.fromARGB(171, 255, 255, 255),
                ),
              ),
              const Padding(padding: EdgeInsets.all(5.0)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RaisedButton(
                    shape: const RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.all(Radius.circular(14.0))), //设置圆角
                    child: const Text('編輯'),
                    color: const Color.fromARGB(128, 97, 254, 207),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const users_editpage()));
                      setState(() {});
                    },
                  ),
                  (data['user_identity'] < 2
                      ? const SizedBox(
                          width: 0,
                        )
                      : const Padding(padding: EdgeInsets.all(5.0))),
                  (data['user_identity'] < 2
                      ? const SizedBox(
                          width: 0,
                        )
                      : RaisedButton(
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(14.0))), //设置圆角
                          child: const Text('賣家模式'),
                          color: const Color.fromARGB(128, 254, 97, 97),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const seller()));
                            setState(() {});
                          },
                        )),
                  (data['user_identity'] < 3
                      ? const SizedBox(
                          width: 0,
                        )
                      : const Padding(padding: EdgeInsets.all(5.0))),
                  (data['user_identity'] < 3
                      ? const SizedBox(
                          width: 0,
                        )
                      : RaisedButton(
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(14.0))), //设置圆角
                          child: const Text('新編輯'),
                          color: Color.fromARGB(128, 217, 254, 97),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => new_usereditpage(
                                          user: data,
                                        ))).then((value) {
                              setState(() {});
                            });
                            setState(() {});
                          },
                        )),
                ],
              ),
            ],
          ));
        }
        return Column(
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
        );
      },
    );
  }
}

//登入防護
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
