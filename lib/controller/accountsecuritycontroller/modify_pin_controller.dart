import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';

import '../../domain/entity/pin/modifypin/modifypinparameter/modify_pin_parameter.dart';
import '../../domain/entity/pin/modifypin/modify_pin_response.dart';
import '../../domain/usecase/modify_pin_use_case.dart';
import '../../misc/load_data_result.dart';
import '../../misc/typedef.dart';
import '../base_getx_controller.dart';

typedef _OnGetModifyPinParameterInput = ModifyPinParameter Function();
typedef _OnModifyPinBack = void Function();
typedef _OnShowModifyPinRequestProcessLoadingCallback = Future<void> Function();
typedef _OnModifyPinRequestProcessSuccessCallback = Future<void> Function();
typedef _OnShowModifyPinRequestProcessFailedCallback = Future<void> Function(dynamic e);

class ModifyPinController extends BaseGetxController {
  final ModifyPinUseCase modifyPinUseCase;

  ModifyPinDelegate? _modifyPinDelegate;

  ModifyPinController(
    super.controllerManager,
    this.modifyPinUseCase
  );

  ModifyPinController setModifyPinDelegate(ModifyPinDelegate modifyPinDelegate) {
    _modifyPinDelegate = modifyPinDelegate;
    return this;
  }

  void modifyPin() async {
    if (_modifyPinDelegate != null) {
      _modifyPinDelegate!.onUnfocusAllWidget();
      _modifyPinDelegate!.onShowModifyPinRequestProcessLoadingCallback();
      LoadDataResult<ModifyPinResponse> modifyPinResponseLoadDataResult = await modifyPinUseCase.execute(
        _modifyPinDelegate!.onGetModifyPinParameterInput()
      ).future(
        parameter: apiRequestManager.addRequestToCancellationPart('modify-validate-pin').value
      );
      _modifyPinDelegate!.onModifyPinBack();
      if (modifyPinResponseLoadDataResult.isSuccess) {
        _modifyPinDelegate!.onModifyPinRequestProcessSuccessCallback();
      } else {
        _modifyPinDelegate!.onShowModifyPinRequestProcessFailedCallback(modifyPinResponseLoadDataResult.resultIfFailed);
      }
    }
  }
}

class ModifyPinDelegate {
  OnUnfocusAllWidget onUnfocusAllWidget;
  _OnGetModifyPinParameterInput onGetModifyPinParameterInput;
  _OnModifyPinBack onModifyPinBack;
  _OnShowModifyPinRequestProcessLoadingCallback onShowModifyPinRequestProcessLoadingCallback;
  _OnModifyPinRequestProcessSuccessCallback onModifyPinRequestProcessSuccessCallback;
  _OnShowModifyPinRequestProcessFailedCallback onShowModifyPinRequestProcessFailedCallback;

  ModifyPinDelegate({
    required this.onUnfocusAllWidget,
    required this.onGetModifyPinParameterInput,
    required this.onModifyPinBack,
    required this.onShowModifyPinRequestProcessLoadingCallback,
    required this.onModifyPinRequestProcessSuccessCallback,
    required this.onShowModifyPinRequestProcessFailedCallback,
  });
}