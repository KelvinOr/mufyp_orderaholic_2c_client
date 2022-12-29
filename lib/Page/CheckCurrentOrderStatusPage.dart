import 'package:flutter/material.dart';
import 'package:mufyp_orderaholic_2c_client/Model/OrderIDModel.dart';
import 'dart:convert';
import '../Function/FireStoreHelper.dart';
import '../Config/Theme.dart';

class CheckCurrentOrderStatusOage extends StatefulWidget {
  final String code;
  const CheckCurrentOrderStatusOage({Key? key, required this.code})
      : super(key: key);

  @override
  _CheckCurrentOrderStatusOage createState() => _CheckCurrentOrderStatusOage();
}

class _CheckCurrentOrderStatusOage extends State<CheckCurrentOrderStatusOage> {
  var item = [];
  var checkIsNull = false;

  @override
  void initState() {
    super.initState();
    getInfo();
  }

  void getInfo() async {
    Map<String, dynamic> jsondecode = jsonDecode(widget.code.toString());
    OrderIDModel orderID = OrderIDModel(
      jsondecode['RestaurantID'].toString(),
      jsondecode['OrderID'].toString(),
    );

    var _orderInfo = await getOrderInfo(orderID.RestaurantID, orderID.OrderID);
    if (_orderInfo != null) {
      item = _orderInfo["Item"];
      if (item.length == 0) {
        Navigator.of(context).pop();
      }
      setState(() {});
    } else {
      checkIsNull = true;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text("Order status"),
        backgroundColor: PrimaryColor,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: EdgeInsets.only(
            left: size.width * 0.05,
            right: size.width * 0.05,
            top: 10,
            bottom: 10,
          ),
          child: Column(
            children: [
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: item.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 6,
                    margin: const EdgeInsets.all(5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: SecondaryColor,
                    child: ListTile(
                      title: Text(
                        item[index]["name"],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        "Price: " +
                            item[index]["price"].toString() +
                            "\nStatus: " +
                            item[index]["state"].toString() +
                            "\nCreate Time: " +
                            item[index]["time"],
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
              checkIsNull
                  ? Text(
                      "Order not found",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : Container(),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: (() {
                  Navigator.pop(context);
                }),
                child: Text("Back"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: SecondaryColor,
                  minimumSize: Size(size.width * 0.87, 47),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
