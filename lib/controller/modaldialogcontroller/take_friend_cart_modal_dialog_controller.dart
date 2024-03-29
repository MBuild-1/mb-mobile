import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';

import '../../domain/entity/bucket/requestjoinbucket/request_join_bucket_parameter.dart';
import '../../domain/entity/bucket/requestjoinbucket/request_join_bucket_response.dart';
import '../../domain/usecase/request_join_bucket_use_case.dart';
import '../../misc/error/validation_error.dart';
import '../../misc/load_data_result.dart';
import '../../misc/manager/controller_manager.dart';
import '../../misc/typedef.dart';
import '../../misc/validation/validation_result.dart';
import '../../misc/validation/validator/validator.dart';
import '../../misc/validation/validatorgroup/take_friend_cart_validator_group.dart';
import 'modal_dialog_controller.dart';

typedef _OnGetTakeFriendCartInput = String Function();
typedef _OnShowTakeFriendCartRequestProcessLoadingCallback = Future<void> Function();
typedef _OnTakeFriendCartRequestProcessSuccessCallback = Future<void> Function();
typedef _OnShowTakeFriendCartRequestProcessFailedCallback = Future<void> Function(dynamic e);
typedef _OnTakeFriendCartBack = void Function();

class TakeFriendCartModalDialogController extends ModalDialogController {
  final RequestJoinBucketUseCase requestJoinBucketUseCase;

  late Rx<Validator> hostCartIdValidatorRx;
  late Rx<Validator> hostCartPasswordValidatorRx;
  late final TakeFriendCartValidatorGroup takeFriendCartValidatorGroup;

  TakeFriendCartModalDialogDelegate? _takeFriendCartModalDialogDelegate;

  TakeFriendCartModalDialogController(
    ControllerManager? controllerManager,
    this.requestJoinBucketUseCase
  ) : super(controllerManager) {
    takeFriendCartValidatorGroup = TakeFriendCartValidatorGroup(
      hostCartIdValidator: Validator(
        onValidate: () => !_takeFriendCartModalDialogDelegate!.onGetHostCartBucketUsernameInput().isEmptyString ? SuccessValidationResult() : FailedValidationResult(e: ValidationError(message: "${"Host cart id is required".tr}."))
      ),
      hostCartPasswordValidator: Validator(
        onValidate: () => !_takeFriendCartModalDialogDelegate!.onGetHostCartBucketPasswordInput().isEmptyString ? SuccessValidationResult() : FailedValidationResult(e: ValidationError(message: "${"Host cart password is required".tr}."))
      ),
    );
    hostCartIdValidatorRx = takeFriendCartValidatorGroup.hostCartIdValidator.obs;
    hostCartPasswordValidatorRx = takeFriendCartValidatorGroup.hostCartPasswordValidator.obs;
  }

  TakeFriendCartModalDialogController setTakeFriendCartModalDialogDelegate(TakeFriendCartModalDialogDelegate takeFriendCartModalDialogDelegate) {
    _takeFriendCartModalDialogDelegate = takeFriendCartModalDialogDelegate;
    return this;
  }

  void takeFriendCart() async {
    if (_takeFriendCartModalDialogDelegate != null) {
      _takeFriendCartModalDialogDelegate!.onUnfocusAllWidget();
      if (takeFriendCartValidatorGroup.validate()) {
        _takeFriendCartModalDialogDelegate!.onShowTakeFriendCartRequestProcessLoadingCallback();
        LoadDataResult<RequestJoinBucketResponse> requestJoinBucketResponseLoadDataResult = await requestJoinBucketUseCase.execute(
          RequestJoinBucketParameter(
            bucketUsername: _takeFriendCartModalDialogDelegate!.onGetHostCartBucketUsernameInput(),
            bucketPassword: _takeFriendCartModalDialogDelegate!.onGetHostCartBucketPasswordInput(),
          )
        ).future(
          parameter: apiRequestManager.addRequestToCancellationPart('take-friend-cart').value
        );
        _takeFriendCartModalDialogDelegate!.onTakeFriendCartBack();
        if (requestJoinBucketResponseLoadDataResult.isSuccess) {
          _takeFriendCartModalDialogDelegate!.onTakeFriendCartRequestProcessSuccessCallback();
        } else {
          _takeFriendCartModalDialogDelegate!.onShowTakeFriendCartRequestProcessFailedCallback(requestJoinBucketResponseLoadDataResult.resultIfFailed);
        }
      }
    }
  }
}

class TakeFriendCartModalDialogDelegate {
  OnUnfocusAllWidget onUnfocusAllWidget;
  _OnGetTakeFriendCartInput onGetHostCartBucketUsernameInput;
  _OnGetTakeFriendCartInput onGetHostCartBucketPasswordInput;
  _OnShowTakeFriendCartRequestProcessLoadingCallback onShowTakeFriendCartRequestProcessLoadingCallback;
  _OnTakeFriendCartRequestProcessSuccessCallback onTakeFriendCartRequestProcessSuccessCallback;
  _OnShowTakeFriendCartRequestProcessFailedCallback onShowTakeFriendCartRequestProcessFailedCallback;
  _OnTakeFriendCartBack onTakeFriendCartBack;

  TakeFriendCartModalDialogDelegate({
    required this.onUnfocusAllWidget,
    required this.onGetHostCartBucketUsernameInput,
    required this.onGetHostCartBucketPasswordInput,
    required this.onShowTakeFriendCartRequestProcessLoadingCallback,
    required this.onTakeFriendCartRequestProcessSuccessCallback,
    required this.onShowTakeFriendCartRequestProcessFailedCallback,
    required this.onTakeFriendCartBack
  });
}