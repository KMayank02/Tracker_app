import 'package:anime_track/screens/home/home_screen.dart';
import 'package:anime_track/screens/landing.dart';
import 'package:anime_track/screens/network_check.dart';
import 'package:anime_track/screens/sign_in/signin_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/auth/auth_bloc.dart';
import 'bloc/auth/auth_states.dart';
import 'bloc/auth/auth_events.dart';
import 'package:bloc/bloc.dart';

class App extends StatelessWidget {
  const App({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: BlocProvider<AppBloc>(
        create: (_) => AppBloc()..add(AppEventInitialize()),
        child: MaterialApp(
          title: 'KONOHA',
          debugShowCheckedModeBanner: false,
          home: BlocConsumer<AppBloc, AppState>(
            listener: (context, appState) {},
            builder: (context, appState) {
              print(appState);
              if (appState is AppStateLoggedOut) {
                return const SignInScreen();
              } else if (appState is AppStateLoggedIn) {
                return NetworkCheckerBody();
              } else {
                // this should never happen
                return Container();
              }
            },
          ),
        ),
      ),
    );
  }
}
