import 'package:anime_track/colors.dart';
import 'package:anime_track/constants.dart';
import 'package:anime_track/models/animetile_model.dart';
import 'package:anime_track/screens/home/components/seasonal_anime_list.dart';
import 'package:anime_track/screens/home/components/upcoming_anime_list.dart';
import 'package:anime_track/size_config.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class CarouselNav extends StatefulWidget {
  // final AnimeTile an;
  const CarouselNav({super.key});

  @override
  State<CarouselNav> createState() => _CarouselNavState();
}

class _CarouselNavState extends State<CarouselNav> {
  List<List<String>> carousel = [];

  @override
  void initState() {
    carousel.add(getCurrentSeason());
    carousel.add(getUpcomingSeason());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return CarouselSlider.builder(
      itemCount: carousel.length,
      itemBuilder: (BuildContext context, int index, int realIndex) {
        final width = SizeConfig.screenWidth;
        return InkWell(
          onTap: () {
            Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
                builder: (context) => carousel[index][2] == '0'
                    ? SeasonalListScreen(
                        imagePath: carousel[index][1],
                      )
                    : UpcomingListScreen(
                        imagePath: carousel[index][1],
                      )));
          },
          child: Container(
            width: width,
            height: double.infinity,
            padding: EdgeInsets.only(bottom: 20.0),
            child: Card(
              elevation: 2,
              shadowColor: kPrimaryColor,
              borderOnForeground: false,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Container(
                width: width,
                height: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Stack(
                    children: [
                      Image.asset(
                        carousel[index][1],
                        width: width,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      Container(
                          width: width,
                          height: double.infinity,
                          padding: EdgeInsets.only(left: 16.0, bottom: 20.0),
                          alignment: Alignment.bottomLeft,
                          child: Center(
                            child: Stack(
                              children: <Widget>[
                                Text(
                                  carousel[index][0],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: SizeConfig.screenWidth*0.08,
                                    fontWeight: FontWeight.bold,
                                    foreground: Paint()
                                      ..style = PaintingStyle.stroke
                                      ..strokeWidth = 2
                                      ..color = Colors.black,
                                  ),
                                ),
                                Text(
                                  carousel[index][0],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: SizeConfig.screenWidth*0.08,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
      options: CarouselOptions(
        enableInfiniteScroll: true,
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 4),
        autoPlayAnimationDuration: Duration(milliseconds: 800),
        pauseAutoPlayOnTouch: true,
        viewportFraction: 0.8,
        enlargeCenterPage: true,
      ),
    );
  }
}
