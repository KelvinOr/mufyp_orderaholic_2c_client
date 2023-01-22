import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mufyp_orderaholic_2c_client/Function/FireStoreHelper.dart';
import '../Config/Theme.dart';

class ViewMyRecorderPage extends StatefulWidget {
  const ViewMyRecorderPage({Key? key}) : super(key: key);

  @override
  State<ViewMyRecorderPage> createState() => _ViewMyRecordPage();
}

class _ViewMyRecordPage extends State<ViewMyRecorderPage> {
  List<dynamic> RecordItem = [];
  List<String> RecordDate = [];

  @override
  void initState() {
    init();
    super.initState();
  }

  init() async {
    var result = await getUserOrderRecord();

    print(result["16-1-2023"]);
    print(result["16-1-2023"][0]["Item"].length.toString());

    for (var i = 0; i < result.length; i++) {
      RecordDate.add(result.keys.elementAt(i));
      for (var j = 0; j < result.values.elementAt(i).length; j++) {
        for (var k = 0; k < result.values.elementAt(i)[j]["Item"].length; k++) {
          RecordItem.add(result.values.elementAt(i)[j]["Item"][k]);
          RecordItem[RecordItem.length - 1]["Date"] =
              result.keys.elementAt(i).toString();
        }
      }
    }

    print(RecordDate);
    print(RecordItem[0]["price"]);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Record",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: PrimaryColor,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              left: size.width * 0.05,
              right: size.width * 0.05,
              top: 10,
              bottom: 10,
            ),
            child: Column(
              children: [
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: RecordDate.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Container(
                          width: size.width,
                          child: Text(
                            RecordDate[index],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: RecordItem.length,
                          itemBuilder: (context, index2) {
                            if (RecordItem[index2]["Date"] ==
                                RecordDate[index]) {
                              return Card(
                                elevation: 6,
                                margin: const EdgeInsets.all(5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                color: SecondaryColor,
                                child: ListTile(
                                  title: Text(
                                    RecordItem[index2]["name"].toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(
                                    "Price: " +
                                        RecordItem[index2]["price"].toString() +
                                        "\n" +
                                        "Quantity: " +
                                        RecordItem[index2]["quantity"]
                                            .toString(),
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              return Container();
                            }
                          },
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
