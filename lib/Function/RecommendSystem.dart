import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import './FireStoreHelper.dart';

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
  var userOrderRecord = await getUserOrderRecord();
  var RecordDecode = [];

  for (var i = 0; i < userOrderRecord.length; i++) {
    for (var j = 0; j < userOrderRecord.values.elementAt(i).length; j++) {
      for (var k = 0;
          k < userOrderRecord.values.elementAt(i)[j]["Item"].length;
          k++) {
        RecordDecode.add(userOrderRecord.values.elementAt(i)[j]["Item"][k]);
      }
    }
  }

  for (var i = 0; i < RecordDecode.length; i++) {
    RecordDecode[i]["time"] = DateTime.parse(RecordDecode[i]["time"]);
  }
  RecordDecode.sort((a, b) => a["time"].compareTo(b["time"]));

  if (userOrderRecord == null) {
    return null;
  } else {
    return RecordDecode;
  }
}
