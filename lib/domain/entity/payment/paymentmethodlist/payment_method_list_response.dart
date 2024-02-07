import '../payment_method_group.dart';

class PaymentMethodListResponse {
  List<PaymentMethodGroup> paymentMethodGroupList;

  PaymentMethodListResponse({
    required this.paymentMethodGroupList
  });
}