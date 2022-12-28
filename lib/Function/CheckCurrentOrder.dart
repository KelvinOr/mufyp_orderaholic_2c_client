import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

Future<void> setCurrentOrder(String restaurantID, String orderID) async {
  final prefs = await SharedPreferences.getInstance();
  final key = 'current_order';
  final value = prefs.getString(key);
  if (value == null) {
    var temp = {restaurantID: orderID};
    prefs.setString(key, jsonEncode(temp));
  } else {
    var DecodeString = jsonDecode(value);
    DecodeString[restaurantID] = orderID;
    prefs.setString(key, jsonEncode(DecodeString));
  }
}

Future<dynamic> checkCurrentOrder() async {
  final prefs = await SharedPreferences.getInstance();
  final key = 'current_order';
  final value = prefs.getString(key);
  return value;
}
