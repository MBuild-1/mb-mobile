import 'create_order_parameter.dart';

class CreateOrderVersion1Point1Parameter extends CreateOrderParameter {
  String? settlingId;

  CreateOrderVersion1Point1Parameter({
    required super.cartList,
    required super.additionalItemList,
    required super.couponId,
    required super.address,
    required this.settlingId
  });
}