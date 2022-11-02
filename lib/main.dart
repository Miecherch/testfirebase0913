import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:testfirebase/page/Home.dart';
import 'package:testfirebase/page/Aboutmepage.dart';
import 'package:testfirebase/page/cart.dart';
import 'package:testfirebase/page/drawer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:testfirebase/page/new_cart.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(750, 1334));
    return MaterialApp(
      title: "fruit time",
      theme: ThemeData.dark(),
      home: const buyerPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class buyerPage extends StatefulWidget {
  const buyerPage({Key? key}) : super(key: key);
  @override
  State<buyerPage> createState() => _buyerPageState();
}

class _buyerPageState extends State<buyerPage> {
  int selectedIndex = 0;
  List<Widget> pages = [
    const homepage(),
    const new_commodity(),
    const AboutMe()
  ]; //cart_page()
  void _onItemTap(int index) {
    setState(
      () => selectedIndex = index,
    );
  }

  User? user = FirebaseAuth.instance.currentUser;
  CollectionReference users = FirebaseFirestore.instance.collection('userdata');
  @override
  Widget build(BuildContext context) {
    bool isSign = (user == null ? false : true); //是否有登入

    return Scaffold(
      // endDrawer: const AppDrawer_logged(),
      // TODO: 底部欄
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          unselectedItemColor: Colors.grey,
          selectedItemColor: const Color.fromARGB(255, 97, 254, 207),
          backgroundColor: Theme.of(context).primaryColor,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home_sharp), label: ('首頁')),
            BottomNavigationBarItem(
                icon: Icon(Icons.shopping_bag_sharp), label: ('商品')),
            BottomNavigationBarItem(
                icon: Icon(Icons.person_sharp), label: ('關於我')),
          ],
          onTap: _onItemTap,
          currentIndex: selectedIndex),
      body: pages[selectedIndex],
      resizeToAvoidBottomInset: false,
    );
  }
}
