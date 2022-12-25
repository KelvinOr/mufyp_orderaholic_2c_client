import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:mufyp_orderaholic_2c_client/Model/MenuItemModel.dart';
import 'dart:convert';
import '../Model/OrderItemFullModel.dart';

var db = FirebaseFirestore.instance;

Future<String> getRestaurants(String restaurantID) async {
  final docRef = db.collection("restaurants").doc(restaurantID);

  var result = await docRef.get().then((doc) {
    if (doc.exists) {
      print(doc.data());
      return jsonEncode(doc.data());
    } else {
      return "null";
    }
  });
  return result.toString();
}

Future<void> sendOrder(
    List<MenuItemModel> orderItem, String orderID, String restaurantID) async {
  DatabaseReference dbRef =
      FirebaseDatabase.instance.ref(restaurantID + "/" + orderID);

  var orderItemArray = [];
  List<OrderItemFullModel> allItems = []..addAll(orderItem
      .map((e) => OrderItemFullModel(e.name, e.price, DateTime.now())));

  for (var item in allItems) {
    orderItemArray.add({
      "name": item.name,
      "price": item.price,
      "time": item.createTime.toString(),
      "state": "Prepare",
    });
  }

  var oldOrderStatus = await dbRef.get();
  var oldItemsArray = [];
  if (oldOrderStatus.exists) {
    Map<String, dynamic> tempMap =
        Map<String, dynamic>.from(oldOrderStatus.value as Map);
    oldItemsArray = tempMap["Item"];
  }

  for (var item in oldItemsArray) {
    orderItemArray.add(item);
  }

  dbRef.update({
    "Item": orderItemArray,
  });
}

Future<dynamic> getOrderInfo(String restaurantID, String orderID) {
  DatabaseReference dbRefgetOrderInf =
      FirebaseDatabase.instance.ref("orders/" + restaurantID + "/" + orderID);

  var result = dbRefgetOrderInf.get().then((value) {
    if (value.exists) {
      print(value.value);
      return value.value;
    } else {
      return null;
    }
  });
  return result;
}
