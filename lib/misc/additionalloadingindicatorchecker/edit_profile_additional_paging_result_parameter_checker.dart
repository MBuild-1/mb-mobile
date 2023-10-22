import 'package:get/get.dart';

import '../controllerstate/listitemcontrollerstate/compound_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/profilemenulistitemcontrollerstate/profile_menu_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/shimmer_container_list_item_controller_state.dart';
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
              ProfileMenuListItemControllerState(
                onTap: null,
                title: 'Name'.tr,
                titleInterceptor: EditProfileHelper.setTitleInterceptor("Dummy Loading", isLoading: true),
                icon: null
              ),
              ProfileMenuListItemControllerState(
                onTap: null,
                title: 'Email'.tr,
                titleInterceptor: EditProfileHelper.setTitleInterceptor("Dummy Loading", isLoading: true),
                icon: null
              ),
              ProfileMenuListItemControllerState(
                onTap: null,
                title: 'Gender'.tr,
                titleInterceptor: EditProfileHelper.setTitleInterceptor("Dummy Loading", isLoading: true),
                icon: null
              ),
              ProfileMenuListItemControllerState(
                onTap: null,
                title: 'Date Birth'.tr,
                titleInterceptor: EditProfileHelper.setTitleInterceptor("Dummy Loading", isLoading: true),
                icon: null
              ),
              ProfileMenuListItemControllerState(
                onTap: null,
                title: 'Place Birth'.tr,
                titleInterceptor: EditProfileHelper.setTitleInterceptor("Dummy Loading", isLoading: true),
                icon: null
              ),
              ProfileMenuListItemControllerState(
                onTap: null,
                title: 'Phone Number'.tr,
                titleInterceptor: EditProfileHelper.setTitleInterceptor("Dummy Loading", isLoading: true),
                icon: null
              ),
            ]
          )
        )
      ]
    );
  }
}