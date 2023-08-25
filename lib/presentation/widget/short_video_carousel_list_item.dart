import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';

import '../../domain/entity/video/shortvideo/short_video.dart';
import '../../misc/constant.dart';
import '../../misc/load_data_result.dart';
import 'video/short_video_item.dart';

class ShortVideoCarouselListItem extends StatefulWidget {
  final LoadDataResult<List<ShortVideo>> shortVideoListLoadDataResult;

  const ShortVideoCarouselListItem({
    Key? key,
    required this.shortVideoListLoadDataResult,
  }) : super(key: key);

  @override
  State<ShortVideoCarouselListItem> createState() => ShortVideoCarouselListItemState();
}

class ShortVideoCarouselListItemState extends State<ShortVideoCarouselListItem> with AutomaticKeepAliveClientMixin {
  late PageController _pageController;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      double shortVideoWidth = 200;
      _pageController = PageController(viewportFraction: shortVideoWidth / MediaQuery.of(context).size.width);
      _isInitialized = true;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (!_isInitialized) {
      return Container();
    }
    return Stack(
      children: [
        Container(
          color: Colors.black,
          height: 410,
        ),
        Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 30, horizontal: Constant.paddingListItem),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "Interesting Short Videos For You".tr,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  Text(
                    "Look All".tr,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 12
                    ),
                  ),
                ]
              )
            ),
            if (widget.shortVideoListLoadDataResult.isSuccess)
              SizedBox(
                height: 390,
                child: PageView.builder(
                  controller: _pageController,
                  clipBehavior: Clip.none,
                  itemCount: widget.shortVideoListLoadDataResult.resultIfSuccess!.length,
                  itemBuilder: (_, index) {
                    if (!_pageController.position.haveDimensions) {
                      return const SizedBox();
                    }
                    ShortVideo shortVideo = widget.shortVideoListLoadDataResult.resultIfSuccess![index];
                    Widget shortVideoItem = ShortVideoItem(shortVideo: shortVideo);
                    return AnimatedBuilder(
                      animation: _pageController,
                      builder: (_, __) {
                        double value = (1 - (_pageController.page! - index).abs() / 2);
                        return Transform.scale(
                          scale: max(0.8, value),
                          origin: const Offset(0, -(390 / 2)),
                          child: Opacity(
                            opacity: max(0, value),
                            child: shortVideoItem
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
          ]
        )
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}