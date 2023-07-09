import 'dart:ui';

import 'package:anime_track/bloc/anime/anime_bloc.dart';
import 'package:anime_track/bloc/anime/anime_events.dart';
import 'package:anime_track/helper_screens/error_screen.dart';
import 'package:anime_track/helper_screens/loader_dialog.dart';
import 'package:anime_track/size_config.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../../../colors.dart';
import '../../../models/animetile_model.dart';
import '../../anime_detail/anime_detail.dart';
import '../../../bloc/anime/anime_states.dart';

class SeasonalListScreen extends StatefulWidget {
  // final String seasonType;
  final String imagePath;
  const SeasonalListScreen({super.key, required this.imagePath});

  @override
  State<SeasonalListScreen> createState() => _SeasonalListScreenState();
}

class _SeasonalListScreenState extends State<SeasonalListScreen> {
  SeasonalAnimeBloc seasonalAnimeBloc = SeasonalAnimeBloc();
  void initState() {
    seasonalAnimeBloc.add(SeasonalAnimeInitialFetchEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
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
            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
            child: AppBar(
              title: Image.asset(
                'assets/appbar/seasonal.png',
                height: AppBar().preferredSize.height,
                fit: BoxFit.fitHeight,
              ),
              backgroundColor: kBgColor.withOpacity(0),
              centerTitle: true,
              elevation: 0,
              leading: Container(
                padding: EdgeInsets.only(left: 16.0),
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: kTextColor),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),
          ),
        ),
      ),
      body: BlocConsumer<SeasonalAnimeBloc, SeasonalAnimeState>(
        bloc: seasonalAnimeBloc,
        listener: (context, state) {},
        builder: (context, state) {
          switch (state.runtimeType) {
            case SeasonalAnimeFetchingLoadingState:
              return LoaderDialog(w: SizeConfig.screenWidth * 0.4,);

            case SeasonalAnimeFetchingSuccessfulState:
              final seasonalAnimeSuccessState =
                  state as SeasonalAnimeFetchingSuccessfulState;
              return Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    opacity: 0.5,
                    image: AssetImage(widget.imagePath),
                    fit: BoxFit.cover,
                  ),
                ),
                child: SafeArea(
                  child: RefreshIndicator(
                    backgroundColor: kPrimaryColor,
                    color: kBgColor,
                    onRefresh: () {
                      seasonalAnimeBloc.add(SeasonalAnimeInitialFetchEvent());
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
                                              childAspectRatio: 1 / 1.5),
                  
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
                                                          malID: seasonalAnimeSuccessState.seasonalAnime[index].malId,
                                                        )));
                                          },
                                          child: Container(
                                            width: width,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.01),
                                            // padding: EdgeInsets.only(bottom: 20.0),
                                            // padding: EdgeInsets.only(
                                            //     bottom: width / 50,
                                            //     left: width / 30,
                                            //     right: width / 30),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Expanded(
                                                  child: Card(
                                                    elevation: 0,
                                                    borderOnForeground: true,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                8.0),
                                                      ),
                                                      width: width,
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                8.0),
                                                        child: CachedNetworkImage(
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              Image.asset(
                                                                  'assets/icons/leaf.png'),
                                                          placeholder: (context,
                                                                  url) =>
                                                              Shimmer.fromColors(
                                                                  child: Container(
                                                                    color: kBgColor,
                                                                  ),
                                                                  baseColor:
                                                                      kBgColor,
                                                                  highlightColor:
                                                                      kPrimaryColor),
                                                          imageUrl:
                                                              seasonalAnimeSuccessState
                                                                  .seasonalAnime[
                                                                      index]
                                                                  .imageUrl,
                                                          width: width,
                                                          height: double.infinity,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  seasonalAnimeSuccessState
                                                              .seasonalAnime[index]
                                                              .titleEnglish !=
                                                          "TBA"
                                                      ? seasonalAnimeSuccessState
                                                          .seasonalAnime[index]
                                                          .titleEnglish
                                                      : seasonalAnimeSuccessState
                                                          .seasonalAnime[index]
                                                          .title,
                                                  style: TextStyle(
                                                      color: kTextColor,
                                                      fontSize: SizeConfig.screenWidth*0.04,
                                                      fontWeight: FontWeight.bold,
                                                      fontFamily: 'Muli'),
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                Divider(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.03,
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                      padding:
                                          EdgeInsets.only(left: 16.0, right: 16.0),
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: seasonalAnimeSuccessState
                                          .seasonalAnime.length,
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
                ),
              );

            case SeasonalAnimeFetchingErrorState:
              return ErrorScreen();

            default:
              return Container();
          }
        },
      ),
    );
  }
}
