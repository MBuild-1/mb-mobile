import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';
import 'package:masterbagasi/misc/ext/paging_controller_ext.dart';

import '../../controller/country_delivery_review_controller.dart';
import '../../domain/entity/delivery/country_delivery_review.dart';
import '../../domain/entity/delivery/country_delivery_review_paging_parameter.dart';
import '../../domain/usecase/get_country_delivery_review_media_paging_use_case.dart';
import '../../domain/usecase/get_country_delivery_review_paging_use_case.dart';
import '../../misc/constant.dart';
import '../../misc/controllerstate/listitemcontrollerstate/countrydeliveryreviewlistitemcontrollerstate/country_delivery_review_container_list_item_controller_state.dart';
import '../../misc/controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../../misc/controllerstate/listitemcontrollerstate/load_data_result_dynamic_list_item_controller_state.dart';
import '../../misc/controllerstate/paging_controller_state.dart';
import '../../misc/entityandlistitemcontrollerstatemediator/horizontal_component_entity_parameterized_entity_and_list_item_controller_state_mediator.dart';
import '../../misc/error/message_error.dart';
import '../../misc/errorprovider/error_provider.dart';
import '../../misc/getextended/get_extended.dart';
import '../../misc/getextended/get_restorable_route_future.dart';
import '../../misc/injector.dart';
import '../../misc/list_item_controller_state_helper.dart';
import '../../misc/load_data_result.dart';
import '../../misc/manager/controller_manager.dart';
import '../../misc/paging/modified_paging_controller.dart';
import '../../misc/paging/pagingcontrollerstatepagedchildbuilderdelegate/list_item_paging_controller_state_paged_child_builder_delegate.dart';
import '../../misc/paging/pagingresult/paging_data_result.dart';
import '../../misc/paging/pagingresult/paging_result.dart';
import '../../misc/parameterizedcomponententityandlistitemcontrollerstatemediatorparameter/horizontal_dynamic_item_carousel_parametered_component_entity_and_list_item_controller_state_mediator_parameter.dart';
import '../widget/background_app_bar_scaffold.dart';
import '../widget/button/custombutton/sized_outline_gradient_button.dart';
import '../widget/modified_paged_list_view.dart';
import '../widget/modifiedappbar/main_menu_search_app_bar.dart';
import 'getx_page.dart';

class CountryDeliveryReviewPage extends RestorableGetxPage<_CountryDeliveryReviewPageRestoration> {
  final String countryId;

  late final ControllerMember<CountryDeliveryReviewController> _countryDeliveryReviewController = ControllerMember<CountryDeliveryReviewController>().addToControllerManager(controllerManager);

  CountryDeliveryReviewPage({
    Key? key,
    required this.countryId
  }) : super(
    key: key,
    pageRestorationId: () => "country-delivery-review-page"
  );

  @override
  void onSetController() {
    _countryDeliveryReviewController.controller = GetExtended.put<CountryDeliveryReviewController>(
      CountryDeliveryReviewController(
        controllerManager,
        Injector.locator<GetCountryDeliveryReviewPagingUseCase>(),
        Injector.locator<GetCountryDeliveryReviewMediaPagingUseCase>()
      ),
      tag: pageName
    );
  }

  @override
  _CountryDeliveryReviewPageRestoration createPageRestoration() => _CountryDeliveryReviewPageRestoration();

  @override
  Widget buildPage(BuildContext context) {
    return _StatefulCountryDeliveryReviewControllerMediatorWidget(
      countryDeliveryReviewController: _countryDeliveryReviewController.controller,
      countryId: countryId,
    );
  }
}

class _CountryDeliveryReviewPageRestoration extends MixableGetxPageRestoration with CountryDeliveryReviewPageRestorationMixin {
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

class CountryDeliveryReviewPageGetPageBuilderAssistant extends GetPageBuilderAssistant {
  final String countryId;

  CountryDeliveryReviewPageGetPageBuilderAssistant({
    required this.countryId
  });

  @override
  GetPageBuilder get pageBuilder => (() => CountryDeliveryReviewPage(
    countryId: countryId
  ));

  @override
  GetPageBuilder get pageWithOuterGetxBuilder => (() => GetxPageBuilder.buildRestorableGetxPage(
    CountryDeliveryReviewPage(
      countryId: countryId
    )
  ));
}

mixin CountryDeliveryReviewPageRestorationMixin on MixableGetxPageRestoration {
  late CountryDeliveryReviewPageRestorableRouteFuture countryDeliveryReviewPageRestorableRouteFuture;

  @override
  void initState() {
    super.initState();
    countryDeliveryReviewPageRestorableRouteFuture = CountryDeliveryReviewPageRestorableRouteFuture(
      restorationId: restorationIdWithPageName('country-delivery-review-route')
    );
  }

  @override
  void restoreState(Restorator restorator, RestorationBucket? oldBucket, bool initialRestore) {
    super.restoreState(restorator, oldBucket, initialRestore);
    countryDeliveryReviewPageRestorableRouteFuture.restoreState(restorator, oldBucket, initialRestore);
  }

  @override
  void dispose() {
    super.dispose();
    countryDeliveryReviewPageRestorableRouteFuture.dispose();
  }
}

class CountryDeliveryReviewPageRestorableRouteFuture extends GetRestorableRouteFuture {
  late RestorableRouteFuture<void> _pageRoute;

  CountryDeliveryReviewPageRestorableRouteFuture({
    required String restorationId
  }) : super(restorationId: restorationId) {
    _pageRoute = RestorableRouteFuture<void>(
      onPresent: (NavigatorState navigator, Object? arguments) {
        return navigator.restorablePush(_pageRouteBuilder, arguments: arguments);
      }
    );
  }

  static Route<void>? _getRoute([Object? arguments]) {
    if (arguments is! String) {
      throw MessageError(message: "Arguments must be a String");
    }
    return GetExtended.toWithGetPageRouteReturnValue<String?>(
      GetxPageBuilder.buildRestorableGetxPageBuilder(
        CountryDeliveryReviewPageGetPageBuilderAssistant(
          countryId: arguments
        )
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

class _StatefulCountryDeliveryReviewControllerMediatorWidget extends StatefulWidget {
  final CountryDeliveryReviewController countryDeliveryReviewController;
  final String countryId;

  const _StatefulCountryDeliveryReviewControllerMediatorWidget({
    required this.countryDeliveryReviewController,
    required this.countryId
  });

  @override
  State<_StatefulCountryDeliveryReviewControllerMediatorWidget> createState() => _StatefulCountryDeliveryReviewControllerMediatorWidgetState();
}

class _StatefulCountryDeliveryReviewControllerMediatorWidgetState extends State<_StatefulCountryDeliveryReviewControllerMediatorWidget> {
  late AssetImage _countryDeliveryReviewAppBarBackgroundAssetImage;
  late final ModifiedPagingController<int, ListItemControllerState> _countryDeliveryReviewListItemPagingController;
  late final PagingControllerState<int, ListItemControllerState> _countryDeliveryReviewListItemPagingControllerState;
  final List<BaseLoadDataResultDynamicListItemControllerState> _dynamicItemLoadDataResultDynamicListItemControllerStateList = [];

  @override
  void initState() {
    super.initState();
    _countryDeliveryReviewAppBarBackgroundAssetImage = AssetImage(Constant.imagePatternFeedMainMenuAppBar);
    _countryDeliveryReviewListItemPagingController = ModifiedPagingController<int, ListItemControllerState>(
      firstPageKey: 1,
      // ignore: invalid_use_of_protected_member
      apiRequestManager: widget.countryDeliveryReviewController.apiRequestManager,
    );
    _countryDeliveryReviewListItemPagingControllerState = PagingControllerState(
      pagingController: _countryDeliveryReviewListItemPagingController,
      isPagingControllerExist: false
    );
    _countryDeliveryReviewListItemPagingControllerState.pagingController.addPageRequestListenerWithItemListForLoadDataResult(
      listener: _countryDeliveryReviewListItemPagingControllerStateListener,
      onPageKeyNext: (pageKey) => pageKey + 1
    );
    _countryDeliveryReviewListItemPagingControllerState.isPagingControllerExist = true;
  }

  @override
  void didChangeDependencies() {
    precacheImage(_countryDeliveryReviewAppBarBackgroundAssetImage, context);
    super.didChangeDependencies();
  }

  Future<LoadDataResult<PagingResult<ListItemControllerState>>> _countryDeliveryReviewListItemPagingControllerStateListener(int pageKey, List<ListItemControllerState>? listItemControllerStateList) async {
    HorizontalComponentEntityParameterizedEntityAndListItemControllerStateMediator componentEntityMediator = Injector.locator<HorizontalComponentEntityParameterizedEntityAndListItemControllerStateMediator>();
    HorizontalDynamicItemCarouselParameterizedEntityAndListItemControllerStateMediatorParameter carouselParameterizedEntityMediator = HorizontalDynamicItemCarouselParameterizedEntityAndListItemControllerStateMediatorParameter(
      onSetState: () => setState(() {}),
      dynamicItemLoadDataResultDynamicListItemControllerStateList: _dynamicItemLoadDataResultDynamicListItemControllerStateList
    );
    _dynamicItemLoadDataResultDynamicListItemControllerStateList.clear();
    LoadDataResult<PagingDataResult<CountryDeliveryReview>> countryDeliveryReviewLoadDataResult = await widget.countryDeliveryReviewController.getCountryDeliveryReview(
      CountryDeliveryReviewPagingParameter(
        page: pageKey
      )
    );
    return countryDeliveryReviewLoadDataResult.map<PagingResult<ListItemControllerState>>((countryDeliveryReviewPaging) {
      List<ListItemControllerState> resultListItemControllerState = [];
      int totalItem = countryDeliveryReviewPaging.totalItem;
      if (pageKey == 1) {
        totalItem = 1;
        resultListItemControllerState = [
          CountryDeliveryReviewContainerListItemControllerState(
            countryDeliveryReviewList: countryDeliveryReviewPaging.itemList,
            onUpdateState: () => setState(() {}),
            errorProvider: Injector.locator<ErrorProvider>(),
            getCountryDeliveryReviewHeaderListItemControllerState: () => componentEntityMediator.mapWithParameter(
              widget.countryDeliveryReviewController.getCountryDeliveryReviewHeader(),
              parameter: carouselParameterizedEntityMediator
            ),
            getCountryDeliveryReviewMediaShortContentListItemControllerState: () => componentEntityMediator.mapWithParameter(
              widget.countryDeliveryReviewController.getCountryDeliveryReviewMediaShortContent(),
              parameter: carouselParameterizedEntityMediator
            ),
          )
        ];
      } else {
        if (ListItemControllerStateHelper.checkListItemControllerStateList(listItemControllerStateList)) {
          CountryDeliveryReviewContainerListItemControllerState countryDeliveryReviewContainerListItemControllerState = ListItemControllerStateHelper.parsePageKeyedListItemControllerState(listItemControllerStateList![0]) as CountryDeliveryReviewContainerListItemControllerState;
          countryDeliveryReviewContainerListItemControllerState.countryDeliveryReviewList.addAll(countryDeliveryReviewPaging.itemList);
        }
      }
      return PagingDataResult<ListItemControllerState>(
        itemList: resultListItemControllerState,
        page: countryDeliveryReviewPaging.page,
        totalPage: countryDeliveryReviewPaging.totalPage,
        totalItem: totalItem
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundAppBarScaffold(
      backgroundAppBarImage: _countryDeliveryReviewAppBarBackgroundAssetImage,
      appBar: MainMenuSearchAppBar(value: 0.0),
      body: Expanded(
        child: ModifiedPagedListView<int, ListItemControllerState>.fromPagingControllerState(
          pagingControllerState: _countryDeliveryReviewListItemPagingControllerState,
          onProvidePagedChildBuilderDelegate: (pagingControllerState) => ListItemPagingControllerStatePagedChildBuilderDelegate<int>(
            pagingControllerState: pagingControllerState!
          ),
          pullToRefresh: true
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}