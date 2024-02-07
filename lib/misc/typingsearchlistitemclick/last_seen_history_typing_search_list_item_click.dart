import 'typing_search_list_item_click.dart';

class LastSeenHistoryTypingSearchListItemClick extends TypingSearchListItemClick {
  String lastSeenRelatedId;
  String lastSeenRelatedName;
  String lastSeenRelatedSlug;

  LastSeenHistoryTypingSearchListItemClick({
    required this.lastSeenRelatedId,
    required this.lastSeenRelatedName,
    required this.lastSeenRelatedSlug
  });
}