import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ExploreNusantaraModifiedCachedNetworkImage extends CachedNetworkImage {
  @override
  PlaceholderWidgetBuilder? get placeholder {
    return (context, url) => Container();
  }

  @override
  LoadingErrorWidgetBuilder? get errorWidget {
    return (context, url, e) => Container();
  }

  @override
  ImageWidgetBuilder? get imageBuilder {
    return (context, imageProvider) => Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: imageProvider,
          fit: BoxFit.fitHeight,
        ),
      ),
    );
  }

  ExploreNusantaraModifiedCachedNetworkImage({
    Key? key,
    required String imageUrl
  }) : super(
    key: key,
    imageUrl: imageUrl,
  );
}