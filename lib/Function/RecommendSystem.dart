import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

Future<List<String>?> GetRecommendTable(String week, String TimeRange) async {
  final prefs = await SharedPreferences.getInstance();
  final key = 'recommend_table';
  final value = prefs.getString(key);
  if (value == null) {
    return null;
  } else {
    var DecodeString = jsonDecode(value);
    DecodeString = DecodeString[week][TimeRange].toString();
    if (DecodeString.contains('[') && DecodeString.contains(']')) {
      DecodeString = DecodeString.replaceAll('[', '');
      DecodeString = DecodeString.replaceAll(']', '');
    }
    List<String> result = DecodeString.split(',');
    return result;
  }
}

Future<dynamic> SetRecommendTable(
    String week, String TimeRange, List<String> ResInfo) async {
  final prefs = await SharedPreferences.getInstance();
  final key = 'recommend_table';
  final value = prefs.getString(key);
  if (value == null) {
    var temp = {
      week: {TimeRange: ResInfo}
    };
    prefs.setString(key, jsonEncode(temp));
  } else {
    var DecodeString = jsonDecode(value);
    DecodeString[week][TimeRange] = ResInfo;
    prefs.setString(key, jsonEncode(DecodeString));
  }
}
