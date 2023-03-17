import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../misc/constant.dart';

class RatingIndicator extends StatelessWidget {
  final double rating;

  const RatingIndicator({
    super.key,
    required this.rating
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(
          width: 15,
          height: 15,
          child: Icon(Icons.star, size: 15)
        ),
        SizedBox(width: 1.w),
        Text("$rating", style: const TextStyle(fontSize: 12.0)),
      ],
    );
  }
}