import 'package:anime_track/bloc/auth/auth_events.dart';
import 'package:anime_track/bloc/auth/auth_bloc.dart';
import 'package:anime_track/colors.dart';
import 'package:flutter/material.dart';

import '../../../size_config.dart';
import 'google_button.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final AppBloc _topAnimeBloc = AppBloc();

  void initState() {
    _topAnimeBloc.add(AppEventInitialize());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                      'assets/icons/leaf.png',
                      width: SizeConfig.screenWidth*0.4,
                    ),
                  // SizedBox(height: 10),
                  Image.asset(
                      'assets/appbar/logo.png',
                      width: SizeConfig.screenWidth,
                    ),
                  Text(
                    'Never Lose Track',
                    style: TextStyle(
                        color: kTextColor,
                        fontFamily: 'Muli',
                        fontSize: SizeConfig.screenWidth*0.06,
                        fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 50),
                  GoogleSignInButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
