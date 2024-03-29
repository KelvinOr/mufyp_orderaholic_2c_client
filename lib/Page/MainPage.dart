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
import 'package:mufyp_orderaholic_2c_client/Page/DisplayResInfoPage.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  var user = FirebaseAuth.instance.currentUser;
  var currentOrder = null;
  var OrderNotFinish = true;
  var restaurantInfo = {
    'name': '',
  };
  var recommendItem;

  @override
  void initState() {
    super.initState();
    _onInit();
  }

  Future<void> _onInit() async {
    if (user == null) {
      Navigator.pop(context);
    }

    checkCurrentOrder().then((value) async {
      if (value.toString() != "null") {
        currentOrder = jsonDecode(value.toString());

        if (currentOrder != null) {
          OrderNotFinish = false;
          var check_result = await getOrderInfo(
              currentOrder['restaurantID'], currentOrder['orderID']);
          if (check_result == null) {
            removeCurrentOrder();
            currentOrder = null;
            OrderNotFinish = true;
          }
        }
      } else {
        currentOrder = null;
        OrderNotFinish = true;
      }
    });
    Recommendation().then((value) => {
          setState(() {
            print("Debug value: ${value}");
            recommendItem = value;
          })
        });
    print('recommendItem: ${recommendItem}');
  }

  currentOrder_widget(Size size) {
    if (OrderNotFinish != true) {
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
              print(currentOrder);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Main Item
                SizedBox(
                  height: size.height * 0.75,
                  child: Container(
                    width: size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Orderaholic",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 10,
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
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Recommend Item",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        recommendItem != null
                            ? ListView.builder(
                                itemCount: recommendItem.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  //TODO: 美化
                                  return Card(
                                    color: SecondaryColor,
                                    child: SizedBox(
                                      height: size.height * 0.07,
                                      width: size.width,
                                      child: Row(
                                        children: [
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Text(
                                              recommendItem[index]['Name']
                                                  .toString(),
                                              style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 217, 201, 201),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              print(recommendItem[index]
                                                  ['Image'][0]);
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    //send data to new page
                                                    builder: (context) =>
                                                        DisplayResInfoPage(
                                                          Name: recommendItem[
                                                              index]['Name'],
                                                          Location:
                                                              recommendItem[
                                                                      index]
                                                                  ['Location'],
                                                          Discription:
                                                              recommendItem[
                                                                          index]
                                                                      [
                                                                      'Discription']
                                                                  .toString(),
                                                          Image: recommendItem[
                                                              index]['Image'],
                                                          Type: recommendItem[
                                                              index]['Type'],
                                                          lat: recommendItem[
                                                                      index]
                                                                  ['Coordinate']
                                                              ['lat'],
                                                          long: recommendItem[
                                                                      index]
                                                                  ['Coordinate']
                                                              ['lng'],
                                                        )),
                                              );
                                            },
                                            icon: const Icon(
                                              Icons.arrow_forward_ios,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              )
                            : Text("No Item"),
                      ],
                    ),
                  ),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
