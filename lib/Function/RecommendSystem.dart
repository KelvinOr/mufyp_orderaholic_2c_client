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
    print(result);
    return result;
  }
}

Future<dynamic> SetRecommendTable(dynamic ResInfo) async {
  final prefs = await SharedPreferences.getInstance();
  final key = 'recommend_table';
  final value = prefs.getString(key);

  var week = DateTime.now().weekday;
  var TimeRange_temp = DateTime.now().hour;
  var TimeRange = "";
  if (TimeRange_temp >= 7 && TimeRange_temp < 11) {
    TimeRange = "7-11";
  }
  if (TimeRange_temp >= 11 && TimeRange_temp < 17) {
    TimeRange = "11-17";
  }
  if (TimeRange_temp >= 17 && TimeRange_temp < 23) {
    TimeRange = "17-23";
  }
  if (TimeRange_temp >= 23 && TimeRange_temp < 7) {
    TimeRange = "23-7";
  }

  if (value == null) {
    var temp = {
      week.toString(): {
        TimeRange: [ResInfo]
      }
    };
    prefs.setString(key, jsonEncode(temp));
  } else {
    var DecodeString = jsonDecode(value);
    DecodeString[week][TimeRange] = ResInfo;
    prefs.setString(key, jsonEncode(DecodeString));
  }
}

Future<dynamic> Recommendation() async {
  var week = DateTime.now().weekday;
  var TimeRange = DateTime.now().hour;
  var result;
  if (TimeRange >= 7 && TimeRange < 11) {
    result = await GetRecommendTable(week.toString(), "7-11")
        .then((value) => result = value);
    print("Recommendation Debug 64: " + result.toString());
  }
  if (TimeRange >= 11 && TimeRange < 17) {
    result = await GetRecommendTable(week.toString(), "11-17")
        .then((value) => result = value);
    print("Recommendation Debug 68: " + result.toString());
  }
  if (TimeRange >= 17 && TimeRange < 23) {
    await GetRecommendTable(week.toString(), "17-23")
        .then((value) => {result = value});
    print("Recommendation Debug 72: " + result.toString());
  }
  if (TimeRange >= 23 && TimeRange < 7) {
    return null;
  }

  return;
}
