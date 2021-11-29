import 'package:flutter/cupertino.dart';
//import 'package:rider/AllScreens/photonAPI.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart' hide Address;
import 'package:geo_rider/Models/address.dart' show Address;

class AppData extends ChangeNotifier {
  Address pickUpLocation;
  dynamic dropOffLocation;
  //bool mapVisibility;
  GeoPoint dropOffLatLng;
  //String earnings = '0';
  //int countTrips = 0;
  //bool splashMainScreen = true;
  // bool floatActBtnMainScreen = true;
  List<String> tripHistoryKeys = [];

  bool locationPickMain = true;

  String price = "";
  String distance = "";
  //bool dropOffText = false;
  bool rideRequest = false;
  bool findingDriver;
  String carDetailsDriver;
  String driverName;
  String driverPhone;
  String rideStatus;
  bool driverDetails = false;
  //String state = "normal";

  void updatePickUpLocationAddress(Address pickUpAddress) {
    pickUpLocation = pickUpAddress;
    notifyListeners();
  }

  void updateDropOffLocationAddress(String dropOffLoc) {
    dropOffLocation = dropOffLoc;
    notifyListeners();
  }

  void updateDropOffGeoPoint(GeoPoint point) {
    dropOffLatLng = point;
    notifyListeners();
  }

  void showMapMainScreen() {
    locationPickMain = false;
    rideRequest = true;
    //floatActBtnMainScreen = false;
    notifyListeners();
  }

  void showMapPriceDistance(String _price, String _distance) {
    price = _price;
    distance = _distance;
    notifyListeners();
  }
}
