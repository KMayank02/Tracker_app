import 'package:anime_track/models/genre_model.dart';
import 'package:flutter/material.dart';

import '../../../colors.dart';

class GenreList extends StatelessWidget {
  final List<Genre> genres;
  const GenreList({super.key, required this.genres});

  @override
  Widget build(BuildContext context) {
    if (genres.isEmpty) {
      return Container();
    }
    return Container(
      padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0, bottom: 8.0),
      child: Wrap(
        alignment: WrapAlignment.center,
        children: genres.map((gen) => Text(
                '${gen.genreName}\t\t\t',
                maxLines: 2,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: kPrimaryColor,
                  fontFamily: 'Muli',
                ),
              )).toList(),
        // children: [
        //   ListView.separated(
        //     separatorBuilder: (context, index) => Text(" "),
        //     shrinkWrap: true,
        //     scrollDirection: Axis.horizontal,
        //     itemCount: genres.length,
        //     itemBuilder: (context, index) {
              // Text(
              //   genres[index].genreName,
              //   maxLines: 2,
              //   textAlign: TextAlign.center,
              //   style: TextStyle(
              //     fontSize: 15.0,
              //     color: kPrimaryColor,
              //     fontFamily: 'Muli',
              //   ),
              // );
        //     },
        //   )
        // ],
      ),
    );
  }
}
