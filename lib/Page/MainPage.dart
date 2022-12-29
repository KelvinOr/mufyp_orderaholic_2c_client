import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:mufyp_orderaholic_2c_client/Config/Theme.dart';
import '../Function/FireStoreHelper.dart';
import '../Function/FirebaseAuth.dart';
import '../Function/CheckCurrentOrder.dart';
import '../Function/RecommendSystem.dart';
import 'package:mufyp_orderaholic_2c_client/Page/QRCodeScanner.dart';
import 'package:mufyp_orderaholic_2c_client/Page/OrderPage.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  var user = FirebaseAuth.instance.currentUser;
  var currentOrder = null;
  var OrderIsFinish = true;
  var restaurantInfo = {
    'name': '',
  };

  ScrollController _scrollController = new ScrollController();
  @override
  void initState() {
    super.initState();
    _onInit();
    _scrollController.addListener(() {
      _onInit();
    });
  }

  Future<void> _onInit() async {
    if (user == null) {
      Navigator.pop(context);
    }
    GetRecommendTable('Monday', 'breakfast').then((value) => print(value));
    checkCurrentOrder().then((value) async {
      if (value != null) {
        currentOrder = jsonDecode(value);
        if (currentOrder != null) {
          OrderIsFinish = false;
          await getRestaurants(currentOrder['restaurantID'])
              .then((value) => restaurantInfo['name'] = value['Name']);
          print(restaurantInfo);
          setState(() {});
        }

        setState(() {});
      }
    });
  }

  currentOrder_widget(Size size) {
    if (OrderIsFinish != true) {
      return InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              //send data to new page
              builder: (context) => OrderPage(
                code: jsonEncode({
                  "RestaurantID": currentOrder['restaurantID'],
                  "OrderID": currentOrder['orderID']
                }),
              ),
            ),
          );
        },
        child: Card(
          color: SecondaryColor,
          child: SizedBox(
            height: size.height * 0.07,
            width: size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Current Order: " +
                      restaurantInfo['name'].toString() +
                      "\nOrder ID: " +
                      currentOrder['orderID'],
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return Card(
        color: SecondaryColor,
        child: SizedBox(
          height: size.height * 0.07,
          width: size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "No Item in handling",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(
          left: size.width * 0.1,
          right: size.width * 0.1,
          top: size.height * 0.05,
        ),
        child: SafeArea(
          child: EasyRefresh(
            onRefresh: () async {
              _onInit();
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Main Item
                SizedBox(
                  height: size.height * 0.7,
                  child: Container(
                    width: size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Recommend Restaurant",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Current Order",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        currentOrder_widget(size),
                      ],
                    ),
                  ),
                ),
                //Test Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(size.width * 0.8, 40),
                    backgroundColor: SecondaryColor,
                  ),
                  onPressed: () {
                    SetRecommendTable(
                        'Monday', 'breakfast', ['Western Restaurant']);
                  },
                  child: const Text("Test set table"),
                ),
                //Bottom Item
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(size.width * 0.8, 40),
                    backgroundColor: SecondaryColor,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const QRCodeScanner(),
                      ),
                    );
                  },
                  child: const Text("Scan QR Code"),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
