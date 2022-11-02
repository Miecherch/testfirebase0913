import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AppDrawer_logged extends StatefulWidget {
  const AppDrawer_logged({Key? key}) : super(key: key);

  @override
  _AppDrawer_loggedState createState() => _AppDrawer_loggedState();
}

class _AppDrawer_loggedState extends State<AppDrawer_logged> {
  //TODO:顯示SnackBar
  void _showButtonPressDialog(
      BuildContext context, String provider, int millisecond) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(provider),
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      duration: Duration(milliseconds: millisecond * 100),
    ));
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    var drawer_tap = 1;
    bool isSign = (user == null ? false : true);
    return (isSign == false
        ? Drawer(
            backgroundColor: Colors.transparent,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text("登入以使用購物車"),
                ],
              ),
            ),
          )
        : Drawer(
            backgroundColor: Colors.transparent,
            child: Column(
              children: [
                DrawerHeader(
                  padding: EdgeInsets.zero,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      /**/
                      color: Colors.black /**/,
                      child: const Center(
                        child: Image(
                            image: AssetImage('img/apple_wait.gif'),
                            fit: BoxFit.contain),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    GestureDetector(
                      child: Row(
                        children: <Widget>[
                          const Text('購物車'),
                          Icon(drawer_tap == 1
                              ? Icons.keyboard_arrow_down
                              : Icons.keyboard_arrow_right)
                        ],
                      ),
                      onTap: () {
                        setState(() {
                          drawer_tap = 1;
                        });
                      },
                    ),
                    GestureDetector(
                      child: Row(
                        children: <Widget>[
                          const Text('處理中'),
                          Icon(drawer_tap == 2
                              ? Icons.keyboard_arrow_down
                              : Icons.keyboard_arrow_right)
                        ],
                      ),
                      onTap: () {
                        setState(() {
                          drawer_tap = 2;
                        });
                        _showButtonPressDialog(
                            context, drawer_tap.toString(), 20);
                      },
                    ),
                    GestureDetector(
                      child: Row(
                        children: <Widget>[
                          const Text('已完成'),
                          Icon(drawer_tap == 3
                              ? Icons.keyboard_arrow_down
                              : Icons.keyboard_arrow_right)
                        ],
                      ),
                      onTap: () {
                        setState(() {
                          drawer_tap = 3;
                        });
                      },
                    ),
                  ],
                ),
              ],
            )

            // ListView(
            //   padding: EdgeInsets.zero,
            //   children: <Widget>[
            //     DrawerHeader(
            //       padding: EdgeInsets.zero,
            //       child: BackdropFilter(
            //         filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            //         child: Container(
            //           /**/
            //           color: Colors.black /**/,
            //           child: const Center(
            //             child: Image(
            //                 image: AssetImage('img/apple_wait.gif'),
            //                 fit: BoxFit.contain),
            //           ),
            //         ),
            //       ),
            //     ),

            //     const Padding(
            //       padding: EdgeInsets.all(16.0),
            //       child: Text(
            //         'Header',
            //       ),
            //     ),
            //     const Divider(
            //       height: 1,
            //       thickness: 1,
            //     ),
            //     const ListTile(
            //       leading: Icon(Icons.favorite),
            //       title: Text('Item 1'),
            //     ),
            //     const ListTile(
            //       leading: Icon(Icons.delete),
            //       title: Text('Item 2'),
            //     ),
            //     const ListTile(
            //       leading: Icon(Icons.label),
            //       title: Text('Item 3'),
            //     ),
            //     const Divider(),
            //     const Padding(
            //       padding: EdgeInsets.all(16.0),
            //       child: Text(
            //         'Label',
            //       ),
            //     ),
            //     const ListTile(
            //       leading: Icon(Icons.bookmark),
            //       title: Text('Item A'),
            //     ),
            //   ],
            // ),
            ));
  }
}
