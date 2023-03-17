import '../../entity/product/productentry/product_entry.dart';
import 'product_dummy.dart';

class ProductEntryDummy {
  ProductDummy productDummy;

  ProductEntryDummy({
    required this.productDummy
  });

  ProductEntry generateShimmerDummy() {
    return ProductEntry(
      id: "",
      productId: "",
      sku: "",
      sustension: "",
      weight: 1.0,
      isViral: 0,
      isKitchen: 0,
      isHandycrafts: 0,
      isFashionable: 0,
      sellingPrice: 0,
      isBestSelling: 0,
      productVariantList: [],
      product: productDummy.generateShimmerDummy()
    );
  }

  ProductEntry generateDefaultDummy() {
    return ProductEntry(
      id: "1",
      productId: "1",
      sku: "1",
      sustension: "1",
      weight: 1.0,
      isViral: 0,
      isKitchen: 0,
      isHandycrafts: 0,
      isFashionable: 0,
      sellingPrice: 0,
      isBestSelling: 0,
      productVariantList: [],
      product: productDummy.generateDefaultDummy()
    );
  }
}