import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';

import '../../misc/error/validation_error.dart';
import '../../misc/manager/controller_manager.dart';
import '../../misc/typedef.dart';
import '../../misc/validation/validation_result.dart';
import '../../misc/validation/validator/validator.dart';
import '../../misc/validation/validatorgroup/input_value_validator_group.dart';
import 'modal_dialog_controller.dart';

typedef _OnGetInputValueInput = String Function();
typedef _OnGetInputValueRequiredMessage = String Function();
typedef _OnInputValueBack = void Function();
typedef _OnInputValueRequestProcessSuccessCallback = Future<void> Function(String);
typedef _OnValidateInput = ValidationResult Function(String);

class InputValueModalDialogController extends ModalDialogController {
  late Rx<Validator> inputValidatorRx;
  late final InputValueValidatorGroup inputValueValidatorGroup;

  InputValueModalDialogDelegate? _inputValueModalDialogDelegate;

  InputValueModalDialogController(
    ControllerManager? controllerManager,
  ) : super(controllerManager) {
    inputValueValidatorGroup = InputValueValidatorGroup(
      inputValueValidator: Validator(
        onValidate: () => _inputValueModalDialogDelegate!.onValidateInput == null
          ? (
            !_inputValueModalDialogDelegate!.onGetInputValueInput().isEmptyString
              ? SuccessValidationResult()
              : FailedValidationResult(
                  e: ValidationError(
                    message: _inputValueModalDialogDelegate!.onGetInputValueRequiredMessage()
                  )
                )
          ) : _inputValueModalDialogDelegate!.onValidateInput!(
            _inputValueModalDialogDelegate!.onGetInputValueInput()
          )
      )
    );
    inputValidatorRx = inputValueValidatorGroup.inputValueValidator.obs;
  }

  InputValueModalDialogController setInputValueModalDialogDelegate(InputValueModalDialogDelegate inputValueModalDialogDelegate) {
    _inputValueModalDialogDelegate = inputValueModalDialogDelegate;
    return this;
  }

  void inputValue() async {
    if (_inputValueModalDialogDelegate != null) {
      _inputValueModalDialogDelegate!.onUnfocusAllWidget();
      if (inputValueValidatorGroup.validate()) {
        _inputValueModalDialogDelegate!.onInputValueRequestProcessSuccessCallback(
          _inputValueModalDialogDelegate!.onGetInputValueInput()
        );
      }
    }
  }
}

class InputValueModalDialogDelegate {
  OnUnfocusAllWidget onUnfocusAllWidget;
  _OnGetInputValueInput onGetInputValueInput;
  _OnInputValueBack onInputValueBack;
  _OnInputValueRequestProcessSuccessCallback onInputValueRequestProcessSuccessCallback;
  _OnGetInputValueRequiredMessage onGetInputValueRequiredMessage;
  _OnValidateInput? onValidateInput;

  InputValueModalDialogDelegate({
    required this.onUnfocusAllWidget,
    required this.onGetInputValueInput,
    required this.onInputValueBack,
    required this.onInputValueRequestProcessSuccessCallback,
    required this.onGetInputValueRequiredMessage,
    required this.onValidateInput
  });
}