import 'dart:async';

import 'package:flutter/material.dart' hide SearchDelegate;
import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';
import 'package:masterbagasi/misc/ext/paging_controller_ext.dart';
import 'package:masterbagasi/misc/ext/paging_ext.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';
import 'package:provider/provider.dart';

import '../../controller/country_delivery_review_controller.dart';
import '../../controller/search_controller.dart';
import '../../domain/entity/cart/support_cart.dart';
import '../../domain/entity/product/product_with_condition_paging_parameter.dart';
import '../../domain/entity/product/productentry/product_entry.dart';
import '../../domain/entity/search/search_history_parameter.dart';
import '../../domain/entity/search/search_history_response.dart';
import '../../domain/entity/search/search_last_seen_history_parameter.dart';
import '../../domain/entity/search/search_last_seen_history_response.dart';
import '../../domain/entity/search/search_parameter.dart';
import '../../domain/entity/search/search_response.dart';
import '../../domain/entity/search/store_keyword_for_search_history_parameter.dart';
import '../../domain/entity/search/store_keyword_for_search_history_response.dart';
import '../../domain/entity/wishlist/support_wishlist.dart';
import '../../domain/usecase/get_product_entry_with_condition_paging_use_case.dart';
import '../../domain/usecase/remove_all_search_history_use_case.dart';
import '../../domain/usecase/search_history_use_case.dart';
import '../../domain/usecase/search_last_seen_history_use_case.dart';
import '../../domain/usecase/search_use_case.dart';
import '../../domain/usecase/store_keyword_for_search_history_use_case.dart';
import '../../domain/usecase/store_search_last_seen_history_use_case.dart';
import '../../misc/additionalloadingindicatorchecker/typing_search_additional_paging_result_parameter_checker.dart';
import '../../misc/constant.dart';
import '../../misc/controllercontentdelegate/wishlist_and_cart_controller_content_delegate.dart';
import '../../misc/controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../../misc/controllerstate/listitemcontrollerstate/load_data_result_dynamic_list_item_controller_state.dart';
import '../../misc/controllerstate/listitemcontrollerstate/no_content_list_item_controller_state.dart';
import '../../misc/controllerstate/listitemcontrollerstate/searchlistitemcontrollerstate/search_container_list_item_controller_state.dart';
import '../../misc/controllerstate/listitemcontrollerstate/searchlistitemcontrollerstate/typing_search_container_list_item_controller_state.dart';
import '../../misc/controllerstate/paging_controller_state.dart';
import '../../misc/dialog_helper.dart';
import '../../misc/entityandlistitemcontrollerstatemediator/horizontal_component_entity_parameterized_entity_and_list_item_controller_state_mediator.dart';
import '../../misc/error/search_not_found_error.dart';
import '../../misc/errorprovider/error_provider.dart';
import '../../misc/getextended/get_extended.dart';
import '../../misc/getextended/get_restorable_route_future.dart';
import '../../misc/injector.dart';
import '../../misc/list_item_controller_state_helper.dart';
import '../../misc/load_data_result.dart';
import '../../misc/login_helper.dart';
import '../../misc/manager/controller_manager.dart';
import '../../misc/paging/modified_paging_controller.dart';
import '../../misc/paging/pagingcontrollerstatepagedchildbuilderdelegate/list_item_paging_controller_state_paged_child_builder_delegate.dart';
import '../../misc/paging/pagingresult/paging_data_result.dart';
import '../../misc/paging/pagingresult/paging_result.dart';
import '../../misc/parameterizedcomponententityandlistitemcontrollerstatemediatorparameter/horizontal_dynamic_item_carousel_parametered_component_entity_and_list_item_controller_state_mediator_parameter.dart';
import '../../misc/typingsearchlistitemclick/brand_typing_search_list_item_click.dart';
import '../../misc/typingsearchlistitemclick/category_typing_search_list_item_click.dart';
import '../../misc/typingsearchlistitemclick/default_typing_search_list_item_click.dart';
import '../../misc/typingsearchlistitemclick/history_typing_search_list_item_click.dart';
import '../../misc/typingsearchlistitemclick/last_seen_history_typing_search_list_item_click.dart';
import '../../misc/typingsearchlistitemclick/product_typing_search_list_item_click.dart';
import '../notifier/component_notifier.dart';
import '../notifier/notification_notifier.dart';
import '../widget/background_app_bar_scaffold.dart';
import '../widget/modified_paged_list_view.dart';
import '../widget/modifiedappbar/core_search_app_bar.dart';
import 'getx_page.dart';
import 'modaldialogpage/search_filter_modal_dialog_page.dart';
import 'product_detail_page.dart';

class SearchPage extends RestorableGetxPage<_SearchPageRestoration> {
  late final ControllerMember<SearchController> _searchController = ControllerMember<SearchController>().addToControllerManager(controllerManager);

  SearchPage({
    Key? key,
  }) : super(
    key: key,
    pageRestorationId: () => "search-page",
  );

  @override
  void onSetController() {
    _searchController.controller = GetExtended.put<SearchController>(
      SearchController(
        controllerManager,
        Injector.locator<GetProductEntryWithConditionPagingUseCase>(),
        Injector.locator<SearchUseCase>(),
        Injector.locator<WishlistAndCartControllerContentDelegate>(),
        Injector.locator<StoreKeywordForSearchHistoryUseCase>(),
        Injector.locator<SearchHistoryUseCase>(),
        Injector.locator<SearchLastSeenHistoryUseCase>(),
        Injector.locator<RemoveAllSearchHistoryUseCase>()
      ),
      tag: pageName
    );
  }

  @override
  _SearchPageRestoration createPageRestoration() => _SearchPageRestoration();

  @override
  Widget buildPage(BuildContext context) {
    return _StatefulSearchControllerMediatorWidget(
      searchController: _searchController.controller,
    );
  }
}

class _SearchPageRestoration extends MixableGetxPageRestoration with ProductDetailPageRestorationMixin {
  @override
  // ignore: unnecessary_overrides
  void initState() {
    super.initState();
  }

  @override
  // ignore: unnecessary_overrides
  void restoreState(Restorator restorator, RestorationBucket? oldBucket, bool initialRestore) {
    super.restoreState(restorator, oldBucket, initialRestore);
  }

  @override
  // ignore: unnecessary_overrides
  void dispose() {
    super.dispose();
  }
}

class SearchPageGetPageBuilderAssistant extends GetPageBuilderAssistant {
  @override
  GetPageBuilder get pageBuilder => (() => SearchPage());

  @override
  GetPageBuilder get pageWithOuterGetxBuilder => (() => GetxPageBuilder.buildRestorableGetxPage(SearchPage()));
}

mixin SearchPageRestorationMixin on MixableGetxPageRestoration {
  late SearchPageRestorableRouteFuture searchPageRestorableRouteFuture;

  @override
  void initState() {
    super.initState();
    searchPageRestorableRouteFuture = SearchPageRestorableRouteFuture(
      restorationId: restorationIdWithPageName('country-delivery-review-route')
    );
  }

  @override
  void restoreState(Restorator restorator, RestorationBucket? oldBucket, bool initialRestore) {
    super.restoreState(restorator, oldBucket, initialRestore);
    searchPageRestorableRouteFuture.restoreState(restorator, oldBucket, initialRestore);
  }

  @override
  void dispose() {
    super.dispose();
    searchPageRestorableRouteFuture.dispose();
  }
}

class SearchPageRestorableRouteFuture extends GetRestorableRouteFuture {
  late RestorableRouteFuture<void> _pageRoute;

  SearchPageRestorableRouteFuture({
    required String restorationId
  }) : super(restorationId: restorationId) {
    _pageRoute = RestorableRouteFuture<void>(
      onPresent: (NavigatorState navigator, Object? arguments) {
        return navigator.restorablePush(_pageRouteBuilder, arguments: arguments);
      }
    );
  }

  static Route<void>? _getRoute([Object? arguments]) {
    return GetExtended.toWithGetPageRouteReturnValue<String?>(
      GetxPageBuilder.buildRestorableGetxPageBuilder(
        SearchPageGetPageBuilderAssistant()
      ),
    );
  }

  @pragma('vm:entry-point')
  static Route<void> _pageRouteBuilder(BuildContext context, Object? arguments) {
    return _getRoute(arguments)!;
  }

  @override
  bool checkBeforePresent([Object? arguments]) => _getRoute(arguments) != null;

  @override
  void presentIfCheckIsPassed([Object? arguments]) => _pageRoute.present(arguments);

  @override
  void restoreState(Restorator restorator, RestorationBucket? oldBucket, bool initialRestore) {
    restorator.registerForRestoration(_pageRoute, restorationId);
  }

  @override
  void dispose() {
    _pageRoute.dispose();
  }
}

class _StatefulSearchControllerMediatorWidget extends StatefulWidget {
  final SearchController searchController;

  const _StatefulSearchControllerMediatorWidget({
    required this.searchController,
  });

  @override
  State<_StatefulSearchControllerMediatorWidget> createState() => _StatefulSearchControllerMediatorWidgetState();
}

class _StatefulSearchControllerMediatorWidgetState extends State<_StatefulSearchControllerMediatorWidget> {
  late AssetImage _searchAppBarBackgroundAssetImage;
  late final ModifiedPagingController<int, ListItemControllerState> _searchListItemPagingController;
  late final PagingControllerState<int, ListItemControllerState> _searchListItemPagingControllerState;
  late final ModifiedPagingController<int, ListItemControllerState> _typingSearchListItemPagingController;
  late final PagingControllerState<int, ListItemControllerState> _typingSearchListItemPagingControllerState;
  final TextEditingController _searchTextEditingController = TextEditingController();
  String? _lastSearch = "";
  bool _beginSearch = false;
  bool _beginSaveOriginalSearchResponse = false;
  LoadDataResult<SearchResponse> _firstSearchResponseLoadDataResult = NoLoadDataResult<SearchResponse>();
  LoadDataResult<SearchResponse> _searchResponseLoadDataResult = NoLoadDataResult<SearchResponse>();
  LoadDataResult<SearchResponse> _typingSearchResponseLoadDataResult = NoLoadDataResult<SearchResponse>();
  LoadDataResult<SearchHistoryResponse> _searchHistoryResponseLoadDataResult = NoLoadDataResult<SearchHistoryResponse>();
  LoadDataResult<SearchLastSeenHistoryResponse> _searchLastSeenHistoryResponseLoadDataResult = NoLoadDataResult<SearchLastSeenHistoryResponse>();
  SearchResponse? _originalSearchResponse;
  Timer? _timer;
  final FocusNode _searchFocusNode = FocusNode();
  SearchFilterModalDialogPageResponse? _searchFilterModalDialogPageResponse;

  int _searchStatus = 0;

  @override
  void initState() {
    super.initState();
    _searchAppBarBackgroundAssetImage = AssetImage(Constant.imagePatternExploreNusantaraMainMenuAppBar);
    _searchListItemPagingController = ModifiedPagingController<int, ListItemControllerState>(
      firstPageKey: 1,
      // ignore: invalid_use_of_protected_member
      apiRequestManager: widget.searchController.apiRequestManager,
    );
    _searchListItemPagingControllerState = PagingControllerState(
      pagingController: _searchListItemPagingController,
      isPagingControllerExist: false
    );
    _searchListItemPagingControllerState.pagingController.addPageRequestListenerWithItemListForLoadDataResult(
      listener: _searchListItemPagingControllerStateListener,
      onPageKeyNext: (pageKey) => pageKey + 1
    );
    _searchListItemPagingControllerState.isPagingControllerExist = true;
    _typingSearchListItemPagingController = ModifiedPagingController<int, ListItemControllerState>(
      firstPageKey: 1,
      // ignore: invalid_use_of_protected_member
      apiRequestManager: widget.searchController.apiRequestManager,
      additionalPagingResultParameterChecker: TypingSearchAdditionalPagingResultParameterChecker()
    );
    _typingSearchListItemPagingControllerState = PagingControllerState(
      pagingController: _typingSearchListItemPagingController,
      isPagingControllerExist: false
    );
    _typingSearchListItemPagingControllerState.pagingController.addPageRequestListenerWithItemListForLoadDataResult(
      listener: _typingSearchListItemPagingControllerStateListener,
      onPageKeyNext: (pageKey) => pageKey + 1
    );
    _typingSearchListItemPagingControllerState.isPagingControllerExist = true;
    _searchTextEditingController.addListener(_searchTextEditingListener);
  }

  void _searchTextEditingListener() {
    if (_lastSearch != _searchTextEditingController.text.trim()) {
      _lastSearch = _searchTextEditingController.text.trim();
      if (_timer != null) {
        _timer?.cancel();
      }
      _timer = Timer(
        const Duration(milliseconds: 300),
        () => _updateTypingSearchState()
      );
    }
  }

  @override
  void didChangeDependencies() {
    precacheImage(_searchAppBarBackgroundAssetImage, context);
    super.didChangeDependencies();
  }

  Future<LoadDataResult<PagingResult<ListItemControllerState>>> _searchListItemPagingControllerStateListener(int pageKey, List<ListItemControllerState>? listItemControllerStateList) async {
    LoadDataResult<PagingResult<ListItemControllerState>> noContent() {
      return SuccessLoadDataResult<PagingResult<ListItemControllerState>>(
        value: PagingDataResult<ListItemControllerState>(
          page: 1,
          totalPage: 1,
          totalItem: 1,
          itemList: [
            NoContentListItemControllerState()
          ],
        )
      );
    }
    if (!_beginSearch) {
      return noContent();
    }
    _searchResponseLoadDataResult = NoLoadDataResult<SearchResponse>();
    if (pageKey == 1) {
      _firstSearchResponseLoadDataResult = NoLoadDataResult<SearchResponse>();
      LoadDataResult<PagingResult<ListItemControllerState>>? finalStoreKeywordForSearchHistoryLoadDataResult;
      LoginHelper.checkingLogin(
        context,
        () async {
          LoadDataResult<StoreKeywordForSearchHistoryResponse> storeKeywordForSearchHistoryLoadDataResult = await widget.searchController.storeKeywordForSearchHistory(
            StoreKeywordForSearchHistoryParameter(
              keyword: _searchTextEditingController.text.trim()
            ),
          );
          if (storeKeywordForSearchHistoryLoadDataResult.isFailed) {
            if (!storeKeywordForSearchHistoryLoadDataResult.isFailedBecauseCancellation) {
              finalStoreKeywordForSearchHistoryLoadDataResult = storeKeywordForSearchHistoryLoadDataResult.map((_) => throw UnimplementedError());
            } else {
              finalStoreKeywordForSearchHistoryLoadDataResult = noContent();
            }
          }
        },
        resultIfHasNotBeenLogin: () {},
      );
      if (finalStoreKeywordForSearchHistoryLoadDataResult != null) {
        return finalStoreKeywordForSearchHistoryLoadDataResult!;
      }
    }
    SearchParameter searchParameter = SearchParameter(
      query: _searchTextEditingController.text.trim(),
      page: pageKey,
      pageSize: 30
    );
    if (_searchFilterModalDialogPageResponse != null) {
      searchParameter.searchSortBy = _searchFilterModalDialogPageResponse!.searchSortBy;
      searchParameter.priceMin = _searchFilterModalDialogPageResponse!.priceMin;
      searchParameter.priceMax = _searchFilterModalDialogPageResponse!.priceMax;
      searchParameter.brandSearchRelated = _searchFilterModalDialogPageResponse!.brandSearchRelated;
      searchParameter.provinceSearchRelated = _searchFilterModalDialogPageResponse!.provinceSearchRelated;
      searchParameter.categorySearchRelated = _searchFilterModalDialogPageResponse!.categorySearchRelated;
    }
    _searchResponseLoadDataResult = await widget.searchController.search(searchParameter, "search");
    if (_searchResponseLoadDataResult.isFailed) {
      if (_searchResponseLoadDataResult.isFailedBecauseCancellation) {
        return noContent();
      }
    }
    if (pageKey == 1) {
      _firstSearchResponseLoadDataResult = _searchResponseLoadDataResult;
      if (_beginSaveOriginalSearchResponse) {
        _beginSaveOriginalSearchResponse = false;
        if (_searchResponseLoadDataResult.isSuccess) {
          _originalSearchResponse = _searchResponseLoadDataResult.resultIfSuccess;
        }
      }
    }
    if (pageKey > 1) {
      if (_searchResponseLoadDataResult.isFailed) {
        dynamic e = _searchResponseLoadDataResult.resultIfFailed!;
        if (e is SearchNotFoundError) {
          return noContent();
        }
      }
    }
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {});
    });
    LoadDataResult<PagingDataResult<ProductEntry>> productEntryLoadDataResult = _searchResponseLoadDataResult.map<PagingDataResult<ProductEntry>>(
      (value) => PagingDataResult<ProductEntry>(
        page: value.paginatedSearchResultList.isNotEmpty ? 1 : 2,
        totalPage: 2,
        totalItem: value.paginatedSearchResultList.length,
        itemList: value.paginatedSearchResultList.map<ProductEntry>(
          (searchResult) => searchResult as ProductEntry
        ).toList()
      )
    );
    return productEntryLoadDataResult.map<PagingResult<ListItemControllerState>>((productEntryPaging) {
      List<ListItemControllerState> resultListItemControllerState = [];
      int totalItem = productEntryPaging.totalItem;
      if (pageKey == 1) {
        totalItem = 1;
        resultListItemControllerState = [
          SearchContainerListItemControllerState(
            searchResultCount: _searchResponseLoadDataResult.resultIfSuccess!.searchResultCount,
            productEntryList: productEntryPaging.itemList,
            onGetColorfulChipTabBarColor: () => Theme.of(context).colorScheme.primary,
            searchFilterModalDialogPageResponse: () => _searchFilterModalDialogPageResponse,
            onUpdateState: () => setState(() {}),
            onGotoFilterModalDialog: _gotoFilterPage,
            onRemoveWishlistWithProductAppearanceData: (productAppearanceData) => widget.searchController.wishlistAndCartControllerContentDelegate.removeFromWishlist(productAppearanceData as SupportWishlist),
            onAddWishlistWithProductAppearanceData: (productAppearanceData) => widget.searchController.wishlistAndCartControllerContentDelegate.addToWishlist(productAppearanceData as SupportWishlist),
            onAddProductCart: (productAppearanceData) => widget.searchController.wishlistAndCartControllerContentDelegate.addToCart(productAppearanceData as SupportCart),
          )
        ];
      } else {
        if (ListItemControllerStateHelper.checkListItemControllerStateList(listItemControllerStateList)) {
          SearchContainerListItemControllerState searchContainerListItemControllerState = ListItemControllerStateHelper.parsePageKeyedListItemControllerState(listItemControllerStateList![0]) as SearchContainerListItemControllerState;
          searchContainerListItemControllerState.productEntryList.addAll(productEntryPaging.itemList);
        }
      }
      return PagingDataResult<ListItemControllerState>(
        itemList: resultListItemControllerState,
        page: productEntryPaging.page,
        totalPage: productEntryPaging.totalPage,
        totalItem: totalItem
      );
    });
  }

  Future<void> _typingSearch() async {
    if (_searchTextEditingController.text.trim().isNotEmptyString) {
      _typingSearchResponseLoadDataResult = await widget.searchController.search(
        SearchParameter(
          suggest: _searchTextEditingController.text.trim()
        ),
        "typing-search"
      );
    }
    await _historySearchAndLastSeenHistorySearch();
  }

  Future<void> _historySearchAndLastSeenHistorySearch() async {
    _searchHistoryResponseLoadDataResult = await widget.searchController.searchHistory(
      SearchHistoryParameter(),
    );
    _searchLastSeenHistoryResponseLoadDataResult = await widget.searchController.searchLastSeenHistory(
      SearchLastSeenHistoryParameter(),
    );
  }

  void _updateTypingSearchState() async {
    await _typingSearch();
    if (mounted) {
      setState(() {});
    }
  }

  Future<LoadDataResult<PagingResult<ListItemControllerState>>> _typingSearchListItemPagingControllerStateListener(int pageKey, List<ListItemControllerState>? listItemControllerStateList) async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await _historySearchAndLastSeenHistorySearch();
      setState(() {});
    });
    return SuccessLoadDataResult<PagingResult<ListItemControllerState>>(
      value: PagingDataResult<ListItemControllerState>(
        page: 1,
        totalPage: 1,
        totalItem: 1,
        itemList: [
          TypingSearchContainerListItemControllerState(
            searchResponseLoadDataResult: () => _typingSearchResponseLoadDataResult,
            searchHistoryResponseLoadDataResult: () => _searchHistoryResponseLoadDataResult,
            searchLastSeenHistoryResponseLoadDataResult: () => _searchLastSeenHistoryResponseLoadDataResult,
            onGetSearchText: () => _searchTextEditingController.text.trim(),
            onTypingSearchListItemClick: (typingSearchListItemClick) {
              if (typingSearchListItemClick is DefaultTypingSearchListItemClick) {
                _searchTextEditingController.text = typingSearchListItemClick.text;
                _search();
              } else if (typingSearchListItemClick is BrandTypingSearchListItemClick) {
                _searchTextEditingController.text = typingSearchListItemClick.brandName;
                _search();
              } else if (typingSearchListItemClick is CategoryTypingSearchListItemClick) {
                _searchTextEditingController.text = typingSearchListItemClick.categoryName;
                _search();
              } else if (typingSearchListItemClick is ProductTypingSearchListItemClick) {
                _searchTextEditingController.text = typingSearchListItemClick.productName;
                _search();
              } else if (typingSearchListItemClick is HistoryTypingSearchListItemClick) {
                _searchTextEditingController.text = typingSearchListItemClick.text;
                _search();
              } else if (typingSearchListItemClick is LastSeenHistoryTypingSearchListItemClick) {
                _searchTextEditingController.text = typingSearchListItemClick.lastSeenRelatedName;
                _search();
              }
            },
            onRemoveAllSearchHistory: () {
              widget.searchController.removeAllSearchLastSeenHistory();
            }
          )
        ],
      )
    );
  }

  void _search({
    bool resetFilter = true,
    bool saveOriginalSearchResponse = true
  }) async {
    if (resetFilter) {
      _searchFilterModalDialogPageResponse = null;
    }
    FocusScope.of(context).unfocus();
    _beginSearch = true;
    if (saveOriginalSearchResponse) {
      _beginSaveOriginalSearchResponse = true;
    }
    _searchListItemPagingController.refresh();
    await Future.delayed(const Duration(milliseconds: 50));
    setState(() => _searchStatus = 1);
  }

  void _gotoFilterPage() async {
    if (_originalSearchResponse == null) {
      return;
    }
    SearchResponse searchResponse = _originalSearchResponse!;
    dynamic result = await DialogHelper.showModalBottomDialogPage<SearchFilterModalDialogPageResponse, SearchFilterModalDialogPageParameter>(
      context: context,
      modalDialogPageBuilder: (context, parameter) => SearchFilterModalDialogPage(
        searchFilterModalDialogPageParameter: parameter!,
      ),
      parameter: SearchFilterModalDialogPageParameter(
        brandSearchRelatedList: searchResponse.brandSearchRelatedList,
        categorySearchRelatedList: searchResponse.categorySearchRelatedList,
        provinceSearchRelatedList: searchResponse.provinceSearchRelatedList,
        lastBrandSearchRelated: _searchFilterModalDialogPageResponse != null ? _searchFilterModalDialogPageResponse!.brandSearchRelated : null,
        lastCategorySearchRelated: _searchFilterModalDialogPageResponse != null ? _searchFilterModalDialogPageResponse!.categorySearchRelated : null,
        lastProvinceSearchRelated: _searchFilterModalDialogPageResponse != null ? _searchFilterModalDialogPageResponse!.provinceSearchRelated : null,
        lastSearchSortBy: _searchFilterModalDialogPageResponse != null ? _searchFilterModalDialogPageResponse!.searchSortBy : null,
        lastPriceMin: _searchFilterModalDialogPageResponse != null ? _searchFilterModalDialogPageResponse!.priceMin : null,
        lastPriceMax: _searchFilterModalDialogPageResponse != null ? _searchFilterModalDialogPageResponse!.priceMax : null,
      )
    );
    if (result is SearchFilterModalDialogPageResponse) {
      _searchFilterModalDialogPageResponse = result.hasFilterResponse ? result : null;
      _search(
        resetFilter: false,
        saveOriginalSearchResponse: false
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    widget.searchController.wishlistAndCartControllerContentDelegate.setWishlistAndCartDelegate(
      Injector.locator<WishlistAndCartDelegateFactory>().generateWishlistAndCartDelegate(
        onGetBuildContext: () => context,
        onGetErrorProvider: () => Injector.locator<ErrorProvider>(),
        onAddToWishlistRequestProcessSuccessCallback: () async => context.read<ComponentNotifier>().updateWishlist(),
        onRemoveFromWishlistRequestProcessSuccessCallback: (wishlist) async => context.read<ComponentNotifier>().updateWishlist(),
        onAddCartRequestProcessSuccessCallback: () async {
          context.read<ComponentNotifier>().updateCart();
          context.read<NotificationNotifier>().loadCartLoadDataResult();
        }
      )
    );
    widget.searchController.setSearchDelegate(
      SearchDelegate(
        onUnfocusAllWidget: () => FocusScope.of(context).unfocus(),
        onSearchBack: () => Get.back(),
        onShowRemoveAllSearchHistoryRequestProcessLoadingCallback: () async => DialogHelper.showLoadingDialog(context),
        onRemoveAllSearchHistoryRequestProcessFailedCallback: (e) async => DialogHelper.showFailedModalBottomDialogFromErrorProvider(
          context: context,
          errorProvider: Injector.locator<ErrorProvider>(),
          e: e
        ),
        onRemoveAllSearchHistoryRequestProcessSuccessCallback: () async {
          if (_searchHistoryResponseLoadDataResult.isSuccess) {
            var searchHistoryResponse = _searchHistoryResponseLoadDataResult.resultIfSuccess!;
            searchHistoryResponse.searchHistoryList.clear();
            setState(() {});
          }
        },
      )
    );
    return WillPopScope(
      onWillPop: () async {
        FocusScope.of(context).unfocus();
        if (_searchStatus == -1) {
          setState(() {
            _searchStatus = 1;
            _beginSearch = false;
          });
          return false;
        }
        return true;
      },
      child: BackgroundAppBarScaffold(
        backgroundAppBarImage: _searchAppBarBackgroundAssetImage,
        appBar: CoreSearchAppBar(
          value: 0.0,
          showFilterIconButton: () {
            if (_searchStatus == 1 && _firstSearchResponseLoadDataResult.isSuccess) {
              return true;
            } else if (_searchStatus == 1 && _firstSearchResponseLoadDataResult.isFailed && _originalSearchResponse != null) {
              return true;
            }
            return false;
          }(),
          onSearch: (search) => _search(),
          onTapSearchFilterIcon: _gotoFilterPage,
          readOnly: _searchStatus == 1,
          searchTextEditingController: _searchTextEditingController,
          filterIconButtonColor: _searchFilterModalDialogPageResponse.hasFilterResponse ? Theme.of(context).colorScheme.primary : null,
          onSearchTextFieldTapped: () async {
            _updateTypingSearchState();
            setState(() => _searchStatus = -1);
            await Future.delayed(const Duration(milliseconds: 50));
            _searchFocusNode.requestFocus();
          },
          searchFocusNode: _searchFocusNode,
        ),
        body: Expanded(
          child: IndexedStack(
            index: () {
              if (_searchStatus < 0) {
                return 0;
              }
              return _searchStatus;
            }(),
            children: [
              _buildModifiedPageListView(
                pagingControllerState: _typingSearchListItemPagingControllerState,
                pullToRefresh: false
              ),
              _buildModifiedPageListView(
                pagingControllerState: _searchListItemPagingControllerState,
                pullToRefresh: true
              ),
            ],
          )
        ),
      ),
    );
  }

  Widget _buildModifiedPageListView({
    required PagingControllerState<int, ListItemControllerState> pagingControllerState,
    required bool pullToRefresh
  }) {
    return ModifiedPagedListView<int, ListItemControllerState>.fromPagingControllerState(
      pagingControllerState: pagingControllerState,
      onProvidePagedChildBuilderDelegate: (pagingControllerState) => ListItemPagingControllerStatePagedChildBuilderDelegate<int>(
        pagingControllerState: pagingControllerState!
      ),
      pullToRefresh: pullToRefresh
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _searchTextEditingController.removeListener(_searchTextEditingListener);
    _searchTextEditingController.dispose();
    super.dispose();
  }
}

extension on SearchFilterModalDialogPageResponse? {
  bool get hasFilterResponse {
    if (this == null) {
      return false;
    }
    int filterCount = 0;
    if (this!.searchSortBy != null) {
      filterCount += 1;
    }
    if (this!.priceMin != null) {
      filterCount += 1;
    }
    if (this!.priceMax != null) {
      filterCount += 1;
    }
    if (this!.brandSearchRelated != null) {
      filterCount += 1;
    }
    if (this!.categorySearchRelated != null) {
      filterCount += 1;
    }
    if (this!.provinceSearchRelated != null) {
      filterCount += 1;
    }
    return filterCount > 0;
  }
}