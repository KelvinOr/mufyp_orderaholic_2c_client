import 'package:flutter/material.dart';
import 'package:mufyp_orderaholic_2c_client/Page/MainPage.dart';
import 'package:mufyp_orderaholic_2c_client/Page/SettingPage.dart';
import '../Config/Theme.dart';

class TabbedPage extends StatefulWidget {
  const TabbedPage({Key? key}) : super(key: key);

  @override
  _TabbedPage createState() => _TabbedPage();
}

class _TabbedPage extends State<TabbedPage> {
  int _currentIndex = 0;
  // 把页面存放到数组里
  List _pageList = [
    MainPage(),
    SettingPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: this._pageList[this._currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: this._currentIndex,
        backgroundColor: PrimaryColor,
        selectedItemColor: Colors.white,
        onTap: (int index) {
          setState(() {
            this._currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}
