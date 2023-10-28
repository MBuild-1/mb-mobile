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
      GlobalKey(),
      GlobalKey(),
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
          titleTop: "E-commerce pertama karya anak bangsa",
          titleBottom: "untuk pasar dunia",
          description: "Berbelanja produk asli Indonesia di Negara mana pun Anda berada.",
          top: topMarginForPageViewContent
        ),
        _buildIntroductionPage(
          key: _pageViewContentGlobalKeyList[1],
          context: context,
          image: introductionImageList[1],
          titleTop: "Pengiriman barang dari Indonesia",
          titleBottom: "Ke seluruh dunia",
          description: "Siapkan barang yang Anda butuhkan lalu kirim ke Warehouse Master Bagasi, kami bantu packing dan kirim ke alamat Anda di seluruh dunia.",
          top: topMarginForPageViewContent
        ),
        _buildIntroductionPage(
          key: _pageViewContentGlobalKeyList[2],
          context: context,
          image: introductionImageList[2],
          titleTop: "Belanja di mana pun,",
          titleBottom: "Kami yang kirim",
          description: "Berbelanja di E-commerce Indonesia (Tokopedia, Shopee, Bukalapak, Dll) dengan menggunakan alamat Warehouse Master Bagasi. Kami kumpulkan belanjaannya, kami re-packing dan kami kirim ke alamat Anda di seluruh dunia.",
          top: topMarginForPageViewContent
        ),
        _buildLastIntroductionPage(
          key: _pageViewContentGlobalKeyList[3],
          context: context,
          top: topMarginForPageViewContent
        )
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
    required String titleTop,
    required String titleBottom,
    required String description,
    double top = 100.0
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 7.w),
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
                  SizedBox(height: 2.5.h),
                  Text(titleTop, style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Constant.colorMain)),
                  Text(titleBottom, style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Constant.colorDarkBlue)),
                  SizedBox(height: 2.h),
                  Text(description, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade500)),
                ]
              )
            )
          )
        ]
      )
    );
  }

  Widget _buildLastIntroductionPage({
    required GlobalKey key,
    required BuildContext context,
    double top = 100.0
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 7.w),
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
                  SizedBox(
                    height: 7.h,
                    child: FittedBox(
                      child: Image.asset(Constant.imageMasterbagasi)
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Center(
                    child: SizedBox(
                      height: 30.h,
                      child: FittedBox(
                        child: Image.asset(Constant.imageIntroduction4)
                      ),
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Center(
                    child: SizedBox(
                      height: 11.h,
                      child: FittedBox(
                        child: Image.asset(Constant.imageBringingHappiness)
                      ),
                    ),
                  ),
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