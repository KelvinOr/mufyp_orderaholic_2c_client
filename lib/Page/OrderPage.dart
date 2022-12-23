import 'package:flutter/material.dart';
import 'package:mufyp_orderaholic_2c_client/Model/OrderIDModel.dart';
import 'dart:convert';
import 'package:mufyp_orderaholic_2c_client/Function/FireStoreHelper.dart';

class OrderPage extends StatefulWidget {
  //const OrderPage({Key? key}) : super(key: key);

  final String code;
  const OrderPage({Key? key, required this.code}) : super(key: key);

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  var _restaurnatMenu = "";

  @override
  void initState() {
    super.initState();
    getRestInfo();
  }

  void getRestInfo() async {
    Map<String, dynamic> jsondecode = jsonDecode(widget.code.toString());
    OrderIDModel orderID = OrderIDModel(
      jsondecode['RestaurantID'].toString(),
      jsondecode['OrderID'].toString(),
    );

    var _restaurnatInfo = await getRestaurants(orderID.RestaurantID.toString());
    if (_restaurnatInfo.toString() != "null") {
      Map<String, dynamic> testjsoncode =
          jsonDecode(_restaurnatInfo.toString());
      _restaurnatMenu = testjsoncode['menu'].toString();

      if (_restaurnatInfo.toString() != "null") {
        var CurrentTime = DateTime.now().hour.toString();
        CurrentTime = "8";
        if (int.parse(CurrentTime) >= 7 && int.parse(CurrentTime) < 11) {
          _restaurnatMenu = testjsoncode['menu']['breakfast'].toString();
          print("testetsts " + testjsoncode.toString());
        }
        if (int.parse(CurrentTime) >= 11 && int.parse(CurrentTime) < 17) {
          _restaurnatMenu = testjsoncode['menu']['lunch'].toString();
        }
        if (int.parse(CurrentTime) >= 17 && int.parse(CurrentTime) < 23) {
          _restaurnatMenu = testjsoncode['menu']['dinner'].toString();
        }
        if (int.parse(CurrentTime) >= 23 && int.parse(CurrentTime) < 7) {
          _restaurnatMenu = "restaurant is closed";
        }
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Text(_restaurnatMenu),
          ElevatedButton(
            onPressed: () {},
            child: const Text("test"),
          ),
        ],
      ),
    );
  }
}
