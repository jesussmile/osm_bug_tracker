import 'package:flutter/material.dart';

import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
//import 'package:geo_rider/AllScreens/mainscreen.dart';
import 'package:provider/provider.dart';
import 'package:geo_rider/DataHandler/appData.dart';

import 'dart:async';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController pickUpTextEditingController = TextEditingController();
  TextEditingController dropOffTextEditingController = TextEditingController();

  //final AppData appdata;

  @override
  void initState() {
    super.initState();
  }

  @override
  @mustCallSuper
  Widget build(BuildContext context) {
    String placeAddress =
        Provider.of<AppData>(context).pickUpLocation.placeName ?? "";
    pickUpTextEditingController.text = placeAddress;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            height: 250.0,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 6.0,
                  spreadRadius: 0.5,
                  offset: Offset(0.7, 0.7),
                )
              ],
            ),
            child: Padding(
              padding: EdgeInsets.only(
                  left: 25.0, top: 30.0, right: 25.0, bottom: 20.0),
              child: Column(
                children: [
                  SizedBox(height: 5.0),
                  Stack(
                    children: [
                      GestureDetector(
                          onTap: () async {
                            FocusScopeNode currentFocus =
                                FocusScope.of(context);
                            if (!currentFocus.hasPrimaryFocus) {
                              currentFocus.unfocus();
                            }
                            Navigator.pop(

                                //send back data
                                context,
                                true);
                            // print("object");
                            // );
                          },
                          child: Icon(Icons.arrow_back)),
                      Center(
                        child: Text(
                          "Choose your drop off ",
                          style: TextStyle(
                              fontSize: 18.0, fontFamily: "Brand-Bold"),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    children: [
                      Image.asset("images/images/pickicon.png",
                          height: 16.0, width: 16.0),
                      SizedBox(width: 18.0),
                      Expanded(
                          child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(3.0),
                          child: TextField(
                            controller: pickUpTextEditingController,
                            decoration: InputDecoration(
                              hintText: "PickUp Location",
                              fillColor: Colors.grey[400],
                              filled: true,
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.only(
                                  left: 11.0, top: 8.0, bottom: 8.0),
                            ),
                          ),
                        ),
                      ))
                    ],
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    children: [
                      Image.asset("images/images/desticon.png",
                          height: 16.0, width: 16.0),
                      SizedBox(width: 18.0),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(3.0),
                            child: TypeAheadField(
                              textFieldConfiguration: TextFieldConfiguration(
                                autofocus: false,
                                maxLines: 1,
                                controller: dropOffTextEditingController,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(3),
                                  hintText: "Pick two points",
                                  labelStyle: TextStyle(color: Colors.black),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1.3, color: Colors.black),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(width: 0.8),
                                  ),
                                ),
                              ),
                              suggestionsCallback: (pattern) async {
                                if (pattern.isNotEmpty)
                                  return await addressSuggestion(pattern);
                                return Future.value();
                              },
                              suggestionsBoxController:
                                  SuggestionsBoxController(),
                              itemBuilder: (context, suggestion) {
                                return ListTile(
                                  leading: Icon(Icons.location_on),
                                  title: Text(
                                      (suggestion as SearchInfo).address.name),
                                  subtitle: Text((suggestion).address.country),
                                );
                              },
                              onSuggestionSelected: (suggestion) {
                                print("xxx $suggestion");

                                dropOffTextEditingController.text =
                                    (suggestion as SearchInfo).address.name;
                                Provider.of<AppData>(context, listen: false)
                                    .updateDropOffLocationAddress(
                                        dropOffTextEditingController.text);
                                //get the coordinates here
                                GeoPoint dropOffPoint =
                                    (suggestion as SearchInfo).point;
                                print("Coordinates :$dropOffPoint");
                                Provider.of<AppData>(context, listen: false)
                                    .updateDropOffGeoPoint(dropOffPoint);

                                // Navigator.pop(
                                //     context, widget.showMapFunction(false));
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
