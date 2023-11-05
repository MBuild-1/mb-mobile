import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';

import '../../domain/entity/additionalitem/additional_item.dart';
import '../../domain/entity/order/modifywarehouseinorder/modifywarehouseinorderitem/all_required_fields_warehouse_in_order_item.dart';
import '../../domain/entity/order/modifywarehouseinorder/modifywarehouseinorderparameter/add_warehouse_in_order_parameter.dart';
import '../../domain/entity/order/modifywarehouseinorder/modifywarehouseinorderparameter/change_warehouse_in_order_parameter.dart';
import '../../domain/entity/order/modifywarehouseinorder/modifywarehouseinorderparameter/modify_warehouse_in_order_parameter.dart';
import '../../domain/entity/order/modifywarehouseinorder/modifywarehouseinorderparameter/remove_warehouse_in_order_parameter.dart';
import '../../misc/error/validation_error.dart';
import '../../misc/typedef.dart';
import '../../misc/validation/validation_result.dart';
import '../../misc/validation/validator/validator.dart';
import '../../misc/validation/validatorgroup/modify_warehouse_in_order_validator_group.dart';
import '../../presentation/page/modaldialogpage/modify_warehouse_in_order_modal_dialog_page.dart';
import 'modal_dialog_controller.dart';

typedef _OnGetModifyWarehouseInOrderInput<T> = T Function();
typedef _OnModifyWarehouseInOrderBack = void Function();
typedef _OnGetModifyWarehouseInOrderActionFurther = ModifyWarehouseInOrderActionFurther Function();
typedef _OnGetModifyWarehouseInOrderAction = ModifyWarehouseInOrderAction Function();
typedef _OnGetModifyWarehouseInOrderParameter = ModifyWarehouseInOrderParameter Function();

class ModifyWarehouseInOrderModalDialogController extends ModalDialogController {
  late Rx<Validator> nameValidatorRx;
  late Rx<Validator> priceValidatorRx;
  late Rx<Validator> weightValidatorRx;
  late Rx<Validator> quantityValidatorRx;
  late Rx<Validator> notesValidatorRx;
  late final ModifyWarehouseInOrderValidatorGroup modifyWarehouseInOrderValidatorGroup;

  ModifyWarehouseInOrderModalDialogDelegate? _modifyWarehouseInOrderModalDialogDelegate;

  ModifyWarehouseInOrderModalDialogController(
    super.controllerManager
  ) {
    modifyWarehouseInOrderValidatorGroup = ModifyWarehouseInOrderValidatorGroup(
      nameValidator: Validator(
        onValidate: () => !_modifyWarehouseInOrderModalDialogDelegate!.onGetNameInput().isEmptyString ? SuccessValidationResult() : FailedValidationResult(e: ValidationError(message: "${"Name is required".tr}."))
      ),
      priceValidator: Validator(
        onValidate: () {
          String estimationPrice = _modifyWarehouseInOrderModalDialogDelegate!.onGetPriceInput();
          if (!estimationPrice.isEmptyString) {
            double? estimationPriceValue = double.tryParse(estimationPrice);
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
      weightValidator: Validator(
        onValidate: () {
          String estimationWeight = _modifyWarehouseInOrderModalDialogDelegate!.onGetWeightInput();
          if (!estimationWeight.isEmptyString) {
            double? estimationWeightValue = double.tryParse(estimationWeight);
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
      quantityValidator: Validator(
        onValidate: () {
          String quantity = _modifyWarehouseInOrderModalDialogDelegate!.onGetQuantityInput();
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
      notesValidator: Validator(
        onValidate: () => !_modifyWarehouseInOrderModalDialogDelegate!.onGetNotesInput().isEmptyString ? SuccessValidationResult() : FailedValidationResult(e: ValidationError(message: "${"Note is required".tr}."))
      ),
    );
    nameValidatorRx = modifyWarehouseInOrderValidatorGroup.nameValidator.obs;
    priceValidatorRx = modifyWarehouseInOrderValidatorGroup.priceValidator.obs;
    weightValidatorRx = modifyWarehouseInOrderValidatorGroup.weightValidator.obs;
    quantityValidatorRx = modifyWarehouseInOrderValidatorGroup.quantityValidator.obs;
    notesValidatorRx = modifyWarehouseInOrderValidatorGroup.notesValidator.obs;
  }

  void submit() {
    if (_modifyWarehouseInOrderModalDialogDelegate != null) {
      bool canBeProcessed = false;
      var modifyWarehouseInOrderParameter = _modifyWarehouseInOrderModalDialogDelegate!.onGetModifyWarehouseInOrderParameter();
      if (modifyWarehouseInOrderParameter is AddWarehouseInOrderParameter) {
        canBeProcessed = _modifyWarehouseInOrderModalDialogDelegate!.onGetAdditionalItemList().isNotEmpty;
      } else if (modifyWarehouseInOrderParameter is ChangeWarehouseInOrderParameter) {
        canBeProcessed = modifyWarehouseInOrderValidatorGroup.validate();
      }
      if (canBeProcessed) {
        _modifyWarehouseInOrderModalDialogDelegate!.onGetModifyWarehouseInOrderAction().submitModifyWarehouse(
          () {
            var modifyWarehouseInOrderParameter = _modifyWarehouseInOrderModalDialogDelegate!.onGetModifyWarehouseInOrderParameter();
            if (modifyWarehouseInOrderParameter is AddWarehouseInOrderParameter) {
              modifyWarehouseInOrderParameter.allRequiredFieldsWarehouseInOrderItemList = _modifyWarehouseInOrderModalDialogDelegate!.onGetAdditionalItemList().map(
                (additionalItem) => AllRequiredFieldsWarehouseInOrderItem(
                  type: "",
                  name: additionalItem.name,
                  weight: additionalItem.estimationWeight,
                  price: additionalItem.estimationPrice.toInt(),
                  quantity: additionalItem.quantity,
                  notes: additionalItem.notes
                )
              ).toList();
            } else if (modifyWarehouseInOrderParameter is ChangeWarehouseInOrderParameter) {
              var optionalFieldsWarehouseInOrderItem = modifyWarehouseInOrderParameter.optionalFieldsWarehouseInOrderItem;
              optionalFieldsWarehouseInOrderItem.name = _modifyWarehouseInOrderModalDialogDelegate!.onGetNameInput();
              optionalFieldsWarehouseInOrderItem.weight = double.parse(_modifyWarehouseInOrderModalDialogDelegate!.onGetWeightInput());
              optionalFieldsWarehouseInOrderItem.price = int.parse(_modifyWarehouseInOrderModalDialogDelegate!.onGetPriceInput());
              optionalFieldsWarehouseInOrderItem.quantity = int.parse(_modifyWarehouseInOrderModalDialogDelegate!.onGetQuantityInput());
              optionalFieldsWarehouseInOrderItem.notes = _modifyWarehouseInOrderModalDialogDelegate!.onGetNotesInput();
            }
            return modifyWarehouseInOrderParameter;
          }(),
          _modifyWarehouseInOrderModalDialogDelegate!.onGetModifyWarehouseInOrderActionFurther(),
        );
      }
    }
  }

  ModifyWarehouseInOrderModalDialogController setModifyWarehouseInOrderModalDialogDelegate(ModifyWarehouseInOrderModalDialogDelegate modifyWarehouseInOrderModalDialogDelegate) {
    _modifyWarehouseInOrderModalDialogDelegate = modifyWarehouseInOrderModalDialogDelegate;
    return this;
  }
}

class ModifyWarehouseInOrderModalDialogDelegate {
  OnUnfocusAllWidget onUnfocusAllWidget;
  _OnGetModifyWarehouseInOrderActionFurther onGetModifyWarehouseInOrderActionFurther;
  _OnGetModifyWarehouseInOrderAction onGetModifyWarehouseInOrderAction;
  _OnGetModifyWarehouseInOrderParameter onGetModifyWarehouseInOrderParameter;
  _OnGetModifyWarehouseInOrderInput<List<AdditionalItem>> onGetAdditionalItemList;
  _OnGetModifyWarehouseInOrderInput<String> onGetNameInput;
  _OnGetModifyWarehouseInOrderInput<String> onGetPriceInput;
  _OnGetModifyWarehouseInOrderInput<String> onGetWeightInput;
  _OnGetModifyWarehouseInOrderInput<String> onGetQuantityInput;
  _OnGetModifyWarehouseInOrderInput<String> onGetNotesInput;
  _OnModifyWarehouseInOrderBack onAddAdditionalItemBack;

  ModifyWarehouseInOrderModalDialogDelegate({
    required this.onUnfocusAllWidget,
    required this.onGetModifyWarehouseInOrderActionFurther,
    required this.onGetModifyWarehouseInOrderAction,
    required this.onGetModifyWarehouseInOrderParameter,
    required this.onGetAdditionalItemList,
    required this.onGetNameInput,
    required this.onGetPriceInput,
    required this.onGetWeightInput,
    required this.onGetQuantityInput,
    required this.onGetNotesInput,
    required this.onAddAdditionalItemBack
  });
}