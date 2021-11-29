import 'dart:math';

import 'package:geolocator/geolocator.dart';

import 'package:intl/intl.dart';

import 'package:provider/provider.dart';
import 'package:geo_rider/Assistants/requestAssistant.dart';
import 'package:geo_rider/DataHandler/appData.dart';
import 'package:geo_rider/Models/address.dart';

import '../DataHandler/appData.dart';

class AssistantMethods {
  static Future<String> searchCoordinateAddress(
      Position position, context) async {
    String placeAddress = "";

    String url =
        "https://nominatim.openstreetmap.org/reverse?format=jsonv2&lat=${position.latitude}&lon=${position.longitude}";
//https://nominatim.openstreetmap.org/reverse?format=jsonv2&lat=27.7012547&lon=85.3474405
    print(url);
    var response = await RequestAssistant.getRequest(url);

    if (response != "failed") {
      placeAddress = response["display_name"];

      Address userPickupAddress = new Address();
      userPickupAddress.longitude = position.longitude;
      userPickupAddress.latitude = position.latitude;
      userPickupAddress.placeName = placeAddress;

      Provider.of<AppData>(context, listen: false)
          .updatePickUpLocationAddress(userPickupAddress);
    }
    return placeAddress;
  }

  static double createRandomNumber(int number) {
    var random = Random();
    int radNumber = random.nextInt(number);
    return radNumber.toDouble();
  }

//history

  static String formatTripDate(String date) {
    DateTime dateTime = DateTime.parse(date);
    String formattedDate =
        "${DateFormat.MMMd().format(dateTime)}, ${DateFormat.y().format(dateTime)} - ${DateFormat.jm().format(dateTime)}";

    return formattedDate;
  }
}
