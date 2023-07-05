import 'package:anime_track/bloc/auth/auth_bloc.dart';
import 'package:anime_track/colors.dart';
import 'package:anime_track/screens/home/home_screen.dart';
import 'package:anime_track/screens/sign_in/signin_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overlay_support/overlay_support.dart';

import 'app.dart';
import 'bloc/auth/auth_events.dart';
import 'bloc/auth/auth_states.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
        statusBarColor: kBgColor,
        systemNavigationBarColor: Colors.black,
        systemNavigationBarIconBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light),
  );
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(
    const OverlaySupport.global(child: App()),
  );
}
