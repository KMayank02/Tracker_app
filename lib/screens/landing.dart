import 'dart:ui';

import 'package:anime_track/colors.dart';
import 'package:anime_track/screens/favourites/favourites_body.dart';
import 'package:anime_track/screens/home/components/home_body.dart';
import 'package:anime_track/screens/profile/profile_body.dart';
import 'package:anime_track/screens/search_screen.dart';
import 'package:anime_track/screens/watchlist/watchlist_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/botnavbar/botnavbar_bloc.dart';
import '../bloc/botnavbar/botnavbar_states.dart';
import '../bloc/botnavbar/botnvabar_events.dart';
import 'package:flutter/cupertino.dart';

List<BottomNavigationBarItem> bottomNavItems = const <BottomNavigationBarItem>[
  BottomNavigationBarItem(
    icon: Icon(CupertinoIcons.house),
    label: 'Home',
  ),
  BottomNavigationBarItem(
    icon: Icon(CupertinoIcons.heart_circle),
    label: 'Favourites',
  ),
  BottomNavigationBarItem(
    icon: Icon(CupertinoIcons.person_crop_circle),
    label: 'Profile',
  ),
];

const List<Widget> bottomNavScreen = <Widget>[
  HomeBody(),
  FavouritesBody(),
  ProfileBody()
];

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    final BottomNavigationBloc bottomNavigationBloc = BottomNavigationBloc();

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        extendBodyBehindAppBar: true,
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
                actions: [
                  Container(
                    padding: EdgeInsets.only(right: 16.0),
                    child: IconButton(
                      icon: Icon(CupertinoIcons.search,
                      color: kTextColor,),
                      onPressed: () {
                         Navigator.of(context, rootNavigator: true)
                            .push(MaterialPageRoute(
                                builder: (context) => SearchAnimeScreen()));
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: BlocBuilder<BottomNavigationBloc, BottomNavigationState>(
          bloc: bottomNavigationBloc,
          builder: (BuildContext context, BottomNavigationState state) {
            return bottomNavScreen[state.tabIndex];
          },
        ),
        bottomNavigationBar:
            BlocBuilder<BottomNavigationBloc, BottomNavigationState>(
                bloc: bottomNavigationBloc,
                builder: (BuildContext context, BottomNavigationState state) {
                  return BottomNavigationBar(
                    
                    backgroundColor: kBgColor,
                    selectedItemColor: kPrimaryColor,
                    unselectedItemColor: kTextColor,
                    showSelectedLabels: false,
                    showUnselectedLabels: false,
                    currentIndex: state.tabIndex,
                    items: bottomNavItems,
                    onTap: (index) =>
                        bottomNavigationBloc.add(TabChange(tabIndex: index)),
                  );
                }),
      ),
    );
  }
}
