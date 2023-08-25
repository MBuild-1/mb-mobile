import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';

import '../../domain/entity/video/defaultvideo/default_video.dart';
import '../../misc/aspect_ratio_value.dart';
import '../../misc/constant.dart';
import '../../misc/load_data_result.dart';
import 'video/default_video_item.dart';

class DefaultVideoCarouselListItem extends StatefulWidget {
  final LoadDataResult<List<DefaultVideo>> defaultVideoListLoadDataResult;

  const DefaultVideoCarouselListItem({
    Key? key,
    required this.defaultVideoListLoadDataResult,
  }) : super(key: key);

  @override
  State<DefaultVideoCarouselListItem> createState() => DefaultVideoCarouselListItemState();
}

class DefaultVideoCarouselListItemState extends State<DefaultVideoCarouselListItem> with AutomaticKeepAliveClientMixin {
  late PageController _pageController;
  bool _isInitialized = false;
  double _currentPageValue = 0.0;

  double get _pageViewPadding => 8;

  double get _viewportFraction {
    return (_pageViewWidth - 2 * _pageViewPadding) / _pageViewWidth;
  }

  double get _pageViewWidth {
    return MediaQuery.of(context).size.width;
  }

  double get _pageViewHeight {
    AspectRatioValue defaultVideoAspectRatioValue = Constant.aspectRatioValueDefaultVideo;
    return (defaultVideoAspectRatioValue.height * _pageViewWidth) / defaultVideoAspectRatioValue.width;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _isInitialized = true;
      _pageController = PageController(viewportFraction: _viewportFraction);
      _pageController.addListener(_pageControllerListener);
      setState(() {});
    });
  }

  void _pageControllerListener() {
    _currentPageValue = _pageController.page ?? 0.0;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (!_isInitialized) {
      return Container();
    }
    return ClipRect(
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 30),
            color: Colors.black,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Video Trip".tr,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                      Text(
                        "Look All".tr,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 12
                        ),
                      ),
                    ]
                  )
                ),
                const SizedBox(height: 20),
                if (widget.defaultVideoListLoadDataResult.isSuccess)
                  Builder(
                    builder: (context) {
                      return Container(
                        padding: EdgeInsets.symmetric(horizontal: _pageViewPadding),
                        height: _pageViewHeight,
                        child: PageView.builder(
                          controller: _pageController,
                          clipBehavior: Clip.antiAlias,
                          itemCount: widget.defaultVideoListLoadDataResult.resultIfSuccess!.length,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (_, index) {
                            DefaultVideo defaultVideo = widget.defaultVideoListLoadDataResult.resultIfSuccess![index];
                            Widget defaultVideoItem = DefaultVideoItem(defaultVideo: defaultVideo);
                            return AnimatedBuilder(
                              animation: _pageController,
                              builder: (_, __) {
                                double value = (1 - (_currentPageValue - index).abs() / 2);
                                return Transform.scale(
                                  scale: max(0.9, value),
                                  child: Opacity(
                                    opacity: max(0, value),
                                    child: defaultVideoItem
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      );
                    }
                  ),
              ]
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.addListener(_pageControllerListener);
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}