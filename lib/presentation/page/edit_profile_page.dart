import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';
import 'package:masterbagasi/misc/ext/paging_controller_ext.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';

import '../../controller/edit_profile_controller.dart';
import '../../domain/entity/user/edituser/edit_user_parameter.dart';
import '../../domain/entity/user/getuser/get_user_parameter.dart';
import '../../domain/entity/user/user.dart';
import '../../domain/usecase/edit_user_use_case.dart';
import '../../domain/usecase/get_user_use_case.dart';
import '../../misc/additionalloadingindicatorchecker/edit_profile_additional_paging_result_parameter_checker.dart';
import '../../misc/controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../../misc/controllerstate/listitemcontrollerstate/profilemenulistitemcontrollerstate/profile_menu_list_item_controller_state.dart';
import '../../misc/controllerstate/paging_controller_state.dart';
import '../../misc/date_util.dart';
import '../../misc/dialog_helper.dart';
import '../../misc/edit_profile_helper.dart';
import '../../misc/errorprovider/error_provider.dart';
import '../../misc/getextended/get_extended.dart';
import '../../misc/getextended/get_restorable_route_future.dart';
import '../../misc/injector.dart';
import '../../misc/load_data_result.dart';
import '../../misc/manager/controller_manager.dart';
import '../../misc/page_restoration_helper.dart';
import '../../misc/paging/modified_paging_controller.dart';
import '../../misc/paging/pagingcontrollerstatepagedchildbuilderdelegate/list_item_paging_controller_state_paged_child_builder_delegate.dart';
import '../../misc/paging/pagingresult/paging_data_result.dart';
import '../../misc/paging/pagingresult/paging_result.dart';
import '../widget/modified_paged_list_view.dart';
import '../widget/modifiedappbar/modified_app_bar.dart';
import 'crop_picture_page.dart';
import 'getx_page.dart';
import 'modaldialogpage/input_value_modal_dialog_page.dart';

class EditProfilePage extends RestorableGetxPage<_EditProfilePageRestoration> {
  late final ControllerMember<EditProfileController> _editProfileController = ControllerMember<EditProfileController>().addToControllerManager(controllerManager);

  EditProfilePage({
    Key? key
  }) : super(key: key, pageRestorationId: () => "edit-profile-page");

  @override
  void onSetController() {
    _editProfileController.controller = GetExtended.put<EditProfileController>(
      EditProfileController(
        controllerManager,
        Injector.locator<EditUserUseCase>(),
        Injector.locator<GetUserUseCase>()
      ), tag: pageName
    );
  }

  @override
  Widget buildPage(BuildContext context) {
    return _StatefulEditProfileControllerMediatorWidget(
      editProfileController: _editProfileController.controller
    );
  }

  @override
  _EditProfilePageRestoration createPageRestoration() => _EditProfilePageRestoration();
}

class _EditProfilePageRestoration extends MixableGetxPageRestoration with CropPicturePageRestorationMixin {
  @override
  // ignore: unnecessary_overrides
  void initState() {
    super.initState();
  }

  @override
  // ignore: unnecessary_overrides
  void restoreState(Restorator restorator, RestorationBucket? oldBucket, bool initialRestore) {
    super.restoreState(restorator, oldBucket, initialRestore);
  }

  @override
  // ignore: unnecessary_overrides
  void dispose() {
    super.dispose();
  }
}

class EditProfilePageGetPageBuilderAssistant extends GetPageBuilderAssistant {
  @override
  GetPageBuilder get pageBuilder => (() => EditProfilePage());

  @override
  GetPageBuilder get pageWithOuterGetxBuilder => (() => GetxPageBuilder.buildRestorableGetxPage(EditProfilePage()));
}

mixin EditProfilePageRestorationMixin on MixableGetxPageRestoration {
  RouteCompletionCallback<bool?>? onCompleteEditProfile;

  late EditProfilePageRestorableRouteFuture editProfilePageRestorableRouteFuture;

  @override
  void initState() {
    super.initState();
    editProfilePageRestorableRouteFuture = EditProfilePageRestorableRouteFuture(
      restorationId: restorationIdWithPageName('edit-profile-route'),
      onComplete: onCompleteEditProfile
    );
  }

  @override
  void restoreState(Restorator restorator, RestorationBucket? oldBucket, bool initialRestore) {
    super.restoreState(restorator, oldBucket, initialRestore);
    editProfilePageRestorableRouteFuture.restoreState(restorator, oldBucket, initialRestore);
  }

  @override
  void dispose() {
    super.dispose();
    editProfilePageRestorableRouteFuture.dispose();
  }
}

class EditProfilePageRestorableRouteFuture extends GetRestorableRouteFuture {
  final RouteCompletionCallback<bool?>? onComplete;

  late RestorableRouteFuture<bool?> _pageRoute;

  EditProfilePageRestorableRouteFuture({
    required String restorationId,
    this.onComplete
  }) : super(restorationId: restorationId) {
    _pageRoute = RestorableRouteFuture<bool?>(
      onPresent: (NavigatorState navigator, Object? arguments) {
        return navigator.restorablePush(_pageRouteBuilder, arguments: arguments);
      },
      onComplete: onComplete
    );
  }

  static Route<bool?>? _getRoute([Object? arguments]) {
    return GetExtended.toWithGetPageRouteReturnValue<bool?>(
      GetxPageBuilder.buildRestorableGetxPageBuilder(EditProfilePageGetPageBuilderAssistant())
    );
  }

  @pragma('vm:entry-point')
  static Route<bool?> _pageRouteBuilder(BuildContext context, Object? arguments) {
    return _getRoute(arguments)!;
  }

  @override
  bool checkBeforePresent([Object? arguments]) => _getRoute(arguments) != null;

  @override
  void presentIfCheckIsPassed([Object? arguments]) => _pageRoute.present(arguments);

  @override
  void restoreState(Restorator restorator, RestorationBucket? oldBucket, bool initialRestore) {
    restorator.registerForRestoration(_pageRoute, restorationId);
  }

  @override
  void dispose() {
    _pageRoute.dispose();
  }
}

class _StatefulEditProfileControllerMediatorWidget extends StatefulWidget {
  final EditProfileController editProfileController;

  const _StatefulEditProfileControllerMediatorWidget({
    required this.editProfileController
  });

  @override
  State<_StatefulEditProfileControllerMediatorWidget> createState() => _StatefulEditProfileControllerMediatorWidgetState();
}

class _StatefulEditProfileControllerMediatorWidgetState extends State<_StatefulEditProfileControllerMediatorWidget> {
  late final ScrollController _editProfileScrollController;
  late final ModifiedPagingController<int, ListItemControllerState> _editProfileListItemPagingController;
  late final PagingControllerState<int, ListItemControllerState> _editProfileListItemPagingControllerState;

  @override
  void initState() {
    super.initState();
    _editProfileScrollController = ScrollController();
    _editProfileListItemPagingController = ModifiedPagingController<int, ListItemControllerState>(
      firstPageKey: 1,
      // ignore: invalid_use_of_protected_member
      apiRequestManager: widget.editProfileController.apiRequestManager,
      additionalPagingResultParameterChecker: EditProfileAdditionalPagingResultParameterChecker()
    );
    _editProfileListItemPagingControllerState = PagingControllerState(
      pagingController: _editProfileListItemPagingController,
      scrollController: _editProfileScrollController,
      isPagingControllerExist: false
    );
    _editProfileListItemPagingControllerState.pagingController.addPageRequestListenerWithItemListForLoadDataResult(
      listener: _editProfileListItemPagingControllerStateListener,
      onPageKeyNext: (pageKey) => pageKey + 1
    );
    _editProfileListItemPagingControllerState.isPagingControllerExist = true;
  }

  Future<LoadDataResult<PagingResult<ListItemControllerState>>> _editProfileListItemPagingControllerStateListener(int pageKey, List<ListItemControllerState>? cartListItemControllerStateList) async {
    LoadDataResult<User> userLoadDataResult = await widget.editProfileController.getUserProfile(GetUserParameter());
    void editProfile(EditUserParameter editUserParameter)  {
      widget.editProfileController.editProfile(editUserParameter);
    }
    void editTextProfileField({
      required BuildContext context,
      required InputValueModalDialogPageParameter inputValueModalDialogPageParameter,
      required EditUserParameter Function(String) onConfigureEditUserParameter
    }) async {
      dynamic result = await DialogHelper.showModalDialogPage<String, InputValueModalDialogPageParameter>(
        context: context,
        modalDialogPageBuilder: (context, parameter) => InputValueModalDialogPage(
          inputValueModalDialogPageParameter: parameter!
        ),
        parameter: inputValueModalDialogPageParameter,
      );
      if (result is String) {
        editProfile(onConfigureEditUserParameter(result));
      }
    }
    return userLoadDataResult.map<PagingResult<ListItemControllerState>>((user) {
      return PagingDataResult<ListItemControllerState>(
        itemList: [
          ProfileMenuListItemControllerState(
            onTap: (context) => editTextProfileField(
              context: context,
              inputValueModalDialogPageParameter: InputValueModalDialogPageParameter(
                value: user.name,
                title: () => 'Name'.tr,
                inputTitle: () => 'Input Name'.tr,
                inputHint: () => 'Type Name'.tr,
                inputSubmitText: () => "Submit".tr,
                requiredMessage: () => "${"Name is required".tr}.",
              ),
              onConfigureEditUserParameter: (result) => EditUserParameter(
                name: result
              )
            ),
            title: 'Name'.tr,
            titleInterceptor: EditProfileHelper.setTitleInterceptor(user.name),
            icon: null
          ),
          ProfileMenuListItemControllerState(
            onTap: (context) => editTextProfileField(
              context: context,
              inputValueModalDialogPageParameter: InputValueModalDialogPageParameter(
                value: user.email,
                title: () => 'Email'.tr,
                inputTitle: () => 'Input Email'.tr,
                inputHint: () => 'Type Email'.tr,
                inputSubmitText: () => "Submit".tr,
                requiredMessage: () => "${"Email is required".tr}.",
              ),
              onConfigureEditUserParameter: (result) => EditUserParameter(
                email: result
              )
            ),
            title: 'Email'.tr,
            titleInterceptor: EditProfileHelper.setTitleInterceptor(user.email),
            icon: null
          ),
          ProfileMenuListItemControllerState(
            onTap: (context) => editTextProfileField(
              context: context,
              inputValueModalDialogPageParameter: InputValueModalDialogPageParameter(
                value: user.userProfile.gender.toEmptyStringNonNull,
                title: () => 'Gender'.tr,
                inputTitle: () => 'Gender'.tr,
                inputHint: () => 'Gender'.tr,
                inputSubmitText: () => "Submit".tr,
                requiredMessage: () => "${"Gender is required".tr}.",
              ),
              onConfigureEditUserParameter: (result) => EditUserParameter(
                gender: result
              )
            ),
            title: 'Gender'.tr,
            titleInterceptor: EditProfileHelper.setTitleInterceptor(user.userProfile.gender.toStringNonNull),
            icon: null
          ),
          ProfileMenuListItemControllerState(
            onTap: (context) async {
              DateTime? selectedDateTime = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.utc(1030, 3, 14),
                lastDate: DateTime.utc(9999, 3, 14),
              );
              if (selectedDateTime != null) {
                editProfile(
                  EditUserParameter(birthDateTime: selectedDateTime)
                );
              }
            },
            title: 'Date Birth'.tr,
            titleInterceptor: EditProfileHelper.setTitleInterceptor(
              user.userProfile.dateBirth != null
                ? DateUtil.standardDateFormat4.format(user.userProfile.dateBirth!)
                // ignore: unnecessary_cast
                : (null as String?).toStringNonNull
            ),
            icon: null
          ),
          ProfileMenuListItemControllerState(
            onTap: (context) => editTextProfileField(
              context: context,
              inputValueModalDialogPageParameter: InputValueModalDialogPageParameter(
                value: user.userProfile.placeBirth.toEmptyStringNonNull,
                title: () => 'Place Birth'.tr,
                inputTitle: () => 'Input Place Birth'.tr,
                inputHint: () => 'Type Place Birth'.tr,
                inputSubmitText: () => "Submit".tr,
                requiredMessage: () => "${"Place Birth is required".tr}.",
              ),
              onConfigureEditUserParameter: (result) => EditUserParameter(
                placeBirth: result
              )
            ),
            title: 'Place Birth'.tr,
            titleInterceptor: EditProfileHelper.setTitleInterceptor(
              user.userProfile.placeBirth.toStringNonNull
            ),
            icon: null
          ),
          ProfileMenuListItemControllerState(
            onTap: (context) => editTextProfileField(
              context: context,
              inputValueModalDialogPageParameter: InputValueModalDialogPageParameter(
                value: user.userProfile.phoneNumber.toEmptyStringNonNull,
                title: () => 'Phone Number'.tr,
                inputTitle: () => 'Input Phone Number'.tr,
                inputHint: () => 'Type Phone Number'.tr,
                inputSubmitText: () => "Submit".tr,
                requiredMessage: () => "${"Phone number is required".tr}.",
              ),
              onConfigureEditUserParameter: (result) => EditUserParameter(
                phoneNumber: result
              )
            ),
            title: 'Phone Number'.tr,
            titleInterceptor: EditProfileHelper.setTitleInterceptor(
              user.userProfile.phoneNumber.toStringNonNull
            ),
            icon: null
          ),
        ],
        page: 1,
        totalPage: 1,
        totalItem: 0
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    widget.editProfileController.setEditProfileDelegate(
      EditProfileDelegate(
        onUnfocusAllWidget: () => FocusScope.of(context).unfocus(),
        onEditProfileBack: () => Get.back(),
        onShowEditProfileRequestProcessLoadingCallback: () async => DialogHelper.showLoadingDialog(context),
        onShowEditProfileRequestProcessFailedCallback: (e) async => DialogHelper.showFailedModalBottomDialogFromErrorProvider(
          context: context,
          errorProvider: Injector.locator<ErrorProvider>(),
          e: e
        ),
        onEditProfileRequestProcessSuccessCallback: () async {
          _editProfileListItemPagingController.refresh();
        },
      )
    );
    return WillPopScope(
      onWillPop: () async {
        Get.back(result: true);
        return false;
      },
      child: Scaffold(
        appBar: ModifiedAppBar(
          titleInterceptor: (context, title) => Row(
            children: [
              Text("Profile".tr),
            ],
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ModifiedPagedListView<int, ListItemControllerState>.fromPagingControllerState(
                  pagingControllerState: _editProfileListItemPagingControllerState,
                  onProvidePagedChildBuilderDelegate: (pagingControllerState) => ListItemPagingControllerStatePagedChildBuilderDelegate<int>(
                    pagingControllerState: pagingControllerState!
                  ),
                  pullToRefresh: true
                ),
              ),
            ]
          )
        ),
      ),
    );
  }
}