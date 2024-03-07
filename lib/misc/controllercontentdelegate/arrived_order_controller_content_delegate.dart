import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';

import '../../domain/entity/order/arrived_order_request.dart';
import '../../domain/entity/order/arrived_order_response.dart';
import '../../domain/usecase/arrived_order_use_case.dart';
import '../dialog_helper.dart';
import '../errorprovider/error_provider.dart';
import '../load_data_result.dart';
import '../manager/api_request_manager.dart';
import '../typedef.dart';
import 'controller_content_delegate.dart';

class ArrivedOrderControllerContentDelegate extends ControllerContentDelegate {
  final ArrivedOrderUseCase arrivedOrderUseCase;

  ArrivedOrderDelegate? _arrivedOrderDelegate;
  ApiRequestManager Function()? _onGetApiRequestManager;

  ArrivedOrderControllerContentDelegate({
    required this.arrivedOrderUseCase,
  });

  void arrivedOrder(ArrivedOrderParameter arrivedOrderParameter) async {
    if (_arrivedOrderDelegate != null && _onGetApiRequestManager != null) {
      ApiRequestManager apiRequestManager = _onGetApiRequestManager!();
      _arrivedOrderDelegate!.onUnfocusAllWidget();
      _arrivedOrderDelegate!.onShowArrivedOrderProcessLoadingCallback();
      LoadDataResult<ArrivedOrderResponse> arrivedOrderResponseLoadDataResult = await arrivedOrderUseCase.execute(
        arrivedOrderParameter
      ).future(
        parameter: apiRequestManager.addRequestToCancellationPart("arrived-order").value
      );
      _arrivedOrderDelegate!.onBack();
      if (arrivedOrderResponseLoadDataResult.isSuccess) {
        _arrivedOrderDelegate!.onArrivedOrderProcessSuccessCallback(arrivedOrderResponseLoadDataResult.resultIfSuccess!);
      } else {
        _arrivedOrderDelegate!.onShowArrivedOrderProcessFailedCallback(arrivedOrderResponseLoadDataResult.resultIfFailed);
      }
    }
  }

  ArrivedOrderControllerContentDelegate setArrivedOrderDelegate(ArrivedOrderDelegate arrivedOrderDelegate) {
    _arrivedOrderDelegate = arrivedOrderDelegate;
    return this;
  }

  ArrivedOrderControllerContentDelegate setApiRequestManager(ApiRequestManager Function() onGetApiRequestManager) {
    _onGetApiRequestManager = onGetApiRequestManager;
    return this;
  }
}

class ArrivedOrderDelegate {
  OnBack onBack;
  OnUnfocusAllWidget onUnfocusAllWidget;
  OnShowArrivedOrderProcessLoadingCallback onShowArrivedOrderProcessLoadingCallback;
  OnArrivedOrderProcessSuccessCallback onArrivedOrderProcessSuccessCallback;
  OnShowArrivedOrderProcessFailedCallback onShowArrivedOrderProcessFailedCallback;

  ArrivedOrderDelegate({
    required this.onBack,
    required this.onUnfocusAllWidget,
    required this.onShowArrivedOrderProcessLoadingCallback,
    required this.onArrivedOrderProcessSuccessCallback,
    required this.onShowArrivedOrderProcessFailedCallback
  });
}

class ArrivedOrderDelegateFactory {
  ArrivedOrderDelegate generateArrivedOrderDelegate({
    required BuildContext Function() onGetBuildContext,
    required ErrorProvider Function() onGetErrorProvider,
    OnBack? onBack,
    OnUnfocusAllWidget? onUnfocusAllWidget,
    OnShowArrivedOrderProcessLoadingCallback? onShowArrivedOrderProcessLoadingCallback,
    OnArrivedOrderProcessSuccessCallback? onArrivedOrderProcessSuccessCallback,
    OnShowArrivedOrderProcessFailedCallback? onShowArrivedOrderProcessFailedCallback
  }) {
    return ArrivedOrderDelegate(
      onUnfocusAllWidget: () => FocusScope.of(onGetBuildContext()).unfocus(),
      onBack: () => Get.back(),
      onShowArrivedOrderProcessLoadingCallback: onShowArrivedOrderProcessLoadingCallback ?? () async => DialogHelper.showLoadingDialog(onGetBuildContext()),
      onArrivedOrderProcessSuccessCallback: onArrivedOrderProcessSuccessCallback ?? (order) async {},
      onShowArrivedOrderProcessFailedCallback: onShowArrivedOrderProcessFailedCallback ?? (e) async => DialogHelper.showFailedModalBottomDialogFromErrorProvider(
        context: onGetBuildContext(),
        errorProvider: onGetErrorProvider(),
        e: e
      )
    );
  }
}