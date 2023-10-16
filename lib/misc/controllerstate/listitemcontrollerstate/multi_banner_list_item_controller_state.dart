import 'package:carousel_slider/carousel_options.dart';

import '../../../domain/entity/banner/banner.dart';
import '../../aspect_ratio_value.dart';
import 'list_item_controller_state.dart';

class MultiBannerListItemControllerState extends ListItemControllerState {
  List<Banner> bannerList;
  AspectRatioValue aspectRatioValue;
  void Function(Banner)? onTapBanner;
  bool isAutoSwipe;
  bool withIndicator;
  final Function(int index, CarouselPageChangedReason reason)? onPageChanged;

  MultiBannerListItemControllerState({
    required this.bannerList,
    required this.aspectRatioValue,
    this.onTapBanner,
    this.isAutoSwipe = true,
    this.withIndicator = true,
    this.onPageChanged
  });
}