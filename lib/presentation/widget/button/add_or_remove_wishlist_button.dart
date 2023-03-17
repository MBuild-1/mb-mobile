import 'package:flutter/material.dart';

import '../../../misc/constant.dart';
import '../modified_svg_picture.dart';

typedef OnAddWishlist = void Function();

class AddOrRemoveWishlistButton extends StatelessWidget {
  final OnAddWishlist onAddWishlist;

  const AddOrRemoveWishlistButton({
    super.key,
    required this.onAddWishlist
  });

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Material(
        color: Constant.colorWishlistButton,
        child: InkWell(
          onTap: onAddWishlist,
          child: SizedBox(
            width: 40,
            height: 40,
            child: Center(
              child: ModifiedSvgPicture.asset(
                Constant.vectorLove,
                color: Constant.colorWishlistIcon,
                width: 25,
                height: 25
              )
            )
          ),
        ),
      ),
    );
  }
}