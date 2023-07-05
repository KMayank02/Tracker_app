import 'dart:ui';

import 'package:anime_track/bloc/user/user_bloc.dart';
import 'package:anime_track/bloc/user/user_events.dart';
import 'package:anime_track/models/anime_model.dart';
import 'package:anime_track/models/watchlist_model.dart';
import 'package:anime_track/screens/anime_detail/components/back_image.dart';
import 'package:anime_track/screens/anime_detail/components/dummy_scaffold.dart';
import 'package:anime_track/screens/anime_detail/components/genre_list.dart';
import 'package:anime_track/screens/anime_detail/components/info_card.dart';
import 'package:anime_track/screens/anime_detail/components/recommendations.dart';
import 'package:anime_track/screens/anime_detail/components/relations.dart';
import 'package:anime_track/screens/anime_detail/components/star_rating.dart';
import 'package:anime_track/bloc/anime/anime_events.dart';
import 'package:anime_track/helper_screens/error_screen.dart';
import 'package:anime_track/helper_screens/loader_dialog.dart';
import 'package:anime_track/size_config.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shape_of_view_null_safe/shape_of_view_null_safe.dart';

import '../../bloc/user/user_states.dart';
import '../../colors.dart';
import '../../models/animetile_model.dart';
import '../../bloc/anime/anime_bloc.dart';
import '../../bloc/anime/anime_states.dart';

class AnimeDetailScreen extends StatefulWidget {
  final int malID;
  const AnimeDetailScreen({super.key, required this.malID});

  @override
  State<AnimeDetailScreen> createState() => _AnimeDetailScreenState();
}

class _AnimeDetailScreenState extends State<AnimeDetailScreen> {
  final User? user = FirebaseAuth.instance.currentUser;
  final FavouriteBoolBloc _favouritesBloc = FavouriteBoolBloc();
  final AnimeDataBloc _animeDataBloc = AnimeDataBloc();
  final UserActivityBloc _userActivityBloc = UserActivityBloc();
  final WatchStatusBloc _watchStatusBloc = WatchStatusBloc();

  @override
  void initState() {
    _animeDataBloc.add(AnimeDataInitialFetchEvent(widget.malID));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
      child: RefreshIndicator(
        backgroundColor: kBgColor2,
        color: kPrimaryColor,
        onRefresh: () {
          _animeDataBloc.add(AnimeDataInitialFetchEvent(widget.malID));
          return Future.delayed(Duration(seconds: 2));
        },
        child: BlocConsumer<AnimeDataBloc, AnimeDataState>(
          bloc: _animeDataBloc,
          listener: (context, state) {
            // TODO: implement listener
          },
          builder: (context, state) {
            switch (state.runtimeType) {
              case AnimeDataFetchingLoadingState:
                {
                  return DummyScaffold(
                      body: LoaderDialog(
                    w: SizeConfig.screenWidth * 0.4,
                  ));
                }

              case AnimeDataFetchingSuccessfulState:
                {
                  final animeDataSuccessState =
                      state as AnimeDataFetchingSuccessfulState;
                  final animeData = animeDataSuccessState.anime;
                  print(animeData.relations.length);
                  _favouritesBloc
                      .add(FavouriteBoolInitialEvent(user!.uid, animeData));
                  _watchStatusBloc
                      .add(WatchStatusFetchInitialEvent(user!.uid, animeData));
                  List<String> watchItems = [];
                  switch (animeData.status) {
                    case "Completed":
                      watchItems = [
                        'Unwatched',
                        'Want to Watch',
                        'Watching',
                        'Watched'
                      ];
                      break;
                    case "Airing":
                      watchItems = ['Unwatched', 'Want to Watch', 'Watching'];
                      break;
                    case "Upcoming":
                      watchItems = ['Unwatched', 'Want to Watch'];
                      break;
                    default:
                      watchItems = [
                        'Unwatched',
                        'Want to Watch',
                        'Watching',
                        'Watched'
                      ];
                      break;
                  }

                  return Scaffold(
                    backgroundColor: kBgColor,
                    extendBodyBehindAppBar: true,
                    appBar: PreferredSize(
                      preferredSize: Size(
                        double.infinity,
                        AppBar().preferredSize.height,
                      ),
                      child: ClipRRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                          child: AppBar(
                            title: Image.asset(
                              'assets/appbar/logo.png',
                              height: AppBar().preferredSize.height,
                              fit: BoxFit.fitHeight,
                            ),
                            backgroundColor: kBgColor.withOpacity(0.0),
                            centerTitle: true,
                            elevation: 0,
                            leading: Container(
                              padding: EdgeInsets.only(left: 16.0),
                              child: IconButton(
                                icon: Icon(Icons.arrow_back_ios_new_rounded,
                                    color: kTextColor),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ),
                            actions: [
                              BlocConsumer<FavouriteBoolBloc,
                                  FavouriteBoolState>(
                                bloc: _favouritesBloc,
                                listener: (context, state) {},
                                builder: (context, state) {
                                  if (state.runtimeType ==
                                      FavouriteBoolSuccessfulState) {
                                    final isFavState =
                                        state as FavouriteBoolSuccessfulState;
                                    return BlocConsumer<UserActivityBloc,
                                        UserActivityState>(
                                      bloc: _userActivityBloc,
                                      listener: (context, state) {
                                        // TODO: implement listener
                                      },
                                      buildWhen: (previous, current) =>
                                          current is AnimeFavouriteClickedState,
                                      builder: (context, state) {
                                        if (state.runtimeType ==
                                            AnimeFavouriteClickedState) {
                                          final favState = state
                                              as AnimeFavouriteClickedState;
                                          return Container(
                                            padding:
                                                EdgeInsets.only(right: 16.0),
                                            child: IconButton(
                                              icon: !favState.fav
                                                  ? Icon(
                                                      Icons
                                                          .favorite_border_rounded,
                                                      color: kTextColor,
                                                    )
                                                  : Icon(
                                                      Icons.favorite_rounded,
                                                      color: kRedColor,
                                                    ),
                                              onPressed: () {
                                                _userActivityBloc.add(
                                                    AnimeFavouriteClickedEvent(
                                                        user: user!,
                                                        anime: animeData,
                                                        fav: favState.fav));
                                              },
                                            ),
                                          );
                                        }
                                        return Container(
                                          padding: EdgeInsets.only(right: 16.0),
                                          child: IconButton(
                                            icon: !isFavState.isFav
                                                ? Icon(
                                                    Icons
                                                        .favorite_border_rounded,
                                                    color: kTextColor,
                                                  )
                                                : Icon(
                                                    Icons.favorite_rounded,
                                                    color: kRedColor,
                                                  ),
                                            onPressed: () {
                                              _userActivityBloc.add(
                                                  AnimeFavouriteClickedEvent(
                                                      user: user!,
                                                      anime: animeData,
                                                      fav: isFavState.isFav));
                                            },
                                          ),
                                        );
                                      },
                                    );
                                  }
                                  return BlocConsumer<UserActivityBloc,
                                      UserActivityState>(
                                    bloc: _userActivityBloc,
                                    listener: (context, state) {
                                      // TODO: implement listener
                                    },
                                    buildWhen: (previous, current) =>
                                        current is AnimeFavouriteClickedState,
                                    builder: (context, state) {
                                      if (state.runtimeType ==
                                          AnimeFavouriteClickedState) {
                                        final favState =
                                            state as AnimeFavouriteClickedState;
                                        return Container(
                                          padding: EdgeInsets.only(right: 16.0),
                                          child: IconButton(
                                            icon: !favState.fav
                                                ? Icon(
                                                    Icons
                                                        .favorite_border_rounded,
                                                    color: kTextColor,
                                                  )
                                                : Icon(
                                                    Icons.favorite_rounded,
                                                    color: kRedColor,
                                                  ),
                                            onPressed: () {
                                              _userActivityBloc.add(
                                                  AnimeFavouriteClickedEvent(
                                                      user: user!,
                                                      anime: animeData,
                                                      fav: favState.fav));
                                            },
                                          ),
                                        );
                                      }
                                      return Container(
                                        padding: EdgeInsets.only(right: 16.0),
                                        child: IconButton(
                                          icon: !false
                                              ? Icon(
                                                  Icons.favorite_border_rounded,
                                                  color: kTextColor,
                                                )
                                              : Icon(
                                                  Icons.favorite_rounded,
                                                  color: kRedColor,
                                                ),
                                          onPressed: () {
                                            _userActivityBloc.add(
                                                AnimeFavouriteClickedEvent(
                                                    user: user!,
                                                    anime: animeData,
                                                    fav: false));
                                          },
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    body: LayoutBuilder(
                      builder: (BuildContext context,
                          BoxConstraints viewportConstraints) {
                        final width = MediaQuery.of(context).size.width;
                        // final contentHeight =
                        //     2.0 * (MediaQuery.of(context).size.width / 2.2) / 3.0;
                        final contentHeight =
                            4.0 * (MediaQuery.of(context).size.width / 2.4) / 3;
                        // final height = MediaQuery.of(context).size.height;
                        // var ratingStarSizeRelativeToScreen =
                        //     MediaQuery.of(context).size.width / 5;
                        return SingleChildScrollView(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                                minHeight: viewportConstraints.maxHeight),
                            child: Container(
                              child: Column(
                                children: [
                                  BackImage(
                                    imageUrl: animeData.imageUrl,
                                    trailerUrl: animeData.trailerUrl,
                                  ),
                                  Column(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.only(
                                            left: 16.0,
                                            right: 16.0,
                                            top: 8.0,
                                            bottom: 8.0),
                                        child: Text(
                                          animeData.titleEnglish != 'TBA'
                                              ? animeData.titleEnglish
                                              : animeData.title,
                                          // maxLines: 2,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize:
                                                SizeConfig.screenWidth * 0.07,
                                            color: kTextColor,
                                            fontFamily: 'Muli',
                                          ),
                                        ),
                                      ),
                                      GenreList(genres: animeData.genres),
                                      StarRating(score: animeData.score / 2),
                                      InfoCard(anime: animeData),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: kPrimaryColor, width: 2),
                                            color: kBgColor,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: BlocConsumer<WatchStatusBloc,
                                            WatchStatusState>(
                                          bloc: _watchStatusBloc,
                                          listener: (context, state) {},
                                          builder: (context, state) {
                                            if (state.runtimeType ==
                                                WatchStatusSuccessfulState) {
                                              final watchTypeState = state
                                                  as WatchStatusSuccessfulState;
                                              return BlocConsumer<
                                                  UserActivityBloc,
                                                  UserActivityState>(
                                                bloc: _userActivityBloc,
                                                listener: (context, state) {},
                                                buildWhen: (previous,
                                                        current) =>
                                                    current is WatchSelectState,
                                                builder: (context, state) {
                                                  if (state.runtimeType ==
                                                      WatchSelectState) {
                                                    final watchState = state
                                                        as WatchSelectState;
                                                    return DropdownButton(
                                                      elevation: 0,
                                                      focusColor: Colors.white,
                                                      iconEnabledColor:
                                                          kPrimaryColor,
                                                      dropdownColor:
                                                          kPrimaryColor
                                                              .withOpacity(0.9),
                                                      // hint: Text("Names"),
                                                      underline: SizedBox(),
                                                      value: watchState.type,
                                                      items: watchItems.map(
                                                          (String typevalue) {
                                                        return DropdownMenuItem(
                                                          value: typevalue,
                                                          child: Text(
                                                            typevalue,
                                                            style: TextStyle(
                                                                fontSize: SizeConfig
                                                                        .screenWidth *
                                                                    0.04,
                                                                color:
                                                                    kTextColor,
                                                                fontFamily:
                                                                    'Muli',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        );
                                                      }).toList(),
                                                      onChanged: (value) {
                                                        _userActivityBloc.add(WatchSelectEvent(
                                                            user: user!,
                                                            anime: WatchlistTile(
                                                                imageUrl:
                                                                    animeData
                                                                        .imageUrl,
                                                                malId: animeData
                                                                    .malId,
                                                                title: animeData
                                                                    .title,
                                                                titleEnglish:
                                                                    animeData
                                                                        .titleEnglish,
                                                                year: animeData
                                                                    .airingDate,
                                                                season:
                                                                    animeData
                                                                        .season,
                                                                airStatus:
                                                                    animeData
                                                                        .status),
                                                            type: value!));
                                                      },
                                                    );
                                                  }
                                                  return DropdownButton(
                                                    elevation: 0,
                                                    focusColor: Colors.white,
                                                    iconEnabledColor:
                                                        kPrimaryColor,
                                                    dropdownColor: kPrimaryColor
                                                        .withOpacity(0.9),
                                                    // hint: Text("Names"),
                                                    // hint: Text("Names"),
                                                    value: watchTypeState
                                                                .type ==
                                                            ''
                                                        ? 'Unwatched'
                                                        : watchTypeState.type,
                                                    underline: SizedBox(),
                                                    items: watchItems.map(
                                                        (String typevalue) {
                                                      return DropdownMenuItem(
                                                        value: typevalue,
                                                        child: Text(
                                                          typevalue,
                                                          style: TextStyle(
                                                              fontSize: SizeConfig
                                                                      .screenWidth *
                                                                  0.04,
                                                              color: kTextColor,
                                                              fontFamily:
                                                                  'Muli',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      );
                                                    }).toList(),
                                                    onChanged: (value) {
                                                      _userActivityBloc.add(WatchSelectEvent(
                                                          user: user!,
                                                          anime: WatchlistTile(
                                                              imageUrl:
                                                                  animeData
                                                                      .imageUrl,
                                                              malId: animeData
                                                                  .malId,
                                                              title: animeData
                                                                  .title,
                                                              titleEnglish:
                                                                  animeData
                                                                      .titleEnglish,
                                                              year: animeData
                                                                  .airingDate,
                                                              season: animeData
                                                                  .season,
                                                              airStatus:
                                                                  animeData
                                                                      .status),
                                                          type: value!));
                                                    },
                                                  );
                                                },
                                              );
                                            }
                                            return DropdownButton(
                                              elevation: 0,
                                              focusColor: Colors.white,
                                              iconEnabledColor: kPrimaryColor,
                                              dropdownColor: kPrimaryColor
                                                  .withOpacity(0.9),
                                              value: 'Unwatched',
                                              underline: SizedBox(),
                                              items: watchItems
                                                  .map((String typevalue) {
                                                return DropdownMenuItem(
                                                  value: typevalue,
                                                  child: Text(
                                                    typevalue,
                                                    style: TextStyle(
                                                        fontSize: SizeConfig
                                                                .screenWidth *
                                                            0.04,
                                                        color: kTextColor,
                                                        fontFamily: 'Muli',
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                );
                                              }).toList(),
                                              onChanged: (value) {
                                                _userActivityBloc.add(
                                                    WatchSelectEvent(
                                                        user: user!,
                                                        anime: WatchlistTile(
                                                            imageUrl: animeData
                                                                .imageUrl,
                                                            malId:
                                                                animeData.malId,
                                                            title:
                                                                animeData.title,
                                                            titleEnglish:
                                                                animeData
                                                                    .titleEnglish,
                                                            year: animeData
                                                                .airingDate,
                                                            season: animeData
                                                                .season,
                                                            airStatus: animeData
                                                                .status),
                                                        type: value!));
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        margin: EdgeInsets.only(
                                            left: 24.0, right: 24.0, top: 8.0),
                                        child: Text(
                                          animeData.synopsis,
                                          textAlign: TextAlign.justify,
                                          style: TextStyle(
                                            fontSize:
                                                SizeConfig.screenWidth * 0.039,
                                            color: kTextColor,
                                            fontFamily: 'Muli',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  // Divider(height: 8.0, color: Colors.transparent),
                                  Relations(relIds: animeData.relations),
                                  Recommendations(malId: animeData.malId)
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
              case AnimeDataFetchingErrorState:
                {
                  return DummyScaffold(body: ErrorScreen());
                }
              default:
                {
                  return DummyScaffold(body: Container());
                }
            }
          },
        ),
      ),
    );
  }
}
