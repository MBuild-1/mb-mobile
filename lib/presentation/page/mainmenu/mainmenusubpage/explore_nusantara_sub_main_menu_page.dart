import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';
import 'package:masterbagasi/presentation/widget/loaddataresultimplementer/load_data_result_implementer_directly.dart';
import 'package:sizer/sizer.dart';
import 'dart:math' as math;

import '../../../../controller/mainmenucontroller/mainmenusubpagecontroller/explore_nusantara_main_menu_sub_controller.dart';
import '../../../../domain/entity/province/province_map.dart';
import '../../../../misc/backgroundappbarscaffoldtype/color_background_app_bar_scaffold_type.dart';
import '../../../../misc/constant.dart';
import '../../../../misc/controllerstate/explore_nusantara_main_menu_controller_state.dart';
import '../../../../misc/custompainter/explore_nusantara_map_custom_painter.dart';
import '../../../../misc/errorprovider/error_provider.dart';
import '../../../../misc/injector.dart';
import '../../../../misc/load_data_result.dart';
import '../../../../misc/login_helper.dart';
import '../../../../misc/main_route_observer.dart';
import '../../../../misc/manager/controller_manager.dart';
import '../../../../misc/page_restoration_helper.dart';
import '../../../../misc/widget_helper.dart';
import '../../../widget/background_app_bar_scaffold.dart';
import '../../../widget/button/custombutton/sized_outline_gradient_button.dart';
import '../../../widget/loaddataresultimplementer/load_data_result_implementer.dart';
import '../../../widget/modified_canvas_touch_detector.dart';
import '../../../widget/modified_svg_picture.dart';
import '../../../widget/modifiedappbar/main_menu_search_app_bar.dart';
import '../../../widget/modifiedcachednetworkimage/explore_nusantara_background_modified_cached_network_image.dart';
import '../../../widget/modifiedcachednetworkimage/explore_nusantara_modified_cached_network_image.dart';
import '../../../widget/rx_consumer.dart';
import '../../../widget/tap_area.dart';
import '../../getx_page.dart';
import '../../product_entry_page.dart';

class ExploreNusantaraMainMenuSubPage extends DefaultGetxPage {
  late final ControllerMember<ExploreNusantaraMainMenuSubController> _exploreNusantaraMainMenuSubController = ControllerMember<ExploreNusantaraMainMenuSubController>().addToControllerManager(controllerManager);
  final String ancestorPageName;

  ExploreNusantaraMainMenuSubPage({Key? key, required this.ancestorPageName}) : super(key: key, systemUiOverlayStyle: SystemUiOverlayStyle.dark);

  @override
  void onSetController() {
    _exploreNusantaraMainMenuSubController.controller = Injector.locator<ExploreNusantaraMainMenuSubControllerInjectionFactory>().inject(controllerManager, ancestorPageName);
  }

  @override
  Widget buildPage(BuildContext context) {
    return _StatefulExploreNusantaraMainMenuSubControllerMediatorWidget(
      exploreNusantaraMainMenuSubController: _exploreNusantaraMainMenuSubController.controller
    );
  }
}

class _StatefulExploreNusantaraMainMenuSubControllerMediatorWidget extends StatefulWidget {
  final ExploreNusantaraMainMenuSubController exploreNusantaraMainMenuSubController;

  const _StatefulExploreNusantaraMainMenuSubControllerMediatorWidget({
    required this.exploreNusantaraMainMenuSubController
  });

  @override
  State<_StatefulExploreNusantaraMainMenuSubControllerMediatorWidget> createState() => _StatefulExploreNusantaraMainMenuSubControllerMediatorWidgetState();
}

class _StatefulExploreNusantaraMainMenuSubControllerMediatorWidgetState extends State<_StatefulExploreNusantaraMainMenuSubControllerMediatorWidget> {
  late AssetImage _exploreNusantaraAppBarBackgroundAssetImage;
  final TransformationController _transformationController = TransformationController();
  double _scale = 1.0;

  @override
  void initState() {
    super.initState();
    _exploreNusantaraAppBarBackgroundAssetImage = AssetImage(Constant.imagePatternExploreNusantaraMainMenuAppBar);
    MainRouteObserver.controllerMediatorMap[Constant.subPageKeyExploreNusantaraMainMenu] = refreshExploreNusantaraMainMenu;
    MainRouteObserver.onChangeSelectedProvince = (provinceMap) {
      widget.exploreNusantaraMainMenuSubController.selectProvinceMap(provinceMap);
    };
  }

  @override
  void didChangeDependencies() {
    precacheImage(_exploreNusantaraAppBarBackgroundAssetImage, context);
    super.didChangeDependencies();
  }

  void refreshExploreNusantaraMainMenu() {
    setState(() {});
  }

  Widget _headerSection() {
    return Column(
      children: [
        const SizedBox(height: 16.0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Opacity(
            opacity: (1.0  - ((_scale - 1.0) / 0.5)).clamp(0.0, 1.0),
            child: Text(
              "Welcome To Nusantara".tr,
              style: TextStyle(
                fontSize: (16.5).sp,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        const SizedBox(height: 0.0),
      ],
    );
  }

  Widget _footerSection() {
    return Column(
      children: [
        const SizedBox(height: 10.0),
        RxConsumer<ExploreNusantaraMainMenuControllerState>(
          rxValue: widget.exploreNusantaraMainMenuSubController.exploreNusantaraMainMenuControllerStateRx,
          onConsumeValue: (context, value) {
            if (value.provinceMapListLoadDataResult.isSuccess) {
              return Column(
                children: [
                  Builder(
                    builder: (context) {
                      double height = (MediaQuery.of(context).size.width * 411 / 547) - 40;
                      return SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: height,
                        child: Transform.scale(
                          scale: 1.11,
                          origin: Offset(0, height / 2),
                          child: ExploreNusantaraModifiedCachedNetworkImage(
                            imageUrl: value.selectedProvinceMap!.icon.toEmptyStringNonNull
                          ),
                        )
                      );
                    }
                  ),
                ]
              );
            } else {
              return Container();
            }
          }
        ),
      ],
    );
  }

  Widget _changeProvinceButtonSelection() {
    return RxConsumer<ExploreNusantaraMainMenuControllerState>(
      rxValue: widget.exploreNusantaraMainMenuSubController.exploreNusantaraMainMenuControllerStateRx,
      onConsumeValue: (context, value) {
        if (value.provinceMapListLoadDataResult.isSuccess) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0).copyWith(top: 0.0),
            child: SizedBox(
              height: 45,
              child: Stack(
                children: [
                  IgnorePointer(
                    child: SizedOutlineGradientButton(
                      onPressed: () {},
                      text: "",
                      outlineGradientButtonType: OutlineGradientButtonType.solid,
                      outlineGradientButtonVariation: OutlineGradientButtonVariation.variation5,
                    ),
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 30,
                        child: TapArea(
                          onTap: () => widget.exploreNusantaraMainMenuSubController.previousProvinceMap(),
                          child: Transform.rotate(
                            angle: -math.pi,
                            child: ModifiedSvgPicture.asset(
                              Constant.vectorArrow,
                              color: Colors.white,
                              height: 10,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: TapArea(
                          onTap: () => PageRestorationHelper.toProductEntryPage(
                            context,
                            ProductEntryPageParameter(
                              productEntryParameterMap: {
                                "province": value.selectedProvinceMap!.slug,
                                "province_id": value.selectedProvinceMap!.id
                              }
                            )
                          ),
                          child: Center(
                            child: Text(
                              value.selectedProvinceMap!.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold
                              )
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 30,
                        child: TapArea(
                          onTap: () => widget.exploreNusantaraMainMenuSubController.nextProvinceMap(),
                          child: ModifiedSvgPicture.asset(
                            Constant.vectorArrow,
                            color: Colors.white,
                            height: 10,
                          ),
                        )
                      )
                    ],
                  ),
                ],
              )
            ),
          );
        } else {
          return Container();
        }
      }
    );
  }

  Widget _requiredLoginWidgetSpacing() {
    return Builder(
      builder: (BuildContext context) {
        bool isLogin = false;
        LoginHelper.checkingLogin(
          context,
          () => isLogin = true,
          resultIfHasNotBeenLogin: () => isLogin = false
        );
        if (!isLogin) {
          return SizedBox(
            height: Constant.mainMenuFooterHeight - Constant.paddingListItem
          );
        }
        return const SizedBox();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      widget.exploreNusantaraMainMenuSubController.loadProvinceMap();
    });
    Widget hideWidget(Widget widget) {
      return Visibility(
        visible: false,
        maintainSize: true,
        maintainAnimation: true,
        maintainState: true,
        child: widget
      );
    }
    Widget contentWidget(Widget Function(double, double, List<ProvinceMap>) content) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0.0),
        child: RxConsumer<ExploreNusantaraMainMenuControllerState>(
          rxValue: widget.exploreNusantaraMainMenuSubController.exploreNusantaraMainMenuControllerStateRx,
          onConsumeValue: (context, value) => LoadDataResultImplementer<List<ProvinceMap>>(
            loadDataResult: value.provinceMapListLoadDataResult,
            errorProvider: Injector.locator<ErrorProvider>(),
            onSuccessLoadDataResultWidget: (provinceMapList) {
              double width = MediaQuery.of(context).size.width;
              double height = width * 350.0 / 1000.0;
              return content(width, height, provinceMapList);
            },
            onFailedLoadDataResultWidget: (errorProvider, e, _) {
              return WidgetHelper.buildFailedPromptIndicatorFromErrorProvider(
                context: context,
                errorProvider: Injector.locator<ErrorProvider>(),
                e: e,
                buttonText: "Reload".tr,
                onPressed: widget.exploreNusantaraMainMenuSubController.reloadProvinceMap
              );
            }
          ),
        ),
      );
    }
    return WidgetHelper.checkVisibility(
      MainRouteObserver.subMainMenuVisibility[Constant.subPageKeyExploreNusantaraMainMenu],
      () => Stack(
        children: [
          RxConsumer<ExploreNusantaraMainMenuControllerState>(
            rxValue: widget.exploreNusantaraMainMenuSubController.exploreNusantaraMainMenuControllerStateRx,
            onConsumeValue: (context, value) {
              if (value.provinceMapListLoadDataResult.isSuccess) {
                return Stack(
                  children: [
                    Builder(
                      builder: (context) {
                        ProvinceMap provinceMap = value.selectedProvinceMap!;
                        String banner = provinceMap.bannerMobile.isNotEmptyString ? provinceMap.bannerMobile.toEmptyStringNonNull : provinceMap.bannerDesktop.toEmptyStringNonNull;
                        return SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: AspectRatio(
                            aspectRatio: Constant.aspectRatioValueExploreNusantaraBanner.toDouble(),
                            child: Stack(
                              children: [
                                ExploreNusantaraBackgroundModifiedCachedNetworkImage(imageUrl: banner),
                              ],
                            ),
                          ),
                        );
                      }
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: AspectRatio(
                          aspectRatio: Constant.aspectRatioValueExploreNusantaraBackground.toDouble(),
                          child: Stack(
                            children: [
                              Container(color: Colors.grey.withOpacity(0.4)),
                              ExploreNusantaraBackgroundModifiedCachedNetworkImage(
                                imageUrl: value.selectedProvinceMap!.background.toEmptyStringNonNull
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ]
                );
              } else {
                return Container();
              }
            }
          ),
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Theme.of(context).scaffoldBackgroundColor.withOpacity(0.0),
                    Theme.of(context).scaffoldBackgroundColor.withOpacity(0.0),
                    Theme.of(context).scaffoldBackgroundColor,
                    Theme.of(context).scaffoldBackgroundColor,
                    Theme.of(context).scaffoldBackgroundColor,
                    Theme.of(context).scaffoldBackgroundColor,
                    Theme.of(context).scaffoldBackgroundColor.withOpacity(0.0),
                  ],
                  stops: const [
                    0.0, 0.26, 0.36, 0.5, 0.6, 0.7, 1.0
                  ]
                )
              ),
            ),
          ),
          InteractiveViewer(
            maxScale: 10.0,
            transformationController: _transformationController,
            onInteractionUpdate: (scaleUpdateDetails) {
              _scale = _transformationController.value.getMaxScaleOnAxis();
              setState(() {});
            },
            child: Column(
              children: [
                const Expanded(
                  child: SizedBox()
                ),
                hideWidget(_headerSection()),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0.0),
                  child: RxConsumer<ExploreNusantaraMainMenuControllerState>(
                    rxValue: widget.exploreNusantaraMainMenuSubController.exploreNusantaraMainMenuControllerStateRx,
                    onConsumeValue: (context, value) => contentWidget(
                      (width, height, provinceMapList) => SizedBox(
                        width: width,
                        height: height,
                        child: ModifiedCanvasTouchDetector(
                          builder: (context) => CustomPaint(
                            painter: ExploreNusantaraMapCustomPainter(
                              context: context,
                              provinceMapList: provinceMapList,
                              selectedProvinceMap: value.selectedProvinceMap,
                              onSelectProvinceMap: (provinceMap) {
                                widget.exploreNusantaraMainMenuSubController.selectProvinceMap(provinceMap);
                              },
                            )
                          )
                        )
                      )
                    )
                  ),
                ),
                hideWidget(_footerSection()),
                hideWidget(_changeProvinceButtonSelection()),
                hideWidget(_requiredLoginWidgetSpacing())
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Flexible(
                child: IgnorePointer(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _headerSection(),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0.0),
                          child: Builder(
                            builder: (context) {
                              return contentWidget(
                                (width, height, _) => SizedBox(
                                  width: width,
                                  height: height,
                                )
                              );
                            }
                          )
                        ),
                        _footerSection(),
                      ],
                    ),
                  ),
                ),
              ),
              _changeProvinceButtonSelection(),
              _requiredLoginWidgetSpacing()
            ]
          ),
          if (_scale > 1.0) ...[
            SafeArea(
              bottom: false,
              child: Stack(
                children: [
                  Positioned(
                    right: 0.0,
                    child: IconButton(
                      icon: const Icon(
                        Icons.zoom_out_map
                      ),
                      iconSize: 40,
                      onPressed: () {
                        _transformationController.value = Matrix4.identity();
                        _scale = _transformationController.value.getMaxScaleOnAxis();
                        setState(() {});
                      },
                    ),
                  ),
                ]
              ),
            )
          ]
        ]
      ),
    );
  }
}