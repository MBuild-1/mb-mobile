import 'package:masterbagasi/misc/ext/future_ext.dart';
import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';

import '../../domain/entity/deleteaccount/senddeleteaccountotp/send_delete_account_otp_parameter.dart';
import '../../domain/entity/deleteaccount/senddeleteaccountotp/send_delete_account_otp_response.dart';
import '../../domain/entity/deleteaccount/verifydeleteaccountotp/verify_delete_account_otp_parameter.dart';
import '../../domain/entity/deleteaccount/verifydeleteaccountotp/verify_delete_account_otp_response.dart';
import '../../domain/entity/user/getuser/get_user_parameter.dart';
import '../../domain/entity/user/user.dart';
import '../../domain/usecase/get_user_use_case.dart';
import '../../domain/usecase/send_delete_account_otp_use_case.dart';
import '../../domain/usecase/verify_delete_account_otp_use_case.dart';
import '../../misc/load_data_result.dart';
import '../../misc/typedef.dart';
import 'modal_dialog_controller.dart';

typedef _OnDeleteAccountBack = void Function();
typedef _OnShowSendDeleteAccountOtpRequestProcessLoadingCallback = Future<void> Function();
typedef _OnSendDeleteAccountOtpRequestProcessSuccessCallback = Future<void> Function(SendDeleteAccountOtpResponse sendDeleteAccountOtpResponse);
typedef _OnShowSendDeleteAccountOtpRequestProcessFailedCallback = Future<void> Function(dynamic e);
typedef _OnShowVerifyDeleteAccountOtpRequestProcessLoadingCallback = Future<void> Function();
typedef _OnVerifyDeleteAccountOtpRequestProcessSuccessCallback = Future<void> Function(VerifyDeleteAccountOtpResponse verifyDeleteAccountOtpResponse);
typedef _OnShowVerifyDeleteAccountOtpRequestProcessFailedCallback = Future<void> Function(dynamic e);
typedef _OnLogoutIntoOneSignal = Future<LoadDataResult<void>> Function();
typedef _OnDeleteToken = Future<void> Function();

class DeleteAccountModalDialogController extends ModalDialogController {
  final SendDeleteAccountOtpUseCase sendDeleteAccountOtpUseCase;
  final VerifyDeleteAccountOtpUseCase verifyDeleteAccountOtpUseCase;
  final GetUserUseCase getUserUseCase;

  DeleteAccountDelegate? _deleteAccountDelegate;

  DeleteAccountModalDialogController(
    super.controllerManager,
    this.sendDeleteAccountOtpUseCase,
    this.verifyDeleteAccountOtpUseCase,
    this.getUserUseCase
  );

  DeleteAccountModalDialogController setDeleteAccountDelegate(DeleteAccountDelegate deleteAccountDelegate) {
    _deleteAccountDelegate = deleteAccountDelegate;
    return this;
  }

  void sendDeleteAccountOtp() async {
    if (_deleteAccountDelegate != null) {
      _deleteAccountDelegate!.onUnfocusAllWidget();
      _deleteAccountDelegate!.onShowSendDeleteAccountOtpRequestProcessLoadingCallback();
      LoadDataResult<SendDeleteAccountOtpResponse> sendDeleteAccountOtpResponseLoadDataResult = await sendDeleteAccountOtpUseCase.execute(
        SendDeleteAccountOtpParameter()
      ).future(
        parameter: apiRequestManager.addRequestToCancellationPart('send-delete-account-otp').value
      );
      _deleteAccountDelegate!.onDeleteAccountBack();
      if (sendDeleteAccountOtpResponseLoadDataResult.isSuccess) {
        _deleteAccountDelegate!.onSendDeleteAccountOtpRequestProcessSuccessCallback(sendDeleteAccountOtpResponseLoadDataResult.resultIfSuccess!);
      } else {
        _deleteAccountDelegate!.onShowSendDeleteAccountOtpRequestProcessFailedCallback(sendDeleteAccountOtpResponseLoadDataResult.resultIfFailed!);
      }
    }
  }

  void verifyDeleteAccountOtp(String otp) async {
    if (_deleteAccountDelegate != null) {
      _deleteAccountDelegate!.onUnfocusAllWidget();
      _deleteAccountDelegate!.onShowVerifyDeleteAccountOtpRequestProcessLoadingCallback();
      LoadDataResult<User> userLoadDataResult = await getUserUseCase.execute(
        GetUserParameter()
      ).future(
        parameter: apiRequestManager.addRequestToCancellationPart('get-user-before-logout').value
      ).map<User>(
        (getUserResponse) => getUserResponse.user
      );
      if (userLoadDataResult.isSuccess) {
        User user = userLoadDataResult.resultIfSuccess!;
        Future<void> unsubscribeChatCount() async {
          await _deleteAccountDelegate!.onUnsubscribeChatCountRealtimeChannel(user.id);
          await _deleteAccountDelegate!.onUnsubscribeNotificationCountRealtimeChannel(user.id);
        }
        LoadDataResult<VerifyDeleteAccountOtpResponse> verifyDeleteAccountOtpResponseLoadDataResult = await verifyDeleteAccountOtpUseCase.execute(
          VerifyDeleteAccountOtpParameter(otp: otp)
        ).future(
          parameter: apiRequestManager.addRequestToCancellationPart('verify-delete-account-otp').value
        );
        if (verifyDeleteAccountOtpResponseLoadDataResult.isSuccess) {
          await _deleteAccountDelegate!.onDeleteToken().getLoadDataResult();
          await _deleteAccountDelegate!.onLogoutIntoOneSignal();
          await unsubscribeChatCount();
          _deleteAccountDelegate!.onDeleteAccountBack();
          _deleteAccountDelegate!.onVerifyDeleteAccountOtpRequestProcessSuccessCallback(verifyDeleteAccountOtpResponseLoadDataResult.resultIfSuccess!);
        } else {
          _deleteAccountDelegate!.onDeleteAccountBack();
          _deleteAccountDelegate!.onShowVerifyDeleteAccountOtpRequestProcessFailedCallback(verifyDeleteAccountOtpResponseLoadDataResult.resultIfFailed!);
        }
      } else {
        _deleteAccountDelegate!.onDeleteAccountBack();
        _deleteAccountDelegate!.onShowVerifyDeleteAccountOtpRequestProcessFailedCallback(userLoadDataResult.resultIfFailed!);
      }
    }
  }
}

class DeleteAccountDelegate {
  OnUnfocusAllWidget onUnfocusAllWidget;
  _OnDeleteAccountBack onDeleteAccountBack;
  _OnShowSendDeleteAccountOtpRequestProcessLoadingCallback onShowSendDeleteAccountOtpRequestProcessLoadingCallback;
  _OnSendDeleteAccountOtpRequestProcessSuccessCallback onSendDeleteAccountOtpRequestProcessSuccessCallback;
  _OnShowSendDeleteAccountOtpRequestProcessFailedCallback onShowSendDeleteAccountOtpRequestProcessFailedCallback;
  _OnShowVerifyDeleteAccountOtpRequestProcessLoadingCallback onShowVerifyDeleteAccountOtpRequestProcessLoadingCallback;
  _OnVerifyDeleteAccountOtpRequestProcessSuccessCallback onVerifyDeleteAccountOtpRequestProcessSuccessCallback;
  _OnShowVerifyDeleteAccountOtpRequestProcessFailedCallback onShowVerifyDeleteAccountOtpRequestProcessFailedCallback;
  _OnLogoutIntoOneSignal onLogoutIntoOneSignal;
  _OnDeleteToken onDeleteToken;
  Future<void> Function(String) onUnsubscribeChatCountRealtimeChannel;
  Future<void> Function(String) onUnsubscribeNotificationCountRealtimeChannel;

  DeleteAccountDelegate({
    required this.onUnfocusAllWidget,
    required this.onDeleteAccountBack,
    required this.onShowSendDeleteAccountOtpRequestProcessLoadingCallback,
    required this.onSendDeleteAccountOtpRequestProcessSuccessCallback,
    required this.onShowSendDeleteAccountOtpRequestProcessFailedCallback,
    required this.onShowVerifyDeleteAccountOtpRequestProcessLoadingCallback,
    required this.onVerifyDeleteAccountOtpRequestProcessSuccessCallback,
    required this.onShowVerifyDeleteAccountOtpRequestProcessFailedCallback,
    required this.onLogoutIntoOneSignal,
    required this.onDeleteToken,
    required this.onUnsubscribeChatCountRealtimeChannel,
    required this.onUnsubscribeNotificationCountRealtimeChannel
  });
}