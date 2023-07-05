import 'dart:ui';

import 'package:anime_track/screens/watchlist/watchlist_body.dart';
import 'package:anime_track/size_config.dart';
import 'package:flutter/material.dart';

import '../../colors.dart';

class WatchListLanding extends StatefulWidget {
  const WatchListLanding({super.key});

  @override
  State<WatchListLanding> createState() => _WatchListLandingState();
}

class _WatchListLandingState extends State<WatchListLanding> {
  int _selectedIndex = 0;

  List<String> watchStatusItems = ['Watched', 'Watching', 'Want to Watch'];
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: kBgColor,
      appBar: PreferredSize(
        preferredSize: Size(
          double.infinity,
          AppBar().preferredSize.height,
        ),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
            child: AppBar(
              title: Image.asset(
                'assets/appbar/logo.png',
                height: AppBar().preferredSize.height,
                fit: BoxFit.fitHeight,
              ),
              backgroundColor: kBgColor.withOpacity(0),
              centerTitle: true,
              elevation: 0,
              leading: Container(
                padding: EdgeInsets.only(left: 16.0),
                child: IconButton(
                  icon:
                      Icon(Icons.arrow_back_ios_new_rounded, color: kTextColor),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),
          ),
        ),
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
          return ConstrainedBox(
            constraints:
                BoxConstraints(minHeight: viewportConstraints.maxHeight),
            child: Container(
              child: Column(
                children: [
                  Divider(
                      height: MediaQuery.of(context).size.width * 0.05,
                      color: Colors.transparent),
                  SizedBox(
                    height: MediaQuery.of(context).size.width * 0.1,
                    child: ListView(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buttonBuilder('Watched', 0),
                        _buttonBuilder('Watching', 1),
                        _buttonBuilder('Want to Watch', 2),
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.transparent,
                    height: 5,
                  ),
                  Expanded(
                      child: WatchlistBody(
                    watchStatus: watchStatusItems[_selectedIndex],
                  )),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buttonBuilder(String name, int myIndex) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = myIndex;
        });
      },
      child: FittedBox(
        child: Container(
          // width: MediaQuery.of(context).size.width*0.25,
          margin: EdgeInsets.symmetric(horizontal: 5),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2.5),
          decoration: BoxDecoration(
            color: _selectedIndex == myIndex ? kBgColor : kPrimaryColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: kPrimaryColor,
              width: 1,
            ),
          ),
          child: Text(
            name,
            style: TextStyle(
              fontSize: SizeConfig.screenWidth*0.03,
              fontWeight: FontWeight.bold,
              fontFamily: 'Muli',
              color: _selectedIndex == myIndex ? kPrimaryColor : kBgColor,
            ),
          ),
        ),
      ),
    );
  }
}
