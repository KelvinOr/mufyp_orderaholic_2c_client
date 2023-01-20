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

    for (var i = 0; i < result.length; i++) {
      RecordDate.add(result.keys.elementAt(i));
      RecordItem.add(result.values.elementAt(i)["Item"]);
    }

    print(RecordDate);
    print(RecordItem);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: RecordDate.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Text(RecordDate[index]),
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: RecordItem.length,
                        itemBuilder: (context, index2) {
                          if (RecordItem[index2]["Date"] == RecordDate[index]) {
                            return Text(RecordItem[index2]["name"].toString());
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
    );
  }
}
