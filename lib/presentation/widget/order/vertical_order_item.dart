import 'order_item.dart';

class VerticalOrderItem extends OrderItem {
  const VerticalOrderItem({
    super.key,
    required super.order,
    required super.onBuyAgainTap,
    required super.onConfirmArrived
  });

  @override
  double? get itemWidth => null;
}