import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/double_ext.dart';
import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';

import '../../domain/entity/additionalitem/add_additional_item_parameter.dart';
import '../../domain/entity/additionalitem/add_additional_item_response.dart';
import '../../domain/entity/additionalitem/additional_item.dart';
import '../../domain/entity/additionalitem/change_additional_item.dart';
import '../../domain/entity/additionalitem/change_additional_item_parameter.dart';
import '../../domain/entity/additionalitem/change_additional_item_response.dart';
import '../../domain/usecase/add_additional_item_use_case.dart';
import '../../domain/usecase/change_additional_item_use_case.dart';
import '../../misc/error/validation_error.dart';
import '../../misc/load_data_result.dart';
import '../../misc/login_helper.dart';
import '../../misc/manager/controller_manager.dart';
import '../../misc/string_util.dart';
import '../../misc/typedef.dart';
import '../../misc/validation/validation_result.dart';
import '../../misc/validation/validator/validator.dart';
import '../../misc/validation/validatorgroup/add_additional_item_validator_group.dart';
import 'modal_dialog_controller.dart';

typedef _OnGetHasParameter = bool Function();
typedef _OnGetAddAdditionalItemInput = String Function();
typedef _OnShowAdditionalItemRequestProcessLoadingCallback = Future<void> Function();
typedef _OnAddAdditionalItemRequestProcessSuccessCallback = Future<void> Function(AddAdditionalItemModalDialogResponse, String);
typedef _OnShowAdditionalItemRequestProcessFailedCallback = Future<void> Function(dynamic e);
typedef _OnAddAdditionalItemBack = void Function();

class AddAdditionalItemModalDialogController extends ModalDialogController {
  late Rx<Validator> additionalItemNameValidatorRx;
  late Rx<Validator> additionalItemEstimationPriceValidatorRx;
  late Rx<Validator> additionalItemEstimationWeightValidatorRx;
  late Rx<Validator> additionalItemQuantityValidatorRx;
  late Rx<Validator> additionalItemNotesValidatorRx;
  late final AddAdditionalItemValidatorGroup addAdditionalItemValidatorGroup;

  final AddAdditionalItemUseCase addAdditionalItemUseCase;
  final ChangeAdditionalItemUseCase changeAdditionalItemUseCase;

  AddAdditionalItemModalDialogDelegate? _addAdditionalItemModalDialogDelegate;

  AddAdditionalItemModalDialogController(
    ControllerManager? controllerManager,
    this.addAdditionalItemUseCase,
    this.changeAdditionalItemUseCase
  ) : super(controllerManager) {
    addAdditionalItemValidatorGroup = AddAdditionalItemValidatorGroup(
      additionalItemNameValidator: Validator(
        onValidate: () => !_addAdditionalItemModalDialogDelegate!.onGetAdditionalItemNameInput().isEmptyString ? SuccessValidationResult() : FailedValidationResult(e: ValidationError(message: "${"Name is required".tr}."))
      ),
      additionalItemEstimationPriceValidator: Validator(
        onValidate: () {
          String estimationPrice = _addAdditionalItemModalDialogDelegate!.onGetAdditionalItemEstimationPriceInput();
          if (!estimationPrice.isEmptyString) {
            double? estimationPriceValue = estimationPrice.tryParseDoubleWithAdditionalChecking();
            if (estimationPriceValue != null) {
              return SuccessValidationResult();
            } else {
              return FailedValidationResult(e: ValidationError(message: "${"Estimation price must be number".tr}."));
            }
          } else {
            return FailedValidationResult(e: ValidationError(message: "${"Estimation price is required".tr}."));
          }
        }
      ),
      additionalItemEstimationWeightValidator: Validator(
        onValidate: () {
          String estimationWeight = _addAdditionalItemModalDialogDelegate!.onGetAdditionalItemEstimationWeightInput();
          if (!estimationWeight.isEmptyString) {
            double? estimationWeightValue = estimationWeight.tryParseDoubleWithAdditionalChecking();
            if (estimationWeightValue != null) {
              return SuccessValidationResult();
            } else {
              return FailedValidationResult(e: ValidationError(message: "${"Estimation weight must be number".tr}."));
            }
          } else {
            return FailedValidationResult(e: ValidationError(message: "${"Estimation weight is required".tr}."));
          }
        }
      ),
      additionalItemQuantityValidator: Validator(
        onValidate: () {
          String quantity = _addAdditionalItemModalDialogDelegate!.onGetAdditionalItemQuantityInput();
          if (!quantity.isEmptyString) {
            int? quantityValue = int.tryParse(quantity);
            if (quantityValue != null) {
              return SuccessValidationResult();
            } else {
              return FailedValidationResult(e: ValidationError(message: "${"Quantity must be number".tr}."));
            }
          } else {
            return FailedValidationResult(e: ValidationError(message: "${"Quantity is required".tr}."));
          }
        }
      ),
      additionalItemNotesValidator: Validator(
        onValidate: () => SuccessValidationResult()
      ),
    );
    additionalItemNameValidatorRx = addAdditionalItemValidatorGroup.additionalItemNameValidator.obs;
    additionalItemEstimationPriceValidatorRx = addAdditionalItemValidatorGroup.additionalItemEstimationPriceValidator.obs;
    additionalItemEstimationWeightValidatorRx = addAdditionalItemValidatorGroup.additionalItemEstimationWeightValidator.obs;
    additionalItemQuantityValidatorRx = addAdditionalItemValidatorGroup.additionalItemQuantityValidator.obs;
    additionalItemNotesValidatorRx = addAdditionalItemValidatorGroup.additionalItemNotesValidator.obs;
  }

  AddAdditionalItemModalDialogController setAddAdditionalItemModalDialogDelegate(AddAdditionalItemModalDialogDelegate addAdditionalItemModalDialogDelegate) {
    _addAdditionalItemModalDialogDelegate = addAdditionalItemModalDialogDelegate;
    return this;
  }

  void createOrChangeAdditionalItem() async {
    if (_addAdditionalItemModalDialogDelegate != null) {
      _addAdditionalItemModalDialogDelegate!.onUnfocusAllWidget();
      if (addAdditionalItemValidatorGroup.validate()) {
        _addAdditionalItemModalDialogDelegate!.onShowAdditionalItemRequestProcessLoadingCallback();
        AdditionalItem additionalItem = AdditionalItem(
          id: _addAdditionalItemModalDialogDelegate!.onGetAdditionalItemIdInput(),
          name: _addAdditionalItemModalDialogDelegate!.onGetAdditionalItemNameInput(),
          estimationPrice: StringUtil.filterNumber(_addAdditionalItemModalDialogDelegate!.onGetAdditionalItemEstimationPriceInput()).parseDoubleWithAdditionalChecking(),
          estimationWeight: _addAdditionalItemModalDialogDelegate!.onGetAdditionalItemEstimationWeightInput().parseDoubleWithAdditionalChecking(),
          quantity: int.parse(_addAdditionalItemModalDialogDelegate!.onGetAdditionalItemQuantityInput()),
          notes: _addAdditionalItemModalDialogDelegate!.onGetAdditionalItemNotesInput()
        );
        if (!_addAdditionalItemModalDialogDelegate!.onGetHasParameter()) {
          LoadDataResult<AddAdditionalItemResponse> addAdditionalItemResponseLoadDataResult = await addAdditionalItemUseCase.execute(
            AddAdditionalItemParameter(additionalItem: additionalItem)
          ).future(
            parameter: apiRequestManager.addRequestToCancellationPart('add-additional-item').value
          );
          _addAdditionalItemModalDialogDelegate!.onAddAdditionalItemBack();
          if (addAdditionalItemResponseLoadDataResult.isSuccess) {
            AddAdditionalItemModalDialogResponse addAdditionalItemModalDialogResponse = AddAdditionalItemModalDialogResponse(
              additionalItem: additionalItem
            );
            _addAdditionalItemModalDialogDelegate!.onAddAdditionalItemRequestProcessSuccessCallback(
              addAdditionalItemModalDialogResponse, addAdditionalItemModalDialogResponse.toEncodeBase64String()
            );
          } else {
            _addAdditionalItemModalDialogDelegate!.onShowAdditionalItemRequestProcessFailedCallback(
              addAdditionalItemResponseLoadDataResult.resultIfFailed
            );
          }
        } else {
          LoadDataResult<ChangeAdditionalItemResponse> changeAdditionalItemResponseLoadDataResult = await changeAdditionalItemUseCase.execute(
            ChangeAdditionalItemParameter(
              changeAdditionalItem: ChangeAdditionalItem(
                id: additionalItem.id,
                name: additionalItem.name,
                estimationPrice: additionalItem.estimationPrice,
                estimationWeight: additionalItem.estimationWeight,
                quantity: additionalItem.quantity,
                notes: additionalItem.notes
              )
            )
          ).future(
            parameter: apiRequestManager.addRequestToCancellationPart('change-additional-item').value
          );
          _addAdditionalItemModalDialogDelegate!.onAddAdditionalItemBack();
          if (changeAdditionalItemResponseLoadDataResult.isSuccess) {
            AddAdditionalItemModalDialogResponse addAdditionalItemModalDialogResponse = AddAdditionalItemModalDialogResponse(
              additionalItem: additionalItem
            );
            _addAdditionalItemModalDialogDelegate!.onAddAdditionalItemRequestProcessSuccessCallback(
              addAdditionalItemModalDialogResponse, addAdditionalItemModalDialogResponse.toEncodeBase64String()
            );
          } else {
            _addAdditionalItemModalDialogDelegate!.onShowAdditionalItemRequestProcessFailedCallback(
              changeAdditionalItemResponseLoadDataResult.resultIfFailed
            );
          }
        }
      }
    }
  }
}

class AddAdditionalItemModalDialogDelegate {
  OnUnfocusAllWidget onUnfocusAllWidget;
  _OnGetHasParameter onGetHasParameter;
  _OnGetAddAdditionalItemInput onGetAdditionalItemIdInput;
  _OnGetAddAdditionalItemInput onGetAdditionalItemNameInput;
  _OnGetAddAdditionalItemInput onGetAdditionalItemEstimationPriceInput;
  _OnGetAddAdditionalItemInput onGetAdditionalItemEstimationWeightInput;
  _OnGetAddAdditionalItemInput onGetAdditionalItemQuantityInput;
  _OnGetAddAdditionalItemInput onGetAdditionalItemNotesInput;
  _OnShowAdditionalItemRequestProcessLoadingCallback onShowAdditionalItemRequestProcessLoadingCallback;
  _OnAddAdditionalItemRequestProcessSuccessCallback onAddAdditionalItemRequestProcessSuccessCallback;
  _OnShowAdditionalItemRequestProcessFailedCallback onShowAdditionalItemRequestProcessFailedCallback;
  _OnAddAdditionalItemBack onAddAdditionalItemBack;

  AddAdditionalItemModalDialogDelegate({
    required this.onUnfocusAllWidget,
    required this.onGetHasParameter,
    required this.onGetAdditionalItemIdInput,
    required this.onGetAdditionalItemNameInput,
    required this.onGetAdditionalItemEstimationPriceInput,
    required this.onGetAdditionalItemEstimationWeightInput,
    required this.onShowAdditionalItemRequestProcessLoadingCallback,
    required this.onAddAdditionalItemRequestProcessSuccessCallback,
    required this.onShowAdditionalItemRequestProcessFailedCallback,
    required this.onGetAdditionalItemQuantityInput,
    required this.onGetAdditionalItemNotesInput,
    required this.onAddAdditionalItemBack
  });
}

class AddAdditionalItemModalDialogParameter {
  AdditionalItem additionalItem;

  AddAdditionalItemModalDialogParameter({
    required this.additionalItem
  });
}

extension AddAdditionalItemModalDialogParameterExt on AddAdditionalItemModalDialogParameter {
  String toEncodeBase64String() => StringUtil.encodeBase64StringFromJson(
    <String, dynamic>{
      "id": additionalItem.id,
      "name": additionalItem.name,
      "estimation_price": additionalItem.estimationPrice,
      "estimation_weight": additionalItem.estimationWeight,
      "quantity": additionalItem.quantity,
      "notes": additionalItem.notes
    }
  );
}

extension AddAdditionalItemModalDialogParameterStringExt on String {
  AddAdditionalItemModalDialogParameter toAddAdditionalItemModalDialogParameter() {
    dynamic result = StringUtil.decodeBase64StringToJson(this);
    return AddAdditionalItemModalDialogParameter(
      additionalItem: AdditionalItem(
        id: result["id"],
        name: result["name"],
        estimationPrice: result["estimation_price"],
        estimationWeight: result["estimation_weight"],
        quantity: result["quantity"],
        notes: result["notes"]
      )
    );
  }
}

class AddAdditionalItemModalDialogResponse {
  AdditionalItem additionalItem;

  AddAdditionalItemModalDialogResponse({
    required this.additionalItem
  });
}

extension AddAdditionalItemModalDialogResponseExt on AddAdditionalItemModalDialogResponse {
  String toEncodeBase64String() => StringUtil.encodeBase64StringFromJson(
    <String, dynamic>{
      "id": additionalItem.id,
      "name": additionalItem.name,
      "estimation_price": additionalItem.estimationPrice,
      "estimation_weight": additionalItem.estimationWeight,
      "quantity": additionalItem.quantity,
      "notes": additionalItem.notes
    }
  );
}

extension AddAdditionalItemModalDialogResponseStringExt on String {
  AddAdditionalItemModalDialogResponse toAddAdditionalItemModalDialogResponse() {
    dynamic result = StringUtil.decodeBase64StringToJson(this);
    return AddAdditionalItemModalDialogResponse(
      additionalItem: AdditionalItem(
        id: result["id"],
        name: result["name"],
        estimationPrice: result["estimation_price"],
        estimationWeight: result["estimation_weight"],
        quantity: result["quantity"],
        notes: result["notes"]
      )
    );
  }
}