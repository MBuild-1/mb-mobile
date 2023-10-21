import '../../../../domain/entity/search/search_history_response.dart';
import '../../../../domain/entity/search/search_last_seen_history_response.dart';
import '../../../../domain/entity/search/search_response.dart';
import '../../../load_data_result.dart';
import '../../../typingsearchlistitemclick/typing_search_list_item_click.dart';
import '../list_item_controller_state.dart';

class TypingSearchContainerListItemControllerState extends ListItemControllerState {
  LoadDataResult<SearchResponse> Function() searchResponseLoadDataResult;
  LoadDataResult<SearchHistoryResponse> Function() searchHistoryResponseLoadDataResult;
  LoadDataResult<SearchLastSeenHistoryResponse> Function() searchLastSeenHistoryResponseLoadDataResult;
  String Function() onGetSearchText;
  void Function(TypingSearchListItemClick) onTypingSearchListItemClick;

  TypingSearchContainerListItemControllerState({
    required this.searchResponseLoadDataResult,
    required this.searchHistoryResponseLoadDataResult,
    required this.searchLastSeenHistoryResponseLoadDataResult,
    required this.onGetSearchText,
    required this.onTypingSearchListItemClick
  });
}