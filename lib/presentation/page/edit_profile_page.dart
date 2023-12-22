import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';
import 'package:masterbagasi/misc/ext/navigator_ext.dart';
import 'package:masterbagasi/misc/ext/paging_controller_ext.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';
import 'package:sizer/sizer.dart';

import '../../controller/edit_profile_controller.dart';
import '../../domain/entity/user/edituser/edit_user_parameter.dart';
import '../../domain/entity/user/getuser/get_user_parameter.dart';
import '../../domain/entity/user/user.dart';
import '../../domain/entity/verifyeditprofile/authidentity/parameter/email_auth_identity_parameter.dart';
import '../../domain/entity/verifyeditprofile/authidentity/parameter/phone_auth_identity_parameter.dart';
import '../../domain/usecase/auth_identity_use_case.dart';
import '../../domain/usecase/edit_user_use_case.dart';
import '../../domain/usecase/get_user_use_case.dart';
import '../../misc/additionalloadingindicatorchecker/edit_profile_additional_paging_result_parameter_checker.dart';
import '../../misc/authidentitystep/choose_verification_method_auth_identity_step.dart';
import '../../misc/authidentitystep/failed_auth_identity_step.dart';
import '../../misc/constant.dart';
import '../../misc/controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../../misc/controllerstate/listitemcontrollerstate/profilemenulistitemcontrollerstate/profile_menu_list_item_controller_state.dart';
import '../../misc/controllerstate/listitemcontrollerstate/widget_substitution_list_item_controller_state.dart';
import '../../misc/controllerstate/paging_controller_state.dart';
import '../../misc/date_util.dart';
import '../../misc/dialog_helper.dart';
import '../../misc/edit_profile_helper.dart';
import '../../misc/errorprovider/error_provider.dart';
import '../../misc/gender.dart';
import '../../misc/getextended/get_extended.dart';
import '../../misc/getextended/get_restorable_route_future.dart';
import '../../misc/injector.dart';
import '../../misc/load_data_result.dart';
import '../../misc/manager/controller_manager.dart';
import '../../misc/multi_language_string.dart';
import '../../misc/paging/modified_paging_controller.dart';
import '../../misc/paging/pagingcontrollerstatepagedchildbuilderdelegate/list_item_paging_controller_state_paged_child_builder_delegate.dart';
import '../../misc/paging/pagingresult/paging_data_result.dart';
import '../../misc/paging/pagingresult/paging_result.dart';
import '../../misc/string_util.dart';
import '../widget/button/custombutton/sized_outline_gradient_button.dart';
import '../widget/modified_paged_list_view.dart';
import '../widget/modifiedappbar/modified_app_bar.dart';
import '../widget/profile_picture_cache_network_image.dart';
import '../widget/tap_area.dart';
import 'crop_picture_page.dart';
import 'getx_page.dart';
import 'modaldialogpage/auth_identity_modal_dialog_page.dart';
import 'modaldialogpage/delete_account_modal_dialog_page.dart';
import 'modaldialogpage/input_value_modal_dialog_page.dart';
import 'modaldialogpage/select_value_modal_dialog_page.dart';

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
        Injector.locator<GetUserUseCase>(),
        Injector.locator<AuthIdentityUseCase>()
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
  _EditProfilePageRestoration createPageRestoration() => _EditProfilePageRestoration(
    onCompleteSetProfilePicture: (cropPictureSerializedJsonResult) {
      if (cropPictureSerializedJsonResult != null) {
        Get.back();
        Map<String, dynamic> result = StringUtil.decodeBase64StringToJson(cropPictureSerializedJsonResult);
        String imagePath = result["image_path"];
        _editProfileController.controller.editProfile(
          EditUserParameter(
            avatar: imagePath
          )
        );
      } else {
        Get.back();
      }
    }
  );
}

class _EditProfilePageRestoration extends ExtendedMixableGetxPageRestoration with CropPicturePageRestorationMixin {
  final RouteCompletionCallback<String?>? _onCompleteSetProfilePicture;

  _EditProfilePageRestoration({
    RouteCompletionCallback<String?>? onCompleteSetProfilePicture
  }) : _onCompleteSetProfilePicture = onCompleteSetProfilePicture;

  @override
  // ignore: unnecessary_overrides
  void initState() {
    onCompleteSetProfilePicture = _onCompleteSetProfilePicture;
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

  AuthIdentityModalDialogPageAction _authIdentityModalDialogPageAction = AuthIdentityModalDialogPageAction();

  final List<Gender> _genderList = <Gender>[
    Gender(
      value: "Male",
      text: MultiLanguageString({
        Constant.textEnUsLanguageKey: "Male",
        Constant.textInIdLanguageKey: "Laki-laki"
      })
    ),
    Gender(
      value: "Female",
      text: MultiLanguageString({
        Constant.textEnUsLanguageKey: "Female",
        Constant.textInIdLanguageKey: "Perempuan"
      })
    ),
  ];

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

  void _editProfile(EditUserParameter editUserParameter)  {
    widget.editProfileController.editProfile(editUserParameter);
  }

  Future<LoadDataResult<PagingResult<ListItemControllerState>>> _editProfileListItemPagingControllerStateListener(int pageKey, List<ListItemControllerState>? cartListItemControllerStateList) async {
    LoadDataResult<User> userLoadDataResult = await widget.editProfileController.getUserProfile(GetUserParameter());
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
        _editProfile(onConfigureEditUserParameter(result));
      }
    }
    return userLoadDataResult.map<PagingResult<ListItemControllerState>>((user) {
      Gender? getGenderBasedUserGender() {
        Iterable<Gender> gender = _genderList.where((gender) => user.userProfile.gender == gender.value);
        if (gender.isEmpty) {
          return null;
        }
        return gender.first;
      }
      return PagingDataResult<ListItemControllerState>(
        itemList: [
          WidgetSubstitutionListItemControllerState(
            widgetSubstitution: (context, index) {
              void onTap() async {
                DialogHelper.showSelectingImageDialog(
                  context, cropAspectRatio: 1.0
                );
              }
              return Column(
                children: [
                  TapArea(
                    onTap: onTap,
                    child: ProfilePictureCacheNetworkImage(
                      profileImageUrl: user.userProfile.avatar.toEmptyStringNonNull,
                      dimension: 20.w
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  TapArea(
                    onTap: onTap,
                    child: Text(
                      "Change Profile Avatar".tr,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary
                      ),
                    )
                  )
                ],
              );
            }
          ),
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
            onTap: (context) {
              widget.editProfileController.authIdentity(EmailAuthIdentityParameter());
            },
            title: 'Email'.tr,
            titleInterceptor: EditProfileHelper.setTitleInterceptor(user.email),
            icon: null
          ),
          ProfileMenuListItemControllerState(
            onTap: (context) async {
              dynamic result = await DialogHelper.showModalDialogPage<Gender, SelectValueModalDialogPageParameter<Gender>>(
                context: context,
                modalDialogPageBuilder: (context, parameter) => SelectValueModalDialogPage(
                  selectValueModalDialogPageParameter: parameter!,
                ),
                parameter: SelectValueModalDialogPageParameter<Gender>(
                  valueList: _genderList,
                  title: MultiLanguageString({
                    Constant.textEnUsLanguageKey: "Select Gender",
                    Constant.textInIdLanguageKey: "Pilih Jenis Kelamin"
                  }).toEmptyStringNonNull,
                  onConvertToStringForItemText: (gender) => gender.text.toStringNonNull,
                  onConvertToStringForComparing: (gender) => (gender?.value).toEmptyStringNonNull,
                  selectedValue: () {
                    return getGenderBasedUserGender();
                  }()
                ),
              );
              if (result is Gender) {
                _editProfile(
                  EditUserParameter(gender: result.value)
                );
              }
            },
            title: 'Gender'.tr,
            titleInterceptor: EditProfileHelper.setTitleInterceptor(
              (getGenderBasedUserGender()?.text).toEmptyStringNonNull
            ),
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
                _editProfile(
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
            onTap: (context) {
              widget.editProfileController.authIdentity(PhoneAuthIdentityParameter());
            },
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
        onShowAuthIdentityRequestProcessLoadingCallback: () async {
          dynamic result = await DialogHelper.showModalDialogPage<bool, int>(
            context: context,
            modalDialogPageBuilder: (context, parameter) => AuthIdentityModalDialogPage(
              authIdentityModalDialogPageAction: _authIdentityModalDialogPageAction,
            ),
            parameter: 0,
          );
          if (result is bool) {
            if (result) {
              _editProfileListItemPagingController.refresh();
            }
          }
        },
        onShowAuthIdentityRequestProcessFailedCallback: (e) async {
          _authIdentityModalDialogPageAction.changeAuthIdentityStep(
            FailedAuthIdentityStep(
              e: e
            )
          );
        },
        onAuthIdentityRequestProcessSuccessCallback: (authIdentityParameterAndResponse) async {
          _authIdentityModalDialogPageAction.changeAuthIdentityStep(
            ChooseVerificationMethodAuthIdentityStep(
              authIdentityParameterAndResponse: authIdentityParameterAndResponse,
            )
          );
        }
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
              Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedOutlineGradientButton(
                      onPressed: () async {
                        await DialogHelper.showModalDialogPage<void, int>(
                          context: context,
                          modalDialogPageBuilder: (context, parameter) => DeleteAccountModalDialogPage(
                            onBackToMainMenu: Navigator.of(context).popUntilMainMenu,
                          ),
                          parameter: 0,
                          barrierDismissible: false
                        );
                      },
                      text: "Delete Account".tr,
                      outlineGradientButtonType: OutlineGradientButtonType.solid,
                      outlineGradientButtonVariation: OutlineGradientButtonVariation.variation4,
                    )
                  ]
                ),
              )
            ]
          )
        ),
      ),
    );
  }
}