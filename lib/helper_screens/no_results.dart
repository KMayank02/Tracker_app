import 'package:anime_track/colors.dart';
import 'package:anime_track/size_config.dart';
import 'package:flutter/material.dart';

class NoResultsScreen extends StatelessWidget {
  const NoResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
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
                'assets/errors/noResults.png',
                width: SizeConfig.screenWidth * 0.7,
              ),
              Spacer(),
              Text(
                "No Results Found",
                style: TextStyle(
                    color: kTextColor,
                    fontFamily: 'Muli',
                    fontWeight: FontWeight.bold,
                    fontSize: SizeConfig.screenWidth * 0.1),
                textAlign: TextAlign.center,
              ),
              Text(
                "We couldn't find what you're looking for.",
                style: TextStyle(
                    color: kTextColor,
                    fontFamily: 'Muli',
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
    );
  }
}
