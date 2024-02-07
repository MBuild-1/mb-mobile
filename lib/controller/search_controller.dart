import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';

import '../domain/entity/product/product_with_condition_paging_parameter.dart';
import '../domain/entity/product/productentry/product_entry.dart';
import '../domain/entity/search/remove_all_search_history_parameter.dart';
import '../domain/entity/search/remove_all_search_history_response.dart';
import '../domain/entity/search/search_history_parameter.dart';
import '../domain/entity/search/search_history_response.dart';
import '../domain/entity/search/search_last_seen_history_parameter.dart';
import '../domain/entity/search/search_last_seen_history_response.dart';
import '../domain/entity/search/search_parameter.dart';
import '../domain/entity/search/search_response.dart';
import '../domain/entity/search/store_keyword_for_search_history_parameter.dart';
import '../domain/entity/search/store_keyword_for_search_history_response.dart';
import '../domain/usecase/get_product_entry_with_condition_paging_use_case.dart';
import '../domain/usecase/remove_all_search_history_use_case.dart';
import '../domain/usecase/search_history_use_case.dart';
import '../domain/usecase/search_last_seen_history_use_case.dart';
import '../domain/usecase/search_use_case.dart';
import '../domain/usecase/store_keyword_for_search_history_use_case.dart';
import '../misc/controllercontentdelegate/wishlist_and_cart_controller_content_delegate.dart';
import '../misc/load_data_result.dart';
import '../misc/paging/pagingresult/paging_data_result.dart';
import '../misc/typedef.dart';
import 'base_getx_controller.dart';

typedef _OnSearchBack = void Function();
typedef _OnShowRemoveAllSearchHistoryRequestProcessLoadingCallback = Future<void> Function();
typedef _OnRemoveAllSearchHistoryRequestProcessSuccessCallback = Future<void> Function();
typedef _OnRemoveAllSearchHistoryRequestProcessFailedCallback = Future<void> Function(dynamic e);

class SearchController extends BaseGetxController {
  final GetProductEntryWithConditionPagingUseCase getProductEntryWithConditionPagingUseCase;
  final SearchUseCase searchUseCase;
  final WishlistAndCartControllerContentDelegate wishlistAndCartControllerContentDelegate;
  final StoreKeywordForSearchHistoryUseCase storeKeywordForSearchHistoryUseCase;
  final SearchHistoryUseCase searchHistoryUseCase;
  final SearchLastSeenHistoryUseCase searchLastSeenHistoryUseCase;
  final RemoveAllSearchHistoryUseCase removeAllSearchHistoryUseCase;

  SearchDelegate? _searchDelegate;

  SearchController(
    super.controllerManager,
    this.getProductEntryWithConditionPagingUseCase,
    this.searchUseCase,
    this.wishlistAndCartControllerContentDelegate,
    this.storeKeywordForSearchHistoryUseCase,
    this.searchHistoryUseCase,
    this.searchLastSeenHistoryUseCase,
    this.removeAllSearchHistoryUseCase
  ) {
    wishlistAndCartControllerContentDelegate.setApiRequestManager(() => apiRequestManager);
  }

  Future<LoadDataResult<PagingDataResult<ProductEntry>>> getProductEntrySearch(ProductWithConditionPagingParameter productWithConditionPagingParameter) {
    return getProductEntryWithConditionPagingUseCase.execute(productWithConditionPagingParameter).future(
      parameter: apiRequestManager.addRequestToCancellationPart("product-search").value
    );
  }

  Future<LoadDataResult<SearchResponse>> search(SearchParameter searchParameter, String searchKey) {
    return searchUseCase.execute(searchParameter).future(
      parameter: apiRequestManager.addRequestToCancellationPart(searchKey).value
    );
  }

  Future<LoadDataResult<SearchHistoryResponse>> searchHistory(SearchHistoryParameter searchHistoryParameter) {
    return searchHistoryUseCase.execute(searchHistoryParameter).future(
      parameter: apiRequestManager.addRequestToCancellationPart("search-history").value
    );
  }

  Future<LoadDataResult<SearchLastSeenHistoryResponse>> searchLastSeenHistory(SearchLastSeenHistoryParameter searchLastSeenHistoryParameter) {
    return searchLastSeenHistoryUseCase.execute(searchLastSeenHistoryParameter).future(
      parameter: apiRequestManager.addRequestToCancellationPart("search-last-seen-history").value
    );
  }

  Future<LoadDataResult<StoreKeywordForSearchHistoryResponse>> storeKeywordForSearchHistory(StoreKeywordForSearchHistoryParameter storeKeywordForSearchHistoryParameter) {
    return storeKeywordForSearchHistoryUseCase.execute(storeKeywordForSearchHistoryParameter).future(
      parameter: apiRequestManager.addRequestToCancellationPart("store-keyword-for-search-history").value
    );
  }

  void removeAllSearchLastSeenHistory() async {
    if (_searchDelegate != null) {
      _searchDelegate!.onUnfocusAllWidget();
      _searchDelegate!.onShowRemoveAllSearchHistoryRequestProcessLoadingCallback();
      LoadDataResult<RemoveAllSearchHistoryResponse> removeAllSearchLastSeenHistoryLoadDataResult = await removeAllSearchHistoryUseCase.execute(
        RemoveAllSearchHistoryParameter()
      ).future(
        parameter: apiRequestManager.addRequestToCancellationPart('remove-all-search-last-seen').value
      );
      _searchDelegate!.onSearchBack();
      if (removeAllSearchLastSeenHistoryLoadDataResult.isSuccess) {
        _searchDelegate!.onRemoveAllSearchHistoryRequestProcessSuccessCallback();
      } else {
        _searchDelegate!.onRemoveAllSearchHistoryRequestProcessFailedCallback(removeAllSearchLastSeenHistoryLoadDataResult.resultIfFailed);
      }
    }
  }

  SearchController setSearchDelegate(SearchDelegate searchDelegate) {
    _searchDelegate = searchDelegate;
    return this;
  }
}

class SearchDelegate {
  OnUnfocusAllWidget onUnfocusAllWidget;
  _OnSearchBack onSearchBack;
  _OnShowRemoveAllSearchHistoryRequestProcessLoadingCallback onShowRemoveAllSearchHistoryRequestProcessLoadingCallback;
  _OnRemoveAllSearchHistoryRequestProcessSuccessCallback onRemoveAllSearchHistoryRequestProcessSuccessCallback;
  _OnRemoveAllSearchHistoryRequestProcessFailedCallback onRemoveAllSearchHistoryRequestProcessFailedCallback;

  SearchDelegate({
    required this.onUnfocusAllWidget,
    required this.onSearchBack,
    required this.onShowRemoveAllSearchHistoryRequestProcessLoadingCallback,
    required this.onRemoveAllSearchHistoryRequestProcessSuccessCallback,
    required this.onRemoveAllSearchHistoryRequestProcessFailedCallback
  });
}