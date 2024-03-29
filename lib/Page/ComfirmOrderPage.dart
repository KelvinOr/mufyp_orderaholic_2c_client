import 'package:flutter/material.dart';
import 'package:mufyp_orderaholic_2c_client/Model/MenuItemModel.dart';
import '../Config/Theme.dart';
import '../Function/CheckCurrentOrder.dart';
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
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: SecondaryColor,
          title: const Text(
            "Order Sent",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          content: const Text(
            "Your order has been sent to the restaurant",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                sendOrder(
                    widget.OrderList, widget.orderID, widget.restaurantID);
                setCurrentOrder(widget.restaurantID, widget.orderID);
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text(
                "OK",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Comfirm Order"),
        backgroundColor: PrimaryColor,
        leading: BackButton(
          onPressed: () => Navigator.pop(context, true),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
            left: size.width * 0.05, right: size.width * 0.05, top: 10),
        physics: ScrollPhysics(),
        child: Column(
          children: [
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
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
                    trailing: IconButton(
                      onPressed: () {
                        widget.OrderList.removeAt(index);
                        setState(() {});
                      },
                      icon: Icon(
                        Icons.delete,
                        color: Colors.white,
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
            SizedBox(height: size.height * 0.01),
          ],
        ),
      ),
    );
  }
}
