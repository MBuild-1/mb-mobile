import '../../misc/controllercontentdelegate/repurchase_controller_content_delegate.dart';
import '../base_getx_controller.dart';

class DeliveryReviewController extends BaseGetxController {
  final RepurchaseControllerContentDelegate repurchaseControllerContentDelegate;

  DeliveryReviewController(
    super.controllerManager,
    this.repurchaseControllerContentDelegate
  ) {
    repurchaseControllerContentDelegate.setApiRequestManager(
      () => apiRequestManager
    );
  }
}