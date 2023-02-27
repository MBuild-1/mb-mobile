import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../constant.dart';
import 'page_view_children_builder.dart';

class IntroductionPageViewChildrenBuilder extends PreloadPageViewChildrenBuilder {
  List<GlobalKey> _pageViewContentGlobalKeyList = [];
  List<GlobalKey> get pageViewContentGlobalKeyList => _pageViewContentGlobalKeyList;
  List<Image> introductionImageList = <Image>[
    Image.asset(Constant.imageIntroduction1),
    Image.asset(Constant.imageIntroduction2),
    Image.asset(Constant.imageIntroduction3),
  ];
  double topMarginForPageViewContent = 0.0;

  void initGlobalKey() {
    _pageViewContentGlobalKeyList = <GlobalKey>[
      GlobalKey(),
      GlobalKey(),
      GlobalKey()
    ];
  }

  @override
  PreloadPageViewChildrenBuilderDelegate buildPageViewChildrenDelegate() {
    return ((context, pageController) {
      List<Widget> pageViewChildren = <Widget>[
        _buildIntroductionPage(
          key: _pageViewContentGlobalKeyList[0],
          context: context,
          image: introductionImageList[0],
          title: "Belanja di Aplikasi Masterbagasi",
          top: topMarginForPageViewContent
        ),
        _buildIntroductionPage(
          key: _pageViewContentGlobalKeyList[1],
          context: context,
          image: introductionImageList[1],
          title: "Belanja dari Marketplace di Indonesia",
          top: topMarginForPageViewContent
        ),
        _buildIntroductionPage(
          key: _pageViewContentGlobalKeyList[2],
          context: context,
          image: introductionImageList[2],
          title: "",
          top: topMarginForPageViewContent
        ),
      ];
      if (pageViewChildren.length != _pageViewContentGlobalKeyList.length) {
        throw FlutterError("Page view children list count is not equal to Page view global key count.");
      }
      return pageViewChildren;
    });
  }

  Widget _buildIntroductionPage({
    required GlobalKey key,
    required BuildContext context,
    required Image image,
    required String title,
    double top = 100.0
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 7.w),
      child: Stack(
        children: [
          Positioned(
            top: top,
            left: 0,
            right: 0,
            child: Container(
              key: key,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: SizedBox(
                      height: 40.h,
                      child: image
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold))
                ]
              )
            )
          )
        ]
      )
    );
  }

  void dispose() {
    _pageViewContentGlobalKeyList.clear();
  }
}