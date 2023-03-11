import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:mufyp_orderaholic_2c_client/Config/Theme.dart';
import 'package:maps_launcher/maps_launcher.dart';

class DisplayResInfoPage extends StatefulWidget {
  final String Name;
  final double lat;
  final double long;
  final String Location;
  final String Discription;
  final List<dynamic> Image;
  final String Type;

  const DisplayResInfoPage(
      {Key? key,
      required this.Name,
      required this.lat,
      required this.long,
      required this.Location,
      required this.Discription,
      required this.Image,
      required this.Type})
      : super(key: key);

  @override
  _DisplayResInfoPage createState() => _DisplayResInfoPage();
}

class _DisplayResInfoPage extends State<DisplayResInfoPage> {
  List<dynamic> DisplayImage = [];

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() {
    //check image source is url or base64
    for (int i = 0; i < widget.Image.length; i++) {
      if (widget.Image[i]["source"].toString().contains("http")) {
        DisplayImage.add({"source": widget.Image[i]["source"], "type": "url"});
      } else {
        DisplayImage.add(
            {"source": widget.Image[i]["source"], "type": "base64"});
      }
    }

    print(DisplayImage);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.Name),
        backgroundColor: PrimaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          //to left
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            //SizeBox for spacing
            SizedBox(
              height: 10,
            ),
            //Display Name in Center
            Center(
              child: Text(
                widget.Name,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            //SizeBox for spacing
            SizedBox(
              height: 10,
            ),
            //Display Image in Scrollable List in Center
            Center(
              child: SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: DisplayImage.length,
                  itemBuilder: (context, index) {
                    if (DisplayImage[index]["type"] == "url") {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.network(
                          DisplayImage[index]["source"],
                          fit: BoxFit.cover,
                        ),
                      );
                    } else {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.memory(
                          base64Decode(DisplayImage[index]["source"]),
                          fit: BoxFit.cover,
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
            //Container

            //title text Discription
            Text(
              "Discription",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            //show Discription
            Text(
              widget.Discription,
              style: TextStyle(
                fontSize: 15,
                color: Colors.white,
              ),
            ),
            //SizeBox for spacing
            SizedBox(
              height: 10,
            ),
            //text Location
            Text(
              "Location: ${widget.Location}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            Spacer(),
            //rounder button in bottom Center
            Center(
              child: ElevatedButton(
                onPressed: () {
                  //open map
                  MapsLauncher.launchCoordinates(widget.lat, widget.long);
                },
                child:
                    Text("Open on Map", style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: SecondaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
