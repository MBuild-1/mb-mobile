import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';

import '../../domain/entity/additionalitem/additional_item.dart';
import '../../domain/entity/additionalitem/additional_item_list_parameter.dart';
import '../../domain/entity/additionalitem/remove_additional_item_parameter.dart';
import '../../domain/entity/additionalitem/remove_additional_item_response.dart';
import '../../domain/entity/bucket/bucket.dart';
import '../../domain/entity/bucket/bucket_member.dart';
import '../../domain/entity/cart/cart.dart';
import '../../domain/entity/user/user.dart';
import '../../presentation/page/modaldialogpage/add_additional_item_modal_dialog_page.dart';
import '../../presentation/widget/button/custombutton/sized_outline_gradient_button.dart';
import '../../presentation/widget/sharedcart/shared_cart_member_item.dart';
import '../acceptordeclinesharedcartmemberparameter/accept_shared_cart_member_parameter.dart';
import '../acceptordeclinesharedcartmemberparameter/decline_shared_cart_member_parameter.dart';
import '../constant.dart';
import '../controllerstate/listitemcontrollerstate/additionalitemlistitemcontrollerstate/additional_item_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/additionalitemlistitemcontrollerstate/additional_item_summary_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/cartlistitemcontrollerstate/cart_container_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/cartlistitemcontrollerstate/cart_header_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/cartlistitemcontrollerstate/cart_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/cartlistitemcontrollerstate/shared_cart_container_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/cartlistitemcontrollerstate/shared_cart_member_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/cartlistitemcontrollerstate/vertical_cart_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/compound_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/divider_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/failed_prompt_indicator_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/host_cart_member_indicator_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/loading_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/padding_container_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/spacing_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/virtual_spacing_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/widget_substitution_list_item_controller_state.dart';
import '../dialog_helper.dart';
import '../error/message_error.dart';
import '../error_helper.dart';
import '../itemtypelistinterceptor/itemtypelistinterceptorchecker/list_item_controller_state_item_type_list_interceptor_checker.dart';
import '../load_data_result.dart';
import '../multi_language_string.dart';
import '../typedef.dart';
import 'item_type_list_sub_interceptor.dart';

class CartItemTypeListSubInterceptor extends ItemTypeListSubInterceptor<ListItemControllerState> {
  final DoubleReturned padding;
  final DoubleReturned itemSpacing;
  final ListItemControllerStateItemTypeInterceptorChecker listItemControllerStateItemTypeInterceptorChecker;

  CartItemTypeListSubInterceptor({
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
    if (oldItemType is CartContainerListItemControllerState) {
      int j = 0;
      List<CartListItemControllerState> cartListItemControllerStateList = oldItemType.cartListItemControllerStateList;
      CartHeaderListItemControllerState cartHeaderListItemControllerState = CartHeaderListItemControllerState(
        isSelected: false,
        onChangeSelected: () {
          int k = 0;
          int selectedCount = 0;
          while (k < cartListItemControllerStateList.length) {
            CartListItemControllerState cartListItemControllerState = cartListItemControllerStateList[k];
            if (cartListItemControllerState.isSelected) {
              selectedCount += 1;
            }
            k++;
          }
          if (selectedCount == cartListItemControllerStateList.length) {
            for (var cartListItemControllerState in cartListItemControllerStateList) {
              cartListItemControllerState.isSelected = false;
            }
          } else {
            for (var cartListItemControllerState in cartListItemControllerStateList) {
              cartListItemControllerState.isSelected = true;
            }
          }
          oldItemType.onUpdateState();
        }
      );
      newItemTypeList.add(cartHeaderListItemControllerState);
      int selectedCount = 0;
      List<Cart> selectedCart = [];
      while (j < cartListItemControllerStateList.length) {
        CartListItemControllerState cartListItemControllerState = cartListItemControllerStateList[j];
        if (cartListItemControllerState.isSelected) {
          selectedCount += 1;
          selectedCart.add(cartListItemControllerState.cart);
        }
        newItemTypeList.addAll(<ListItemControllerState>[
          SpacingListItemControllerState(),
          cartListItemControllerState
        ]);
        j++;
        cartListItemControllerState.onChangeSelected = () {
          cartListItemControllerState.isSelected = !cartListItemControllerState.isSelected;
          oldItemType.onUpdateState();
        };
      }
      if (selectedCount == cartListItemControllerStateList.length) {
        cartHeaderListItemControllerState.isSelected = true;
      } else {
        cartHeaderListItemControllerState.isSelected = false;
      }
      CartContainerStateStorageListItemControllerState cartContainerStateStorageListItemControllerState = oldItemType.cartContainerStateStorageListItemControllerState;
      CartContainerActionListItemControllerState cartContainerActionListItemControllerState = oldItemType.cartContainerActionListItemControllerState;
      CartContainerInterceptingActionListItemControllerState cartContainerInterceptingActionListItemControllerState = oldItemType.cartContainerInterceptingActionListItemControllerState;
      if (cartContainerStateStorageListItemControllerState is DefaultCartContainerStateStorageListItemControllerState) {
        if (selectedCount != cartContainerStateStorageListItemControllerState._lastSelectedCount) {
          cartContainerStateStorageListItemControllerState._lastSelectedCount = selectedCount;
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            oldItemType.onChangeSelected(selectedCart);
          });
        }
        if (cartListItemControllerStateList.length != cartContainerStateStorageListItemControllerState._lastCartCount) {
          cartContainerStateStorageListItemControllerState._lastCartCount = cartListItemControllerStateList.length;
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            oldItemType.onCartChange();
          });
        }
      }
      if (cartContainerInterceptingActionListItemControllerState is DefaultCartContainerInterceptingActionListItemControllerState) {
        cartContainerInterceptingActionListItemControllerState._removeCart = (cart) {
          int l = 0;
          while (l < cartListItemControllerStateList.length) {
            CartListItemControllerState cartListItemControllerState = cartListItemControllerStateList[l];
            if (cartListItemControllerState.cart.id == cart.id) {
              cartListItemControllerStateList.removeAt(l);
              break;
            }
            l++;
          }
          oldItemType.onUpdateState();
        };
        cartContainerInterceptingActionListItemControllerState._getCartCount = () => cartListItemControllerStateList.length;
      }
      void loadAdditionalItem() async {
        if (cartContainerStateStorageListItemControllerState is DefaultCartContainerStateStorageListItemControllerState) {
          cartContainerStateStorageListItemControllerState._additionalItemLoadDataResult = IsLoadingLoadDataResult<List<AdditionalItem>>();
          oldItemType.onUpdateState();
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            oldItemType.onScrollToAdditionalItemsSection();
          });
          LoadDataResult<List<AdditionalItem>> additionalItemListLoadDataResult = await cartContainerActionListItemControllerState.getAdditionalItemList(AdditionalItemListParameter());
          if (additionalItemListLoadDataResult.isFailedBecauseCancellation) {
            return;
          }
          if (additionalItemListLoadDataResult.isSuccess) {
            oldItemType.additionalItemList.clear();
            oldItemType.additionalItemList.addAll(additionalItemListLoadDataResult.resultIfSuccess!);
          }
          cartContainerStateStorageListItemControllerState._additionalItemLoadDataResult = additionalItemListLoadDataResult;
          oldItemType.onUpdateState();
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            oldItemType.onScrollToAdditionalItemsSection();
          });
        }
      }
      void removeAdditionalItem(AdditionalItem additionalItem) async {
        if (cartContainerStateStorageListItemControllerState is DefaultCartContainerStateStorageListItemControllerState) {
          cartContainerStateStorageListItemControllerState._additionalItemLoadDataResult = IsLoadingLoadDataResult<List<AdditionalItem>>();
          oldItemType.onUpdateState();
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            oldItemType.onScrollToAdditionalItemsSection();
          });
          LoadDataResult<RemoveAdditionalItemResponse> removeAdditionalItemResponseLoadDataResult = await cartContainerActionListItemControllerState.removeAdditionalItem(
            RemoveAdditionalItemParameter(additionalItemId: additionalItem.id)
          );
          if (removeAdditionalItemResponseLoadDataResult.isFailedBecauseCancellation) {
            return;
          }
          loadAdditionalItem();
        }
      }
      if (oldItemType is! SharedCartContainerListItemControllerState) {
        newItemTypeList.add(VirtualSpacingListItemControllerState(height: 10.0));
        newItemTypeList.add(
          PaddingContainerListItemControllerState(
            padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
            paddingChildListItemControllerState: WidgetSubstitutionListItemControllerState(
              widgetSubstitution: (context, index) {
                return SizedOutlineGradientButton(
                  onPressed: () {
                    if (cartContainerStateStorageListItemControllerState is DefaultCartContainerStateStorageListItemControllerState) {
                      cartContainerStateStorageListItemControllerState._enableSendAdditionalItems = !cartContainerStateStorageListItemControllerState._enableSendAdditionalItems;
                      if (cartContainerStateStorageListItemControllerState._enableSendAdditionalItems) {
                        loadAdditionalItem();
                        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                          oldItemType.onScrollToAdditionalItemsSection();
                        });
                      } else {
                        oldItemType.additionalItemList.clear();
                      }
                      oldItemType.onUpdateState();
                    }
                  },
                  text: () {
                    String text = "Add Send Additional Items".tr;
                    if (cartContainerStateStorageListItemControllerState is DefaultCartContainerStateStorageListItemControllerState) {
                      if (cartContainerStateStorageListItemControllerState._enableSendAdditionalItems) {
                        text = "Disable Send Additional Items".tr;
                      }
                    }
                    return text;
                  }(),
                  outlineGradientButtonType: OutlineGradientButtonType.solid,
                  outlineGradientButtonVariation: OutlineGradientButtonVariation.variation1,
                );
              }
            )
          )
        );
        if (cartContainerStateStorageListItemControllerState is DefaultCartContainerStateStorageListItemControllerState) {
          if (cartContainerStateStorageListItemControllerState._enableSendAdditionalItems) {
            newItemTypeList.add(VirtualSpacingListItemControllerState(height: 25.0));
            newItemTypeList.add(
              PaddingContainerListItemControllerState(
                padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
                paddingChildListItemControllerState: WidgetSubstitutionListItemControllerState(
                  widgetSubstitution: (context, index) {
                    return Text(
                      "Enter The Items You Want To Send Along With The Estimated Weight and Price".tr,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    );
                  }
                )
              )
            );
            if (cartContainerStateStorageListItemControllerState._additionalItemLoadDataResult.isLoading) {
              newItemTypeList.add(LoadingListItemControllerState());
            } else if (cartContainerStateStorageListItemControllerState._additionalItemLoadDataResult.isSuccess) {
              List<ListItemControllerState> newAdditionalItemListControllerStateList = [];
              for (int i = 0; i < oldItemType.additionalItemList.length; i++) {
                AdditionalItem additionalItem = oldItemType.additionalItemList[i];
                ListItemControllerState newAdditionalItemListControllerState = CompoundListItemControllerState(
                  listItemControllerState: [
                    VirtualSpacingListItemControllerState(height: 10),
                    PaddingContainerListItemControllerState(
                      padding: EdgeInsets.symmetric(horizontal: padding()),
                      paddingChildListItemControllerState: AdditionalItemListItemControllerState(
                        additionalItem: additionalItem,
                        no: i + 1,
                        onRemoveAdditionalItem: removeAdditionalItem,
                        onLoadAdditionalItem: loadAdditionalItem
                      )
                    )
                  ]
                );
                listItemControllerStateItemTypeInterceptorChecker.interceptEachListItem(
                  i, ListItemControllerStateWrapper(newAdditionalItemListControllerState), oldItemTypeList, newAdditionalItemListControllerStateList
                );
              }
              newItemTypeList.addAll(newAdditionalItemListControllerStateList);
            }
            newItemTypeList.add(VirtualSpacingListItemControllerState(height: 15.0));
            newItemTypeList.add(
              PaddingContainerListItemControllerState(
                padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
                paddingChildListItemControllerState: WidgetSubstitutionListItemControllerState(
                  widgetSubstitution: (context, index) {
                    return Material(
                      color: Colors.grey.shade300,
                      child: InkWell(
                        onTap: () async {
                          dynamic result = await DialogHelper.showModalDialogPage<String, String>(
                            context: context,
                            modalDialogPageBuilder: (context, parameter) => AddAdditionalItemModalDialogPage(),
                          );
                          if (result != null) {
                            loadAdditionalItem();
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          child: Center(
                            child: Text(
                              "+ ${"Add Item".tr}",
                            ),
                          )
                        ),
                      ),
                    );
                  }
                )
              )
            );
            newItemTypeList.add(VirtualSpacingListItemControllerState(height: 15.0));
            if (oldItemType.additionalItemList.isNotEmpty) {
              newItemTypeList.addAll(<ListItemControllerState>[
                PaddingContainerListItemControllerState(
                  padding: EdgeInsets.symmetric(horizontal: padding()),
                  paddingChildListItemControllerState: DividerListItemControllerState(
                    lineColor: Colors.black
                  )
                ),
                PaddingContainerListItemControllerState(
                  padding: EdgeInsets.symmetric(horizontal: padding()),
                  paddingChildListItemControllerState: AdditionalItemSummaryListItemControllerState(
                    additionalItemList: oldItemType.additionalItemList
                  )
                )
              ]);
            }
          } else {
            newItemTypeList.add(VirtualSpacingListItemControllerState(height: 10.0));
          }
        }
      } else {
        SharedCartContainerListItemControllerState sharedCartContainerListItemControllerState = oldItemType;
        LoadDataResult<Bucket> bucketLoadDataResult = sharedCartContainerListItemControllerState.bucketLoadDataResult();
        LoadDataResult<BucketMember> bucketMemberLoadDataResult = sharedCartContainerListItemControllerState.bucketMemberLoadDataResult();
        LoadDataResult<User> userLoadDataResult = sharedCartContainerListItemControllerState.userLoadDataResult();
        if (bucketMemberLoadDataResult.isSuccess) {
          BucketMember bucketMember = bucketMemberLoadDataResult.resultIfSuccess!;
          if (bucketMember.hostBucket != 1) {
            return true;
          }
        }
        newItemTypeList.add(VirtualSpacingListItemControllerState(height: 10.0));
        newItemTypeList.add(
          WidgetSubstitutionListItemControllerState(
            widgetSubstitution: (BuildContext context, int index) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: padding()),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: padding(), horizontal: padding()),
                  decoration: BoxDecoration(
                    color: Constant.colorGrey5,
                    borderRadius: BorderRadius.circular(8.0)
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            children: [
                              const TextSpan(
                                text: "Total Member: "
                              ),
                              TextSpan(
                                text: bucketLoadDataResult.resultIfSuccess!.totalMember.toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold
                                )
                              ),
                            ]
                          )
                        ),
                      ),
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            children: [
                              const TextSpan(
                                text: "Total Berat: "
                              ),
                              TextSpan(
                                text: "${bucketLoadDataResult.resultIfSuccess!.totalWeight.toString()} Kg",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold
                                )
                              ),
                            ]
                          )
                        ),
                      ),
                    ]
                  ),
                )
              );
            }
          )
        );
        newItemTypeList.add(VirtualSpacingListItemControllerState(height: 24.0));
        newItemTypeList.add(SpacingListItemControllerState());
        List<ListItemControllerState> newBucketMemberListItemControllerStateList = [];
        BucketMember? checkBucketMember({
          required BucketMember? expandedBucketMember,
          required BucketMember iteratedBucketMember
        }) {
          if (expandedBucketMember != null) {
            if (expandedBucketMember.id == iteratedBucketMember.id) {
              return iteratedBucketMember;
            }
          }
          return null;
        }
        void iterateBucketMember({
          required List<BucketMember> bucketMemberList,
          required bool isRequest
        }) {
          for (int i = 0; i < bucketMemberList.length; i++) {
            BucketMember bucketMember = bucketMemberList[i];
            BucketMember? resultBucketMember = checkBucketMember(
              expandedBucketMember: sharedCartContainerListItemControllerState.onGetBucketMember(),
              iteratedBucketMember: bucketMember
            );
            List<ListItemControllerState> newBucketMemberCartListItemControllerStateList = [];
            if (resultBucketMember != null) {
              newBucketMemberCartListItemControllerStateList.addAll(
                resultBucketMember.bucketCartList.map(
                  (cart) => VerticalCartListItemControllerState(
                    cart: cart,
                    isSelected: false,
                    showCheck: false,
                    showBottom: false
                  )
                )
              );
            }
            ListItemControllerState newBucketMemberListItemControllerState = CompoundListItemControllerState(
              listItemControllerState: [
                VirtualSpacingListItemControllerState(
                  height: 24.0
                ),
                PaddingContainerListItemControllerState(
                  padding: EdgeInsets.symmetric(horizontal: padding()),
                  paddingChildListItemControllerState: CompoundListItemControllerState(
                    listItemControllerState: [
                      HostCartMemberIndicatorListItemControllerState(
                        bucketMember: bucketMember,
                        memberNo: isRequest ? 0 : i + 1
                      ),
                      VirtualSpacingListItemControllerState(
                        height: 10.0
                      ),
                      SharedCartMemberListItemControllerState(
                        bucketMember: bucketMember,
                        isExpanded: resultBucketMember != null,
                        onTapMore: () {
                          BucketMember? expandedBucketMember = sharedCartContainerListItemControllerState.onGetBucketMember();
                          if (expandedBucketMember != null) {
                            BucketMember? checkedResultBucketMember = checkBucketMember(
                              expandedBucketMember: sharedCartContainerListItemControllerState.onGetBucketMember(),
                              iteratedBucketMember: bucketMember
                            );
                            if (checkedResultBucketMember != null) {
                              sharedCartContainerListItemControllerState.onUnExpandBucketMemberRequest();
                            } else {
                              sharedCartContainerListItemControllerState.onExpandBucketMemberRequest(bucketMember);
                            }
                          } else {
                            sharedCartContainerListItemControllerState.onExpandBucketMemberRequest(bucketMember);
                          }
                        },
                        onTapDelete: () {
                          sharedCartContainerListItemControllerState.onRemoveSharedCartMember(bucketMember);
                        },
                        onAcceptOrDeclineMember: isRequest ? (value) {
                          if (value == SharedCartAcceptOrDeclineMemberResult.accept) {
                            sharedCartContainerListItemControllerState.onAcceptOrDeclineSharedCart(
                              AcceptSharedCartMemberParameter(
                                bucketMember: bucketMember
                              )
                            );
                          } else if (value == SharedCartAcceptOrDeclineMemberResult.decline) {
                            sharedCartContainerListItemControllerState.onAcceptOrDeclineSharedCart(
                              DeclineSharedCartMemberParameter(
                                bucketMember: bucketMember
                              )
                            );
                          }
                        } : null
                      )
                    ]
                  )
                ),
                if (resultBucketMember != null) ...[
                  CompoundListItemControllerState(
                    listItemControllerState: [
                      VirtualSpacingListItemControllerState(
                        height: padding()
                      ),
                      if (newBucketMemberCartListItemControllerStateList.isNotEmpty) ...[
                        ...newBucketMemberCartListItemControllerStateList
                      ] else ...[
                        FailedPromptIndicatorListItemControllerState(
                          errorProvider: sharedCartContainerListItemControllerState.onGetErrorProvider(),
                          e: FailedLoadDataResult.throwException(() {
                            throw ErrorHelper.generateMultiLanguageDioError(
                              MultiLanguageMessageError(
                                title: MultiLanguageString({
                                  Constant.textEnUsLanguageKey: "Cart Item Is Empty",
                                  Constant.textInIdLanguageKey: "Keranjangnya Kosong",
                                }),
                                message: MultiLanguageString({
                                  Constant.textEnUsLanguageKey: "For now, cart Item is empty.",
                                  Constant.textInIdLanguageKey: "Untuk sekarang, keranjangnya kosong.",
                                }),
                              )
                            );
                          })!.e
                        )
                      ]
                    ]
                  )
                ]
              ]
            );
            listItemControllerStateItemTypeInterceptorChecker.interceptEachListItem(
              i,
              ListItemControllerStateWrapper(newBucketMemberListItemControllerState),
              oldItemTypeList,
              newBucketMemberListItemControllerStateList
            );
          }
        }
        Bucket bucket = bucketLoadDataResult.resultIfSuccess!;
        iterateBucketMember(
          bucketMemberList: bucket.bucketMemberList.where(
            (bucketMember) => bucket.userId != bucketMember.userId
          ).toList(),
          isRequest: false
        );
        iterateBucketMember(
          bucketMemberList: bucketLoadDataResult.resultIfSuccess!.bucketMemberRequestList,
          isRequest: true
        );
        newItemTypeList.addAll(newBucketMemberListItemControllerStateList);
        newItemTypeList.add(VirtualSpacingListItemControllerState(height: 10.0));
      }
      return true;
    }
    return false;
  }
}

class DefaultCartContainerStateStorageListItemControllerState extends CartContainerStateStorageListItemControllerState {
  int _lastSelectedCount = -1;
  int _lastCartCount = -1;
  bool _enableSendAdditionalItems = false;
  LoadDataResult<List<AdditionalItem>> _additionalItemLoadDataResult = NoLoadDataResult<List<AdditionalItem>>();
}

class DefaultCartContainerInterceptingActionListItemControllerState extends CartContainerInterceptingActionListItemControllerState {
  void Function(Cart)? _removeCart;
  int Function()? _getCartCount;

  @override
  void Function(Cart)? get removeCart => _removeCart ?? (throw UnimplementedError());

  @override
  int Function()? get getCartCount => _getCartCount ?? (throw UnimplementedError());
}