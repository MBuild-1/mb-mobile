import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../presentation/widget/profile_picture_cache_network_image.dart';
import '../../presentation/widget/tap_area.dart';
import '../constant.dart';
import '../controllerstate/listitemcontrollerstate/compound_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/padding_container_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/profilemenuincardlistitemcontrollerstate/profile_menu_in_card_group_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/profilemenuincardlistitemcontrollerstate/profile_menu_in_card_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/profilemenulistitemcontrollerstate/profile_menu_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/shimmer_container_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/virtual_spacing_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/widget_substitution_list_item_controller_state.dart';
import '../edit_profile_helper.dart';
import '../paging/pagingresult/paging_result_with_parameter.dart';
import 'additional_paging_result_parameter_checker.dart';

class EditProfileAdditionalPagingResultParameterChecker extends AdditionalPagingResultParameterChecker<int, ListItemControllerState> {
  @override
  PagingResultParameter<ListItemControllerState>? getAdditionalPagingResultParameter(AdditionalPagingResultCheckerParameter<int, ListItemControllerState> additionalPagingResultCheckerParameter) {
    return PagingResultParameter<ListItemControllerState>(
      showOriginalLoaderIndicator: false,
      additionalItemList: <ListItemControllerState>[
        ShimmerContainerListItemControllerState(
          shimmerChildListItemControllerState: CompoundListItemControllerState(
            listItemControllerState: [
              WidgetSubstitutionListItemControllerState(
                widgetSubstitution: (context, index) {
                  return Column(
                    children: [
                      ProfilePictureCacheNetworkImage(
                        profileImageUrl: "",
                        dimension: 20.w
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        "Change Profile Photo".tr,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          backgroundColor: Colors.grey
                        ),
                      )
                    ],
                  );
                }
              ),
              VirtualSpacingListItemControllerState(height: 16.0),
              PaddingContainerListItemControllerState(
                padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
                paddingChildListItemControllerState: ProfileMenuInCardGroupListItemControllerState(
                  onUpdateState: () {},
                  profileMenuInCardListItemControllerStateList: [
                    ProfileMenuInCardListItemControllerState(
                      onTap: null,
                      title: 'Name'.tr,
                      titleInterceptor: EditProfileHelper.setContentInterceptor("Dummy Loading", isLoading: true),
                      icon: null
                    ),
                    ProfileMenuInCardListItemControllerState(
                      onTap: null,
                      title: 'Email'.tr,
                      titleInterceptor: EditProfileHelper.setContentInterceptor("Dummy Loading", isLoading: true),
                      icon: null
                    ),
                    ProfileMenuInCardListItemControllerState(
                      onTap: null,
                      title: 'Gender'.tr,
                      titleInterceptor: EditProfileHelper.setContentInterceptor("Dummy Loading", isLoading: true),
                      icon: null
                    ),
                    ProfileMenuInCardListItemControllerState(
                      onTap: null,
                      title: 'Date Birth'.tr,
                      titleInterceptor: EditProfileHelper.setContentInterceptor("Dummy Loading", isLoading: true),
                      icon: null
                    ),
                    ProfileMenuInCardListItemControllerState(
                      onTap: null,
                      title: 'Place Birth'.tr,
                      titleInterceptor: EditProfileHelper.setContentInterceptor("Dummy Loading", isLoading: true),
                      icon: null
                    ),
                    ProfileMenuInCardListItemControllerState(
                      onTap: null,
                      title: 'Phone Number'.tr,
                      titleInterceptor: EditProfileHelper.setContentInterceptor("Dummy Loading", isLoading: true),
                      icon: null
                    ),
                  ]
                )
              )
            ]
          )
        )
      ]
    );
  }
}