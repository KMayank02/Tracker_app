import 'dart:ui';

import 'package:anime_track/bloc/user/user_bloc.dart';
import 'package:anime_track/bloc/user/user_events.dart';
import 'package:anime_track/models/user_model.dart';
import 'package:anime_track/size_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

import '../../colors.dart';

class EditProfileBody extends StatefulWidget {
  final UserDataBloc userDataBloc;
  final User user;
  final UserModel userLog;
  const EditProfileBody(
      {super.key,
      required this.userDataBloc,
      required this.user,
      required this.userLog});

  @override
  State<EditProfileBody> createState() => _EditProfileBodyState();
}

class _EditProfileBodyState extends State<EditProfileBody> {
  String? name = "";
  final _formKey = GlobalKey<FormState>();

  _trySubmit() async {
    var isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState!.save();
      widget.userDataBloc.add(UserDataUpdateNameEvent(name!, widget.user));
      // showSimpleNotification(
      //   Text(
      //     "Your Profile has been updated successfully",
      //     style: TextStyle(color: kBgColor, fontFamily: 'Muli',fontWeight: FontWeight.bold),
      //   ),
      //   background: kPrimaryColor,
      // );
      Navigator.pop(context);
    } else {
      // showSimpleNotification(
      //   Text(
      //     "Please fill the details.",
      //     style: TextStyle(color: kBgColor,fontFamily: 'Muli',fontWeight: FontWeight.bold),
      //   ),
      //   background: kPrimaryColor,
      // );
      // Navigator.pushReplacement(
      //     context, MaterialPageRoute(builder: (context) => EditProfile()));
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
      child: Scaffold(
          // extendBodyBehindAppBar: true,
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
          body: LayoutBuilder(builder:
              (BuildContext context, BoxConstraints viewportConstraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints:
                    BoxConstraints(minHeight: viewportConstraints.maxHeight),
                child: Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Form(
                      key: _formKey,
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          TextFormField(
                            key: ValueKey("name"),
                            onSaved: (newValue) {
                              name = newValue!;
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "This field cannot be blank";
                              }
                              return null;
                            },
                            cursorColor: kPrimaryColor,
                            style: TextStyle(
                                color: kTextColor, fontFamily: 'Muli',fontSize: SizeConfig.screenWidth*0.05),
                            keyboardType: TextInputType.name,
                            textCapitalization: TextCapitalization.words,
                            decoration: InputDecoration(
                              errorStyle: TextStyle(
                                  color: kPrimaryColor, fontFamily: 'Muli'),
                              labelText: "Name :",
                              labelStyle: TextStyle(
                                  color: kTextColor, fontFamily: 'Muli',
                                  fontSize: SizeConfig.screenWidth * 0.04),
                              hintText: widget.userLog.name,
                              hintStyle: TextStyle(
                                  color: Colors.grey, fontFamily: 'Muli',
                                  fontSize: SizeConfig.screenWidth * 0.04),
                              fillColor: Colors.white,
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: kPrimaryColor,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: kTextColor,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Flexible(
                                child: MaterialButton(
                                    onPressed: () {
                                      _trySubmit();
                                    },
                                    color: kPrimaryColor,
                                    child: Icon(
                                      CupertinoIcons.checkmark_alt_circle,
                                      color: kBgColor2,
                                      size: SizeConfig.screenWidth*0.06,
                                    )),
                              ),
                              Flexible(
                                child: MaterialButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    color: Color(0xfff7215a),
                                    child: Icon(
                                      CupertinoIcons.clear_circled,
                                      color: kTextColor,
                                      size: SizeConfig.screenWidth * 0.06,
                                    )),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          })),
    );
  }
}
