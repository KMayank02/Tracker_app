import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../colors.dart';

class DummyScaffold extends StatelessWidget {
  final Widget body;
  const DummyScaffold({super.key, required this.body});

  @override
  Widget build(BuildContext context) {
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
              filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
              child: AppBar(
                title: Image.asset(
                  'assets/appbar/logo.png',
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
                // actions: [
                //   Container(
                //     padding: EdgeInsets.only(right: 16.0),
                //     child: IconButton(
                //       icon: Icon(
                //         Icons.favorite_border_rounded,
                //         color: kTextColor,
                //       ),
                //       onPressed: () {
                //       },
                //     ),
                //   ),
                // ],
              ),
            ),
          ),
        ),
        body: body);
  }
}
