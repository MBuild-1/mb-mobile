import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';
import 'package:masterbagasi/misc/ext/paging_controller_ext.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';

import '../../../controller/modaldialogcontroller/coupon_tac_modal_dialog_controller.dart';
import '../../../domain/entity/coupon/coupon.dart';
import '../../../domain/entity/coupon/coupon_tac.dart';
import '../../../domain/entity/coupon/coupon_tac_list_parameter.dart';
import '../../../domain/usecase/get_coupon_tac_list_use_case.dart';
import '../../../misc/constant.dart';
import '../../../misc/controllerstate/listitemcontrollerstate/builder_list_item_controller_state.dart';
import '../../../misc/controllerstate/listitemcontrollerstate/compound_list_item_controller_state.dart';
import '../../../misc/controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../../../misc/controllerstate/listitemcontrollerstate/padding_container_list_item_controller_state.dart';
import '../../../misc/controllerstate/listitemcontrollerstate/title_and_description_list_item_controller_state.dart';
import '../../../misc/controllerstate/listitemcontrollerstate/virtual_spacing_list_item_controller_state.dart';
import '../../../misc/controllerstate/listitemcontrollerstate/widget_substitution_list_item_controller_state.dart';
import '../../../misc/controllerstate/paging_controller_state.dart';
import '../../../misc/date_util.dart';
import '../../../misc/injector.dart';
import '../../../misc/load_data_result.dart';
import '../../../misc/paging/modified_paging_controller.dart';
import '../../../misc/paging/pagingcontrollerstatepagedchildbuilderdelegate/list_item_paging_controller_state_paged_child_builder_delegate.dart';
import '../../../misc/paging/pagingresult/paging_data_result.dart';
import '../../../misc/paging/pagingresult/paging_result.dart';
import '../../widget/horizontal_justified_title_and_description.dart';
import '../../widget/modified_paged_list_view.dart';
import '../../widget/modifiedcachednetworkimage/product_modified_cached_network_image.dart';
import 'modal_dialog_page.dart';

class CouponTacModalDialogPage extends ModalDialogPage<CouponTacModalDialogController> {
  CouponTacModalDialogController get couponTacModalDialogController => modalDialogController.controller;

  final Coupon coupon;

  CouponTacModalDialogPage({
    super.key,
    required this.coupon
  });

  @override
  CouponTacModalDialogController onCreateModalDialogController() {
    return CouponTacModalDialogController(
      controllerManager,
      Injector.locator<GetCouponTacListUseCase>()
    );
  }

  @override
  Widget buildPage(BuildContext context) {
    return _StatefulCouponTacModalDialogControllerMediatorWidget(
      couponTacModalDialogController: couponTacModalDialogController,
      coupon: coupon
    );
  }
}

class _StatefulCouponTacModalDialogControllerMediatorWidget extends StatefulWidget {
  final CouponTacModalDialogController couponTacModalDialogController;
  final Coupon coupon;

  const _StatefulCouponTacModalDialogControllerMediatorWidget({
    required this.couponTacModalDialogController,
    required this.coupon
  });

  @override
  State<_StatefulCouponTacModalDialogControllerMediatorWidget> createState() => _StatefulCouponTacModalDialogControllerMediatorWidgetState();
}

class _StatefulCouponTacModalDialogControllerMediatorWidgetState extends State<_StatefulCouponTacModalDialogControllerMediatorWidget> {
  late final ScrollController _couponTacScrollController;
  late final ModifiedPagingController<int, ListItemControllerState> _couponTacPagingController;
  late final PagingControllerState<int, ListItemControllerState> _couponTacPagingControllerState;

  @override
  void initState() {
    super.initState();
    _couponTacScrollController = ScrollController();
    _couponTacPagingController = ModifiedPagingController<int, ListItemControllerState>(
      firstPageKey: 1,
      // ignore: invalid_use_of_protected_member
      apiRequestManager: widget.couponTacModalDialogController.apiRequestManager,
    );
    _couponTacPagingControllerState = PagingControllerState(
      pagingController: _couponTacPagingController,
      scrollController: _couponTacScrollController,
      isPagingControllerExist: false
    );
    _couponTacPagingControllerState.pagingController.addPageRequestListenerForLoadDataResult(
      listener: _couponTacListItemPagingControllerStateListener,
      onPageKeyNext: (pageKey) => pageKey + 1
    );
    _couponTacPagingControllerState.isPagingControllerExist = true;
  }

  Future<LoadDataResult<PagingResult<ListItemControllerState>>> _couponTacListItemPagingControllerStateListener(int pageKey) async {
    LoadDataResult<List<CouponTac>> couponTacListLoadDataResult = await widget.couponTacModalDialogController.getCouponTacList(
      CouponTacListParameter(couponId: widget.coupon.id)
    );
    return couponTacListLoadDataResult.map<PagingResult<ListItemControllerState>>((couponTacList) =>
      PagingDataResult<ListItemControllerState>(
        itemList: [
          BuilderListItemControllerState(
            buildListItemControllerState: () => CompoundListItemControllerState(
              listItemControllerState: [
                WidgetSubstitutionListItemControllerState(
                  widgetSubstitution: (BuildContext context, int index) => AspectRatio(
                    aspectRatio: Constant.aspectRatioValueCouponBanner.toDouble(),
                    child: ClipRRect(
                      child: ProductModifiedCachedNetworkImage(
                        imageUrl: widget.coupon.bannerMobile.isNotEmptyString ? widget.coupon.bannerMobile! : widget.coupon.bannerDesktop.toEmptyStringNonNull,
                      )
                    )
                  )
                ),
                VirtualSpacingListItemControllerState(height: 12),
                WidgetSubstitutionListItemControllerState(
                  widgetSubstitution: (BuildContext context, int index) => Column(
                    children: [
                      Text(
                        widget.coupon.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 10.0),
                      HorizontalJustifiedTitleAndDescription(
                        title: "Expired Date".tr,
                        description: "${DateUtil.standardDateFormat7.format(widget.coupon.startPeriod)} - ${DateUtil.standardDateFormat7.format(widget.coupon.endPeriod)}",
                        titleWidgetInterceptor: (title, widget) => Text(
                          title.toStringNonNull,
                        ),
                        descriptionWidgetInterceptor: (description, widget) => Text(
                          description.toStringNonNull,
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      HorizontalJustifiedTitleAndDescription(
                        title: "Transaction Maximal".tr,
                        description: "${widget.coupon.quota}x",
                        titleWidgetInterceptor: (title, widget) => Text(
                          title.toStringNonNull,
                        ),
                        descriptionWidgetInterceptor: (description, widget) => Text(
                          description.toStringNonNull,
                        ),
                      ),
                    ],
                  )
                ),
                if (couponTacList.isNotEmpty) ...[
                  VirtualSpacingListItemControllerState(height: 12),
                  CompoundListItemControllerState(
                    listItemControllerState: couponTacList.mapIndexed<ListItemControllerState>(
                      (i, couponTac) => CompoundListItemControllerState(
                        listItemControllerState: [
                          if (i > 0) ...[
                            VirtualSpacingListItemControllerState(height: 5)
                          ],
                          WidgetSubstitutionListItemControllerState(
                            widgetSubstitution: (BuildContext context, int index) => Row(
                              children: [
                                SizedBox(
                                  width: 26.0,
                                  child: Text("${(i + 1)}.")
                                ),
                                Expanded(
                                  child: Text(couponTac.text)
                                )
                              ],
                            )
                          ),
                        ]
                      )
                    ).toList()
                  ),
                ]
              ]
            )
          )
        ],
        page: 1,
        totalPage: 1,
        totalItem: 1
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          child: ModifiedPagedListView<int, ListItemControllerState>.fromPagingControllerState(
            padding: EdgeInsets.all(Constant.paddingListItem),
            pagingControllerState: _couponTacPagingControllerState,
            onProvidePagedChildBuilderDelegate: (pagingControllerState) => ListItemPagingControllerStatePagedChildBuilderDelegate<int>(
              pagingControllerState: pagingControllerState!
            ),
            shrinkWrap: true,
          )
        )
      ]
    );
  }

  @override
  void dispose() {
    _couponTacPagingController.dispose();
    _couponTacScrollController.dispose();
    super.dispose();
  }
}