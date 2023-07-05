import 'dart:ui';

import 'package:anime_track/bloc/auth/auth_events.dart';
import 'package:anime_track/colors.dart';
import 'package:anime_track/bloc/anime/anime_bloc.dart';
import 'package:anime_track/helper_screens/animelist.dart';
import 'package:anime_track/screens/home/components/home_body.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:stroke_text/stroke_text.dart';

import '../../models/animetile_model.dart';
import '../anime_detail/anime_detail.dart';
import '../../bloc/anime/anime_events.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TopAnimeBloc _topAnimeBloc= TopAnimeBloc();

  void initState() {
    _topAnimeBloc.add(TopAnimeInitialFetchEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final contentHeight = 4.0 * (MediaQuery.of(context).size.width / 2.4) / 3;
    return SafeArea(
      child: Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: kBgColor,
          appBar: PreferredSize(
            preferredSize: Size(
              double.infinity,
              56.0,
            ),
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: AppBar(
                  title: Image.asset(
                    'assets/appbar/logo.png',
                    height: 56.0,
                    fit: BoxFit.fitHeight,
                  ),
                  backgroundColor: kBgColor.withOpacity(0.3),
                  centerTitle: true,
                  elevation: 0,
                  leading: Container(
                    padding: EdgeInsets.only(left: 16.0),
                    child: IconButton(
                      icon: Icon(
                        Icons.menu_rounded,
                        color: kTextColor,
                      ),
                      onPressed: () {},
                    ),
                  ),
                  actions: [
                    Container(
                      padding: EdgeInsets.only(right: 16.0),
                      child: IconButton(
                        icon: Icon(
                          Icons.search_rounded,
                          color: kTextColor,
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: HomeBody()),
    );
  }
}
