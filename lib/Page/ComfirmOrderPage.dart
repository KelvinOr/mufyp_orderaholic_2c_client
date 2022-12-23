import 'package:flutter/material.dart';
import 'package:mufyp_orderaholic_2c_client/Model/MenuItemModel.dart';

class ComfirmOrderPage extends StatefulWidget {
  final List<MenuItemModel> OrderList;
  const ComfirmOrderPage({Key? key, required this.OrderList}) : super(key: key);

  @override
  _ComfirmOrderPageState createState() => _ComfirmOrderPageState();
}

class _ComfirmOrderPageState extends State<ComfirmOrderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Comfirm Order"),
      ),
      body: Text(
        widget.OrderList[0].name,
      ),
    );
  }
}
