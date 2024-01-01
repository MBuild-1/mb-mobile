import 'payment_method.dart';

class PaymentMethodGroup {
  String id;
  String name;
  String clientName;
  int active;
  List<PaymentMethod> paymentMethodList;

  PaymentMethodGroup({
    required this.id,
    required this.name,
    required this.clientName,
    required this.active,
    required this.paymentMethodList
  });
}