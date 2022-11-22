import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';

var db = FirebaseFirestore.instance;

Future<String> getRestaurants(String restaurantID) async {
  final docRef = db.collection("restaurants").doc(restaurantID);

  var result = await docRef.get().then((doc) {
    if (doc.exists) {
      return jsonEncode(doc.data());
    } else {
      return "null";
    }
  });
  return result.toString();
}
