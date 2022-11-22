import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> jsondecode = jsonDecode(widget.code.toString());
    OrderIDModel orderID = OrderIDModel(
      jsondecode['RestaurantID'].toString(),
      jsondecode['OrderID'].toString(),
    );

    void btn_test_onClick() async {
      var result = await getRestaurants(orderID.RestaurantID.toString());
      print(result);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.code),
      ),
      body: Column(
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(200, 50),
            ),
            onPressed: btn_test_onClick,
            child: const Text("test"),
          ),
        ],
      ),
    );
  }
}
