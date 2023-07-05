import 'package:anime_track/size_config.dart';
import 'package:flutter/material.dart';

import '../../../colors.dart';
import '../../../models/anime_model.dart';

class InfoCard extends StatelessWidget {
  final Anime anime;
  const InfoCard({super.key, required this.anime});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Center(
      child: Container(
        padding:
            EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0, bottom: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(''),
            Column(
              children: [
                Text(
                  'Season',
                  style: TextStyle(
                    fontSize: SizeConfig.screenWidth*0.04,
                    color: kTextColor,
                    fontFamily: 'Muli',
                  ),
                ),
                Text(
                  anime.season != ''
                      ? anime.season[0].toUpperCase() +
                          anime.season.substring(1)
                      : 'NA',
                  style: TextStyle(
                    fontSize: SizeConfig.screenWidth * 0.05,
                    color: kPrimaryColor,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Muli',
                  ),
                )
              ],
            ),
            Column(
              children: [
                Text(
                  'Year',
                  style: TextStyle(
                    fontSize: SizeConfig.screenWidth * 0.04,
                    color: kTextColor,
                    fontFamily: 'Muli',
                  ),
                ),
                Text(
                  anime.airingDate.toString(),
                  style: TextStyle(
                    fontSize: SizeConfig.screenWidth * 0.05,
                    color: kPrimaryColor,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Muli',
                  ),
                )
              ],
            ),
            Column(
              children: [
                Text(
                  'Status',
                  style: TextStyle(
                    fontSize: SizeConfig.screenWidth * 0.04,
                    color: kTextColor,
                    fontFamily: 'Muli',
                  ),
                ),
                Text(
                  anime.status,
                  style: TextStyle(
                    fontSize: SizeConfig.screenWidth * 0.05,
                    color: kPrimaryColor,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Muli',
                  ),
                )
              ],
            ),
            Column(
              children: [
                Text(
                  'Episodes',
                  style: TextStyle(
                    fontSize: SizeConfig.screenWidth * 0.04,
                    color: kTextColor,
                    fontFamily: 'Muli',
                  ),
                ),
                Text(
                  anime.episodes > 0 ? anime.episodes.toString() : 'NA',
                  style: TextStyle(
                    fontSize: SizeConfig.screenWidth * 0.05,
                    color: kPrimaryColor,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Muli',
                  ),
                )
              ],
            ),
            Text(''),
          ],
        ),
      ),
    );
  }
}
