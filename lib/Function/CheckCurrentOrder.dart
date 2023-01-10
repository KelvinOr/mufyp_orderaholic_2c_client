import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

Future<void> setCurrentOrder(String restaurantID, String orderID) async {
  final prefs = await SharedPreferences.getInstance();
  final key = 'current_order';

  await prefs.remove(key);

  var temp = {"restaurantID": restaurantID, "orderID": orderID};
  prefs.setString(key, jsonEncode(temp));
}

Future<String?> checkCurrentOrder() async {
  final prefs = await SharedPreferences.getInstance();
  final key = 'current_order';
  final value = prefs.getString(key);

  return value.toString();
}

Future<void> removeCurrentOrder() async {
  final prefs = await SharedPreferences.getInstance();
  final key = 'current_order';

  await prefs.remove(key);
}
