import 'dart:ui';

import 'package:anime_track/bloc/anime/anime_events.dart';
import 'package:anime_track/helper_screens/error_screen.dart';
import 'package:anime_track/helper_screens/no_results.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../colors.dart';
import '../size_config.dart';
import '../bloc/anime/anime_bloc.dart';
import 'anime_detail/anime_detail.dart';
import '../bloc/anime/anime_states.dart';
import '../helper_screens/loader_dialog.dart';

class SearchAnimeScreen extends StatefulWidget {
  const SearchAnimeScreen({super.key});

  @override
  State<SearchAnimeScreen> createState() => _SearchAnimeScreenState();
}

class _SearchAnimeScreenState extends State<SearchAnimeScreen> {
  SearchAnimeBloc _searchAnimeBloc = SearchAnimeBloc();
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar: true,
      backgroundColor: kBgColor,
      appBar: PreferredSize(
        preferredSize: Size(
          double.infinity,
          AppBar().preferredSize.height
        ),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: AppBar(
              title: Container(
                width: double.infinity,
                height: AppBar().preferredSize.height,
                decoration: BoxDecoration(color: Colors.transparent),
                child: Center(
                  child: TextField(
                    autofocus: true,
                    controller: _controller,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Search Anime",
                      hintStyle: TextStyle(color: Colors.grey,fontFamily: 'Muli',fontSize: SizeConfig.screenWidth * 0.04,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.cancel_rounded,color: kTextColor,),
                        onPressed: () {
                          _controller.clear();
                        },
                      ),
                    ),
                    cursorColor: kPrimaryColor,
                    keyboardType: TextInputType.name,
                    textCapitalization: TextCapitalization.words,
                    style: TextStyle(color: kTextColor,fontFamily: 'Muli', fontSize: SizeConfig.screenWidth * 0.04,
                    ),
                    onSubmitted: (value) {
                      _searchAnimeBloc
                          .add(SearchAnimeInitialFetchEvent(query: value));
                    },
                  ),
                ),
              ),
              backgroundColor: kBgColor.withOpacity(0.3),
              centerTitle: true,
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios_new_rounded),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              elevation: 0,
            ),
          ),
        ),
      ),
      body: BlocConsumer<SearchAnimeBloc, SearchAnimeState>(
        bloc: _searchAnimeBloc,
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          switch (state.runtimeType) {
            case SearchAnimeFetchingLoadingState:
              return LoaderDialog(w: SizeConfig.screenWidth * 0.4,);

            case SearchAnimeFetchingSuccessfulState:
              final searchState = state as SearchAnimeFetchingSuccessfulState;
              if (searchState.searchedAnime.isNotEmpty) {
                return LayoutBuilder(
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
                                height: 5,
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
                                                        malID: searchState
                                                            .searchedAnime[index]
                                                            .malId)));
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
                                                // elevation: 10.0,
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
                                                      imageUrl: searchState
                                                          .searchedAnime[index]
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
                                              searchState.searchedAnime[index]
                                                          .titleEnglish !=
                                                      "TBA"
                                                  ? searchState.searchedAnime[index]
                                                      .titleEnglish
                                                  : searchState
                                                      .searchedAnime[index].title,
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
                                  itemCount: searchState.searchedAnime.length,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              } else {
                return NoResultsScreen();
              }

            case SearchAnimeFetchingErrorState:
              return ErrorScreen();

            default:
              return Container();
          }
          // return Container();
        },
      ),
    );
  }
}
