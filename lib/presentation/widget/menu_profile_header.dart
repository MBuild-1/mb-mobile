import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/error_provider_ext.dart';
import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';
import 'package:sizer/sizer.dart';

import '../../domain/entity/user/user.dart';
import '../../misc/constant.dart';
import '../../misc/errorprovider/error_provider.dart';
import '../../misc/load_data_result.dart';
import '../../misc/page_restoration_helper.dart';
import 'icon_title_and_description_list_item.dart';
import 'modified_svg_picture.dart';
import 'profile_picture_cache_network_image.dart';

class MenuProfileHeader extends StatefulWidget {
  final LoadDataResult<User> userLoadDataResult;
  final ErrorProvider errorProvider;

  const MenuProfileHeader({
    super.key,
    required this.userLoadDataResult,
    required this.errorProvider
  });

  @override
  State<MenuProfileHeader> createState() => _MenuProfileHeaderState();
}

class _MenuProfileHeaderState extends State<MenuProfileHeader> with AutomaticKeepAliveClientMixin<MenuProfileHeader> {
  final GlobalKey _containerGlobalKey = GlobalKey();
  double? _containerHeight;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Size? containerSize = (_containerGlobalKey.currentContext?.findRenderObject() as RenderBox?)?.size;
      if (_containerHeight != containerSize?.height) {
        setState(() {
          _containerHeight = containerSize?.height;
        });
      }
    });
    String title = "";
    String description = "";
    String profileImageUrl = "";
    String noName = "No Name".tr;
    if (widget.userLoadDataResult.isLoading) {
      String loading = "(${Constant.textLoading})";
      title = loading;
      description = loading;
    } else if (widget.userLoadDataResult.isSuccess) {
      User user = widget.userLoadDataResult.resultIfSuccess!;
      title = user.name.isEmptyString ? user.name.toStringNonNullWithCustomText(text: noName) : user.name.toStringNonNullWithCustomText(text: noName);
      description = user.email.isEmptyString ? (user.userProfile.phoneNumber.isEmptyString ? "No Email".tr : user.userProfile.phoneNumber!) : user.email;
      profileImageUrl = user.userProfile.avatar.toEmptyStringNonNull;
    } else if (widget.userLoadDataResult.isFailed) {
      ErrorProviderResult errorProviderResult = widget.errorProvider.onGetErrorProviderResult(widget.userLoadDataResult.resultIfFailed!).toErrorProviderResultNonNull();
      title = errorProviderResult.title;
      description = errorProviderResult.message;
    }
    return Column(
      children: [
        Container(
          key: _containerGlobalKey,
          padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: Constant.colorGrey10
          ),
          clipBehavior: Clip.antiAlias,
          child: Row(
            children: [
              SizedBox(width: Constant.paddingListItem),
              Expanded(
                child: Column(
                  children: [
                    const SizedBox(height: 12.0),
                    IconTitleAndDescriptionListItem(
                      title: title,
                      titleInterceptor: (title, textStyle) {
                        return Text(
                          title,
                          style: textStyle?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 20.0
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        );
                      },
                      description: description,
                      descriptionInterceptor: (description, textStyle) {
                        return Text(
                          description,
                          style: textStyle?.copyWith(
                            color: Colors.white,
                            fontSize: 12.0
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        );
                      },
                      space: 4.w,
                      verticalSpace: 0.0,
                      icon: ProfilePictureCacheNetworkImage(
                        profileImageUrl: profileImageUrl,
                        dimension: 50.0,
                      ),
                    ),
                    const SizedBox(height: 12.0),
                  ],
                ),
              ),
              const SizedBox(width: 10.0),
              SizedBox(
                height: _containerHeight,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _containerHeight != null ? () => PageRestorationHelper.toEditProfilePage(context) : null,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
                      child: ModifiedSvgPicture.asset(
                        Constant.vectorSettings,
                        width: 16.0,
                        color: Colors.white
                      ),
                    ),
                  )
                ),
              )
            ]
          )
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: Material(
                borderRadius: BorderRadius.circular(8.0),
                child: InkWell(
                  onTap: () => PageRestorationHelper.toMsmePartnerPage(context),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            "Join MB Partners".tr,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis
                          ),
                        ),
                        const SizedBox(width: 10),
                        ModifiedSvgPicture.asset(
                          Constant.vectorArrow,
                          height: 10,
                        ),
                      ]
                    ),
                  )
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Material(
                borderRadius: BorderRadius.circular(8.0),
                child: InkWell(
                  onTap: () => PageRestorationHelper.toAffiliatePage(context),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            "Register MB Affiliation".tr,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis
                          ),
                        ),
                        const SizedBox(width: 10),
                        ModifiedSvgPicture.asset(
                          Constant.vectorArrow,
                          height: 10,
                        ),
                      ]
                    ),
                  )
                ),
              ),
            )
          ]
        )
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}