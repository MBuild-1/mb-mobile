import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';

import '../../domain/entity/address/address.dart';
import '../../domain/entity/address/address_list_parameter.dart';
import '../../domain/entity/address/update_current_selected_address_parameter.dart';
import '../../domain/entity/address/update_current_selected_address_response.dart';
import '../../domain/entity/componententity/dynamic_item_carousel_component_entity.dart';
import '../../domain/entity/componententity/i_dynamic_item_carousel_component_entity.dart';
import '../../domain/usecase/get_address_list_use_case.dart';
import '../../domain/usecase/update_current_selected_address_use_case.dart';
import '../../misc/constant.dart';
import '../../misc/error/message_error.dart';
import '../../misc/load_data_result.dart';
import '../../misc/manager/controller_manager.dart';
import '../../misc/on_observe_load_product_delegate.dart';
import 'modal_dialog_controller.dart';

typedef _OnSelectAddressBack = void Function();
typedef _OnShowSelectAddressRequestProcessLoadingCallback = Future<void> Function();
typedef _OnSelectAddressRequestProcessSuccessCallback = Future<void> Function(Address);
typedef _OnShowSelectAddressRequestProcessFailedCallback = Future<void> Function(dynamic e);

class SelectAddressModalDialogController extends ModalDialogController {
  final GetAddressListUseCase getAddressListUseCase;
  final UpdateCurrentSelectedAddressUseCase updateCurrentSelectedAddressUseCase;
  SelectAddressDelegate? _selectAddressDelegate;

  SelectAddressModalDialogController(
    ControllerManager? controllerManager,
    this.getAddressListUseCase,
    this.updateCurrentSelectedAddressUseCase
  ) : super(controllerManager);

  IDynamicItemCarouselComponentEntity getAddressListCarousel() {
    return DynamicItemCarouselComponentEntity(
      onDynamicItemAction: (title, description, observer) async {
        observer(title, description, IsLoadingLoadDataResult<List<Address>>());
        LoadDataResult<List<Address>> addressListDataResult = await getAddressListUseCase.execute(
          AddressListParameter()
        ).future(
          parameter: apiRequestManager.addRequestToCancellationPart("address-list").value
        );
        if (addressListDataResult.isFailedBecauseCancellation) {
          return;
        }
        observer(title, description, addressListDataResult);
      },
      onObserveLoadingDynamicItemActionState: (title, description, loadDataResult) {
        if (_selectAddressDelegate != null) {
          return _selectAddressDelegate!.onObserveLoadProductDelegate.onObserveLoadingLoadAddressCarousel(
            OnObserveLoadingLoadAddressCarouselParameter()
          );
        }
        throw MessageError(title: "Address delegate must be initialized");
      },
      onObserveSuccessDynamicItemActionState: (title, description, loadDataResult) {
        List<Address> addressList = loadDataResult.resultIfSuccess!;
        if (_selectAddressDelegate != null) {
          return _selectAddressDelegate!.onObserveLoadProductDelegate.onObserveSuccessLoadAddressCarousel(
            OnObserveSuccessLoadAddressCarouselParameter(
              title: title,
              description: description,
              addressList: addressList
            )
          );
        }
        throw MessageError(title: "Address delegate must be initialized");
      },
      onObserveFailedDynamicItemActionState: (title, description, loadDataResult) {
        if (_selectAddressDelegate != null) {
          bool isEmptyError = false;
          FailedLoadDataResult failedLoadDataResult = loadDataResult as FailedLoadDataResult;
          dynamic e = failedLoadDataResult.e;
          dynamic message = e.response?.data["meta"]["message"];
          if (message is Map<String, dynamic>) {
            if (message[Constant.textEnUsLanguageKey].toLowerCase().contains("address is empty")) {
              isEmptyError = true;
            }
          }
          return _selectAddressDelegate!.onObserveLoadProductDelegate.onObserveFailedLoadAddressCarousel(
            OnObserveFailedLoadAddressCarouselParameter(
              e: e,
              buttonText: isEmptyError ? "Add Address".tr : null,
              onPressed: isEmptyError ? _selectAddressDelegate!.onGotoAddAddress : null
            )
          );
        }
        throw MessageError(title: "My cart delegate must be initialized");
      }
    );
  }

  void selectCurrentAddress(Address address) async {
    if (_selectAddressDelegate != null) {
      _selectAddressDelegate!.onShowSelectAddressRequestProcessLoadingCallback();
      LoadDataResult<UpdateCurrentSelectedAddressResponse> updateCurrentSelectedAddressResponseLoadDataResult = await updateCurrentSelectedAddressUseCase.execute(
        UpdateCurrentSelectedAddressParameter(
          addressId: address.id
        )
      ).future(
        parameter: apiRequestManager.addRequestToCancellationPart('update-current-selected-address').value
      );
      _selectAddressDelegate!.onSelectAddressBack();
      if (updateCurrentSelectedAddressResponseLoadDataResult.isSuccess) {
        _selectAddressDelegate!.onSelectAddressRequestProcessSuccessCallback(address);
      } else {
        _selectAddressDelegate!.onShowSelectAddressRequestProcessFailedCallback(updateCurrentSelectedAddressResponseLoadDataResult.resultIfFailed!);
      }
    }
  }

  SelectAddressModalDialogController setSelectAddressDelegate(SelectAddressDelegate selectAddressDelegate) {
    _selectAddressDelegate = selectAddressDelegate;
    return this;
  }
}

class SelectAddressDelegate {
  OnObserveLoadProductDelegate onObserveLoadProductDelegate;
  _OnSelectAddressBack onSelectAddressBack;
  _OnShowSelectAddressRequestProcessLoadingCallback onShowSelectAddressRequestProcessLoadingCallback;
  _OnSelectAddressRequestProcessSuccessCallback onSelectAddressRequestProcessSuccessCallback;
  _OnShowSelectAddressRequestProcessFailedCallback onShowSelectAddressRequestProcessFailedCallback;
  void Function()? onGotoAddAddress;

  SelectAddressDelegate({
    required this.onObserveLoadProductDelegate,
    required this.onSelectAddressBack,
    required this.onShowSelectAddressRequestProcessLoadingCallback,
    required this.onSelectAddressRequestProcessSuccessCallback,
    required this.onShowSelectAddressRequestProcessFailedCallback,
    required this.onGotoAddAddress
  });
}