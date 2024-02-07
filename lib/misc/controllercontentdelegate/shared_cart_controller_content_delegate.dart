import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';

import '../../domain/entity/bucket/checkbucket/check_bucket_parameter.dart';
import '../../domain/entity/bucket/checkbucket/check_bucket_response.dart';
import '../../domain/usecase/check_bucket_use_case.dart';
import '../dialog_helper.dart';
import '../errorprovider/error_provider.dart';
import '../load_data_result.dart';
import '../manager/api_request_manager.dart';
import '../navigation_helper.dart';
import '../page_restoration_helper.dart';
import '../typedef.dart';
import 'controller_content_delegate.dart';

class SharedCartControllerContentDelegate extends ControllerContentDelegate {
  final CheckBucketUseCase checkBucketUseCase;

  SharedCartDelegate? _sharedCartDelegate;
  ApiRequestManager Function()? _onGetApiRequestManager;

  SharedCartControllerContentDelegate({
    required this.checkBucketUseCase,
  });

  void checkSharedCart() async {
    if (_sharedCartDelegate != null && _onGetApiRequestManager != null) {
      ApiRequestManager apiRequestManager = _onGetApiRequestManager!();
      _sharedCartDelegate!.onUnfocusAllWidget();
      _sharedCartDelegate!.onShowCheckSharedCartRequestProcessLoadingCallback();
      LoadDataResult<CheckBucketResponse> checkBucketLoadDataResult = await checkBucketUseCase.execute(CheckBucketParameter()).future(
        parameter: apiRequestManager.addRequestToCancellationPart("check-bucket").value
      );
      _sharedCartDelegate!.onBack();
      if (checkBucketLoadDataResult.isSuccess) {
        _sharedCartDelegate!.onCheckSharedCartRequestProcessSuccessCallback(checkBucketLoadDataResult.resultIfSuccess!);
      } else {
        _sharedCartDelegate!.onShowCheckSharedCartRequestProcessFailedCallback(checkBucketLoadDataResult.resultIfFailed);
      }
    }
  }

  SharedCartControllerContentDelegate setSharedCartDelegate(SharedCartDelegate sharedCartDelegate) {
    _sharedCartDelegate = sharedCartDelegate;
    return this;
  }

  SharedCartControllerContentDelegate setApiRequestManager(ApiRequestManager Function() onGetApiRequestManager) {
    _onGetApiRequestManager = onGetApiRequestManager;
    return this;
  }
}

class SharedCartDelegate {
  OnBack onBack;
  OnUnfocusAllWidget onUnfocusAllWidget;
  OnShowCheckSharedCartRequestProcessLoadingCallback onShowCheckSharedCartRequestProcessLoadingCallback;
  OnCheckSharedCartRequestProcessSuccessCallback onCheckSharedCartRequestProcessSuccessCallback;
  OnShowCheckSharedCartRequestProcessFailedCallback onShowCheckSharedCartRequestProcessFailedCallback;

  SharedCartDelegate({
    required this.onBack,
    required this.onUnfocusAllWidget,
    required this.onShowCheckSharedCartRequestProcessLoadingCallback,
    required this.onCheckSharedCartRequestProcessSuccessCallback,
    required this.onShowCheckSharedCartRequestProcessFailedCallback
  });
}

class SharedCartDelegateFactory {
  SharedCartDelegate generateSharedCartDelegate({
    required BuildContext Function() onGetBuildContext,
    required ErrorProvider Function() onGetErrorProvider,
    OnBack? onBack,
    OnUnfocusAllWidget? onUnfocusAllWidget,
    OnShowCheckSharedCartRequestProcessLoadingCallback? onShowCheckSharedCartRequestProcessLoadingCallback,
    OnCheckSharedCartRequestProcessSuccessCallback? onCheckSharedCartRequestProcessSuccessCallback,
    OnShowCheckSharedCartRequestProcessFailedCallback? onShowCheckSharedCartRequestProcessFailedCallback,
  }) {
    return SharedCartDelegate(
      onUnfocusAllWidget: () => FocusScope.of(onGetBuildContext()).unfocus(),
      onBack: () => Get.back(),
      onShowCheckSharedCartRequestProcessLoadingCallback: onShowCheckSharedCartRequestProcessLoadingCallback ?? () async => DialogHelper.showLoadingDialog(onGetBuildContext()),
      onCheckSharedCartRequestProcessSuccessCallback: onCheckSharedCartRequestProcessSuccessCallback ?? (checkBucketResponse) async {
        PageRestorationHelper.toSharedCartPage(onGetBuildContext());
      },
      onShowCheckSharedCartRequestProcessFailedCallback: onShowCheckSharedCartRequestProcessFailedCallback ?? (e) async {
        if (e is DioError) {
          dynamic data = e.response?.data;
          if (data is Map<String, dynamic>) {
            String message = (data["meta"]["message"] as String).toLowerCase();
            if (message.contains("you need join or create bucket")) {
              DialogHelper.showSharedCartOptionsPrompt(onGetBuildContext());
              return;
            } else if (message.contains("your request has not been accepted by the host")) {
              DialogHelper.showWaitingRequestJoinBucketIsAccepted(onGetBuildContext());
              return;
            }
          }
        }
        return DialogHelper.showFailedModalBottomDialogFromErrorProvider(
          context: onGetBuildContext(),
          errorProvider: onGetErrorProvider(),
          e: e
        );
      },
    );
  }
}