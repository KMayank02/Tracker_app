import 'dart:ui';

import 'package:anime_track/colors.dart';
import 'package:anime_track/helper_screens/error_screen.dart';
import 'package:anime_track/screens/profile/edit_profile.dart';
import 'package:anime_track/screens/watchlist/watchlist_body.dart';
import 'package:anime_track/screens/watchlist/watchlist_landing.dart';
import 'package:anime_track/size_config.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../bloc/auth/auth_events.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/user/user_bloc.dart';
import '../../bloc/user/user_events.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/user/user_states.dart';
import '../../dialogs/delete_account_dialog.dart';
import '../../dialogs/logout_dialog.dart';
import '../../helper_screens/loader_dialog.dart';

class ProfileBody extends StatefulWidget {
  const ProfileBody({super.key});

  @override
  State<ProfileBody> createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<ProfileBody> {
  final User? user = FirebaseAuth.instance.currentUser;
  final UserDataBloc _userBloc = UserDataBloc();
  final AppBloc _appBloc = AppBloc();
  void initState() {
    _userBloc.add(UserDataInitialFetchEvent(user!));
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
          _userBloc.add(UserDataInitialFetchEvent(user!));
          return Future.delayed(Duration(seconds: 1));
        },
        child: BlocConsumer<UserDataBloc, UserDataState>(
          bloc: _userBloc,
          listener: (context, state) {
            // TODO: implement listener
          },
          // buildWhen: (previous, current) => current is UserDataFetchingSuccessfulState,
          builder: (context, state) {
            switch (state.runtimeType) {
              case UserDataFetchingLoadingState:
                return LoaderDialog(
                  w: SizeConfig.screenWidth * 0.4,
                );
      
              case UserDataFetchingSuccessfulState:
                final userState = state as UserDataFetchingSuccessfulState;
                print(userState.user.photoURL);
                return LayoutBuilder(
                  builder:
                      (BuildContext context, BoxConstraints viewportConstraints) {
                    return SafeArea(
                      child: SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        child: ConstrainedBox(
                            constraints: BoxConstraints(
                                minHeight: viewportConstraints.maxHeight),
                            child: Stack(
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.width * 0.4,
                                  child: Image.asset(
                                    'assets/banner.png',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal:
                                          MediaQuery.of(context).size.width * 0.05,
                                      vertical:
                                          MediaQuery.of(context).size.height * 0.1),
                                  child: SizedBox(
                                    child: Column(
                                      children: [
                                        ClipRect(
                                          child: BackdropFilter(
                                            filter: ImageFilter.blur(
                                                sigmaX: 3, sigmaY: 3),
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 10, horizontal: 15),
                                              // height: size.height * 0.25,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10.0),
                                                  color: Colors.grey.shade800
                                                      .withOpacity(0.5)),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.center,
                                                    children: [
                                                      Stack(
                                                        alignment:
                                                            Alignment.bottomRight,
                                                        children: [
                                                          CachedNetworkImage(
                                                            imageUrl: userState
                                                                .user.photoURL,
                                                            imageBuilder: (context,
                                                                    imageProvider) =>
                                                                Container(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.3,
                                                              height: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.3,
                                                              decoration:
                                                                  BoxDecoration(
                                                                shape:
                                                                    BoxShape.circle,
                                                                image: DecorationImage(
                                                                    image:
                                                                        imageProvider,
                                                                    fit: BoxFit
                                                                        .cover),
                                                              ),
                                                            ),
                                                            errorWidget: (context, url, error) => CachedNetworkImage(imageUrl: user!.photoURL!,errorWidget: (context, url, error) => CircleAvatar(),),
                                                            placeholder: (context,
                                                                    url) =>
                                                                CircularProgressIndicator(),
                                                          ),
                                                          Positioned(
                                                              // bottom: 0,
                                                              // right: 0,
                                                              child: Container(
                                                            width: 35,
                                                            height: 35,
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            100),
                                                                color:
                                                                    kPrimaryColor),
                                                            child: IconButton(
                                                              icon: Icon(
                                                                  Icons
                                                                      .edit_rounded,
                                                                  color: kBgColor,
                                                                  size: 20),
                                                              onPressed: () {
                                                                _userBloc.add(
                                                                    UserUpdatePhotoEvent(
                                                                        user!.uid,
                                                                        userState
                                                                            .user));
                                                              },
                                                            ),
                                                          )),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        width: 15,
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text("Kon'nichiwa,",
                                                              style: TextStyle(
                                                                  color: kTextColor,
                                                                  fontFamily:
                                                                      'Muli',
                                                                  fontSize: SizeConfig
                                                                          .screenWidth *
                                                                      0.05)),
                                                          Text(userState.user.name,
                                                              style: TextStyle(
                                                                  color: kTextColor,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontFamily:
                                                                      'Muli',
                                                                  fontSize: SizeConfig
                                                                          .screenWidth *
                                                                      0.06)),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.of(context,
                                                    rootNavigator: true)
                                                .push(MaterialPageRoute(
                                                    builder: (context) =>
                                                        WatchListLanding()));
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: kPrimaryColor,
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            margin:
                                                EdgeInsets.symmetric(vertical: 0),
                                            padding:
                                                EdgeInsets.fromLTRB(10, 0, 10, 0),
                                            height:
                                                MediaQuery.of(context).size.width *
                                                    0.15,
                                            width:
                                                MediaQuery.of(context).size.width,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "View",
                                                  style: TextStyle(
                                                      color: kBgColor2,
                                                      fontFamily: 'Muli',
                                                      fontSize:
                                                          SizeConfig.screenWidth *
                                                              0.04),
                                                ),
                                                Text(
                                                  "Your Lists",
                                                  style: TextStyle(
                                                      color: kBgColor2,
                                                      fontFamily: 'Muli',
                                                      fontSize:
                                                          SizeConfig.screenWidth *
                                                              0.04,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            profileButton("Change", "Your UserName",
                                                () {
                                              Navigator.of(context,
                                                      rootNavigator: true)
                                                  .push(MaterialPageRoute(
                                                      builder: (context) =>
                                                          EditProfileBody(
                                                            user: user!,
                                                            userDataBloc: _userBloc,
                                                            userLog: userState.user,
                                                          )));
                                            }, kBgColor2),
                                            VerticalDivider(
                                              width: 3,
                                            ),
                                            profileButton("Reset", "Your Photo",
                                                () {
                                              _userBloc
                                                  .add(UserResetPhotoEvent(user!));
                                            }, kBgColor2),
                                          ],
                                        ),
                                        SizedBox(height: 5),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            profileButton("Log", "Out", () async {
                                              final shouldLogOut =
                                                  await showLogOutDialog(context);
                                              if (shouldLogOut) {
                                                context.read<AppBloc>().add(
                                                      AppEventLogOut(),
                                                    );
                                              }
                                            }, kBgColor2),
                                            VerticalDivider(
                                              width: 3,
                                            ),
                                            profileButton("Delete", "Your Account",
                                                () async {
                                              final shouldDeleteAccount =
                                                  await showDeleteAccountDialog(
                                                      context);
                                              if (shouldDeleteAccount) {
                                                context.read<AppBloc>().add(
                                                      AppEventDeleteAccount(),
                                                    );
                                              }
                                            }, kRedColor),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )),
                      ),
                    );
                  },
                );
      
              case UserDataFetchingErrorState:
                return ErrorScreen();
      
              default:
                return Container();
            }
          },
        ),
      ),
    );
  }

  Widget profileButton(String text1, String text2, Function func, Color color) {
    return Flexible(
      child: GestureDetector(
        onTap: () {
          func();
        },
        child: Container(
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(5)),
          margin: EdgeInsets.symmetric(vertical: 0),
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          height: MediaQuery.of(context).size.width * 0.15,
          width: MediaQuery.of(context).size.width * 0.45,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                text1,
                style: TextStyle(
                    color: kTextColor,
                    fontFamily: 'Muli',
                    fontSize: SizeConfig.screenWidth * 0.04),
              ),
              Text(
                text2,
                style: TextStyle(
                    color: kTextColor,
                    fontFamily: 'Muli',
                    fontSize: SizeConfig.screenWidth * 0.04,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
