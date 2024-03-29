import 'package:anime_track/models/animetile_model.dart';
import 'package:anime_track/data/repo/anime_repo.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class AppEvent {
  const AppEvent();
}

@immutable
class AppEventDeleteAccount implements AppEvent {
  const AppEventDeleteAccount();
}

@immutable
class AppEventLogOut implements AppEvent {
  const AppEventLogOut();
}

@immutable
class AppEventInitialize implements AppEvent {
  const AppEventInitialize();
}

@immutable
class AppEventLogIn implements AppEvent {
  // final String email;
  // final String password;

  const AppEventLogIn();
}
