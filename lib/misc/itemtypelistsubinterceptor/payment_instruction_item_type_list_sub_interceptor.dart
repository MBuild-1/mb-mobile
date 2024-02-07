import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:masterbagasi/data/entitymappingext/payment_entity_mapping_ext.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';

import '../../domain/entity/payment/paymentinstruction/payment_instruction_group.dart';
import '../../domain/entity/payment/paymentinstruction/paymentinstructiontransactionsummary/payment_instruction_transaction_summary.dart';
import '../../domain/entity/summaryvalue/summary_value.dart';
import '../../presentation/widget/transaction_summary_widget.dart';
import '../constant.dart';
import '../controllerstate/listitemcontrollerstate/builder_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/compound_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/divider_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/load_data_result_dynamic_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/padding_container_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/paymentinstructionlistitemcontrollerstate/payment_instruction_container_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/paymentinstructionlistitemcontrollerstate/payment_instruction_content_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/paymentinstructionlistitemcontrollerstate/payment_instruction_divided_container_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/paymentinstructionlistitemcontrollerstate/payment_instruction_header_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/spacing_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/virtual_spacing_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/widget_substitution_list_item_controller_state.dart';
import '../itemtypelistinterceptor/itemtypelistinterceptorchecker/list_item_controller_state_item_type_list_interceptor_checker.dart';
import '../response_wrapper.dart';
import '../typedef.dart';
import 'item_type_list_sub_interceptor.dart';

class PaymentInstructionItemTypeListSubInterceptor extends ItemTypeListSubInterceptor<ListItemControllerState> {
  final DoubleReturned padding;
  final DoubleReturned itemSpacing;
  final ListItemControllerStateItemTypeInterceptorChecker listItemControllerStateItemTypeInterceptorChecker;

  PaymentInstructionItemTypeListSubInterceptor({
    required this.padding,
    required this.itemSpacing,
    required this.listItemControllerStateItemTypeInterceptorChecker
  });

  @override
  bool intercept(
    int i,
    ListItemControllerStateWrapper oldItemTypeWrapper,
    List<ListItemControllerState> oldItemTypeList,
    List<ListItemControllerState> newItemTypeList
  ) {
    ListItemControllerState oldItemType = oldItemTypeWrapper.listItemControllerState;
    if (oldItemType is PaymentInstructionContainerListItemControllerState) {
      List<ListItemControllerState> newListItemControllerState = [];
      newListItemControllerState.add(SpacingListItemControllerState());
      PaymentInstructionResponseStateValue paymentInstructionResponseStateValue = oldItemType.paymentInstructionResponseStateValue();
      _interceptForOrderPayment(i, paymentInstructionResponseStateValue.paymentInstructionTransactionSummary, oldItemTypeList, newListItemControllerState);
      newListItemControllerState.add(SpacingListItemControllerState());
      _interceptForPaymentInstruction(
        i,
        oldItemType.paymentInstructionResponseStateValue().paymentInstructionGroupStateValueList,
        oldItemType.onUpdateState,
        oldItemTypeList,
        newListItemControllerState
      );
      newItemTypeList.addAll(newListItemControllerState);
      return true;
    } else if (oldItemType is PaymentInstructionDividedContainerListItemControllerState) {
      List<ListItemControllerState> newListItemControllerState = [];
      ListItemControllerState paymentInstructionTransactionSummaryListItemControllerState = LoadDataResultDynamicListItemControllerState(
        loadDataResult: oldItemType.paymentInstructionTransactionSummaryLoadDataResult(),
        errorProvider: oldItemType.onGetErrorProvider(),
        isLoadingListItemControllerState: (listItemControllerState) {
          return CompoundListItemControllerState(
            listItemControllerState: [
              listItemControllerState,
              VirtualSpacingListItemControllerState(
                height: padding()
              )
            ]
          );
        },
        failedListItemControllerState: (errorProvider, e, listItemControllerState) {
          return CompoundListItemControllerState(
            listItemControllerState: [
              listItemControllerState,
              VirtualSpacingListItemControllerState(
                height: 8
              )
            ]
          );
        },
        successListItemControllerState: (paymentInstructionTransactionSummary) {
          List<ListItemControllerState> newPaymentInstructionTransactionSummaryListItemControllerState = [];
          List<SummaryValue> summaryValueList = paymentInstructionTransactionSummary.paymentInstructionTransactionSummaryValueList;
          List<SummaryValue> tempSummaryValueList = [];
          int j = 0;
          void addPaymentInstructionTransactionSummary() {
            _interceptForOrderPayment(
              i,
              PaymentInstructionTransactionSummary(
                paymentInstructionTransactionSummaryValueList: tempSummaryValueList
              ),
              oldItemTypeList,
              newPaymentInstructionTransactionSummaryListItemControllerState
            );
          }
          while (j < summaryValueList.length) {
            SummaryValue summaryValue = summaryValueList[j];
            if (summaryValue.type == "payment_instruction") {
              List<PaymentInstructionGroupStateValue> paymentInstructionGroupStateValueList = [];
              var paymentInstructionContainerStorageListItemControllerState = oldItemType.paymentInstructionContainerStorageListItemControllerState;
              if (paymentInstructionContainerStorageListItemControllerState is DefaultPaymentInstructionContainerStorageListItemControllerState) {
                paymentInstructionContainerStorageListItemControllerState._paymentInstructionGroupStateValueList ??= ResponseWrapper(summaryValue.value)
                  .mapFromResponseToPaymentInstructionGroupList()
                  .map<PaymentInstructionGroupStateValue>((paymentInstructionGroup) {
                    return PaymentInstructionGroupStateValue(
                      paymentInstructionGroup: paymentInstructionGroup,
                      isExpanded: true
                    );
                  })
                  .toList();
                paymentInstructionGroupStateValueList = paymentInstructionContainerStorageListItemControllerState._paymentInstructionGroupStateValueList ?? [];
              }
              addPaymentInstructionTransactionSummary();
              newPaymentInstructionTransactionSummaryListItemControllerState.add(SpacingListItemControllerState());
              _interceptForPaymentInstruction(
                i,
                paymentInstructionGroupStateValueList,
                oldItemType.onUpdateState,
                oldItemTypeList,
                newPaymentInstructionTransactionSummaryListItemControllerState
              );
            } else {
              tempSummaryValueList.add(summaryValue);
              if (j == summaryValueList.length - 1) {
                addPaymentInstructionTransactionSummary();
              }
            }
            j++;
          }
          return CompoundListItemControllerState(
            listItemControllerState: newPaymentInstructionTransactionSummaryListItemControllerState
          );
        }
      );
      listItemControllerStateItemTypeInterceptorChecker.interceptEachListItem(
        i, ListItemControllerStateWrapper(paymentInstructionTransactionSummaryListItemControllerState), oldItemTypeList, newListItemControllerState
      );
      newItemTypeList.addAll(newListItemControllerState);
      return true;
    }
    return false;
  }

  void _interceptForOrderPayment(
    int i,
    PaymentInstructionTransactionSummary paymentInstructionTransactionSummary,
    List<ListItemControllerState> oldItemTypeList,
    List<ListItemControllerState> newListItemControllerState
  ) {
    newListItemControllerState.add(
      VirtualSpacingListItemControllerState(height: 6)
    );
    ListItemControllerState transactionSummaryListItemControllerState = PaddingContainerListItemControllerState(
      padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
      paddingChildListItemControllerState: WidgetSubstitutionListItemControllerState(
        widgetSubstitution: (context, index) {
          return TransactionSummaryWidget(
            transactionSummaryValueList: paymentInstructionTransactionSummary.paymentInstructionTransactionSummaryValueList,
          );
        }
      )
    );
    listItemControllerStateItemTypeInterceptorChecker.interceptEachListItem(
      i, ListItemControllerStateWrapper(transactionSummaryListItemControllerState), oldItemTypeList, newListItemControllerState
    );
    newListItemControllerState.add(
      VirtualSpacingListItemControllerState(height: padding())
    );
  }

  void _interceptForPaymentInstruction(
    int i,
    List<PaymentInstructionGroupStateValue> paymentInstructionGroupStateValueList,
    void Function() onUpdateState,
    List<ListItemControllerState> oldItemTypeList,
    List<ListItemControllerState> newListItemControllerState
  ) {
    ListItemControllerState transactionSummaryListItemControllerState = CompoundListItemControllerState(
      listItemControllerState: paymentInstructionGroupStateValueList.mapIndexed<ListItemControllerState>(
        (index1, paymentInstructionGroupStateValue) => BuilderListItemControllerState(
          buildListItemControllerState: () {
            PaymentInstructionGroup paymentInstructionGroup = paymentInstructionGroupStateValue.paymentInstructionGroup;
            return CompoundListItemControllerState(
              listItemControllerState: [
                if (index1 > 0) ...[
                  PaddingContainerListItemControllerState(
                    padding: EdgeInsets.symmetric(horizontal: padding()),
                    paddingChildListItemControllerState: DividerListItemControllerState()
                  )
                ],
                PaymentInstructionHeaderListItemControllerState(
                  title: paymentInstructionGroup.name.toStringNonNull,
                  isExpanded: paymentInstructionGroupStateValue.isExpanded,
                  onTap: () {
                    paymentInstructionGroupStateValue.isExpanded = !paymentInstructionGroupStateValue.isExpanded;
                    onUpdateState();
                  }
                ),
                if (paymentInstructionGroupStateValue.isExpanded) ...[
                  ...paymentInstructionGroup.paymentInstructionList.mapIndexed<ListItemControllerState>(
                    (index2, paymentInstruction) {
                      return CompoundListItemControllerState(
                        listItemControllerState: [
                          if (index2 > 0) ...[
                            VirtualSpacingListItemControllerState(height: 5),
                          ],
                          PaddingContainerListItemControllerState(
                            padding: EdgeInsets.symmetric(horizontal: padding()),
                            paddingChildListItemControllerState: PaymentInstructionContentListItemControllerState(
                              number: index2 + 1,
                              paymentInstruction: paymentInstruction,
                            )
                          )
                        ]
                      );
                    }
                  ).toList(),
                  VirtualSpacingListItemControllerState(height: padding())
                ]
              ]
            );
          }
        )
      ).toList()
    );
    listItemControllerStateItemTypeInterceptorChecker.interceptEachListItem(
      i, ListItemControllerStateWrapper(transactionSummaryListItemControllerState), oldItemTypeList, newListItemControllerState
    );
  }
}

class DefaultPaymentInstructionContainerStorageListItemControllerState extends PaymentInstructionContainerStorageListItemControllerState {
  List<PaymentInstructionGroupStateValue>? _paymentInstructionGroupStateValueList;
}