import 'package:flutter/material.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';
import 'dart:math' as math;

import '../../domain/entity/province/province_map.dart';
import '../../misc/constant.dart';
import '../../misc/dialog_helper.dart';
import '../page/modaldialogpage/select_provinces_modal_dialog_page.dart';
import 'button/custombutton/sized_outline_gradient_button.dart';
import 'modified_svg_picture.dart';
import 'modifiedcachednetworkimage/explore_nusantara_modified_cached_network_image.dart';

class ProvinceMapHeaderListItem extends StatelessWidget {
  final ProvinceMap provinceMap;
  final void Function(ProvinceMap)? onSelectProvince;

  const ProvinceMapHeaderListItem({
    super.key,
    required this.provinceMap,
    this.onSelectProvince
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 200,
              child: ExploreNusantaraModifiedCachedNetworkImage(
                imageUrl: provinceMap.icon.toEmptyStringNonNull
              ),
            ),
            const SizedBox(height: 15.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SizedBox(
                height: 45,
                child: Stack(
                  children: [
                    SizedOutlineGradientButton(
                      onPressed: () async {
                        dynamic result = await DialogHelper.showModalDialogPage<ProvinceMap, ProvinceMap>(
                          context: context,
                          modalDialogPageBuilder: (context, parameter) => SelectProvincesModalDialogPage(
                            selectedProvince: parameter,
                          ),
                          parameter: provinceMap,
                        );
                        if (result is ProvinceMap) {
                          if (onSelectProvince != null) {
                            onSelectProvince!(result);
                          }
                        }
                      },
                      text: provinceMap.name,
                      customPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                      childInterceptor: (textStyle) {
                        return Row(
                          children: [
                            Expanded(
                              child: Center(
                                child: Text(
                                  provinceMap.name,
                                  style: textStyle,
                                ),
                              ),
                            ),
                            Transform.rotate(
                              angle: math.pi / 2,
                              child: ModifiedSvgPicture.asset(
                                Constant.vectorArrow,
                                width: 20.0,
                                height: 13.0,
                                color: Colors.white,
                              ),
                            )
                          ]
                        );
                      },
                      outlineGradientButtonType: OutlineGradientButtonType.solid,
                      outlineGradientButtonVariation: OutlineGradientButtonVariation.variation1,
                    ),
                  ],
                )
              ),
            ),
          ]
        ),
      ]
    );
  }
}