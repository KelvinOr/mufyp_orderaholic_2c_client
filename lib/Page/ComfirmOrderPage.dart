import 'package:flutter/material.dart';
import 'package:mufyp_orderaholic_2c_client/Model/MenuItemModel.dart';
import '../Config/Theme.dart';
import '../Function/FireStoreHelper.dart';

class ComfirmOrderPage extends StatefulWidget {
  final List<MenuItemModel> OrderList;
  final String orderID;
  final String restaurantID;

  const ComfirmOrderPage(
      {Key? key,
      required this.OrderList,
      required this.orderID,
      required this.restaurantID})
      : super(key: key);

  @override
  _ComfirmOrderPageState createState() => _ComfirmOrderPageState();
}

class _ComfirmOrderPageState extends State<ComfirmOrderPage> {
  void btn_submitOrder_onClick() {
    sendOrder(widget.OrderList, widget.orderID, widget.restaurantID);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Comfirm Order"),
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
              itemCount: widget.OrderList.length,
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
                      widget.OrderList[index].name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      widget.OrderList[index].price,
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: btn_submitOrder_onClick,
              child: const Text("Confirm Order"),
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
    );
  }
}
