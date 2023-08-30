import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';

import '../../domain/entity/order/order.dart';
import '../../domain/entity/order/repurchase_parameter.dart';
import '../../domain/usecase/repurchase_use_case.dart';
import '../dialog_helper.dart';
import '../errorprovider/error_provider.dart';
import '../load_data_result.dart';
import '../manager/api_request_manager.dart';
import '../navigation_helper.dart';
import '../typedef.dart';
import 'controller_content_delegate.dart';

class RepurchaseControllerContentDelegate extends ControllerContentDelegate {
  final RepurchaseUseCase repurchaseUseCase;

  RepurchaseDelegate? _repurchaseDelegate;
  ApiRequestManager Function()? _onGetApiRequestManager;

  RepurchaseControllerContentDelegate({
    required this.repurchaseUseCase,
  });

  void repurchase(String combinedOrderId) async {
    if (_repurchaseDelegate != null && _onGetApiRequestManager != null) {
      ApiRequestManager apiRequestManager = _onGetApiRequestManager!();
      _repurchaseDelegate!.onUnfocusAllWidget();
      _repurchaseDelegate!.onShowRepurchaseProcessLoadingCallback();
      RepurchaseParameter repurchaseParameter = RepurchaseParameter(
        combinedOrderId: combinedOrderId
      );
      LoadDataResult<Order> orderLoadDataResult = await repurchaseUseCase.execute(repurchaseParameter).future(
        parameter: apiRequestManager.addRequestToCancellationPart("repurchase").value
      );
      _repurchaseDelegate!.onBack();
      if (orderLoadDataResult.isSuccess) {
        _repurchaseDelegate!.onRepurchaseProcessSuccessCallback(orderLoadDataResult.resultIfSuccess!);
      } else {
        _repurchaseDelegate!.onShowRepurchaseProcessFailedCallback(orderLoadDataResult.resultIfFailed);
      }
    }
  }

  RepurchaseControllerContentDelegate setRepurchaseDelegate(RepurchaseDelegate repurchaseDelegate) {
    _repurchaseDelegate = repurchaseDelegate;
    return this;
  }

  RepurchaseControllerContentDelegate setApiRequestManager(ApiRequestManager Function() onGetApiRequestManager) {
    _onGetApiRequestManager = onGetApiRequestManager;
    return this;
  }
}

class RepurchaseDelegate {
  OnBack onBack;
  OnUnfocusAllWidget onUnfocusAllWidget;
  OnShowRepurchaseProcessLoadingCallback onShowRepurchaseProcessLoadingCallback;
  OnRepurchaseProcessSuccessCallback onRepurchaseProcessSuccessCallback;
  OnShowRepurchaseProcessFailedCallback onShowRepurchaseProcessFailedCallback;

  RepurchaseDelegate({
    required this.onBack,
    required this.onUnfocusAllWidget,
    required this.onShowRepurchaseProcessLoadingCallback,
    required this.onRepurchaseProcessSuccessCallback,
    required this.onShowRepurchaseProcessFailedCallback,
  });
}

class RepurchaseDelegateFactory {
  RepurchaseDelegate generateRepurchaseDelegate({
    required BuildContext Function() onGetBuildContext,
    required ErrorProvider Function() onGetErrorProvider,
    OnBack? onBack,
    OnUnfocusAllWidget? onUnfocusAllWidget,
    OnShowRepurchaseProcessLoadingCallback? onShowRepurchaseProcessLoadingCallback,
    OnRepurchaseProcessSuccessCallback? onRepurchaseProcessSuccessCallback,
    OnShowRepurchaseProcessFailedCallback? onShowRepurchaseProcessFailedCallback
  }) {
    return RepurchaseDelegate(
      onUnfocusAllWidget: () => FocusScope.of(onGetBuildContext()).unfocus(),
      onBack: () => Get.back(),
      onShowRepurchaseProcessLoadingCallback: onShowRepurchaseProcessLoadingCallback ?? () async => DialogHelper.showLoadingDialog(onGetBuildContext()),
      onRepurchaseProcessSuccessCallback: onRepurchaseProcessSuccessCallback ?? (order) async {
        NavigationHelper.navigationAfterPurchaseProcess(onGetBuildContext(), order);
      },
      onShowRepurchaseProcessFailedCallback: onShowRepurchaseProcessFailedCallback ?? (e) async => DialogHelper.showFailedModalBottomDialogFromErrorProvider(
        context: onGetBuildContext(),
        errorProvider: onGetErrorProvider(),
        e: e
      ),
    );
  }
}