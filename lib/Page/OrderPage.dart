import 'package:flutter/material.dart';
import 'package:mufyp_orderaholic_2c_client/Model/OrderIDModel.dart';
import 'dart:convert';
import 'package:mufyp_orderaholic_2c_client/Function/FireStoreHelper.dart';
import 'package:mufyp_orderaholic_2c_client/Page/CheckCurrentOrderStatusPage.dart';
import 'package:mufyp_orderaholic_2c_client/Page/ComfirmOrderPage.dart';
import '../Model/MenuItemModel.dart';
import '../Config/Theme.dart';

class OrderPage extends StatefulWidget {
  //const OrderPage({Key? key}) : super(key: key);

  final String code;
  const OrderPage({Key? key, required this.code}) : super(key: key);

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  List<MenuItemModel> _restaurnatMenu = [];
  List<MenuItemModel> _orderItem = [];
  String _resturantName = "";

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

    if (_restaurnatInfo != null) {
      _resturantName = _restaurnatInfo["Name"].toString();

      Map<String, dynamic> testjsoncode = _restaurnatInfo;

      if (_restaurnatInfo != null) {
        var CurrentTime = DateTime.now().hour.toString();
        //TODO: remove debug time
        CurrentTime = "8";
        if (int.parse(CurrentTime) >= 7 && int.parse(CurrentTime) < 11) {
          for (var items in testjsoncode['menu']['breakfast']) {
            _restaurnatMenu.add(MenuItemModel(items['name'], items['price']));
          }
        }
        if (int.parse(CurrentTime) >= 11 && int.parse(CurrentTime) < 17) {
          _restaurnatMenu = testjsoncode['menu']['lunch'];
        }
        if (int.parse(CurrentTime) >= 17 && int.parse(CurrentTime) < 23) {
          _restaurnatMenu = testjsoncode['menu']['dinner'];
        }
        if (int.parse(CurrentTime) >= 23 && int.parse(CurrentTime) < 7) {}
        setState(() {});
      }
    }
  }

  void btn_addToComfirm_onClick(BuildContext context) async {
    Map<String, dynamic> jsondecode = jsonDecode(widget.code.toString());
    OrderIDModel orderID = OrderIDModel(
      jsondecode['RestaurantID'].toString(),
      jsondecode['OrderID'].toString(),
    );

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ComfirmOrderPage(
          OrderList: _orderItem,
          orderID: orderID.OrderID,
          restaurantID: orderID.RestaurantID,
        ),
      ),
    );

    if (result == true) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(_resturantName),
        backgroundColor: PrimaryColor,
      ),
      body: Padding(
        padding: EdgeInsets.only(
            left: size.width * 0.05, right: size.width * 0.05, top: 10),
        child: Column(
          children: [
            ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: _restaurnatMenu.length,
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
                      _restaurnatMenu[index].name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      _restaurnatMenu[index].price,
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        setState(() {
                          _orderItem.add(_restaurnatMenu[index]);
                        });
                      },
                      icon: Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              },
            ),
            SizedBox(
              height: size.height * 0.01,
            ),
            ElevatedButton(
              child: Text("Have " + _orderItem.length.toString() + " item"),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(size.width * 0.87, size.height * 0.05),
                backgroundColor: SecondaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () => btn_addToComfirm_onClick(context),
            ),
            SizedBox(height: 5),
            ElevatedButton(
              child: Text("Check current order status"),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(size.width * 0.87, size.height * 0.05),
                backgroundColor: SecondaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        CheckCurrentOrderStatusOage(code: widget.code),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
