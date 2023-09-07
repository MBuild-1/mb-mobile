import '../../domain/entity/additionalitem/additional_item.dart';
import '../../domain/entity/order/order_purchasing.dart';

extension OrderPurchasingExt on OrderPurchasing {
  AdditionalItem toAdditionalItem() {
    return AdditionalItem(
      id: id,
      name: name,
      quantity: quantity,
      estimationPrice: price.toDouble(),
      estimationWeight: weight.toDouble()
    );
  }
}