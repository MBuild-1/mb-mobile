import 'payment_method_item.dart';

class HorizontalPaymentMethodItem extends PaymentMethodItem {
  const HorizontalPaymentMethodItem({
    super.key,
    required super.paymentMethod,
    required super.onSelectPaymentMethod,
    required super.isSelected
  });
}