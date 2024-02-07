import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/error_provider_ext.dart';
import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';
import 'package:masterbagasi/misc/ext/number_ext.dart';

import '../../domain/entity/additionalitem/additional_item.dart';
import '../../domain/entity/additionalitem/additional_item_list_parameter.dart';
import '../../domain/entity/additionalitem/remove_additional_item_parameter.dart';
import '../../domain/entity/additionalitem/remove_additional_item_response.dart';
import '../../domain/entity/bucket/bucket.dart';
import '../../domain/entity/bucket/bucket_member.dart';
import '../../domain/entity/cart/cart.dart';
import '../../domain/entity/cart/host_cart.dart';
import '../../domain/entity/payment/payment_method.dart';
import '../../domain/entity/user/user.dart';
import '../../domain/entity/wishlist/support_wishlist.dart';
import '../../presentation/page/modaldialogpage/add_additional_item_modal_dialog_page.dart';
import '../../presentation/widget/button/custombutton/sized_outline_gradient_button.dart';
import '../../presentation/widget/colorful_chip.dart';
import '../../presentation/widget/modified_loading_indicator.dart';
import '../../presentation/widget/payment/paymentmethod/selected_payment_method_indicator.dart';
import '../../presentation/widget/sharedcart/shared_cart_member_item.dart';
import '../../presentation/widget/tap_area.dart';
import '../acceptordeclinesharedcartmemberparameter/accept_shared_cart_member_parameter.dart';
import '../acceptordeclinesharedcartmemberparameter/decline_shared_cart_member_parameter.dart';
import '../constant.dart';
import '../controllerstate/listitemcontrollerstate/additionalitemlistitemcontrollerstate/additional_item_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/additionalitemlistitemcontrollerstate/additional_item_summary_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/builder_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/cartlistitemcontrollerstate/cart_container_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/cartlistitemcontrollerstate/cart_header_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/cartlistitemcontrollerstate/cart_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/cartlistitemcontrollerstate/shared_cart_container_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/cartlistitemcontrollerstate/shared_cart_member_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/cartlistitemcontrollerstate/vertical_cart_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/compound_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/divider_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/failed_prompt_indicator_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/host_cart_indicator_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/host_cart_member_indicator_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/loading_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/non_expanded_item_in_row_child_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/padding_container_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/row_container_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/spacing_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/virtual_spacing_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/widget_substitution_list_item_controller_state.dart';
import '../dialog_helper.dart';
import '../error/cart_empty_error.dart';
import '../error/message_error.dart';
import '../error_helper.dart';
import '../errorprovider/error_provider.dart';
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
      List<CartListItemControllerState> cartListItemControllerStateList = [];
      if (oldItemType is! SharedCartContainerListItemControllerState) {
        cartListItemControllerStateList = oldItemType.cartListItemControllerStateList;
      } else {
        SharedCartContainerListItemControllerState sharedCartContainerListItemControllerState = oldItemType;
        bool allSuccessLoadData = sharedCartContainerListItemControllerState.userLoadDataResult().isSuccess
            && sharedCartContainerListItemControllerState.bucketLoadDataResult().isSuccess
            && sharedCartContainerListItemControllerState.bucketMemberLoadDataResult().isSuccess
            && sharedCartContainerListItemControllerState.cartListLoadDataResult().isSuccess;
        if (!allSuccessLoadData) {
          return true;
        }
        LoadDataResult<Bucket> bucketLoadDataResult = sharedCartContainerListItemControllerState.bucketLoadDataResult();
        Bucket bucket = bucketLoadDataResult.resultIfSuccess!;
        newItemTypeList.addAll(<ListItemControllerState>[
          PaddingContainerListItemControllerState(
            padding: EdgeInsets.all(padding()),
            paddingChildListItemControllerState: HostCartIndicatorListItemControllerState(
              hostCart: HostCart(username: bucket.bucketUsername)
            )
          ),
          SpacingListItemControllerState(),
          VirtualSpacingListItemControllerState(
            height: padding()
          ),
          PaddingContainerListItemControllerState(
            padding: EdgeInsets.symmetric(horizontal: padding()),
            paddingChildListItemControllerState: WidgetSubstitutionListItemControllerState(
              widgetSubstitution: (context, index) {
                return Text(
                  "Cart".tr,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                );
              }
            )
          ),
        ]);
        Iterable<BucketMember> bucketMemberIterable = bucket.bucketMemberList.where(
          (bucketMember) => bucketMember.hostBucket == 1
        );
        if (bucketMemberIterable.isNotEmpty) {
          BucketMember bucketMember = bucketMemberIterable.first;
          cartListItemControllerStateList = bucketMember.bucketCartList.map<CartListItemControllerState>(
            (cart) => VerticalCartListItemControllerState(
              isSelected: true,
              showDefaultCart: false,
              showCheck: false,
              canBeSelected: false,
              cart: cart,
              onChangeQuantity: null,
              onAddToWishlist: null,
              onRemoveCart: null,
            )
          ).toList();
        } else {
          cartListItemControllerStateList = [];
        }
      }
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
      if (oldItemType is! SharedCartContainerListItemControllerState) {
        newItemTypeList.addAll(<ListItemControllerState>[
          cartHeaderListItemControllerState,
          SpacingListItemControllerState()
        ]);
      }
      int selectedCount = 0;
      List<Cart> selectedCart = [];
      if (cartListItemControllerStateList.isNotEmpty) {
        while (j < cartListItemControllerStateList.length) {
          CartListItemControllerState cartListItemControllerState = cartListItemControllerStateList[j];
          if (cartListItemControllerState.isSelected) {
            selectedCount += 1;
            selectedCart.add(cartListItemControllerState.cart);
          }
          newItemTypeList.addAll(<ListItemControllerState>[
            if (j > 0) SpacingListItemControllerState(),
            cartListItemControllerState
          ]);
          j++;
          cartListItemControllerState.onChangeSelected = () {
            cartListItemControllerState.isSelected = !cartListItemControllerState.isSelected;
            oldItemType.onUpdateState();
          };
        }
      } else {
        if (oldItemType is SharedCartContainerListItemControllerState) {
          newItemTypeList.add(
            FailedPromptIndicatorListItemControllerState(
              e: CartEmptyError(),
              errorProvider: oldItemType.onGetErrorProvider()
            )
          );
        }
      }
      if (selectedCount == cartListItemControllerStateList.length) {
        cartHeaderListItemControllerState.isSelected = true;
      } else {
        cartHeaderListItemControllerState.isSelected = false;
      }
      CartContainerStateStorageListItemControllerState cartContainerStateStorageListItemControllerState = oldItemType.cartContainerStateStorageListItemControllerState;
      CartContainerActionListItemControllerState cartContainerActionListItemControllerState = oldItemType.cartContainerActionListItemControllerState;
      CartContainerInterceptingActionListItemControllerState cartContainerInterceptingActionListItemControllerState = oldItemType.cartContainerInterceptingActionListItemControllerState;
      void loadAdditionalItem(bool scrollToAdditionalItemSection) async {
        if (cartContainerStateStorageListItemControllerState is DefaultCartContainerStateStorageListItemControllerState) {
          cartContainerStateStorageListItemControllerState._additionalItemLoadDataResult = IsLoadingLoadDataResult<List<AdditionalItem>>();
          oldItemType.onUpdateState();
          if (scrollToAdditionalItemSection) {
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              oldItemType.onScrollToAdditionalItemsSection();
            });
          }
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
          if (scrollToAdditionalItemSection) {
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              oldItemType.onScrollToAdditionalItemsSection();
            });
          }
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
          loadAdditionalItem(true);
        }
      }
      void onEnableOrDisableAdditionalItemClick({bool scrollToAdditionalItemSection = true}) {
        if (cartContainerStateStorageListItemControllerState is DefaultCartContainerStateStorageListItemControllerState) {
          cartContainerStateStorageListItemControllerState._enableSendAdditionalItems = !cartContainerStateStorageListItemControllerState._enableSendAdditionalItems;
          if (cartContainerStateStorageListItemControllerState._enableSendAdditionalItems) {
            loadAdditionalItem(scrollToAdditionalItemSection);
            if (scrollToAdditionalItemSection) {
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                oldItemType.onScrollToAdditionalItemsSection();
              });
            }
          } else {
            oldItemType.additionalItemList.clear();
          }
          oldItemType.onUpdateState();
        }
      }
      void checkAdditionalItem() async {
        if (cartContainerStateStorageListItemControllerState is DefaultCartContainerStateStorageListItemControllerState) {
          cartContainerStateStorageListItemControllerState._checkingAdditionalItemLoadDataResult = IsLoadingLoadDataResult<List<AdditionalItem>>();
          oldItemType.onUpdateState();
          LoadDataResult<List<AdditionalItem>> additionalItemListLoadDataResult = await cartContainerActionListItemControllerState.getAdditionalItemList(AdditionalItemListParameter());
          if (additionalItemListLoadDataResult.isFailedBecauseCancellation) {
            return;
          }
          cartContainerStateStorageListItemControllerState._checkingAdditionalItemLoadDataResult = additionalItemListLoadDataResult;
          oldItemType.onUpdateState();
          if (additionalItemListLoadDataResult.isSuccess) {
            List<AdditionalItem> checkingResultAdditionalItemList = additionalItemListLoadDataResult.resultIfSuccess!;
            if (checkingResultAdditionalItemList.isNotEmpty) {
              onEnableOrDisableAdditionalItemClick(
                scrollToAdditionalItemSection: false
              );
            }
          }
        }
      }
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
        if (cartContainerStateStorageListItemControllerState._checkingAdditionalItemLoadDataResult is NoLoadDataResult<List<AdditionalItem>>) {
          cartContainerStateStorageListItemControllerState._checkingAdditionalItemLoadDataResult = IsLoadingLoadDataResult<List<AdditionalItem>>();
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            checkAdditionalItem();
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
                      var checkingAdditionalItemLoadDataResult = cartContainerStateStorageListItemControllerState._checkingAdditionalItemLoadDataResult;
                      if (checkingAdditionalItemLoadDataResult.isSuccess || checkingAdditionalItemLoadDataResult.isFailed) {
                        return onEnableOrDisableAdditionalItemClick;
                      }
                      return null;
                    }
                  }(),
                  text: "",
                  childInterceptor: (style) {
                    if (cartContainerStateStorageListItemControllerState is DefaultCartContainerStateStorageListItemControllerState) {
                      var checkingAdditionalItemLoadDataResult = cartContainerStateStorageListItemControllerState._checkingAdditionalItemLoadDataResult;
                      if (checkingAdditionalItemLoadDataResult.isSuccess || checkingAdditionalItemLoadDataResult.isFailed) {
                        String text = "Add Send Additional Items".tr;
                        if (cartContainerStateStorageListItemControllerState._enableSendAdditionalItems) {
                          text = "Close Send Additional Items".tr;
                        }
                        return Center(
                          child: Text(
                            text,
                            style: style
                          ),
                        );
                      } else {
                        return const Center(
                          child: ModifiedLoadingIndicator()
                        );
                      }
                    }
                    return Container();
                  },
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
                    VirtualSpacingListItemControllerState(height: 14),
                    PaddingContainerListItemControllerState(
                      padding: EdgeInsets.symmetric(horizontal: padding()),
                      paddingChildListItemControllerState: AdditionalItemListItemControllerState(
                        additionalItem: additionalItem,
                        no: i + 1,
                        onRemoveAdditionalItem: removeAdditionalItem,
                        onLoadAdditionalItem: () => loadAdditionalItem(true)
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
                            loadAdditionalItem(true);
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
        Bucket bucket = bucketLoadDataResult.resultIfSuccess!;
        Iterable<BucketMember> bucketMemberIterable = bucket.bucketMemberList.where(
          (bucketMember) => bucketMember.userId == userLoadDataResult.resultIfSuccess!.id
        );
        int loggedUserHostBucket = -1;
        if (bucketMemberIterable.isNotEmpty) {
          BucketMember bucketMember = bucketMemberIterable.first;
          loggedUserHostBucket = bucketMember.hostBucket;
        }
        ListItemControllerState sharedCartHostWarehouseListItemControllerState = BuilderListItemControllerState(
          buildListItemControllerState: () {
            List<ListItemControllerState> sharedCartHostWarehouseListItemControllerStateList = [];
            Iterable<BucketMember> hostBucketMemberIterable = bucket.bucketMemberList.where(
              (bucketMember) => bucketMember.hostBucket == 1
            );
            if (hostBucketMemberIterable.isNotEmpty) {
              BucketMember hostBucketMember = hostBucketMemberIterable.first;
              if (hostBucketMember.bucketWarehouseAdditionalItemList.isNotEmpty) {
                sharedCartHostWarehouseListItemControllerStateList.addAll([
                  PaddingContainerListItemControllerState(
                    padding: EdgeInsets.symmetric(horizontal: padding()),
                    paddingChildListItemControllerState: WidgetSubstitutionListItemControllerState(
                      widgetSubstitution: (context, index) {
                        return Text(
                          "Warehouse".tr,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        );
                      }
                    )
                  ),
                  VirtualSpacingListItemControllerState(height: 16),
                  ...hostBucketMember.bucketWarehouseAdditionalItemList.mapIndexed<ListItemControllerState>(
                    (index, additionalItem) => PaddingContainerListItemControllerState(
                      padding: EdgeInsets.symmetric(horizontal: padding()),
                      paddingChildListItemControllerState: CompoundListItemControllerState(
                        listItemControllerState: [
                          if (index > 0) VirtualSpacingListItemControllerState(height: 14),
                          AdditionalItemListItemControllerState(
                            additionalItem: additionalItem,
                            no: index + 1,
                            onLoadAdditionalItem: () {},
                            showEditAndRemoveIcon: false
                          )
                        ]
                      )
                    )
                  )
                ]);
              }
            }
            return CompoundListItemControllerState(
              listItemControllerState: sharedCartHostWarehouseListItemControllerStateList
            );
          }
        );
        listItemControllerStateItemTypeInterceptorChecker.interceptEachListItem(
          i,
          ListItemControllerStateWrapper(sharedCartHostWarehouseListItemControllerState),
          oldItemTypeList,
          newItemTypeList
        );
        newItemTypeList.add(VirtualSpacingListItemControllerState(height: 10.0));
        newItemTypeList.add(
          PaddingContainerListItemControllerState(
            padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
            paddingChildListItemControllerState: DividerListItemControllerState()
          )
        );
        newItemTypeList.add(VirtualSpacingListItemControllerState(height: 16.0));
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
                      if (bucketLoadDataResult.resultIfSuccess!.totalWeight != null) ...[
                        Expanded(
                          child: Text.rich(
                            TextSpan(
                              children: [
                                const TextSpan(
                                  text: "Total Berat: "
                                ),
                                TextSpan(
                                  text: "${bucketLoadDataResult.resultIfSuccess!.totalWeight!.toWeightStringDecimalPlaced()} Kg",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold
                                  )
                                ),
                              ]
                            )
                          ),
                        ),
                      ]
                    ]
                  ),
                )
              );
            }
          )
        );

        // Selected Payment Method
        if (loggedUserHostBucket == 1) {
          newItemTypeList.add(VirtualSpacingListItemControllerState(height: 24.0));
          newItemTypeList.add(
            PaddingContainerListItemControllerState(
              padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
              paddingChildListItemControllerState: WidgetSubstitutionListItemControllerState(
                widgetSubstitution: (context, index) {
                  return Text(
                    "Payment Method".tr,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  );
                }
              )
            )
          );
          newItemTypeList.add(
            VirtualSpacingListItemControllerState(
              height: 10.0
            )
          );
          newItemTypeList.add(
            DividerListItemControllerState(
              lineColor: Colors.black
            )
          );
          newItemTypeList.add(
            VirtualSpacingListItemControllerState(
              height: 10.0
            )
          );
          double paymentMethodEndSpacing = 25.0;
          LoadDataResult<PaymentMethod> selectedPaymentMethodLoadDataResult = oldItemType.selectedPaymentMethodLoadDataResult();
          if (selectedPaymentMethodLoadDataResult.isSuccess) {
            paymentMethodEndSpacing = 20.0;
            newItemTypeList.add(
              PaddingContainerListItemControllerState(
                padding: const EdgeInsets.symmetric(horizontal: 0.0),
                paddingChildListItemControllerState: WidgetSubstitutionListItemControllerState(
                  widgetSubstitution: (context, index) => SelectedPaymentMethodIndicator(
                    onTap: oldItemType.onSelectPaymentMethod,
                    onRemove: oldItemType.onRemovePaymentMethod,
                    selectedPaymentMethod: selectedPaymentMethodLoadDataResult.resultIfSuccess!,
                  ),
                )
              )
            );
          } else if (selectedPaymentMethodLoadDataResult.isFailed) {
            ErrorProvider errorProvider = oldItemType.errorProvider();
            ErrorProviderResult errorProviderResult = errorProvider.onGetErrorProviderResult(selectedPaymentMethodLoadDataResult.resultIfFailed!).toErrorProviderResultNonNull();
            newItemTypeList.add(
              VirtualSpacingListItemControllerState(
                height: 10.0
              )
            );
            newItemTypeList.add(
              PaddingContainerListItemControllerState(
                padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
                paddingChildListItemControllerState: WidgetSubstitutionListItemControllerState(
                  widgetSubstitution: (context, index) => Text(
                    errorProviderResult.message,
                    style: const TextStyle(fontWeight: FontWeight.bold)
                  ),
                )
              )
            );
          } else if (selectedPaymentMethodLoadDataResult.isLoading) {
            newItemTypeList.add(
              VirtualSpacingListItemControllerState(
                height: 10.0
              )
            );
            newItemTypeList.add(LoadingListItemControllerState());
            newItemTypeList.add(
              VirtualSpacingListItemControllerState(
                height: 10.0
              )
            );
          } else {
            newItemTypeList.add(
              PaddingContainerListItemControllerState(
                padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
                paddingChildListItemControllerState: WidgetSubstitutionListItemControllerState(
                  widgetSubstitution: (context, index) {
                    return Text(
                      "No selected payment method".tr,
                    );
                  }
                )
              )
            );
            newItemTypeList.add(
              VirtualSpacingListItemControllerState(
                height: 15.0
              )
            );
            newItemTypeList.add(
              PaddingContainerListItemControllerState(
                padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
                paddingChildListItemControllerState: WidgetSubstitutionListItemControllerState(
                  widgetSubstitution: (context, index) {
                    return Row(
                      children: [
                        TapArea(
                          onTap: oldItemType.onSelectPaymentMethod,
                          child: Container(
                            child: Text("Select Payment Method".tr, style: const TextStyle(fontWeight: FontWeight.bold)),
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                            decoration: BoxDecoration(
                              border: Border.all()
                            ),
                          )
                        ),
                      ]
                    );
                  }
                )
              )
            );
          }
          newItemTypeList.add(
            VirtualSpacingListItemControllerState(
              height: padding()
            )
          );
        } else {
          newItemTypeList.add(VirtualSpacingListItemControllerState(height: padding()));
        }

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
        bool iterateBucketMember({
          required List<BucketMember> bucketMemberList,
          required bool isRequest
        }) {
          if (bucketMemberList.isEmpty) {
            return false;
          }
          for (int i = 0; i < bucketMemberList.length; i++) {
            BucketMember bucketMember = bucketMemberList[i];
            BucketMember? resultBucketMember = checkBucketMember(
              expandedBucketMember: sharedCartContainerListItemControllerState.onGetBucketMember(),
              iteratedBucketMember: bucketMember
            );
            List<ListItemControllerState> newBucketMemberCartListItemControllerStateList = [];
            if (resultBucketMember != null) {
              if (resultBucketMember.bucketCartList.isNotEmpty) {
                newBucketMemberCartListItemControllerStateList.addAll([
                  PaddingContainerListItemControllerState(
                    padding: EdgeInsets.symmetric(horizontal: padding()),
                    paddingChildListItemControllerState: WidgetSubstitutionListItemControllerState(
                      widgetSubstitution: (context, index) {
                        return Text(
                          "Cart".tr,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        );
                      }
                    )
                  ),
                  ...resultBucketMember.bucketCartList.map(
                    (cart) => VerticalCartListItemControllerState(
                      cart: cart,
                      showDefaultCart: false,
                      isSelected: false,
                      showCheck: false,
                      showBottom: false
                    )
                  )
                ]);
              }
              if (resultBucketMember.bucketWarehouseAdditionalItemList.isNotEmpty) {
                newBucketMemberCartListItemControllerStateList.addAll([
                  PaddingContainerListItemControllerState(
                    padding: EdgeInsets.symmetric(horizontal: padding()),
                    paddingChildListItemControllerState: WidgetSubstitutionListItemControllerState(
                      widgetSubstitution: (context, index) {
                        return Text(
                          "Warehouse".tr,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        );
                      }
                    )
                  ),
                  VirtualSpacingListItemControllerState(height: 16),
                  ...resultBucketMember.bucketWarehouseAdditionalItemList.mapIndexed<ListItemControllerState>(
                    (index, additionalItem) => PaddingContainerListItemControllerState(
                      padding: EdgeInsets.symmetric(horizontal: padding()),
                      paddingChildListItemControllerState: CompoundListItemControllerState(
                        listItemControllerState: [
                          if (index > 0) VirtualSpacingListItemControllerState(height: 14),
                          AdditionalItemListItemControllerState(
                            additionalItem: additionalItem,
                            no: index + 1,
                            onLoadAdditionalItem: () {},
                            showEditAndRemoveIcon: false
                          )
                        ]
                      )
                    )
                  )
                ]);
              }
            }
            ListItemControllerState newBucketMemberListItemControllerState = CompoundListItemControllerState(
              listItemControllerState: [
                VirtualSpacingListItemControllerState(
                  height: padding()
                ),
                PaddingContainerListItemControllerState(
                  padding: EdgeInsets.symmetric(horizontal: padding()),
                  paddingChildListItemControllerState: CompoundListItemControllerState(
                    listItemControllerState: [
                      RowContainerListItemControllerState(
                        rowChildListItemControllerState: [
                          HostCartMemberIndicatorListItemControllerState(
                            bucketMember: bucketMember,
                            memberNo: isRequest ? 0 : i + 1,
                            isMe: bucketMember.userId == userLoadDataResult.resultIfSuccess!.id
                          ),
                          VirtualSpacingListItemControllerState(
                            width: 10.0
                          ),
                          if (bucketMember.status > -1) ...[
                            NonExpandedItemInRowChildControllerState(
                              childListItemControllerState: WidgetSubstitutionListItemControllerState(
                                widgetSubstitution: (BuildContext context, int index) {
                                  bool isReady = bucketMember.status == 1;
                                  return ColorfulChip(
                                    text: MultiLanguageString({
                                      Constant.textInIdLanguageKey: isReady ? "Siap" : "Belum Siap",
                                      Constant.textEnUsLanguageKey: isReady ? "Ready" : "Not Ready"
                                    }).toString(),
                                    color: isReady ? Constant.colorMain : Colors.grey.shade300,
                                    textColor: isReady ? Colors.white : null,
                                  );
                                }
                              )
                            ),
                          ]
                        ]
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
                        onTapReady: () {
                          sharedCartContainerListItemControllerState.onTriggerReady(bucketMember);
                        },
                        showDeleteButton: loggedUserHostBucket == 1,
                        showReadyButton: loggedUserHostBucket == 0,
                        readyStatus: bucketMember.status,
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
                        } : null,
                        isLoggedUser: bucketMember.userId == userLoadDataResult.resultIfSuccess!.id,
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
          return true;
        }
        bool hasBucketMember = false;
        bool hasRequestBucketMember = false;
        // bucket.userId != bucketMember.userId
        hasBucketMember = iterateBucketMember(
          bucketMemberList: bucket.bucketMemberList.where(
            (bucketMember) => bucketMember.hostBucket != 1
          ).toList(),
          isRequest: false
        );
        if (loggedUserHostBucket == 1) {
          hasRequestBucketMember = iterateBucketMember(
            bucketMemberList: bucketLoadDataResult.resultIfSuccess!.bucketMemberRequestList,
            isRequest: true
          );
        }
        if (!hasBucketMember && !hasRequestBucketMember) {
          listItemControllerStateItemTypeInterceptorChecker.interceptEachListItem(
            i,
            ListItemControllerStateWrapper(
              CompoundListItemControllerState(
                listItemControllerState: [
                  VirtualSpacingListItemControllerState(height: padding()),
                  FailedPromptIndicatorListItemControllerState(
                    errorProvider: sharedCartContainerListItemControllerState.onGetErrorProvider(),
                    e: FailedLoadDataResult.throwException(() {
                      throw ErrorHelper.generateMultiLanguageDioError(
                        MultiLanguageMessageError(
                          title: MultiLanguageString({
                            Constant.textEnUsLanguageKey: "There Are Not Member That Joined",
                            Constant.textInIdLanguageKey: "Belum Ada Member Yang Join",
                          }),
                          message: MultiLanguageString({
                            Constant.textEnUsLanguageKey: "For now, there are not member that joined.",
                            Constant.textInIdLanguageKey: "Untuk sekarang, belum ada member yang join.",
                          }),
                        )
                      );
                    })!.e
                  )
                ]
              )
            ),
            oldItemTypeList,
            newBucketMemberListItemControllerStateList
          );
        }
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
  LoadDataResult<List<AdditionalItem>> _checkingAdditionalItemLoadDataResult = NoLoadDataResult<List<AdditionalItem>>();
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