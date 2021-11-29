import 'dart:async';

//******For POD ERROR
//WATCH 41 */

import 'package:drawer_swipe/drawer_swipe.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:geo_rider/AllScreens/searchScreen.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:geo_rider/Assistants/assistantMethod.dart';
import 'package:geo_rider/DataHandler/appData.dart';
//import 'dart:math' as Math;
import 'package:map_pin_picker/map_pin_picker.dart';

class MainScreen extends StatefulWidget {
  static const String idScreen = "mainScreen";

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with AutomaticKeepAliveClientMixin {
  bool nearbyAvailableDriverKeysLoaded = false;

  bool dropOffText = false;

  GeoPoint initPosition;
  String price = "";
  String distance = "";
  String uName = "";
  // static const double pi = Math.pi;

  TextEditingController textCont;

  String state = "normal";

  final GlobalKey _mapKey = GlobalKey();
  DatabaseReference rideRequestRef;
  var drawerKey = GlobalKey<SwipeDrawerState>();

  MapController osmController;

  GlobalKey<ScaffoldState> scaffoldKey;
  TextEditingController searchTextEditingController = TextEditingController();
  MapPickerController mapPickerController = MapPickerController();
  @override
  void didChangeDependencies() {
    print("didchange Dependencies test ");

    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();

    osmController = MapController(
      initMapWithUserPosition: true,
    );

    scaffoldKey = GlobalKey<ScaffoldState>();
    Future.delayed(Duration(seconds: 10), () async {
      // await osmController.setZoom(zoomLevel: 10);
      await osmController.rotateMapCamera(45.0);
      await osmController.currentLocation();
      await osmController.rotateMapCamera(0);

      locatePosition();
    });
  }

  void locatePosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print("This is your Position:: " + position.toString());

    GeoPoint initPos =
        GeoPoint(latitude: position.latitude, longitude: position.longitude);
    initPosition = initPos;
    String address =
        await AssistantMethods.searchCoordinateAddress(position, context);
    print("This is your Address:: " + address);
  }

  @override
  void dispose() {
    print("dispose  test ");
    osmController.dispose();
    super.dispose();
  }

  // bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      key: scaffoldKey,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.blue[400],
                  width: 2.0,
                ),
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(20.0),
                    bottomLeft: Radius.circular(20.0)),
                boxShadow: [],
              ),
              height: 580,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(20.0),
                    bottomLeft: Radius.circular(20.0)),
                child: MapPicker(
                  iconWidget: Icon(
                    Icons.location_pin,
                    size: 30,
                    color: Colors.red,
                  ),
                  mapPickerController: mapPickerController,
                  child: (OSMFlutter(
                    key: _mapKey,
                    controller: osmController,
                    initZoom: 18,
                    minZoomLevel: 8,
                    maxZoomLevel: 18,
                    stepZoom: 1.0,
                    // driverKey?? :
                    //onMapIsReady: ,

                    // staticPoints: [ //removed staticPoint as its already below and causes error while loading
                    //   StaticPositionGeoPoint(
                    //     driverKey,
                    //     MarkerIcon(
                    //       //icon: null,
                    //       icon: Icon(Icons.star),
                    //     ),
                    //     [GeoPoint(latitude: driverLat, longitude: driverLon)],
                    //   ),
                    // ],

                    //currentLocation: false,
                    road: Road(
                      startIcon: MarkerIcon(
                        icon: Icon(
                          Icons.pin_drop,
                          size: 64,
                          color: Colors.green,
                        ),
                      ),
                      roadColor: Colors.yellowAccent,
                    ),
                    markerOption: MarkerOption(
                        defaultMarker: MarkerIcon(
                      icon: Icon(null
                          //Icons.star_half_rounded,
                          //color: Colors.blue,
                          //size: 56,
                          ),
                    )),
                  )),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Consumer<AppData>(
              builder: (ctx, prod, child) => Visibility(
                visible: prod.locationPickMain,
                maintainSize: false,
                child: Container(
                  height: 250.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(18.0),
                        topRight: Radius.circular(18.0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 16.0,
                        spreadRadius: 0.5,
                        offset: Offset(0.7, 0.7),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24.0, vertical: 5.0),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          onTap: () async {
                            final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SearchScreen()));
                            if (result)
                              try {
                                Provider.of<AppData>(context, listen: false)
                                    .showMapMainScreen();
                                await osmController.removeLastRoad();

                                GeoPoint pointA = initPosition;
                                print("xxx $pointA");

                                GeoPoint pointB =
                                    Provider.of<AppData>(context, listen: false)
                                        .dropOffLatLng;
                                print("xxxb $pointB");
                                RoadInfo roadInformation =
                                    await osmController.drawRoad(pointA, pointB,
                                        roadOption: RoadOption(
                                            roadWidth: 10,
                                            roadColor: Colors.red,
                                            showMarkerOfPOI: true));
                                String duration =
                                    "duration: ${Duration(seconds: roadInformation.duration.toInt()).inMinutes} minutes ";

                                price = (roadInformation.distance * 39 + 50)
                                    .toStringAsFixed(2);
                                distance =
                                    "${roadInformation.distance.toStringAsFixed(2)} Km ";
                                Provider.of<AppData>(context, listen: false)
                                    .showMapPriceDistance(price, distance);

                                print(duration);
                                print(distance);
                              } on RoadException catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "${e.errorMessage()}",
                                    ),
                                  ),
                                );
                              }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black54,
                                  blurRadius: 6.0,
                                  spreadRadius: 0.5,
                                  offset: Offset(0.7, 0.7),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.search,
                                    color: Colors.blueAccent,
                                  ),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Consumer<AppData>(
                                      builder: (ctx, prod, child) => dropOffText
                                          ? Text(
                                              prod.dropOffLocation != null
                                                  ? prod.dropOffLocation
                                                  : "Pick your destination ",
                                              style: TextStyle(fontSize: 12.0),
                                              overflow: TextOverflow.ellipsis,
                                            )
                                          : Text("Pick your destination ")),
                                  // )
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 24.0),
                        Row(
                          children: [
                            Icon(
                              Icons.home,
                              color: Colors.grey,
                            ),
                            SizedBox(
                              width: 12.0,
                            ),
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (Provider.of<AppData>(context)
                                          .pickUpLocation !=
                                      null)
                                    Text(
                                      Provider.of<AppData>(context)
                                          .pickUpLocation
                                          .placeName,
                                      style: TextStyle(fontSize: 12.0),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  SizedBox(
                                    height: 4.0,
                                  ),
                                  Text("Your home Address",
                                      style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 12.0)),
                                ],
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 24.0),
                        Row(
                          children: [
                            Icon(
                              Icons.work,
                              color: Colors.grey,
                            ),
                            SizedBox(
                              width: 12.0,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Add Work"),
                                SizedBox(
                                  height: 4.0,
                                ),
                                Text("Your office address",
                                    style: TextStyle(
                                        color: Colors.black54, fontSize: 12.0))
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Consumer<AppData>(
              builder: (ctx, prod, child) => Visibility(
                visible: prod.rideRequest,
                // visible: rideRequest,
                child: Container(
                  height: 330,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16.0),
                      topRight: Radius.circular(16.0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 16.0,
                        spreadRadius: 0.5,
                        offset: Offset(0.7, 0.7),
                      )
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 17.0),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            width: double.infinity,
                            //color: Colors.tealAccent,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                children: [
                                  Image.asset(
                                    "images/images/bike.png",
                                    height: 70.0,
                                    width: 80.0,
                                  ),
                                  SizedBox(
                                    width: 16.0,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Bike",
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            fontFamily: "Brand Bold"),
                                      ),
                                      if (Provider.of<AppData>(context)
                                              .distance !=
                                          null)
                                        Text(
                                          distance,
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontFamily: "Brand Bold"),
                                        )
                                    ],
                                  ),
                                  //Expanded(child: Container()),

                                  Consumer<AppData>(
                                      builder: (ctx, prod, child) => dropOffText
                                          ? Text(
                                              prod.dropOffLocation != null
                                                  ? prod.dropOffLocation
                                                  : "Pick your destination ",
                                              style: TextStyle(fontSize: 12.0),
                                              overflow: TextOverflow.ellipsis,
                                            )
                                          : Text("Pick your destination ")),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Divider(
                          height: 2,
                          thickness: 2,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            width: double.infinity,
                            //color: Colors.tealAccent,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                children: [
                                  Image.asset(
                                    "images/images/ubergo.png",
                                    height: 70.0,
                                    width: 80.0,
                                  ),
                                  SizedBox(
                                    width: 16.0,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "UberGo",
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            fontFamily: "Brand Bold"),
                                      ),
                                      Text(
                                        distance,
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontFamily: "Brand Bold"),
                                      ),
                                    ],
                                  ),
                                  Expanded(child: Container()),
                                  Text(
                                    (price == "") ? price : "Rs $price",
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        fontFamily: "Brand Bold"),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Divider(
                          height: 2,
                          thickness: 2,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            width: double.infinity,
                            // color: Colors.tealAccent,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                children: [
                                  Image.asset(
                                    "images/images/uberx.png",
                                    height: 70.0,
                                    width: 80.0,
                                  ),
                                  SizedBox(
                                    width: 16.0,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "UberX",
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            fontFamily: "Brand Bold"),
                                      ),
                                      Text(
                                        distance,
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontFamily: "Brand Bold"),
                                      ),
                                    ],
                                  ),
                                  //Expanded(child: Container()),
                                  Consumer<AppData>(
                                      builder: (ctx, prod, child) =>
                                          price.isNotEmpty
                                              ? Text(
                                                  "Rs ${(double.tryParse(price) / 2).toStringAsFixed(2)}",
                                                  style: TextStyle(
                                                      fontSize: 18.0,
                                                      fontFamily: "Brand Bold"),
                                                )
                                              : Text("")),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Divider(
                          height: 2,
                          thickness: 2,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  buildShowDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return CircularProgressIndicator();
        });
  }

  @override
  bool get wantKeepAlive => true;
}
