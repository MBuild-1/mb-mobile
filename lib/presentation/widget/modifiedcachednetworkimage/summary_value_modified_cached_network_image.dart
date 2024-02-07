import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../misc/constant.dart';

class SummaryValueModifiedCachedNetworkImage extends CachedNetworkImage {
  final BoxFit? boxFit;

  @override
  PlaceholderWidgetBuilder? get placeholder {
    return (context, url) => Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(Constant.imageProductPlaceholder),
          fit: BoxFit.cover
        )
      ),
    );
  }

  @override
  LoadingErrorWidgetBuilder? get errorWidget {
    return (context, url, e) => Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(Constant.imageProductPlaceholder),
          fit: BoxFit.cover
        )
      ),
    );
  }

  @override
  ImageWidgetBuilder? get imageBuilder {
    return (context, imageProvider) => Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: imageProvider,
          fit: boxFit ?? BoxFit.cover,
        ),
      ),
    );
  }

  SummaryValueModifiedCachedNetworkImage({
    Key? key,
    required String imageUrl,
    required this.boxFit
  }) : super(key: key, imageUrl: imageUrl);
}