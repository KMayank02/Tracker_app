import 'package:anime_track/colors.dart';
import 'package:anime_track/models/favourites_model.dart';
import 'package:anime_track/bloc/anime/anime_bloc.dart';
import 'package:anime_track/screens/anime_detail/anime_detail.dart';
import 'package:anime_track/bloc/anime/anime_events.dart';
import 'package:anime_track/bloc/anime/anime_states.dart';
import 'package:anime_track/helper_screens/error_screen.dart';
import 'package:anime_track/helper_screens/no_results.dart';
import 'package:anime_track/size_config.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../bloc/auth/auth_events.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/user/user_bloc.dart';
import '../../bloc/user/user_events.dart';
import '../../bloc/user/user_states.dart';
import '../../helper_screens/animelist.dart';
import '../../helper_screens/loader_dialog.dart';

class FavouritesBody extends StatefulWidget {
  const FavouritesBody({super.key});

  @override
  State<FavouritesBody> createState() => _FavouritesBodyState();
}

class _FavouritesBodyState extends State<FavouritesBody> {
  final User? user = FirebaseAuth.instance.currentUser;
  final FavouritesFetchBloc _favouritesFetchBloc = FavouritesFetchBloc();
  final UserActivityBloc _userActivityBloc = UserActivityBloc();
  final AppBloc _appBloc = AppBloc();

  void initState() {
    // _favouritesFetchBloc.add(FavouritesFetchInitialEvent(user!.uid));
    _appBloc.add(AppEventInitialize());
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
          _favouritesFetchBloc.add(FavouritesFetchInitialEvent(user!.uid));
          return Future.delayed(Duration(seconds: 2));
        },
        child: BlocConsumer<UserActivityBloc, UserActivityState>(
          bloc: _userActivityBloc,
          listener: (context, state) {},
          buildWhen: (previous, current) => current is FavouriteDeleteClickedState,
          builder: (context, state) {
            _favouritesFetchBloc.add(FavouritesFetchInitialEvent(user!.uid));
            return BlocConsumer<FavouritesFetchBloc, FavouritesFetchState>(
              bloc: _favouritesFetchBloc,
              listener: (context, state) {
                // TODO: implement listener
              },
              builder: (context, state) {
                switch (state.runtimeType) {
                  case FavouritesFetchLoadingState:
                    return LoaderDialog(
                      w: SizeConfig.screenWidth * 0.4,
                    );
      
                  case FavouritesFetchSuccessfulState:
                    final favouritesState = state as FavouritesFetchSuccessfulState;
      
                    if (favouritesState.favourites.isNotEmpty) {
                      List<FavouriteTile> favAnime = favouritesState.favourites;
                      favAnime.sort((a, b) {
                        return a.titleEnglish
                            .toLowerCase()
                            .compareTo(b.titleEnglish.toLowerCase());
                      });
                      return LayoutBuilder(
                        builder: (BuildContext context,
                            BoxConstraints viewportConstraints) {
                          return SingleChildScrollView(
                            physics: AlwaysScrollableScrollPhysics(),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                  minHeight: viewportConstraints.maxHeight),
                              child: Container(
                                child: Column(
                                  children: [
                                    Divider(
                                        height: MediaQuery.of(context).size.width *
                                            0.05,
                                        color: Colors.transparent),
                                    ListView.separated(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      separatorBuilder: (context, index) => Divider(
                                        color: Colors.transparent,
                                        height: 3,
                                      ),
                                      itemCount: favAnime.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Container(
                                          padding:
                                              EdgeInsets.symmetric(horizontal: 15),
                                          margin: EdgeInsets.only(bottom: 10),
                                          child: Slidable(
                                            key: Key(
                                                favAnime[index].malId.toString()),
                                            direction: Axis.horizontal,
                                            endActionPane: ActionPane(
                                              motion: const DrawerMotion(),
                                              extentRatio: 0.25,
                                              children: [
                                                SlidableAction(
                                                  flex: 1,
                                                  onPressed: (context) {
                                                    _userActivityBloc.add(
                                                        FavouriteDeleteClickedEvent(
                                                      user: user!,
                                                      anime: favAnime[index],
                                                    ));
                                                  },
                                                  backgroundColor: kBgColor,
                                                  foregroundColor: kRedColor,
                                                  icon: CupertinoIcons.heart_slash,
                                                ),
                                              ],
                                            ),
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.of(context,
                                                        rootNavigator: true)
                                                    .push(MaterialPageRoute(
                                                        builder: (context) =>
                                                            AnimeDetailScreen(
                                                                malID:
                                                                    favAnime[index]
                                                                        .malId)));
                                              },
                                              child: Card(
                                                color: kBgColor2,
                                                borderOnForeground: true,
                                                elevation: 0,
                                                // shadowColor: kTextColor,
                                                child: Container(
                                                  padding: EdgeInsets.all(10),
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Flexible(
                                                        flex: 2,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              favAnime[index]
                                                                          .titleEnglish !=
                                                                      'TBA'
                                                                  ? favAnime[index]
                                                                      .titleEnglish
                                                                  : favAnime[index]
                                                                      .title,
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Muli',
                                                                  color: kTextColor,
                                                                  fontSize: SizeConfig
                                                                          .screenWidth *
                                                                      0.05,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                              maxLines: 2,
                                                              overflow: TextOverflow
                                                                  .ellipsis,
                                                            ),
                                                            Text(
                                                              "${favAnime[index].season[0].toUpperCase()}${favAnime[index].season.substring(1).toLowerCase()}\t${favAnime[index].year.toString()}",
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Muli',
                                                                  color:
                                                                      kPrimaryColor,
                                                                  fontSize: SizeConfig
                                                                          .screenWidth *
                                                                      0.04,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                              maxLines: 2,
                                                              overflow: TextOverflow
                                                                  .ellipsis,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Flexible(
                                                        child: CachedNetworkImage(
                                                          
                                                          placeholder:
                                                              (context, url) =>
                                                                  Center(
                                                            child:
                                                                CircularProgressIndicator(),
                                                          ),
                                                          imageUrl: favAnime[index]
                                                              .imageUrl,
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              Image.asset(
                                                                  'assets/icons/leaf.png'),
                                                          // width: 60,
                                                          height:
                                                              MediaQuery.of(context)
                                                                      .size
                                                                      .width *
                                                                  0.2,
                                                          fit: BoxFit.contain,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
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
      
                  case FavouritesFetchErrorState:
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
