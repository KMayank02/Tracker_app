import 'dart:ui';

import 'package:anime_track/size_config.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../colors.dart';
import '../models/animetile_model.dart';
import '../screens/anime_detail/anime_detail.dart';

class AnimeListScreen extends StatefulWidget {
  final List<AnimeTile> anime;
  final String title;
  const AnimeListScreen({super.key, required this.anime, required this.title});

  @override
  State<AnimeListScreen> createState() => _AnimeListScreenState();
}

class _AnimeListScreenState extends State<AnimeListScreen> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: kBgColor,
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size(
          double.infinity,
          AppBar().preferredSize.height
        ),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: AppBar(
              title: Image.asset(
                'assets/appbar/${widget.title.toLowerCase()}.png',
                height: AppBar().preferredSize.height,
                fit: BoxFit.fitHeight,
              ),
              backgroundColor: kBgColor.withOpacity(0.3),
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
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
          final pwidth = MediaQuery.of(context).size.width;
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints:
                  BoxConstraints(minHeight: viewportConstraints.maxHeight),
              child: Container(
                child: Column(
                  children: [
                    Divider(
                      height: MediaQuery.of(context).size.width * 0.2,
                    ),
                    Container(
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, childAspectRatio: 1 / 1.5),
                        itemBuilder: (BuildContext context, int index) {
                          final width = pwidth / 2;
                          return InkWell(
                            onTap: () {
                              Navigator.of(context, rootNavigator: true)
                                  .push(MaterialPageRoute(
                                      builder: (context) => AnimeDetailScreen(
                                            malID: widget.anime[index].malId,
                                          )));
                            },
                            child: Container(
                              width: width,
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                      MediaQuery.of(context).size.width * 0.01),
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
                                            BorderRadius.circular(8.0),
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        width: width,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          child: CachedNetworkImage(
                                            errorWidget: (context, url,
                                                    error) =>
                                                Image.asset(
                                                    'assets/icons/leaf.png'),
                                            placeholder: (context, url) =>
                                                Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                            imageUrl:
                                                widget.anime[index].imageUrl,
                                            width: width,
                                            height: double.infinity,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    widget.anime[index].titleEnglish != "TBA"
                                        ? widget.anime[index].titleEnglish
                                        : widget.anime[index].title,
                                    style: TextStyle(
                                        color: kTextColor,
                                        fontSize: SizeConfig.screenWidth*0.04,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Muli'),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Divider(
                                    height: MediaQuery.of(context).size.width *
                                        0.03,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        padding: EdgeInsets.only(left: 16.0, right: 16.0),
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: widget.anime.length,
                      ),
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
