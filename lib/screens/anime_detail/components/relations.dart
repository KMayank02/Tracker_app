import 'dart:ui';

import 'package:anime_track/bloc/anime/anime_bloc.dart';
import 'package:anime_track/bloc/anime/anime_events.dart';
import 'package:anime_track/helper_screens/error_screen.dart';
import 'package:anime_track/helper_screens/loader_dialog.dart';
import 'package:anime_track/helper_screens/no_results.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

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
    return Builder(builder: (context) {
      return Scaffold(
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
              ),
            ),
          ),
        ),
        body: BlocConsumer<RelationsBloc, RelationsState>(
          bloc: relationsBloc,
          listener: (context, state) {},
          builder: (context, state) {
            switch (state.runtimeType) {
              case RelationsFetchingLoadingState:
                return LoaderDialog(
                  w: SizeConfig.screenWidth * 0.3,
                );
              case RelationsFetchingSuccessfulState:
                final relSuccessState =
                    state as RelationsFetchingSuccessfulState;
                print(relSuccessState.relations.length);
                if (relSuccessState.relations.isNotEmpty) {
                  return SafeArea(
                    child: RefreshIndicator(
                      backgroundColor: kPrimaryColor,
                      color: kBgColor,
                      onRefresh: () {
                        relationsBloc
                            .add(RelationsInitialFetchEvent(widget.relIds));
                        return Future.delayed(Duration(seconds: 1));
                      },
                      child: LayoutBuilder(
                        builder: (BuildContext context,
                            BoxConstraints viewportConstraints) {
                          final pwidth = MediaQuery.of(context).size.width;
                          return SingleChildScrollView(
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                  minHeight: viewportConstraints.maxHeight),
                              child: Container(
                                child: Column(
                                  children: [
                                    Divider(
                                      height: SizeConfig.screenWidth * 0.1,
                                    ),
                                    Container(
                                      child: GridView.builder(
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 2,
                                                childAspectRatio: 1 / 1.6),
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          final width = pwidth / 2;
                                          return InkWell(
                                            onTap: () {
                                              Navigator.of(context,
                                                      rootNavigator: true)
                                                  .push(MaterialPageRoute(
                                                      builder: (context) =>
                                                          AnimeDetailScreen(
                                                            malID: relSuccessState.relations[
                                                                    index]
                                                                .malId,
                                                          )));
                                            },
                                            child: Container(
                                              width: width,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.01),
                                              // padding: EdgeInsets.only(bottom: 20.0),
                                              // padding: EdgeInsets.only(
                                              //     bottom: width / 50,
                                              //     left: width / 30,
                                              //     right: width / 30),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Expanded(
                                                    child: Card(
                                                      elevation: 0,
                                                      borderOnForeground: true,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                      ),
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.0),
                                                        ),
                                                        width: width,
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.0),
                                                          child:
                                                              CachedNetworkImage(
                                                            errorWidget: (context,
                                                                    url,
                                                                    error) =>
                                                                Image.asset(
                                                                    'assets/icons/leaf.png'),
                                                            placeholder: (context, url) => Shimmer
                                                                .fromColors(
                                                                    child:
                                                                        Container(
                                                                      color:
                                                                          kBgColor,
                                                                    ),
                                                                    baseColor:
                                                                        kBgColor,
                                                                    highlightColor:
                                                                        kPrimaryColor),
                                                            imageUrl:
                                                                relSuccessState
                                                                    .relations[
                                                                        index]
                                                                    .imageUrl,
                                                            width: width,
                                                            height:
                                                                double.infinity,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    relSuccessState
                                                        .relations[index]
                                                        .relationName,
                                                    style: TextStyle(
                                                        color: kPrimaryColor,
                                                        fontSize: SizeConfig
                                                                .screenWidth *
                                                            0.05,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily: 'Muli'),
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  Divider(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.03,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                        padding: EdgeInsets.only(
                                            left: 16.0, right: 16.0),
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: relSuccessState.relations.length,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                } else {
                  return NoResultsScreen();
                }

              case RelationsFetchingErrorState:
                return ErrorScreen();
              default:
                return Container();
            }
          },
        ),
      );
    });
  }
}
