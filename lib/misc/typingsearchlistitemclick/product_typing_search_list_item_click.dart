import 'typing_search_list_item_click.dart';

class ProductTypingSearchListItemClick extends TypingSearchListItemClick {
  String productId;
  String productName;
  String productSlug;

  ProductTypingSearchListItemClick({
    required this.productId,
    required this.productName,
    required this.productSlug
  });
}