import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/error_provider_ext.dart';
import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';

import '../../domain/entity/user/user.dart';
import '../../domain/entity/user/user_and_loaded_related_user_data.dart';
import '../../misc/constant.dart';
import '../../misc/errorprovider/error_provider.dart';
import '../../misc/load_data_result.dart';
import '../../misc/page_restoration_helper.dart';
import 'modified_country_flag.dart';
import 'modified_divider.dart';
import 'modified_shimmer.dart';
import 'modified_svg_picture.dart';
import 'profile_picture_cache_network_image.dart';

class MenuProfileHeader extends StatefulWidget {
  final LoadDataResult<UserAndLoadedRelatedUserData> userLoadDataResult;
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
  @override
  Widget build(BuildContext context) {
    super.build(context);
    String title = "";
    String description = "";
    String profileImageUrl = "";
    String noName = "No Name".tr;
    String biography = "";
    String countryCode = "";
    if (widget.userLoadDataResult.isLoading) {
      String loading = "(${Constant.textLoading})";
      title = loading;
      description = loading;
      biography = loading;
      countryCode = loading;
    } else if (widget.userLoadDataResult.isSuccess) {
      UserAndLoadedRelatedUserData userAndLoadedRelatedUserData = widget.userLoadDataResult.resultIfSuccess!;
      User user = widget.userLoadDataResult.resultIfSuccess!.user;
      title = user.name.isEmptyString ? user.name.toStringNonNullWithCustomText(text: noName) : user.name.toStringNonNullWithCustomText(text: noName);
      description = user.userProfile.username.isNotEmptyString ? "@${user.userProfile.username}" : "No Username".tr;
      biography = user.userProfile.biography.isNotEmptyString ? user.userProfile.biography! : "No Bio".tr;
      profileImageUrl = user.userProfile.avatar.toEmptyStringNonNull;
      countryCode = userAndLoadedRelatedUserData.countryCode;
    } else if (widget.userLoadDataResult.isFailed) {
      ErrorProviderResult errorProviderResult = widget.errorProvider.onGetErrorProviderResult(widget.userLoadDataResult.resultIfFailed!).toErrorProviderResultNonNull();
      title = errorProviderResult.title;
      description = errorProviderResult.message;
    }
    double profilePictureSize = 55.0;
    Widget result = Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8.0),
      child: InkWell(
        onTap: () => PageRestorationHelper.toEditProfilePage(context),
        borderRadius: BorderRadius.circular(8.0),
        child: Column(
          children: [
            const SizedBox(height: 12.0),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(width: 16.0),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ProfilePictureCacheNetworkImage(
                      profileImageUrl: profileImageUrl,
                      dimension: profilePictureSize,
                    ),
                    if (countryCode.isNotEmptyString) ...[
                      const SizedBox(height: 10),
                      ModifiedCountryFlag(
                        width: 25,
                        countryCode: countryCode,
                      ),
                      const SizedBox(height: 4),
                      Text(countryCode, style: const TextStyle(fontSize: 12.0))
                    ]
                  ]
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Builder(
                    builder: (context) {
                      TextSpan titleTextSpan = TextSpan(
                        text: title,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 17.0
                        )
                      );
                      TextSpan? subtitleTextSpan = widget.userLoadDataResult.isLoading ? null : TextSpan(
                        text: description,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 12.0
                        )
                      );
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: profilePictureSize,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text.rich(
                                        titleTextSpan,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      if (subtitleTextSpan != null) ...[
                                        Text.rich(
                                          subtitleTextSpan,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 6.0),
                                      ],
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 32.0,
                                  height: profilePictureSize + 12.0,
                                  child: Center(
                                    child: ModifiedSvgPicture.asset(
                                      Constant.vectorArrow,
                                      width: 10.0,
                                      color: Constant.colorGrey3
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ),
                          const ModifiedDivider(),
                          if (biography.isNotEmptyString) ...[
                            const SizedBox(height: 12.0),
                            Text(
                              biography,
                              style: const TextStyle(fontSize: 12.0),
                            )
                          ]
                        ],
                      );
                    }
                  ),
                ),
              ]
            ),
            const SizedBox(height: 12.0),
          ],
        )
      ),
    );
    return widget.userLoadDataResult.isLoading
      ? ModifiedShimmer.fromColors(child: result)
      : result;
  }

  @override
  bool get wantKeepAlive => true;
}