import 'dart:ui';

import 'package:anime_track/bloc/user/user_events.dart';
import 'package:anime_track/models/watchlist_model.dart';
import 'package:anime_track/bloc/anime/anime_bloc.dart';
import 'package:anime_track/bloc/anime/anime_events.dart';
import 'package:anime_track/helper_screens/error_screen.dart';
import 'package:anime_track/helper_screens/no_results.dart';
import 'package:anime_track/size_config.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../bloc/user/user_bloc.dart';
import '../../bloc/user/user_states.dart';
import '../../colors.dart';
import '../anime_detail/anime_detail.dart';
import '../../bloc/anime/anime_states.dart';
import '../../helper_screens/loader_dialog.dart';

class WatchlistBody extends StatefulWidget {
  final String watchStatus;
  const WatchlistBody({super.key, required this.watchStatus});

  @override
  State<WatchlistBody> createState() => _WatchlistBodyState();
}

class _WatchlistBodyState extends State<WatchlistBody> {
  final User? user = FirebaseAuth.instance.currentUser;
  final WatchlistFetchBloc _watchlistFetchBloc = WatchlistFetchBloc();
  final UserActivityBloc _userActivityBloc = UserActivityBloc();

  void initState() {
    // _favouritesFetchBloc.add(FavouritesFetchInitialEvent(user!.uid));
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
          _watchlistFetchBloc.add(WatchlistFetchInitialEvent(user!.uid));
          return Future.delayed(Duration(seconds: 1));
        },
        child: BlocConsumer<UserActivityBloc, UserActivityState>(
          bloc: _userActivityBloc,
          listener: (context, state) {},
          buildWhen: (previous, current) => current is WatchSelectState,
          builder: (context, state) {
            _watchlistFetchBloc.add(WatchlistFetchInitialEvent(user!.uid));
            return BlocConsumer<WatchlistFetchBloc, WatchlistFetchState>(
              bloc: _watchlistFetchBloc,
              listener: (context, state) {},
              builder: (context, state) {
                switch (state.runtimeType) {
                  case WatchlistFetchLoadingState:
                    return LoaderDialog(w: SizeConfig.screenWidth * 0.4);
      
                  case WatchlistFetchSuccessfulState:
                    final watchlistState = state as WatchlistFetchSuccessfulState;
                    // List<WatchlistTile> watchlistAnime = watchlistState.watchlist;
                    if (watchlistState.watchlist.isNotEmpty) {
                      watchlistState.watchlist.sort((a, b) {
                        return a.titleEnglish
                            .toLowerCase()
                            .compareTo(b.titleEnglish.toLowerCase());
                      });
                      List<WatchlistTile> localList = [];
                      localList = List.from(watchlistState.watchlist.where(
                          (element) => element.watchStatus == widget.watchStatus));
                      if (localList.isNotEmpty) {
                        return SingleChildScrollView(
                          child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            direction: Axis.vertical,
                            children: [
                              Text(
                                'Anime Count :  ${localList.length}',
                                style: TextStyle(
                                  fontSize: SizeConfig.screenWidth * 0.05,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Muli',
                                  color: kTextColor,
                                ),
                              ),
                              Divider(
                                color: Colors.transparent,
                                height: 5,
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.height,
                                width: MediaQuery.of(context).size.width,
                                child: ListView.separated(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  separatorBuilder: (context, index) => Divider(
                                    color: Colors.transparent,
                                    height: 2,
                                  ),
                                  itemCount: localList.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    List<String> watchItems = [];
                                    switch (localList[index].airStatus) {
                                      case "Completed":
                                        watchItems = [
                                          'Unwatched',
                                          'Want to Watch',
                                          'Watching',
                                          'Watched'
                                        ];
                                        break;
                                      case "Airing":
                                        watchItems = [
                                          'Unwatched',
                                          'Want to Watch',
                                          'Watching'
                                        ];
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
                                    return Container(
                                      padding: EdgeInsets.symmetric(horizontal: 15),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.of(context, rootNavigator: true)
                                              .push(MaterialPageRoute(
                                                  builder: (context) =>
                                                      AnimeDetailScreen(
                                                          malID: localList[index]
                                                              .malId)));
                                        },
                                        child: Card(
                                          color: kBgColor2,
                                          borderOnForeground: true,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                          elevation: 0,
                                          shadowColor: kTextColor,
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            padding: EdgeInsets.all(10),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: [
                                                Flexible(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        localList[index]
                                                                    .titleEnglish !=
                                                                'TBA'
                                                            ? localList[index]
                                                                .titleEnglish
                                                            : localList[index]
                                                                .title,
                                                        style: TextStyle(
                                                            fontFamily: 'Muli',
                                                            color: kTextColor,
                                                            fontSize: SizeConfig
                                                                    .screenWidth *
                                                                0.04,
                                                            fontWeight:
                                                                FontWeight.bold),
                                                        maxLines: 2,
                                                        overflow:
                                                            TextOverflow.ellipsis,
                                                      ),
                                                      Text(
                                                        "${localList[index].season[0].toUpperCase()}${localList[index].season.substring(1).toLowerCase()}\t${localList[index].year.toString()}",
                                                        style: TextStyle(
                                                            fontFamily: 'Muli',
                                                            color: kPrimaryColor,
                                                            fontSize: SizeConfig
                                                                    .screenWidth *
                                                                0.035,
                                                            fontWeight:
                                                                FontWeight.bold),
                                                        maxLines: 2,
                                                        overflow:
                                                            TextOverflow.ellipsis,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Flexible(
                                                  child: Container(
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal: 10),
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: kPrimaryColor,
                                                            width: 1),
                                                        color: kBgColor,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                10)),
                                                    child: DropdownButton(
                                                      style: TextStyle(
                                                          fontSize: SizeConfig
                                                                  .screenWidth *
                                                              0.04,
                                                          color: kTextColor,
                                                          fontFamily: 'Muli',
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      elevation: 0,
                                                      focusColor: kTextColor,
                                                      iconEnabledColor:
                                                          kPrimaryColor,
                                                      dropdownColor: kPrimaryColor
                                                          .withOpacity(0.9),
                                                      // hint: Text("Names"),
                                                      underline: SizedBox(),
                                                      value: widget.watchStatus,
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
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        );
                                                      }).toList(),
                                                      onChanged: (value) {
                                                        _userActivityBloc.add(
                                                            WatchSelectEvent(
                                                                user: user!,
                                                                anime: localList[
                                                                    index],
                                                                type: value!));
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return NoResultsScreen();
                      }
                    }
                    return NoResultsScreen();
                  // return LayoutBuilder(
                  //   builder:
                  //       (BuildContext context, BoxConstraints viewportConstraints) {
                  //     return SingleChildScrollView(
                  //       child: ConstrainedBox(
                  //         constraints: BoxConstraints(minHeight: viewportConstraints.maxHeight),
                  //         child: Container(
                  //           child: ListView.builder(itemBuilder: itemBuilder),
                  //         ),
                  //       ),
                  //     );
                  //   },
                  // );
      
                  case WatchlistFetchErrorState:
                    return ErrorScreen();
      
                  default:
                    return Container();
                }
              },
            );
          },
        ),
      ),
    );
  }
}
