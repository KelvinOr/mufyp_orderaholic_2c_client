import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:mufyp_orderaholic_2c_client/Model/MenuItemModel.dart';
import 'dart:convert';
import '../Model/OrderItemFullModel.dart';
import 'package:firebase_auth/firebase_auth.dart';

var db = FirebaseFirestore.instance;

Future<dynamic> getRestaurants(String restaurantID) async {
  final docRef = db.collection("restaurants").doc(restaurantID);

  var result = await docRef.get().then((doc) {
    if (doc.exists) {
      return doc.data();
    } else {
      return null;
    }
  });

  return result;
}

Future<void> sendOrder(
    List<MenuItemModel> orderItem, String orderID, String restaurantID) async {
  DatabaseReference dbRef =
      FirebaseDatabase.instance.ref("orders/" + restaurantID + "/" + orderID);

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
    if (tempMap["Item"] != null) {
      oldItemsArray = tempMap["Item"];
      for (var item in oldItemsArray) {
        orderItemArray.add(item);
      }
    }
  }

  var CID = FirebaseAuth.instance.currentUser?.uid.toString();

  dbRef.update({
    "CID": CID,
    "Item": orderItemArray,
  });
}

Future<dynamic> getOrderInfo(String restaurantID, String orderID) {
  DatabaseReference dbRefgetOrderInf =
      FirebaseDatabase.instance.ref("orders/" + restaurantID + "/" + orderID);

  var result = dbRefgetOrderInf.get().then((value) {
    if (value.exists) {
      Map<String, dynamic> tempMap =
          Map<String, dynamic>.from(value.value as Map);
      if (tempMap["Item"] == null) {
        return null;
      }
      return value.value;
    } else {
      return null;
    }
  });
  print(result);
  return result;
}

Future<bool> checkOrderIsFinish(String restaurantID, String orderID) async {
  DatabaseReference dbRefgetOrderInf =
      FirebaseDatabase.instance.ref("orders/" + restaurantID + "/" + orderID);

  var result = dbRefgetOrderInf.get().then((value) {
    if (value.exists) {
      Map<String, dynamic> tempMap =
          Map<String, dynamic>.from(value.value as Map);
      if (tempMap["Item"] == null) {
        return true;
      }
      return false;
    } else {
      return true;
    }
  });
  return result;
}

Future<dynamic> getUserOrderRecord() async {
  var userID = FirebaseAuth.instance.currentUser?.uid.toString();
  final docRef = db.collection("history_custom").doc(userID);

  var result = await docRef.get().then((doc) {
    if (doc.exists) {
      return doc.data();
    } else {
      return null;
    }
  });

  return result;
}

Future<dynamic> getRestaurantByType(String type) async {
  final docRef = db.collection("restaurants").where("Type", isEqualTo: type);

  var result = await docRef.get().then((doc) {
    if (doc.docs.isNotEmpty) {
      return doc.docs.map((e) => e.data()).toList();
    } else {
      return null;
    }
  });

  return result;
}
