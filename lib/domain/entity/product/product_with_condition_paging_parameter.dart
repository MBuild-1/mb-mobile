import 'product_paging_parameter.dart';

class ProductWithConditionPagingParameter extends ProductPagingParameter {
  String withCondition;

  ProductWithConditionPagingParameter({
    required super.page,
    super.itemEachPageCount = 15,
    required this.withCondition
  });
}