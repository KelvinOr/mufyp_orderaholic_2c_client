import 'dart:convert';
import 'dart:ffi';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import './FireStoreHelper.dart';
import 'dart:math';
import 'package:geolocator/geolocator.dart';

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
  dynamic QueryResult = [];
  dynamic temp = [];
  var allRestaurantType = [
    "Chinese Restaurant",
    "Western Restaurant",
    "Asian restaurant",
    "Fast Food",
    "Bar",
    "Cafe",
    "Other"
  ];
  bool serviceEnabled;
  dynamic position;

  var permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      serviceEnabled = false;
      return;
    } else {
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      position = await Geolocator.getLastKnownPosition();
    }
  } else {
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    position = await Geolocator.getLastKnownPosition();
  }

  // for (var i = 0; i < userOrderRecord.length; i++) {
  //   for (var j = 0; j < userOrderRecord.values.elementAt(i).length; j++) {
  //     for (var k = 0;
  //         k < userOrderRecord.values.elementAt(i)[j]["Item"].length;
  //         k++) {
  //       RecordDecode.add(userOrderRecord.values.elementAt(i)[j]["Item"][k]);
  //     }
  //   }
  // }

  if (userOrderRecord == null) {
    var recommandTable = [];
    for (var i = 0; i < 5; i++) {
      QueryResult = await getRestaurantByType(
          allRestaurantType[Random().nextInt(allRestaurantType.length)]);
      if (QueryResult == null) {
        i--;
        continue;
      }

      //GPS
      if (serviceEnabled) {
        //經，緯度計算QueryResult的距離, 用cos計算緯度差並排列QueryResult

        QueryResult.sort((a, b) {
          //two point distance sort with position
          return (pow(
                      double.parse(a["Coordinate"]["lat"].toString()) -
                          position.latitude,
                      2) +
                  pow(
                      double.parse(a["Coordinate"]["lng"].toString()) -
                          position.longitude,
                      2))
              .compareTo(pow(
                      double.parse(b["Coordinate"]["lat"].toString()) -
                          position.latitude,
                      2) +
                  pow(
                      double.parse(b["Coordinate"]["lng"].toString()) -
                          position.longitude,
                      2));
        });

        try {
          temp = QueryResult[recommandTable.length];
        } catch (e) {
          continue;
        }
      } else {
        temp = QueryResult[Random().nextInt(QueryResult.length)];
      }

      var isInlist = false;

      if (recommandTable.length > 0) {
        for (var k = 0; k < recommandTable.length; k++) {
          if (temp["Name"] == recommandTable[k]["Name"]) {
            isInlist = true;
            break;
          }
        }
      }
      if (isInlist == false) {
        recommandTable.add(temp);
      } else {
        continue;
      }
    }
    return recommandTable;
  }

  for (var i = 0; i < userOrderRecord.length; i++) {
    for (var j = 0; j < userOrderRecord.values.elementAt(i).length; j++) {
      RecordDecode.add({
        "restaurantName": userOrderRecord.values.elementAt(i)[j]
            ["restaurantName"],
        "restaurantType": userOrderRecord.values.elementAt(i)[j]
            ["restaurantType"],
        "time": userOrderRecord.values.elementAt(i)[j]["Item"][0]["time"]
      });
    }
  }

  for (var i = 0; i < RecordDecode.length; i++) {
    RecordDecode[i]["time"] = DateTime.parse(RecordDecode[i]["time"]);
  }
  RecordDecode.sort((a, b) => a["time"].compareTo(b["time"]));

  var breakfast = [];
  var lunch = [];
  var dinner = [];

  for (var i = 0; i < RecordDecode.length; i++) {
    if (RecordDecode[i]["time"].hour >= 7 &&
        RecordDecode[i]["time"].hour < 11) {
      breakfast.add(RecordDecode[i]);
    }
    if (RecordDecode[i]["time"].hour >= 11 &&
        RecordDecode[i]["time"].hour < 17) {
      lunch.add(RecordDecode[i]);
    }
    if (RecordDecode[i]["time"].hour >= 17 &&
        RecordDecode[i]["time"].hour < 23) {
      dinner.add(RecordDecode[i]);
    }
  }

  print('breakfast: ${breakfast}');
  print('lunch: ${lunch}');
  print('dinner: ${dinner}');

  //current time
  var TimeRange_temp = DateTime.now().hour;
  var recommandTable = [];
  // if (TimeRange_temp >= 7 && TimeRange_temp < 11) {
  //   if (breakfast.length == 0) {
  //     for (var i = 0; i < 5; i++) {
  //       recommandTable.add(getRestaurantByType(
  //           allRestaurantType[Random().nextInt(allRestaurantType.length)]
  //               .toString()));
  //     }
  //   } else {
  //     for (var i = 0; i < 5; i++) {
  //       recommandTable.add(await getRestaurantByType(
  //           breakfast[Random().nextInt(breakfast.length)]["restaurantType"]));
  //     }
  //   }
  // }

  if (TimeRange_temp >= 7 && TimeRange_temp < 11) {
    if (breakfast.length == 0) {
      for (var i = 0; i < 5; i++) {
        QueryResult = await getRestaurantByType(
            allRestaurantType[Random().nextInt(allRestaurantType.length)]);
        if (QueryResult == null) {
          i--;
          continue;
        }

        //var temp = QueryResult[Random().nextInt(QueryResult.length)];

        //GPS
        if (serviceEnabled) {
          //經，緯度計算QueryResult的距離, 用cos計算緯度差並排列QueryResult

          QueryResult.sort((a, b) {
            //two point distance sort with position
            return (pow(
                        double.parse(a["Coordinate"]["lat"].toString()) -
                            position.latitude,
                        2) +
                    pow(
                        double.parse(a["Coordinate"]["lng"].toString()) -
                            position.longitude,
                        2))
                .compareTo(pow(
                        double.parse(b["Coordinate"]["lat"].toString()) -
                            position.latitude,
                        2) +
                    pow(
                        double.parse(b["Coordinate"]["lng"].toString()) -
                            position.longitude,
                        2));
          });

          try {
            temp = QueryResult[recommandTable.length];
          } catch (e) {
            continue;
          }
        } else {
          temp = QueryResult[Random().nextInt(QueryResult.length)];
        }

        var isInlist = false;
        if (recommandTable.length > 0) {
          for (var k = 0; k < recommandTable.length; k++) {
            if (temp["Name"] == recommandTable[k]["Name"]) {
              isInlist = true;
              break;
            }
          }
        }
        if (isInlist == false) {
          recommandTable.add(temp);
        } else {
          continue;
        }
      }
    } else {
      for (var i = 0; i < 5; i++) {
        QueryResult = await getRestaurantByType(
            breakfast[Random().nextInt(breakfast.length)]["restaurantType"]);
        if (QueryResult == null) {
          i--;
          continue;
        }
        //var temp = QueryResult[Random().nextInt(QueryResult.length)];

        //GPS
        if (serviceEnabled) {
          //經，緯度計算QueryResult的距離, 用cos計算緯度差並排列QueryResult

          QueryResult.sort((a, b) {
            //two point distance sort with position
            return (pow(
                        double.parse(a["Coordinate"]["lat"].toString()) -
                            position.latitude,
                        2) +
                    pow(
                        double.parse(a["Coordinate"]["lng"].toString()) -
                            position.longitude,
                        2))
                .compareTo(pow(
                        double.parse(b["Coordinate"]["lat"].toString()) -
                            position.latitude,
                        2) +
                    pow(
                        double.parse(b["Coordinate"]["lng"].toString()) -
                            position.longitude,
                        2));
          });

          try {
            temp = QueryResult[recommandTable.length];
          } catch (e) {
            continue;
          }
        } else {
          temp = QueryResult[Random().nextInt(QueryResult.length)];
        }

        print("temp: ${temp}");
        //check item in recommandTable
        var isInlist = false;
        if (recommandTable.length > 0) {
          for (var k = 0; k < recommandTable.length; k++) {
            if (temp["Name"] == recommandTable[k]["Name"]) {
              isInlist = true;
              break;
            }
          }
        }
        if (isInlist == false) {
          recommandTable.add(temp);
        } else {
          continue;
        }
      }
    }
  } else if (TimeRange_temp >= 11 && TimeRange_temp < 17) {
    if (lunch.length == 0) {
      for (var i = 0; i < 5; i++) {
        QueryResult = await getRestaurantByType(
            allRestaurantType[Random().nextInt(allRestaurantType.length)]);
        if (QueryResult == null) {
          i--;
          continue;
        }

        //GPS
        if (serviceEnabled) {
          //經，緯度計算QueryResult的距離, 用cos計算緯度差並排列QueryResult

          QueryResult.sort((a, b) {
            //two point distance sort with position
            return (pow(
                        double.parse(a["Coordinate"]["lat"].toString()) -
                            position.latitude,
                        2) +
                    pow(
                        double.parse(a["Coordinate"]["lng"].toString()) -
                            position.longitude,
                        2))
                .compareTo(pow(
                        double.parse(b["Coordinate"]["lat"].toString()) -
                            position.latitude,
                        2) +
                    pow(
                        double.parse(b["Coordinate"]["lng"].toString()) -
                            position.longitude,
                        2));
          });
          print('Debug Line354 : QueryResult: ${QueryResult.toString()}');

          try {
            temp = QueryResult[recommandTable.length];
          } catch (e) {
            continue;
          }
        } else {
          temp = QueryResult[Random().nextInt(QueryResult.length)];
        }

        var isInlist = false;
        if (recommandTable.length > 0) {
          for (var k = 0; k < recommandTable.length; k++) {
            if (temp["Name"] == recommandTable[k]["Name"]) {
              isInlist = true;
              break;
            }
          }
        }
        if (isInlist == false) {
          recommandTable.add(temp);
        } else {
          continue;
        }
      }
    } else {
      for (var i = 0; i < 5; i++) {
        QueryResult = await getRestaurantByType(
            lunch[Random().nextInt(lunch.length)]["restaurantType"]);
        if (QueryResult == null) {
          i--;
          continue;
        }
        //temp = QueryResult[Random().nextInt(QueryResult.length)];

        //GPS
        if (serviceEnabled) {
          //經，緯度計算QueryResult的距離, 用cos計算緯度差並排列QueryResult

          QueryResult.sort((a, b) {
            //two point distance sort with position
            return (pow(
                        double.parse(a["Coordinate"]["lat"].toString()) -
                            position.latitude,
                        2) +
                    pow(
                        double.parse(a["Coordinate"]["lng"].toString()) -
                            position.longitude,
                        2))
                .compareTo(pow(
                        double.parse(b["Coordinate"]["lat"].toString()) -
                            position.latitude,
                        2) +
                    pow(
                        double.parse(b["Coordinate"]["lng"].toString()) -
                            position.longitude,
                        2));
          });

          print('Debug Line409 : QueryResult: ${QueryResult.toString()}');

          try {
            temp = QueryResult[recommandTable.length];
          } catch (e) {
            continue;
          }
        } else {
          temp = QueryResult[Random().nextInt(QueryResult.length)];
        }

        print("temp: ${temp}");
        //check item in recommandTable
        var isInlist = false;
        if (recommandTable.length > 0) {
          for (var k = 0; k < recommandTable.length; k++) {
            if (temp["Name"] == recommandTable[k]["Name"]) {
              isInlist = true;
              break;
            }
          }
        }
        if (isInlist == false) {
          recommandTable.add(temp);
        } else {
          continue;
        }
      }
    }
  } else if (TimeRange_temp >= 17 && TimeRange_temp < 23) {
    if (dinner.length == 0) {
      for (var i = 0; i < 5; i++) {
        QueryResult = await getRestaurantByType(
            allRestaurantType[Random().nextInt(allRestaurantType.length)]);
        if (QueryResult == null) {
          i--;
          continue;
        }

        //var temp = QueryResult[Random().nextInt(QueryResult.length)];
        //GPS
        if (serviceEnabled) {
          //經，緯度計算QueryResult的距離, 用cos計算緯度差並排列QueryResult

          QueryResult.sort((a, b) {
            //two point distance sort with position
            return (pow(
                        double.parse(a["Coordinate"]["lat"].toString()) -
                            position.latitude,
                        2) +
                    pow(
                        double.parse(a["Coordinate"]["lng"].toString()) -
                            position.longitude,
                        2))
                .compareTo(pow(
                        double.parse(b["Coordinate"]["lat"].toString()) -
                            position.latitude,
                        2) +
                    pow(
                        double.parse(b["Coordinate"]["lng"].toString()) -
                            position.longitude,
                        2));
          });

          try {
            temp = QueryResult[recommandTable.length];
          } catch (e) {
            continue;
          }
        } else {
          temp = QueryResult[Random().nextInt(QueryResult.length)];
        }

        print("temp286: ${temp}");
        var isInlist = false;
        if (recommandTable.length > 0) {
          for (var k = 0; k < recommandTable.length; k++) {
            if (temp["Name"] == recommandTable[k]["Name"]) {
              isInlist = true;
              break;
            }
          }
        }
        if (isInlist == false) {
          recommandTable.add(temp);
        } else {
          continue;
        }
      }
    } else {
      for (var i = 0; i < 5; i++) {
        QueryResult = await getRestaurantByType(
            dinner[Random().nextInt(dinner.length)]["restaurantType"]);
        if (QueryResult == null) {
          i--;
          continue;
        }

        //var temp = QueryResult[Random().nextInt(QueryResult.length)];
        //GPS
        if (serviceEnabled) {
          //經，緯度計算QueryResult的距離, 用cos計算緯度差並排列QueryResult

          QueryResult.sort((a, b) {
            //two point distance sort with position
            return (pow(
                        double.parse(a["Coordinate"]["lat"].toString()) -
                            position.latitude,
                        2) +
                    pow(
                        double.parse(a["Coordinate"]["lng"].toString()) -
                            position.longitude,
                        2))
                .compareTo(pow(
                        double.parse(b["Coordinate"]["lat"].toString()) -
                            position.latitude,
                        2) +
                    pow(
                        double.parse(b["Coordinate"]["lng"].toString()) -
                            position.longitude,
                        2));
          });
          try {
            temp = QueryResult[recommandTable.length];
          } catch (e) {
            continue;
          }
        } else {
          temp = QueryResult[Random().nextInt(QueryResult.length)];
        }

        //check item in recommandTable
        var isInlist = false;
        if (recommandTable.length > 0) {
          for (var k = 0; k < recommandTable.length; k++) {
            if (temp["Name"] == recommandTable[k]["Name"]) {
              isInlist = true;
              break;
            }
          }
        } else {
          recommandTable.add(temp);
        }
        if (isInlist == false) {
          recommandTable.add(temp);
        } else {
          continue;
        }
      }
    }
  } else {
    for (var i = 0; i < 5; i++) {
      QueryResult = await getRestaurantByType(
          allRestaurantType[Random().nextInt(allRestaurantType.length)]);
      if (QueryResult == null) {
        i--;
        continue;
      }

      //var temp = QueryResult[Random().nextInt(QueryResult.length)];
      //GPS
      if (serviceEnabled) {
        //經，緯度計算QueryResult的距離, 用cos計算緯度差並排列QueryResult

        QueryResult.sort((a, b) {
          //two point distance sort with position
          return (pow(
                      double.parse(a["Coordinate"]["lat"].toString()) -
                          position.latitude,
                      2) +
                  pow(
                      double.parse(a["Coordinate"]["lng"].toString()) -
                          position.longitude,
                      2))
              .compareTo(pow(
                      double.parse(b["Coordinate"]["lat"].toString()) -
                          position.latitude,
                      2) +
                  pow(
                      double.parse(b["Coordinate"]["lng"].toString()) -
                          position.longitude,
                      2));
        });

        try {
          temp = QueryResult[recommandTable.length];
        } catch (e) {
          continue;
        }
      } else {
        temp = QueryResult[Random().nextInt(QueryResult.length)];
      }

      print("temp: ${temp}");
      var isInlist = false;
      if (recommandTable.length > 0) {
        for (var k = 0; k < recommandTable.length; k++) {
          if (temp["Name"] == recommandTable[k]["Name"]) {
            isInlist = true;
            break;
          }
        }
      }
    }
  }

  print("RecommandTable:  ${recommandTable}");
  print("length: ${recommandTable.length}");
  return recommandTable;
}
