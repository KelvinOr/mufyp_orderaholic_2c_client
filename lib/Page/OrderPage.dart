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
  var _restaurnatInfo = "";

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

    _restaurnatInfo = await getRestaurants(orderID.RestaurantID.toString());
    print(_restaurnatInfo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          //get code
          Text(widget.code.toString(), style: TextStyle(color: Colors.white)),
          ElevatedButton(
            onPressed: () {},
            child: const Text("test"),
          ),
        ],
      ),
    );
  }
}
