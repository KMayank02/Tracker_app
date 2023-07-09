import 'package:anime_track/dialogs/generic_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:shape_of_view_null_safe/shape_of_view_null_safe.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../colors.dart';

class BackImage extends StatefulWidget {
  final String imageUrl;
  final String trailerUrl;
  const BackImage(
      {super.key, required this.imageUrl, required this.trailerUrl});

  @override
  State<BackImage> createState() => _BackImageState();
}

class _BackImageState extends State<BackImage> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final contentHeight = 2.0 * (MediaQuery.of(context).size.width / 2.2) / 3.0;
    final height = MediaQuery.of(context).size.height;
    return Container(
      width: double.infinity,
      height: height / 2,
      child: Stack(
        children: [
          ShapeOfView(
            shape: DiagonalShape(
              angle: DiagonalAngle.deg(angle: 10),
            ),
            height: width,
            elevation: 0,
            child: Container(
              width: double.infinity,
              height: width,
              child: Container(
                child: CachedNetworkImage(
                  errorWidget: (context, url, error) =>
                      Image.asset('assets/icons/leaf.png'),
                  placeholder: (context, url) => Shimmer.fromColors(
                      child: Container(
                        color: kBgColor,
                      ),
                      baseColor: kBgColor,
                      highlightColor: kPrimaryColor),
                  imageUrl: widget.imageUrl,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -10,
            left: 0.0,
            right: 0.0,
            child: FractionalTranslation(
              translation: Offset(0.0, -0.2),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: kPrimaryColor, width: 4.0),
                ),
                width: MediaQuery.of(context).size.width*0.2,
                height: MediaQuery.of(context).size.width*0.2,
                child: FittedBox(
                  child: FloatingActionButton(
                    elevation: 5,
                    onPressed: () async {
                      bool _validURL = Uri.parse(widget.trailerUrl).isAbsolute;
                      if (_validURL) {
                        try {
                          if (await launchUrl(Uri.parse(widget.trailerUrl),
                              mode: LaunchMode.externalApplication)) {
                          } else {
                            // toastMessage('#1: Could not launch $url');
                          }
                        } catch (e) {
                          // toastMessage('#2: Could not launch $url');
                          print("An error occurred: $e");
                        }
                      } else {
                        showGenericDialog(
                          context: context,
                          title: "Trailer not found :(",
                          content: "",
                          optionsBuilder: () => {
                            'OK': false,
                          },
                        );
                        // showDialog(
                        //   context: context,
                        //   builder: (BuildContext context) {
                        //     return AlertDialog(
                        //       content: Text("Trailer not found :("),
                        //       actions: [
                        //         TextButton(
                        //           child: Text("OK"),
                        //           onPressed: () {
                        //             Navigator.pop(context);
                        //           },
                        //         )
                        //       ],
                        //     );
                        //   },
                        // );
                      }
                    },
                    backgroundColor: kBgColor,
                    child: Icon(
                      Icons.play_arrow_outlined,
                      color: kPrimaryColor,
                      size: MediaQuery.of(context).size.width*0.1,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
