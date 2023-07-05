import 'dart:async';

import 'package:anime_track/helper_screens/no_internet_screen.dart';
import 'package:anime_track/screens/landing.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class NetworkCheckerBody extends StatefulWidget {
  const NetworkCheckerBody({super.key});

  @override
  State<NetworkCheckerBody> createState() => _NetworkCheckerBodyState();
}

class _NetworkCheckerBodyState extends State<NetworkCheckerBody> {
  
  bool hide = false;

  final Connectivity connectivity = Connectivity();

  @override
  void initState() {
    connectivity.onConnectivityChanged.listen((event) {
      if (event == ConnectivityResult.none) {
        print(hide);
        setState(() {
          hide = true;
        });
      } else {
        print(hide);
        setState(() {
          hide = false;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: hide==true ? NoInternetScreen() : LandingPage(),
    );
  }
}
