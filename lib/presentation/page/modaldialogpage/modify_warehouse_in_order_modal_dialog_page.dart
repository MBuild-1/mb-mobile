import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/paging_controller_ext.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';
import 'package:masterbagasi/misc/ext/validation_result_ext.dart';
import 'package:sizer/sizer.dart';

import '../../../controller/modaldialogcontroller/modify_warehouse_in_order_modal_dialog_controller.dart';
import '../../../domain/entity/additionalitem/additional_item.dart';
import '../../../domain/entity/order/modifywarehouseinorder/modifywarehouseinorderitem/optional_fields_warehouse_in_order_item.dart';
import '../../../domain/entity/order/modifywarehouseinorder/modifywarehouseinorderparameter/add_warehouse_in_order_parameter.dart';
import '../../../domain/entity/order/modifywarehouseinorder/modifywarehouseinorderparameter/change_warehouse_in_order_parameter.dart';
import '../../../domain/entity/order/modifywarehouseinorder/modifywarehouseinorderparameter/modify_warehouse_in_order_parameter.dart';
import '../../../domain/entity/order/modifywarehouseinorder/modifywarehouseinorderresponse/modify_warehouse_in_order_response.dart';
import '../../../misc/constant.dart';
import '../../../misc/controllerstate/listitemcontrollerstate/additionalitemlistitemcontrollerstate/additional_item_list_item_controller_state.dart';
import '../../../misc/controllerstate/listitemcontrollerstate/additionalitemlistitemcontrollerstate/additional_item_summary_list_item_controller_state.dart';
import '../../../misc/controllerstate/listitemcontrollerstate/builder_list_item_controller_state.dart';
import '../../../misc/controllerstate/listitemcontrollerstate/compound_list_item_controller_state.dart';
import '../../../misc/controllerstate/listitemcontrollerstate/divider_list_item_controller_state.dart';
import '../../../misc/controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../../../misc/controllerstate/listitemcontrollerstate/modifywarehouselistitemcontrollerstate/modify_warehouse_container_list_item_controller_state.dart';
import '../../../misc/controllerstate/listitemcontrollerstate/padding_container_list_item_controller_state.dart';
import '../../../misc/controllerstate/listitemcontrollerstate/virtual_spacing_list_item_controller_state.dart';
import '../../../misc/controllerstate/listitemcontrollerstate/widget_substitution_list_item_controller_state.dart';
import '../../../misc/controllerstate/paging_controller_state.dart';
import '../../../misc/dialog_helper.dart';
import '../../../misc/errorprovider/error_provider.dart';
import '../../../misc/injector.dart';
import '../../../misc/inputdecoration/default_input_decoration.dart';
import '../../../misc/load_data_result.dart';
import '../../../misc/multi_language_string.dart';
import '../../../misc/paging/modified_paging_controller.dart';
import '../../../misc/paging/pagingcontrollerstatepagedchildbuilderdelegate/list_item_paging_controller_state_paged_child_builder_delegate.dart';
import '../../../misc/paging/pagingresult/paging_data_result.dart';
import '../../../misc/paging/pagingresult/paging_result.dart';
import '../../../misc/validation/validator/validator.dart';
import '../../widget/button/custombutton/sized_outline_gradient_button.dart';
import '../../widget/field.dart';
import '../../widget/modified_paged_list_view.dart';
import '../../widget/modified_text_field.dart';
import '../../widget/rx_consumer.dart';
import 'modal_dialog_page.dart';

class ModifyWarehouseInOrderModalDialogPage extends ModalDialogPage<ModifyWarehouseInOrderModalDialogController> {
  ModifyWarehouseInOrderModalDialogController get modifyWarehouseInOrderModalDialogController => modalDialogController.controller;

  final ModifyWarehouseInOrderModalDialogPageParameter modifyWarehouseInOrderModalDialogPageParameter;

  ModifyWarehouseInOrderModalDialogPage({
    Key? key,
    required this.modifyWarehouseInOrderModalDialogPageParameter
  }) : super(key: key);

  @override
  ModifyWarehouseInOrderModalDialogController onCreateModalDialogController() {
    return ModifyWarehouseInOrderModalDialogController(
      controllerManager
    );
  }

  @override
  Widget buildPage(BuildContext context) {
    return _StatefulModifyWarehouseInOrderControllerMediatorWidget(
      modifyWarehouseInOrderModalDialogController: modifyWarehouseInOrderModalDialogController,
      modifyWarehouseInOrderModalDialogPageParameter: modifyWarehouseInOrderModalDialogPageParameter
    );
  }
}

class _StatefulModifyWarehouseInOrderControllerMediatorWidget extends StatefulWidget {
  final ModifyWarehouseInOrderModalDialogController modifyWarehouseInOrderModalDialogController;
  final ModifyWarehouseInOrderModalDialogPageParameter modifyWarehouseInOrderModalDialogPageParameter;

  const _StatefulModifyWarehouseInOrderControllerMediatorWidget({
    required this.modifyWarehouseInOrderModalDialogController,
    required this.modifyWarehouseInOrderModalDialogPageParameter
  });

  @override
  State<_StatefulModifyWarehouseInOrderControllerMediatorWidget> createState() => _StatefulModifyWarehouseInOrderControllerMediatorWidgetState();
}

class _StatefulModifyWarehouseInOrderControllerMediatorWidgetState extends State<_StatefulModifyWarehouseInOrderControllerMediatorWidget> {
  final TextEditingController _nameTextEditingController = TextEditingController();
  final TextEditingController _priceTextEditingController = TextEditingController();
  final TextEditingController _weightTextEditingController = TextEditingController();
  final TextEditingController _quantityTextEditingController = TextEditingController();
  final TextEditingController _notesTextEditingController = TextEditingController();

  late final ScrollController _modifyWarehouseInOrderScrollController;
  late final ModifiedPagingController<int, ListItemControllerState> _modifyWarehouseInOrderListItemPagingController;
  late final PagingControllerState<int, ListItemControllerState> _modifyWarehouseInOrderListItemPagingControllerState;

  final List<AdditionalItem> _additionalItemList = [];
  ModifyWarehouseInOrderParameter? _localModifyWarehouseInOrderParameter;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    var modifyWarehouseInOrderParameter = widget.modifyWarehouseInOrderModalDialogPageParameter.modifyWarehouseInOrderParameter;
    if (modifyWarehouseInOrderParameter is ChangeWarehouseInOrderParameter) {
      OptionalFieldsWarehouseInOrderItem optionalFieldsWarehouseInOrderItem = modifyWarehouseInOrderParameter.optionalFieldsWarehouseInOrderItem;
      _nameTextEditingController.text = optionalFieldsWarehouseInOrderItem.name.toEmptyStringNonNull;
      _priceTextEditingController.text = optionalFieldsWarehouseInOrderItem.price != null ? optionalFieldsWarehouseInOrderItem.price!.toString() : "";
      _weightTextEditingController.text = optionalFieldsWarehouseInOrderItem.weight != null ? optionalFieldsWarehouseInOrderItem.weight!.toString() : "";
      _quantityTextEditingController.text = optionalFieldsWarehouseInOrderItem.quantity != null ? optionalFieldsWarehouseInOrderItem.quantity!.toString() : "";
      _notesTextEditingController.text = optionalFieldsWarehouseInOrderItem.notes.toEmptyStringNonNull;
      _index = 1;
    }
    _modifyWarehouseInOrderScrollController = ScrollController();
    _modifyWarehouseInOrderListItemPagingController = ModifiedPagingController<int, ListItemControllerState>(
      firstPageKey: 1,
      // ignore: invalid_use_of_protected_member
      apiRequestManager: widget.modifyWarehouseInOrderModalDialogController.apiRequestManager,
    );
    _modifyWarehouseInOrderListItemPagingControllerState = PagingControllerState(
      pagingController: _modifyWarehouseInOrderListItemPagingController,
      scrollController: _modifyWarehouseInOrderScrollController,
      isPagingControllerExist: false
    );
    _modifyWarehouseInOrderListItemPagingControllerState.pagingController.addPageRequestListenerForLoadDataResult(
      listener: _modifyWarehouseInOrderListItemPagingControllerStateListener,
      onPageKeyNext: (pageKey) => pageKey + 1
    );
    _modifyWarehouseInOrderListItemPagingControllerState.isPagingControllerExist = true;
  }

  Future<LoadDataResult<PagingResult<ListItemControllerState>>> _modifyWarehouseInOrderListItemPagingControllerStateListener(int pageKey) async {
    return SuccessLoadDataResult<PagingResult<ListItemControllerState>>(
      value: PagingDataResult<ListItemControllerState>(
        page: 1,
        totalPage: 1,
        totalItem: 1,
        itemList: [
          ModifyWarehouseContainerListItemControllerState(
            additionalItemList: _additionalItemList,
            onGotoAddWarehouse: () {
              var modifyWarehouseInOrderParameter = widget.modifyWarehouseInOrderModalDialogPageParameter.modifyWarehouseInOrderParameter;
              if (modifyWarehouseInOrderParameter is AddWarehouseInOrderParameter) {
                _nameTextEditingController.text = "";
                _priceTextEditingController.text = "";
                _weightTextEditingController.text = "";
                _quantityTextEditingController.text = "";
                _notesTextEditingController.text = "";
                _index = 1;
                _localModifyWarehouseInOrderParameter = AddWarehouseInOrderParameter(
                  orderProductId: '',
                  allRequiredFieldsWarehouseInOrderItemList: []
                );
              }
              setState(() => _index = 1);
            },
            onGotoEditWarehouse: (additionalItem) {
              var modifyWarehouseInOrderParameter = widget.modifyWarehouseInOrderModalDialogPageParameter.modifyWarehouseInOrderParameter;
              if (modifyWarehouseInOrderParameter is AddWarehouseInOrderParameter) {
                _nameTextEditingController.text = additionalItem.name;
                _priceTextEditingController.text = additionalItem.estimationPrice.toString();
                _weightTextEditingController.text = additionalItem.estimationWeight.toString();
                _quantityTextEditingController.text = additionalItem.quantity.toString();
                _notesTextEditingController.text = additionalItem.notes;
                _index = 1;
                _localModifyWarehouseInOrderParameter = ChangeWarehouseInOrderParameter(
                  orderProductId: '',
                  id: additionalItem.id,
                  optionalFieldsWarehouseInOrderItem: OptionalFieldsWarehouseInOrderItem()
                );
              }
              setState(() => _index = 1);
            },
            onRemoveWarehouse: (additionalItem) => setState(() => _additionalItemList.remove(additionalItem)),
            onSubmitModifyWarehouse: (value) => widget.modifyWarehouseInOrderModalDialogController.submit()
          ),
        ]
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    widget.modifyWarehouseInOrderModalDialogController.setModifyWarehouseInOrderModalDialogDelegate(
      ModifyWarehouseInOrderModalDialogDelegate(
        onUnfocusAllWidget: () => FocusScope.of(context).unfocus(),
        onGetModifyWarehouseInOrderActionFurther: () => ModifyWarehouseInOrderActionFurther._(
          close: () => Get.back(),
          closeWithResult: (modifyWarehouseInOrderResponse) => Get.back(result: modifyWarehouseInOrderResponse),
          showErrorDialog: (e) => DialogHelper.showFailedModalBottomDialogFromErrorProvider(
            context: context,
            errorProvider: Injector.locator<ErrorProvider>(),
            e: e
          ),
        ),
        onGetModifyWarehouseInOrderAction: () => widget.modifyWarehouseInOrderModalDialogPageParameter.modifyWarehouseInOrderAction,
        onGetModifyWarehouseInOrderParameter: () => widget.modifyWarehouseInOrderModalDialogPageParameter.modifyWarehouseInOrderParameter,
        onGetAdditionalItemList: () => _additionalItemList,
        onGetNameInput: () => _nameTextEditingController.text,
        onGetPriceInput: () => _priceTextEditingController.text,
        onGetWeightInput: () => _weightTextEditingController.text,
        onGetQuantityInput: () => _quantityTextEditingController.text,
        onGetNotesInput: () => _notesTextEditingController.text,
        onAddAdditionalItemBack: () async => Get.back(),
      )
    );
    return WillPopScope(
      onWillPop: () async {
        var modifyWarehouseInOrderParameter = widget.modifyWarehouseInOrderModalDialogPageParameter.modifyWarehouseInOrderParameter;
        if (modifyWarehouseInOrderParameter is ChangeWarehouseInOrderParameter) {
          return true;
        }
        if (_index > 0) {
          setState(() => _index--);
          return false;
        } else {
          return true;
        }
      },
      child: Builder(
        builder: (build) {
          if (_index == 0) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: SizedBox(
                    child: ModifiedPagedListView<int, ListItemControllerState>.fromPagingControllerState(
                      padding: EdgeInsets.zero,
                      pagingControllerState: _modifyWarehouseInOrderListItemPagingControllerState,
                      onProvidePagedChildBuilderDelegate: (pagingControllerState) => ListItemPagingControllerStatePagedChildBuilderDelegate<int>(
                        pagingControllerState: pagingControllerState!
                      ),
                      shrinkWrap: true,
                    )
                  ),
                ),
              ]
            );
          } else if (_index == 1) {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IgnorePointer(
                      child: ExcludeFocus(
                        child: SizedOutlineGradientButton(
                          onPressed: () {},
                          text: () {
                            var modifyWarehouseInOrderParameter = widget.modifyWarehouseInOrderModalDialogPageParameter.modifyWarehouseInOrderParameter;
                            if (modifyWarehouseInOrderParameter is AddWarehouseInOrderParameter) {
                              if (_localModifyWarehouseInOrderParameter is AddWarehouseInOrderParameter) {
                                return "Add New Item".tr;
                              } else if (_localModifyWarehouseInOrderParameter is ChangeWarehouseInOrderParameter) {
                                return "Change New Item".tr;
                              }
                              return "Add New Item".tr;
                            } else if (modifyWarehouseInOrderParameter is ChangeWarehouseInOrderParameter) {
                              return "Change New Item".tr;
                            } else {
                              return "";
                            }
                          }(),
                          outlineGradientButtonType: OutlineGradientButtonType.outline,
                          outlineGradientButtonVariation: OutlineGradientButtonVariation.variation1,
                          customGradientButtonVariation: (outlineGradientButtonType) {
                            return CustomGradientButtonVariation(
                              outlineGradientButtonType: outlineGradientButtonType,
                              textStyle: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold
                              )
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text("Name".tr),
                    const SizedBox(height: 10),
                    RxConsumer<Validator>(
                      rxValue: widget.modifyWarehouseInOrderModalDialogController.nameValidatorRx,
                      onConsumeValue: (context, value) => Field(
                        child: (context, validationResult, validator) => ModifiedTextField(
                          isError: validationResult.isFailed,
                          controller: _nameTextEditingController,
                          decoration: const DefaultInputDecoration(hintText: ""),
                          onChanged: (value) => validator?.validate(),
                          textInputAction: TextInputAction.next,
                        ),
                        validator: value,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text("Price".tr),
                    const SizedBox(height: 10),
                    RxConsumer<Validator>(
                      rxValue: widget.modifyWarehouseInOrderModalDialogController.priceValidatorRx,
                      onConsumeValue: (context, value) => Field(
                        child: (context, validationResult, validator) => ModifiedTextField(
                          isError: validationResult.isFailed,
                          controller: _priceTextEditingController,
                          decoration: const DefaultInputDecoration(hintText: ""),
                          onChanged: (value) => validator?.validate(),
                          textInputAction: TextInputAction.next,
                        ),
                        validator: value,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text("Weight".tr),
                    const SizedBox(height: 10),
                    RxConsumer<Validator>(
                      rxValue: widget.modifyWarehouseInOrderModalDialogController.weightValidatorRx,
                      onConsumeValue: (context, value) => Field(
                        child: (context, validationResult, validator) => ModifiedTextField(
                          isError: validationResult.isFailed,
                          controller: _weightTextEditingController,
                          decoration: const DefaultInputDecoration(hintText: ""),
                          onChanged: (value) => validator?.validate(),
                          textInputAction: TextInputAction.next,
                        ),
                        validator: value,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text("Quantity".tr),
                    const SizedBox(height: 10),
                    RxConsumer<Validator>(
                      rxValue: widget.modifyWarehouseInOrderModalDialogController.quantityValidatorRx,
                      onConsumeValue: (context, value) => Field(
                        child: (context, validationResult, validator) => ModifiedTextField(
                          isError: validationResult.isFailed,
                          controller: _quantityTextEditingController,
                          decoration: const DefaultInputDecoration(hintText: ""),
                          onChanged: (value) => validator?.validate(),
                          textInputAction: TextInputAction.next,
                        ),
                        validator: value,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text("Note".tr),
                    const SizedBox(height: 10),
                    RxConsumer<Validator>(
                      rxValue: widget.modifyWarehouseInOrderModalDialogController.notesValidatorRx,
                      onConsumeValue: (context, value) => Field(
                        child: (context, validationResult, validator) => ModifiedTextField(
                          isError: validationResult.isFailed,
                          controller: _notesTextEditingController,
                          decoration: const DefaultInputDecoration(hintText: ""),
                          onChanged: (value) => validator?.validate(),
                          textInputAction: TextInputAction.next,
                        ),
                        validator: value,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedOutlineGradientButton(
                      onPressed: () async {
                        var modifyWarehouseInOrderParameter = widget.modifyWarehouseInOrderModalDialogPageParameter.modifyWarehouseInOrderParameter;
                        if (modifyWarehouseInOrderParameter is ChangeWarehouseInOrderParameter) {
                          widget.modifyWarehouseInOrderModalDialogController.submit();
                        } else if (modifyWarehouseInOrderParameter is AddWarehouseInOrderParameter) {
                          if (widget.modifyWarehouseInOrderModalDialogController.modifyWarehouseInOrderValidatorGroup.validate()) {
                            if (_localModifyWarehouseInOrderParameter is AddWarehouseInOrderParameter) {
                              _additionalItemList.add(
                                AdditionalItem(
                                  id: "",
                                  name: _nameTextEditingController.text,
                                  estimationPrice: double.parse(_priceTextEditingController.text),
                                  estimationWeight: double.parse(_weightTextEditingController.text),
                                  quantity: int.parse(_quantityTextEditingController.text),
                                  notes: _notesTextEditingController.text
                                )
                              );
                              _additionalItemList.forEachIndexed(
                                (index, additionalItem) => additionalItem.id = (index + 1).toString()
                              );
                            } else if (_localModifyWarehouseInOrderParameter is ChangeWarehouseInOrderParameter) {
                              ChangeWarehouseInOrderParameter changeWarehouseInOrderParameter = _localModifyWarehouseInOrderParameter as ChangeWarehouseInOrderParameter;
                              Iterable<AdditionalItem> additionalItemIterable = _additionalItemList.where(
                                (additionalItem) => additionalItem.id == changeWarehouseInOrderParameter.id
                              );
                              if (additionalItemIterable.isNotEmpty) {
                                AdditionalItem willBeEditAdditionalItem = additionalItemIterable.first;
                                willBeEditAdditionalItem.name = _nameTextEditingController.text;
                                willBeEditAdditionalItem.estimationPrice = double.parse(_priceTextEditingController.text);
                                willBeEditAdditionalItem.estimationWeight = double.parse(_weightTextEditingController.text);
                                willBeEditAdditionalItem.quantity = int.parse(_quantityTextEditingController.text);
                                willBeEditAdditionalItem.notes = _notesTextEditingController.text;
                              }
                              _additionalItemList.forEachIndexed(
                                (index, additionalItem) => additionalItem.id = (index + 1).toString()
                              );
                            }
                            setState(() => _index = 0);
                          }
                        }
                      },
                      text: "Submit".tr,
                      outlineGradientButtonType: OutlineGradientButtonType.solid,
                      outlineGradientButtonVariation: OutlineGradientButtonVariation.variation2,
                    ),
                  ]
                )
              )
            );
          }
          return Container();
        }
      ),
    );
  }

  @override
  void dispose() {
    _nameTextEditingController.dispose();
    _priceTextEditingController.dispose();
    _weightTextEditingController.dispose();
    _quantityTextEditingController.dispose();
    _notesTextEditingController.dispose();
    super.dispose();
  }
}

class ModifyWarehouseInOrderModalDialogPageParameter {
  final ModifyWarehouseInOrderParameter modifyWarehouseInOrderParameter;
  final ModifyWarehouseInOrderAction modifyWarehouseInOrderAction;

  const ModifyWarehouseInOrderModalDialogPageParameter({
    required this.modifyWarehouseInOrderParameter,
    required this.modifyWarehouseInOrderAction,
  });
}

class ModifyWarehouseInOrderAction {
  final void Function(ModifyWarehouseInOrderParameter, ModifyWarehouseInOrderActionFurther) _submitModifyWarehouse;

  ModifyWarehouseInOrderAction({
    required void Function(ModifyWarehouseInOrderParameter, ModifyWarehouseInOrderActionFurther) submitModifyWarehouse
  }) : _submitModifyWarehouse = submitModifyWarehouse;

  void Function(ModifyWarehouseInOrderParameter, ModifyWarehouseInOrderActionFurther) get submitModifyWarehouse => _submitModifyWarehouse;
}

class ModifyWarehouseInOrderActionFurther {
  final void Function() _close;
  final void Function(ModifyWarehouseInOrderResponse) _closeWithResult;
  final void Function(Exception) _showErrorDialog;

  ModifyWarehouseInOrderActionFurther._({
    required void Function() close,
    required void Function(ModifyWarehouseInOrderResponse) closeWithResult,
    required void Function(Exception) showErrorDialog
  }) : _close = close,
      _closeWithResult = closeWithResult,
      _showErrorDialog = showErrorDialog;

  void Function() get close => _close;
  void Function(ModifyWarehouseInOrderResponse) get closeWithResult => _closeWithResult;
  void Function(Exception) get showErrorDialog => _showErrorDialog;
}