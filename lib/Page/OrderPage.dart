import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mufyp_orderaholic_2c_client/Model/OrderIDModel.dart';
import 'dart:convert';

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

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.code),
      ),
      body: Column(
        children: [
          Text(
            orderID.OrderID,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
