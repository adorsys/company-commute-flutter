import 'package:company_commute/screens/commutes_list.dart';
import 'package:company_commute/utils/colors.dart';
import 'package:firebase/firebase.dart';
import 'package:flutter/material.dart';

// Web is only able to display the CommuteList because the Google Map packages currently does not support web
start() {
  initializeApp(
    apiKey: "AIzaSyDSh7aqNSiwZwe5b-Yd6ssyGDcB3VL07zg",
    authDomain: "flutter-company-commute.firebaseapp.com",
    databaseURL: "https://flutter-company-commute.firebaseio.com",
    projectId: "flutter-company-commute",
    storageBucket: "flutter-company-commute.appspot.com",
  );
  runApp(MaterialApp(
      title: 'Company Commute Web',
      theme: ThemeData(
          primarySwatch: adorsysColor,
          floatingActionButtonTheme:
              FloatingActionButtonThemeData(backgroundColor: Colors.white)),
      home: CommutesListScreen()));
}