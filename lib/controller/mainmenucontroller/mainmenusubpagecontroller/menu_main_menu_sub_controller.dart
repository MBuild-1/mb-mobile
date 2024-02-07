import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/future_ext.dart';
import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';
import 'package:masterbagasi/misc/ext/rx_ext.dart';

import '../../../domain/entity/cart/cart.dart';
import '../../../domain/entity/cart/cart_paging_parameter.dart';
import '../../../domain/entity/componententity/dynamic_item_carousel_component_entity.dart';
import '../../../domain/entity/componententity/dynamic_item_carousel_directly_component_entity.dart';
import '../../../domain/entity/componententity/i_dynamic_item_carousel_component_entity.dart';
import '../../../domain/entity/logout/logout_parameter.dart';
import '../../../domain/entity/logout/logout_response.dart';
import '../../../domain/entity/user/getuser/get_user_parameter.dart';
import '../../../domain/entity/user/user.dart';
import '../../../domain/usecase/get_my_cart_use_case.dart';
import '../../../domain/usecase/get_short_my_cart_use_case.dart';
import '../../../domain/usecase/get_user_use_case.dart';
import '../../../domain/usecase/logout_use_case.dart';
import '../../../misc/constant.dart';
import '../../../misc/controllercontentdelegate/shared_cart_controller_content_delegate.dart';
import '../../../misc/controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../../../misc/entityandlistitemcontrollerstatemediator/horizontal_component_entity_parameterized_entity_and_list_item_controller_state_mediator.dart';
import '../../../misc/error/message_error.dart';
import '../../../misc/errorprovider/error_provider.dart';
import '../../../misc/getextended/get_extended.dart';
import '../../../misc/load_data_result.dart';
import '../../../misc/login_helper.dart';
import '../../../misc/manager/controller_manager.dart';
import '../../../misc/multi_language_string.dart';
import '../../../misc/on_observe_load_product_delegate.dart';
import '../../../misc/paging/pagingresult/paging_data_result.dart';
import '../../../misc/typedef.dart';
import '../../base_getx_controller.dart';

typedef _OnShowLogoutRequestProcessLoadingCallback = Future<void> Function();
typedef _OnLogoutRequestProcessSuccessCallback = Future<void> Function();
typedef _OnShowLogoutRequestProcessFailedCallback = Future<void> Function(dynamic e);
typedef _OnLogoutIntoOneSignal = Future<LoadDataResult<void>> Function();
typedef _OnDeleteToken = Future<void> Function();

class MenuMainMenuSubController extends BaseGetxController {
  final GetUserUseCase getUserUseCase;
  final GetShortMyCartUseCase getShortMyCartUseCase;
  final LogoutUseCase logoutUseCase;
  MenuMainMenuSubDelegate? _menuMainMenuSubDelegate;
  final SharedCartControllerContentDelegate sharedCartControllerContentDelegate;

  LoadDataResult<User> _userLoadDataResult = NoLoadDataResult<User>();
  late Rx<LoadDataResultWrapper<User>> userLoadDataResultWrapperRx;

  MenuMainMenuSubController(
    super.controllerManager,
    this.getUserUseCase,
    this.getShortMyCartUseCase,
    this.logoutUseCase,
    this.sharedCartControllerContentDelegate
  ) {
    userLoadDataResultWrapperRx = LoadDataResultWrapper<User>(_userLoadDataResult).obs;
    sharedCartControllerContentDelegate.setApiRequestManager(
      () => apiRequestManager
    );
  }

  IDynamicItemCarouselComponentEntity getMyCart() {
    RepeatableDynamicItemCarouselAdditionalParameter repeatableDynamicItemCarouselAdditionalParameter = RepeatableDynamicItemCarouselAdditionalParameter();
    return DynamicItemCarouselComponentEntity(
      title: MultiLanguageString({
        Constant.textEnUsLanguageKey: "My Cart",
        Constant.textInIdLanguageKey: "Keranjang Saya"
      }),
      onDynamicItemAction: (title, description, observer) async {
        observer(title, description, IsLoadingLoadDataResult<List<Cart>>());
        LoadDataResult<List<Cart>> cartPagingLoadDataResult = await getShortMyCartUseCase.execute().future(
          parameter: apiRequestManager.addRequestToCancellationPart("short-my-cart").value
        );
        if (cartPagingLoadDataResult.isFailedBecauseCancellation) {
          return;
        }
        observer(title, description, cartPagingLoadDataResult);
      },
      onObserveLoadingDynamicItemActionState: (title, description, loadDataResult) {
        if (_menuMainMenuSubDelegate != null) {
          return _menuMainMenuSubDelegate!.onObserveLoadProductDelegate.onObserveLoadingLoadCartCarousel(
            OnObserveLoadingLoadCartCarouselParameter(
              repeatableDynamicItemCarouselAdditionalParameter: repeatableDynamicItemCarouselAdditionalParameter
            )
          );
        }
      },
      onObserveSuccessDynamicItemActionState: (title, description, loadDataResult) {
        List<Cart> cartList = loadDataResult.resultIfSuccess!;
        if (_menuMainMenuSubDelegate != null) {
          return _menuMainMenuSubDelegate!.onObserveLoadProductDelegate.onObserveSuccessLoadCartCarousel(
            OnObserveSuccessLoadCartCarouselParameter(
              title: title,
              description: description,
              cartList: cartList,
              data: Constant.carouselKeyShortMyCart,
              repeatableDynamicItemCarouselAdditionalParameter: repeatableDynamicItemCarouselAdditionalParameter
            )
          );
        }
        throw MessageError(title: "My cart delegate must be initialized");
      },
      onObserveFailedDynamicItemActionState: (title, description, loadDataResult) {
        if (_menuMainMenuSubDelegate != null) {
          return _menuMainMenuSubDelegate!.onObserveLoadProductDelegate.onObserveFailedLoadCartCarousel(
            OnObserveFailedLoadCartCarouselParameter(
              e: (loadDataResult as FailedLoadDataResult).e,
              repeatableDynamicItemCarouselAdditionalParameter: repeatableDynamicItemCarouselAdditionalParameter
            )
          );
        }
        throw MessageError(title: "My cart delegate must be initialized");
      },
      dynamicItemCarouselAdditionalParameter: repeatableDynamicItemCarouselAdditionalParameter,
    );
  }

  void loadLoggedUser() async {
    _userLoadDataResult = IsLoadingLoadDataResult<User>();
    _updateMenuMainMenuState();
    _userLoadDataResult = await getUserUseCase.execute(GetUserParameter()).future(
      parameter: apiRequestManager.addRequestToCancellationPart("user").value
    ).map<User>(
      (getUserResponse) => getUserResponse.user
    );
    if (_userLoadDataResult.isFailedBecauseCancellation) {
      return;
    }
    _updateMenuMainMenuState();
  }

  void setMenuMainMenuSubDelegate(MenuMainMenuSubDelegate menuMainMenuSubDelegate) {
    _menuMainMenuSubDelegate = menuMainMenuSubDelegate;
  }

  void _updateMenuMainMenuState() {
    userLoadDataResultWrapperRx.valueFromLast((value) => LoadDataResultWrapper<User>(_userLoadDataResult));
    update();
  }

  void logout() async {
    if (_menuMainMenuSubDelegate != null) {
      _menuMainMenuSubDelegate!.onUnfocusAllWidget();
      _menuMainMenuSubDelegate!.onShowLogoutRequestProcessLoadingCallback();
      LoadDataResult<User> userLoadDataResult = await getUserUseCase.execute(
        GetUserParameter()
      ).future(
        parameter: apiRequestManager.addRequestToCancellationPart('get-user-after-logout').value
      ).map<User>(
        (getUserResponse) => getUserResponse.user
      );
      LoadDataResult<LogoutResponse> logoutLoadDataResult = await logoutUseCase.execute(
        LogoutParameter()
      ).future(
        parameter: apiRequestManager.addRequestToCancellationPart('logout').value
      );
      Future<void> unsubscribeChatCount() async {
        if (userLoadDataResult.isSuccess) {
          User user = userLoadDataResult.resultIfSuccess!;
          await _menuMainMenuSubDelegate!.onUnsubscribeChatCountRealtimeChannel(user.id);
          await _menuMainMenuSubDelegate!.onUnsubscribeNotificationCountRealtimeChannel(user.id);
        }
      }
      await _menuMainMenuSubDelegate!.onDeleteToken().getLoadDataResult();
      if (logoutLoadDataResult.isSuccess) {
        await _menuMainMenuSubDelegate!.onLogoutIntoOneSignal();
        await unsubscribeChatCount();
        Get.back();
        _menuMainMenuSubDelegate!.onLogoutRequestProcessSuccessCallback();
      } else {
        await unsubscribeChatCount();
        Get.back();
        if (logoutLoadDataResult.isFailedBecauseUnauthenticated) {
          _menuMainMenuSubDelegate!.onLogoutRequestProcessSuccessCallback();
        } else {
          _menuMainMenuSubDelegate!.onShowLogoutRequestProcessFailedCallback(logoutLoadDataResult.resultIfFailed);
        }
      }
    }
  }
}

class MenuMainMenuSubControllerInjectionFactory {
  final GetUserUseCase getUserUseCase;
  final GetShortMyCartUseCase getShortMyCartUseCase;
  final LogoutUseCase logoutUseCase;
  final SharedCartControllerContentDelegate sharedCartControllerContentDelegate;

  MenuMainMenuSubControllerInjectionFactory({
    required this.getUserUseCase,
    required this.getShortMyCartUseCase,
    required this.logoutUseCase,
    required this.sharedCartControllerContentDelegate
  });

  MenuMainMenuSubController inject(ControllerManager controllerManager, String pageName) {
    return GetExtended.put<MenuMainMenuSubController>(
      MenuMainMenuSubController(
        controllerManager,
        getUserUseCase,
        getShortMyCartUseCase,
        logoutUseCase,
        sharedCartControllerContentDelegate
      ),
      tag: pageName
    );
  }
}

class MenuMainMenuSubDelegate {
  OnObserveLoadProductDelegate onObserveLoadProductDelegate;
  ListItemControllerState Function(_OnObserveLoadLoggedUserDirectlyParameter) onObserveLoadLoggedUserDirectly;
  OnUnfocusAllWidget onUnfocusAllWidget;
  _OnDeleteToken onDeleteToken;
  _OnShowLogoutRequestProcessLoadingCallback onShowLogoutRequestProcessLoadingCallback;
  _OnLogoutRequestProcessSuccessCallback onLogoutRequestProcessSuccessCallback;
  _OnShowLogoutRequestProcessFailedCallback onShowLogoutRequestProcessFailedCallback;
  _OnLogoutIntoOneSignal onLogoutIntoOneSignal;
  Future<void> Function(String) onUnsubscribeChatCountRealtimeChannel;
  Future<void> Function(String) onUnsubscribeNotificationCountRealtimeChannel;

  MenuMainMenuSubDelegate({
    required this.onObserveLoadProductDelegate,
    required this.onObserveLoadLoggedUserDirectly,
    required this.onUnfocusAllWidget,
    required this.onDeleteToken,
    required this.onShowLogoutRequestProcessLoadingCallback,
    required this.onLogoutRequestProcessSuccessCallback,
    required this.onShowLogoutRequestProcessFailedCallback,
    required this.onLogoutIntoOneSignal,
    required this.onUnsubscribeChatCountRealtimeChannel,
    required this.onUnsubscribeNotificationCountRealtimeChannel
  });
}

class _OnObserveLoadLoggedUserDirectlyParameter {
  LoadDataResult<User> userLoadDataResult;
  ErrorProvider errorProvider;

  _OnObserveLoadLoggedUserDirectlyParameter({
    required this.userLoadDataResult,
    required this.errorProvider
  });
}