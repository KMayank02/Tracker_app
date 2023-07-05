import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../../../colors.dart';

class StarRating extends StatefulWidget {
  final double score;
  const StarRating({super.key, required this.score});

  @override
  State<StarRating> createState() => _StarRatingState();
}

class _StarRatingState extends State<StarRating> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          5,
          (index) {
            if (index >= widget.score) {
              return Icon(
                Icons.star_outline_rounded,
                color: kPrimaryColor,
              );
            } else if (index > widget.score - 1 && index < widget.score) {
              return Icon(
                Icons.star_half_rounded,
                color: kPrimaryColor,
              );
            } else {
              return Icon(
                Icons.star_rounded,
                color: kPrimaryColor,
              );
            }
          },
        ),
      ),
    );
  }
}
