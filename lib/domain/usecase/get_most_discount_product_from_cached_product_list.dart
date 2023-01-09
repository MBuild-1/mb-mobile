import '../entity/product.dart';

class GetMostDiscountProductFromCachedProductList {
  List<Product> execute(List<Product> cachedProductList, int topCount) {
    if (cachedProductList.isEmpty) {
      return cachedProductList;
    }
    List<Product> sortedProductList = List<Product>.of(cachedProductList);
    sortedProductList.sort((product1, product2) {
      if (product1.productDiscountPrice > product2.productDiscountPrice) {
        return 1;
      } else if (product1.productDiscountPrice < product2.productDiscountPrice){
        return -1;
      } else {
        return 0;
      }
    });
    return sortedProductList.take(topCount).toList();
  }
}