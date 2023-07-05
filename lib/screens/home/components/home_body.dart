import 'package:anime_track/bloc/user/user_events.dart';
import 'package:anime_track/bloc/user/user_states.dart';
import 'package:anime_track/colors.dart';
import 'package:anime_track/bloc/anime/anime_bloc.dart';
import 'package:anime_track/helper_screens/error_loader.dart';
import 'package:anime_track/screens/home/components/carousel.dart';
import 'package:anime_track/screens/home/components/top_anime_list.dart';
import 'package:anime_track/screens/home/components/top_movie.dart';
import 'package:anime_track/helper_screens/loader_dialog.dart';
import 'package:anime_track/size_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/auth/auth_events.dart';
import '../../../bloc/auth/auth_bloc.dart';
import '../../../bloc/user/user_bloc.dart';
import '../../../models/animetile_model.dart';
import '../../../bloc/anime/anime_events.dart';
import '../../../bloc/anime/anime_states.dart';
import 'airing_anime_list.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  final User? user = FirebaseAuth.instance.currentUser;
  final UserDataBloc userDataBloc = UserDataBloc();
  final TopAnimeBloc animeBloc = TopAnimeBloc();
  final AiringAnimeBloc airingAnimeBloc = AiringAnimeBloc();
  final MoviesBloc moviesBloc = MoviesBloc();
  final AppBloc _appBloc = AppBloc();

  void initState() {
    _appBloc.add(AppEventInitialize());
    userDataBloc.add(UserDataInitialFetchEvent(user!));
    animeBloc.add(TopAnimeInitialFetchEvent());
    airingAnimeBloc.add(AiringAnimeInitialFetchEvent());
    moviesBloc.add(MoviesInitialFetchEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    print(user!.uid);
    final contentHeight = 4.0 * (SizeConfig.screenWidth / 2.4) / 3;
    return RefreshIndicator(
      backgroundColor: kBgColor2,
      color: kPrimaryColor,
      onRefresh: () {
        animeBloc.add(TopAnimeInitialFetchEvent());
        airingAnimeBloc.add(AiringAnimeInitialFetchEvent());
        moviesBloc.add(MoviesInitialFetchEvent());
        return Future.delayed(Duration(seconds: 2));
      },
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints:
                  BoxConstraints(minHeight: viewportConstraints.maxHeight),
              child: Container(
                child: Column(
                  children: [
                    Divider(
                        height: MediaQuery.of(context).padding.top,
                        color: Colors.transparent),
                    CarouselNav(),
                    Divider(height: 4, color: Colors.transparent),

                    BlocConsumer<TopAnimeBloc, TopAnimeState>(
                      bloc: animeBloc,
                      listener: (context, state) {},
                      builder: (context, state) {
                        switch (state.runtimeType) {
                          case TopAnimeFetchingLoadingState:
                            return LoaderDialog(
                              w: SizeConfig.screenWidth * 0.3,
                            );

                          case TopAnimeFetchingSuccessfulState:
                            final topAnimeSuccessState =
                                state as TopAnimeFetchingSuccessfulState;
                            return TopAnimeList(
                                anime: topAnimeSuccessState.topAnime);
                          case TopAnimeFetchingErrorState:
                            return ErrorLoader(w: SizeConfig.screenWidth * 0.3);
                          default:
                            return const SizedBox();
                        }
                      },
                    ),
                    // Divider(height: 2.0, color: Colors.transparent),
                    BlocConsumer<AiringAnimeBloc, AiringAnimeState>(
                      bloc: airingAnimeBloc,
                      listener: (context, state) {},
                      builder: (context, state) {
                        switch (state.runtimeType) {
                          case AiringAnimeFetchingLoadingState:
                            return LoaderDialog(
                              w: SizeConfig.screenWidth * 0.3,
                            );

                          case AiringAnimeFetchingSuccessfulState:
                            final airingAnimeSuccessState =
                                state as AiringAnimeFetchingSuccessfulState;
                            return AiringAnimeList(
                                anime: airingAnimeSuccessState.airingAnime);

                          case AiringAnimeFetchingErrorState:
                            return ErrorLoader(w: SizeConfig.screenWidth * 0.3);

                          default:
                            return const SizedBox();
                        }
                      },
                    ),
                    // Divider(height: 2.0, color: Colors.transparent),
                    BlocConsumer<MoviesBloc, MoviesState>(
                      bloc: moviesBloc,
                      listener: (context, state) {},
                      builder: (context, state) {
                        switch (state.runtimeType) {
                          case MoviesFetchingLoadingState:
                            return LoaderDialog(
                              w: SizeConfig.screenWidth * 0.3,
                            );

                          case MoviesFetchingSuccessfulState:
                            final moviesSuccessState =
                                state as MoviesFetchingSuccessfulState;
                            return MoviesAnimeList(
                                anime: moviesSuccessState.movies);

                          case MoviesFetchingErrorState:
                            return ErrorLoader(w: SizeConfig.screenWidth * 0.3);

                          default:
                            return const SizedBox();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
