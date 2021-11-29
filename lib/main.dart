//import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:geo_rider/AllScreens/mainscreen.dart';

import 'package:geo_rider/DataHandler/appData.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppData(),
      child: MaterialApp(
          title: 'Nepali Rider',
          theme: ThemeData(
            //  fontFamily: "Brand Bold",
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          initialRoute: MainScreen.idScreen,
          routes: {
            MainScreen.idScreen: (context) => MainScreen(),
          }),
    );
  }
}
