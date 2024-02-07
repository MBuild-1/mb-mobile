import '../domain/entity/product/productentry/product_entry.dart';
import '../domain/entity/product/productvariant/product_variant.dart';

class _ProductHelperImpl {
  ProductEntry? getSelectedProductEntry(List<ProductEntry> productEntryList, int productEntryIndex) {
    ProductEntry? selectedProductEntry;
    if (productEntryList.isNotEmpty && productEntryIndex > -1) {
      selectedProductEntry = productEntryList[productEntryIndex];
    } else if (productEntryIndex == -1) {
      selectedProductEntry = productEntryList.first;
    }
    return selectedProductEntry;
  }

  String getProductVariantDescription(ProductEntry productEntry) {
    List<ProductVariant> productVariantList = productEntry.productVariantList;
    String productVariantDescription = "";
    if (productVariantList.isNotEmpty) {
      int j = 0;
      for (ProductVariant productVariant in productVariantList) {
        productVariantDescription += "${(j > 0 ? ", " : "")}${productVariant.type} (${productVariant.name})";
        j++;
      }
    } else {
      productVariantDescription = productEntry.sustension;
    }
    return productVariantDescription;
  }
}

// ignore: non_constant_identifier_names
final _ProductHelperImpl ProductHelper = _ProductHelperImpl();