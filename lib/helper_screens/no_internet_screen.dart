import 'package:anime_track/colors.dart';
import 'package:anime_track/size_config.dart';
import 'package:flutter/material.dart';

class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: kBgColor,
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Spacer(
                  flex: 2,
                ),
                Image.asset(
                  'assets/errors/noInternet.png',
                  width: SizeConfig.screenWidth * 0.8,
                ),
                Spacer(),
                Text(
                  "No Internet!",
                  style: TextStyle(
                      color: kTextColor,
                      fontFamily: 'Muli',
                      fontWeight: FontWeight.bold,
                      fontSize: SizeConfig.screenWidth * 0.1),
                  textAlign: TextAlign.center,
                ),
                Text(
                  "Check your connection.",
                  style: TextStyle(
                      color: kTextColor,
                      fontFamily: 'Muli',
                      // fontWeight: FontWeight.bold,
                      fontSize: SizeConfig.screenWidth * 0.05),
                  textAlign: TextAlign.center,
                ),
                Spacer(
                  flex: 2,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
