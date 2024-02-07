import 'typing_search_list_item_click.dart';

class CategoryTypingSearchListItemClick extends TypingSearchListItemClick {
  String categoryId;
  String categoryName;
  String categorySlug;

  CategoryTypingSearchListItemClick({
    required this.categoryId,
    required this.categoryName,
    required this.categorySlug
  });
}