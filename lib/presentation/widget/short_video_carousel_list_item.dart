import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';
import 'package:scroll_snap_effect/scroll_snap_effect.dart';

import '../../domain/entity/video/shortvideo/short_video.dart';
import '../../misc/aspect_ratio_value.dart';
import '../../misc/constant.dart';
import '../../misc/load_data_result.dart';
import '../../misc/page_restoration_helper.dart';
import '../../misc/scrollphysics/paging_scroll_physics.dart';
import '../page/videopage/video_page.dart';
import 'tap_area.dart';
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
                  TapArea(
                    onTap: () => PageRestorationHelper.toVideoPage(context, VideoPageParameter(videoType: VideoType.shortVideo)),
                    child: Text(
                      "Look All".tr,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 12
                      ),
                    ),
                  )
                ]
              )
            ),
            if (widget.shortVideoListLoadDataResult.isSuccess)
              Builder(
                builder: (context) {
                  int length = widget.shortVideoListLoadDataResult.resultIfSuccess!.length;
                  double height = 390.0;
                  AspectRatioValue aspectRatioValue = Constant.aspectRatioValueShortVideo;
                  return SizedBox(
                    height: height,
                    child: ScrollSnapEffect(
                      itemSize: (aspectRatioValue.width * height / aspectRatioValue.height) + Constant.paddingListItem,
                      itemCount: length,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemBuilder: (context, index) {
                        ShortVideo shortVideo = widget.shortVideoListLoadDataResult.resultIfSuccess![index];
                        Widget shortVideoItem = ShortVideoItem(shortVideo: shortVideo);
                        return index > 0 ? Row(
                          children: [
                            SizedBox(width: Constant.paddingListItem),
                            shortVideoItem
                          ],
                        ) : shortVideoItem;
                      }
                    ),
                  );
                }
              ),
          ]
        )
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}