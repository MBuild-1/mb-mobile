import 'product_paging_parameter.dart';

class ProductWithConditionPagingParameter extends ProductPagingParameter {
  Map<String, dynamic> withCondition;

  ProductWithConditionPagingParameter({
    required super.page,
    super.itemEachPageCount = 15,
    this.withCondition = const {},
  });
}