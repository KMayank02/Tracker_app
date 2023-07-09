import 'dart:ui';

import 'package:anime_track/models/animetile_model.dart';
import 'package:anime_track/screens/anime_detail/anime_detail.dart';
import 'package:anime_track/size_config.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:shimmer/shimmer.dart';

import '../../../colors.dart';
import '../../../helper_screens/animelist.dart';

class MoviesAnimeList extends StatefulWidget {
  final List<AnimeTile> anime;
  const MoviesAnimeList({super.key, required this.anime});

  @override
  State<MoviesAnimeList> createState() => _MoviesAnimeListState();
}

class _MoviesAnimeListState extends State<MoviesAnimeList> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final contentHeight = 4.0 * (SizeConfig.screenWidth / 2.4) / 3;
    return Container(
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(left: 20.0, right: 16.0),
            height: 48.0,
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    "Top Movies",
                    style: TextStyle(
                      color: kTextColor,
                      fontSize: SizeConfig.screenWidth*0.05,
                      fontFamily: 'Muli',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.arrow_forward, color: kTextColor),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).push(
                        MaterialPageRoute(
                            builder: (context) => AnimeListScreen(
                                anime: widget.anime, title: "movies")));
                  },
                )
              ],
            ),
          ),
          Container(
            height: contentHeight,
            child: ListView.separated(
              padding: EdgeInsets.only(left: 16.0, right: 16.0),
              scrollDirection: Axis.horizontal,
              separatorBuilder: (context, index) => VerticalDivider(
                color: Colors.transparent,
                width: 6.0,
              ),
              itemCount: 10,
              itemBuilder: (BuildContext context, int index) {
                final width = MediaQuery.of(context).size.width / 2.6;
                return InkWell(
                  onTap: () {
                    Navigator.of(context, rootNavigator: true)
                        .push(MaterialPageRoute(
                            builder: (context) => AnimeDetailScreen(
                                  malID: widget.anime[index].malId,
                                )));
                  },
                  child: Stack(
                    children: [
                      Container(
                        width: width,
                        height: double.infinity,
                        padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.01,
                            right: MediaQuery.of(context).size.width * 0.01,
                            bottom: MediaQuery.of(context).size.width * 0.04),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: CachedNetworkImage(
                            errorWidget: (context, url, error) =>
                                Image.asset('assets/icons/leaf.png'),
                            placeholder: (context, url) => Shimmer.fromColors(
                                child: Container(
                                  color: kBgColor,
                                ),
                                baseColor: kBgColor,
                                highlightColor: kPrimaryColor),
                            imageUrl: widget.anime[index].imageUrl,
                            width: width,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            width: width,
                            margin: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width * 0.01,
                                right: MediaQuery.of(context).size.width * 0.01,
                                bottom:
                                    MediaQuery.of(context).size.width * 0.04),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(8),
                                bottomRight: Radius.circular(8),
                              ),
                              color: kBgColor.withOpacity(0.3),
                              // boxShadow: kBoxShadow,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(8),
                                  bottomRight: Radius.circular(8)),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal:
                                          MediaQuery.of(context).size.width *
                                              0.01,
                                      vertical:
                                          MediaQuery.of(context).size.width *
                                              0.02),
                                  child: Text(
                                    widget.anime[index].titleEnglish != 'TBA'
                                        ? widget.anime[index].titleEnglish
                                        : widget.anime[index].title,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: 'Muli',
                                        color: kTextColor,
                                        fontSize: SizeConfig.screenWidth * 0.04,
                                        fontWeight: FontWeight.bold),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
