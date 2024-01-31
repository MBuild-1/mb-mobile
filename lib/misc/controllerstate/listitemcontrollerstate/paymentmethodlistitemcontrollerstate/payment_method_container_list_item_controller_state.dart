import 'dart:ui';

import '../../../../domain/entity/payment/payment_method.dart';
import '../../../../domain/entity/payment/payment_method_group.dart';
import '../../../../presentation/widget/colorful_chip_tab_bar.dart';
import '../list_item_controller_state.dart';

class PaymentMethodContainerListItemControllerState extends ListItemControllerState {
  List<PaymentMethodGroup> paymentMethodGroupList;
  Color Function() onGetPaymentMethodTabColor;
  ColorfulChipTabBarController Function() onGetPaymentMethodColorfulChipTabBarController;
  String? Function() onGetSelectedPaymentMethodSettlingId;
  void Function(PaymentMethod) onSelectPaymentMethod;
  void Function() onUpdateState;

  PaymentMethodContainerListItemControllerState({
    required this.paymentMethodGroupList,
    required this.onGetPaymentMethodTabColor,
    required this.onGetPaymentMethodColorfulChipTabBarController,
    required this.onGetSelectedPaymentMethodSettlingId,
    required this.onSelectPaymentMethod,
    required this.onUpdateState,
  });
}