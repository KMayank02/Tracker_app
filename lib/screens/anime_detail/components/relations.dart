import 'dart:ui';

import 'package:anime_track/bloc/anime/anime_bloc.dart';
import 'package:anime_track/bloc/anime/anime_events.dart';
import 'package:anime_track/helper_screens/loader_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../colors.dart';
import '../../../size_config.dart';
import '../../../bloc/anime/anime_states.dart';
import '../anime_detail.dart';

class Relations extends StatefulWidget {
  final Map<int, String> relIds;
  const Relations({super.key, required this.relIds});

  @override
  State<Relations> createState() => _RelationsState();
}

class _RelationsState extends State<Relations> {
  RelationsBloc relationsBloc = RelationsBloc();

  @override
  void initState() {
    relationsBloc.add(RelationsInitialFetchEvent(widget.relIds));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final contentHeight = 4.0 * (MediaQuery.of(context).size.width / 2.4) / 3;
    return BlocConsumer<RelationsBloc, RelationsState>(
      bloc: relationsBloc,
      listener: (context, state) {},
      builder: (context, state) {
        switch (state.runtimeType) {
          case RelationsFetchingLoadingState:
            return LoaderDialog(
              w: SizeConfig.screenWidth * 0.3,
            );
          case RelationsFetchingSuccessfulState:
            final relSuccessState = state as RelationsFetchingSuccessfulState;
            print(relSuccessState.relations.length);
            if (relSuccessState.relations.isNotEmpty) {
              return Container(
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      // padding: EdgeInsets.only(left: 20.0, right: 16.0),
                      height: 48.0,
                      child: Text(
                        "Related",
                        style: TextStyle(
                          color: kTextColor,
                          fontSize: SizeConfig.screenWidth * 0.05,
                          fontFamily: 'Muli',
                          fontWeight: FontWeight.bold,
                        ),
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
                        itemCount: relSuccessState.relations.length,
                        itemBuilder: (BuildContext context, int index) {
                          final width = MediaQuery.of(context).size.width / 2.6;
                          return InkWell(
                            onTap: () {
                              Navigator.of(context, rootNavigator: true)
                                  .push(MaterialPageRoute(
                                      builder: (context) => AnimeDetailScreen(
                                            malID: relSuccessState
                                                .relations[index].malId,
                                          )));
                            },
                            child: Stack(
                              children: [
                                Container(
                                  width: width,
                                  height: double.infinity,
                                  padding: EdgeInsets.only(
                                      left: MediaQuery.of(context).size.width *
                                          0.01,
                                      right: MediaQuery.of(context).size.width *
                                          0.01,
                                      bottom:
                                          MediaQuery.of(context).size.width *
                                              0.04),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: CachedNetworkImage(
                                      placeholder: (context, url) => Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                      imageUrl: relSuccessState
                                          .relations[index].imageUrl,
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
                                          left: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.01,
                                          right: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.01,
                                          bottom: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.04),
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
                                          filter: ImageFilter.blur(
                                              sigmaX: 3, sigmaY: 3),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal:
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.01,
                                                vertical: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.02),
                                            child: Text(
                                              relSuccessState.relations[index]
                                                          .titleEnglish !=
                                                      'TBA'
                                                  ? relSuccessState
                                                      .relations[index]
                                                      .titleEnglish
                                                  : relSuccessState
                                                      .relations[index].title,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontFamily: 'Muli',
                                                  color: kTextColor,
                                                  fontSize:
                                                      SizeConfig.screenWidth *
                                                          0.04,
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
            } else {
              return Container();
            }

          case RelationsFetchingErrorState:
            return Container();
          default:
            return Container();
        }
      },
    );
  }
}
