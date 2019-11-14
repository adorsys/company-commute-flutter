import 'package:company_commute/screens/commutes_list.dart';
import 'package:company_commute/utils/colors.dart';
import 'package:flutter/material.dart';

// Web is only able to display the CommuteList because the Google Map packages currently does not support web
start() {
  runApp(MaterialApp(
      title: 'Company Commute Web',
      theme: ThemeData(
          primarySwatch: adorsysColor,
          floatingActionButtonTheme:
              FloatingActionButtonThemeData(backgroundColor: Colors.white)),
      home: CommutesListScreen()));
}