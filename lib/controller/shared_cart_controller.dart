import 'package:masterbagasi/misc/ext/future_ext.dart';
import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';

import '../domain/entity/additionalitem/add_additional_item_parameter.dart';
import '../domain/entity/additionalitem/add_additional_item_response.dart';
import '../domain/entity/additionalitem/additional_item.dart';
import '../domain/entity/additionalitem/additional_item_list_parameter.dart';
import '../domain/entity/additionalitem/change_additional_item_parameter.dart';
import '../domain/entity/additionalitem/change_additional_item_response.dart';
import '../domain/entity/additionalitem/remove_additional_item_parameter.dart';
import '../domain/entity/additionalitem/remove_additional_item_response.dart';
import '../domain/entity/bucket/approveorrejectrequestbucket/approve_or_reject_request_bucket_parameter.dart';
import '../domain/entity/bucket/approveorrejectrequestbucket/approve_or_reject_request_bucket_response.dart';
import '../domain/entity/bucket/bucket.dart';
import '../domain/entity/bucket/bucket_member.dart';
import '../domain/entity/bucket/checkbucket/check_bucket_parameter.dart';
import '../domain/entity/bucket/checkbucket/check_bucket_response.dart';
import '../domain/entity/bucket/checkoutbucket/checkout_bucket_parameter.dart';
import '../domain/entity/bucket/checkoutbucket/checkout_bucket_response.dart';
import '../domain/entity/bucket/destroybucket/destroy_bucket_parameter.dart';
import '../domain/entity/bucket/destroybucket/destroy_bucket_response.dart';
import '../domain/entity/bucket/leavebucket/leave_bucket_parameter.dart';
import '../domain/entity/bucket/leavebucket/leave_bucket_response.dart';
import '../domain/entity/bucket/removememberbucket/remove_member_bucket_parameter.dart';
import '../domain/entity/bucket/removememberbucket/remove_member_bucket_response.dart';
import '../domain/entity/bucket/shared_cart_summary_parameter.dart';
import '../domain/entity/bucket/showbucketbyid/show_bucket_by_id_parameter.dart';
import '../domain/entity/bucket/showbucketbyid/show_bucket_by_id_response.dart';
import '../domain/entity/bucket/triggerbucketready/trigger_bucket_ready_parameter.dart';
import '../domain/entity/bucket/triggerbucketready/trigger_bucket_ready_response.dart';
import '../domain/entity/cart/cart.dart';
import '../domain/entity/cart/cart_list_parameter.dart';
import '../domain/entity/cart/cart_summary.dart';
import '../domain/entity/cart/cart_summary_parameter.dart';
import '../domain/entity/cart/remove_from_cart_parameter.dart';
import '../domain/entity/cart/remove_from_cart_response.dart';
import '../domain/entity/user/getuser/get_user_parameter.dart';
import '../domain/entity/user/user.dart';
import '../domain/entity/wishlist/add_wishlist_parameter.dart';
import '../domain/entity/wishlist/add_wishlist_response.dart';
import '../domain/entity/wishlist/support_wishlist.dart';
import '../domain/usecase/add_additional_item_use_case.dart';
import '../domain/usecase/add_to_cart_use_case.dart';
import '../domain/usecase/add_wishlist_use_case.dart';
import '../domain/usecase/approve_or_reject_request_bucket_use_case.dart';
import '../domain/usecase/change_additional_item_use_case.dart';
import '../domain/usecase/check_bucket_use_case.dart';
import '../domain/usecase/checkout_bucket_use_case.dart';
import '../domain/usecase/create_bucket_use_case.dart';
import '../domain/usecase/destroy_bucket_use_case.dart';
import '../domain/usecase/get_additional_item_use_case.dart';
import '../domain/usecase/get_cart_list_use_case.dart';
import '../domain/usecase/get_cart_summary_use_case.dart';
import '../domain/usecase/get_shared_cart_summary_use_case.dart';
import '../domain/usecase/get_user_use_case.dart';
import '../domain/usecase/leave_bucket_use_case.dart';
import '../domain/usecase/remove_additional_item_use_case.dart';
import '../domain/usecase/remove_from_cart_use_case.dart';
import '../domain/usecase/remove_member_bucket_use_case.dart';
import '../domain/usecase/request_join_bucket_use_case.dart';
import '../domain/usecase/show_bucket_by_id_use_case.dart';
import '../domain/usecase/trigger_bucket_ready_use_case.dart';
import '../misc/error/not_found_error.dart';
import '../misc/load_data_result.dart';
import '../misc/typedef.dart';
import 'base_getx_controller.dart';

typedef _OnCartBack = void Function();
typedef _OnShowAddToWishlistRequestProcessLoadingCallback = Future<void> Function();
typedef _OnAddToWishlistRequestProcessSuccessCallback = Future<void> Function();
typedef _OnShowAddToWishlistRequestProcessFailedCallback = Future<void> Function(dynamic e);
typedef _OnShowRemoveCartRequestProcessLoadingCallback = Future<void> Function();
typedef _OnRemoveCartRequestProcessSuccessCallback = Future<void> Function(Cart cart);
typedef _OnShowRemoveCartRequestProcessFailedCallback = Future<void> Function(dynamic e);
typedef _OnShowCheckoutBucketRequestProcessLoadingCallback = Future<void> Function();
typedef _OnCheckoutBucketRequestProcessSuccessCallback = Future<void> Function(CheckoutBucketResponse checkoutBucketResponse);
typedef _OnShowCheckoutBucketRequestProcessFailedCallback = Future<void> Function(dynamic e);
typedef _OnShowApproveOrRejectRequestBucketProcessLoadingCallback = Future<void> Function();
typedef _OnApproveOrRejectRequestBucketProcessSuccessCallback = Future<void> Function(ApproveOrRejectRequestBucketResponse approveOrRejectRequestBucketResponse);
typedef _OnShowApproveOrRejectRequestBucketProcessFailedCallback = Future<void> Function(dynamic e);
typedef _OnShowRemoveMemberRequestBucketProcessLoadingCallback = Future<void> Function();
typedef _OnRemoveMemberRequestBucketProcessSuccessCallback = Future<void> Function(RemoveMemberBucketResponse removeMemberBucketResponse);
typedef _OnShowRemoveMemberRequestBucketProcessFailedCallback = Future<void> Function(dynamic e);
typedef _OnShowTriggerBucketReadyProcessLoadingCallback = Future<void> Function();
typedef _OnTriggerBucketReadyProcessSuccessCallback = Future<void> Function(TriggerBucketReadyResponse triggerBucketReadyResponse);
typedef _OnShowTriggerBucketReadyProcessFailedCallback = Future<void> Function(dynamic e);
typedef _OnShowSharedCartSummaryProcessCallback = Future<void> Function(LoadDataResult<CartSummary>);
typedef _OnShareCartInfoProcessLoadingCallback = Future<void> Function();
typedef _OnShareCartInfoProcessSuccessCallback = Future<void> Function(ShowBucketByIdResponse showBucketByIdResponse);
typedef _OnShareCartInfoProcessFailedCallback = Future<void> Function(dynamic e);
typedef _OnDestroyBucketProcessLoadingCallback = Future<void> Function();
typedef _OnDestroyBucketProcessSuccessCallback = Future<void> Function(DestroyBucketResponse destroyBucketResponse);
typedef _OnDestroyBucketProcessFailedCallback = Future<void> Function(dynamic e);
typedef _OnLeaveBucketProcessLoadingCallback = Future<void> Function();
typedef _OnLeaveBucketProcessSuccessCallback = Future<void> Function(LeaveBucketResponse leaveBucketResponse);
typedef _OnLeaveBucketProcessFailedCallback = Future<void> Function(dynamic e);

class SharedCartController extends BaseGetxController {
  final GetCartListUseCase getCartListUseCase;
  final AddToCartUseCase addToCartUseCase;
  final RemoveFromCartUseCase removeFromCartUseCase;
  final GetSharedCartSummaryUseCase getSharedCartSummaryUseCase;
  final GetAdditionalItemUseCase getAdditionalItemUseCase;
  final AddAdditionalItemUseCase addAdditionalItemUseCase;
  final ChangeAdditionalItemUseCase changeAdditionalItemUseCase;
  final RemoveAdditionalItemUseCase removeAdditionalItemUseCase;
  final AddWishlistUseCase addWishlistUseCase;
  final CreateBucketUseCase createBucketUseCase;
  final RequestJoinBucketUseCase requestJoinBucketUseCase;
  final CheckBucketUseCase checkBucketUseCase;
  final ShowBucketByIdUseCase showBucketByIdUseCase;
  final GetUserUseCase getUserUseCase;
  final ApproveOrRejectRequestBucketUseCase approveOrRejectRequestBucketUseCase;
  final RemoveMemberBucketUseCase removeMemberBucketUseCase;
  final TriggerBucketReadyUseCase triggerBucketReadyUseCase;
  final CheckoutBucketUseCase checkoutBucketUseCase;
  final LeaveBucketUseCase leaveBucketUseCase;
  final DestroyBucketUseCase destroyBucketUseCase;

  MainSharedCartDelegate? _mainSharedCartDelegate;

  SharedCartController(
    super.controllerManager,
    this.getCartListUseCase,
    this.addToCartUseCase,
    this.removeFromCartUseCase,
    this.getSharedCartSummaryUseCase,
    this.getAdditionalItemUseCase,
    this.addAdditionalItemUseCase,
    this.changeAdditionalItemUseCase,
    this.removeAdditionalItemUseCase,
    this.addWishlistUseCase,
    this.createBucketUseCase,
    this.requestJoinBucketUseCase,
    this.checkBucketUseCase,
    this.showBucketByIdUseCase,
    this.getUserUseCase,
    this.approveOrRejectRequestBucketUseCase,
    this.removeMemberBucketUseCase,
    this.triggerBucketReadyUseCase,
    this.checkoutBucketUseCase,
    this.leaveBucketUseCase,
    this.destroyBucketUseCase
  );

  Future<LoadDataResult<List<Cart>>> getCartList(CartListParameter cartListParameter) {
    return getCartListUseCase.execute(cartListParameter).future(
      parameter: apiRequestManager.addRequestToCancellationPart("cart").value
    );
  }

  Future<LoadDataResult<List<AdditionalItem>>> getAdditionalItem(AdditionalItemListParameter additionalItemListParameter) {
    return getAdditionalItemUseCase.execute(additionalItemListParameter).future(
      parameter: apiRequestManager.addRequestToCancellationPart("get-additional-item").value
    );
  }

  Future<LoadDataResult<AddAdditionalItemResponse>> addAdditionalItem(AddAdditionalItemParameter addAdditionalItemParameter) {
    return addAdditionalItemUseCase.execute(addAdditionalItemParameter).future(
      parameter: apiRequestManager.addRequestToCancellationPart("add-additional-item").value
    );
  }

  Future<LoadDataResult<ChangeAdditionalItemResponse>> changeAdditionalItem(ChangeAdditionalItemParameter changeAdditionalItemParameter) {
    return changeAdditionalItemUseCase.execute(changeAdditionalItemParameter).future(
      parameter: apiRequestManager.addRequestToCancellationPart("change-additional-item").value
    );
  }

  Future<LoadDataResult<RemoveAdditionalItemResponse>> removeAdditionalItem(RemoveAdditionalItemParameter removeAdditionalItemParameter) {
    return removeAdditionalItemUseCase.execute(removeAdditionalItemParameter).future(
      parameter: apiRequestManager.addRequestToCancellationPart("remove-additional-item").value
    );
  }

  Future<LoadDataResult<ShowBucketByIdResponse>> showBucketByLoggedUserId() async {
    LoadDataResult<CheckBucketResponse> checkBucketResponseLoadDataResult = await checkBucketUseCase.execute(CheckBucketParameter()).future(
      parameter: apiRequestManager.addRequestToCancellationPart("check-bucket-parameter").value
    );
    if (checkBucketResponseLoadDataResult.isSuccess) {
      return await showBucketByIdUseCase.execute(
        ShowBucketByIdParameter(bucketId: checkBucketResponseLoadDataResult.resultIfSuccess!.bucketId)
      ).future(
        parameter: apiRequestManager.addRequestToCancellationPart("show-bucket-by-id").value
      );
    }
    // Return failed
    return checkBucketResponseLoadDataResult.map((_) => throw UnimplementedError());
  }

  Future<LoadDataResult<BucketMember>> getBucketMember({LoadDataResult<Bucket>? bucketLoadDataResult, LoadDataResult<User>? parameterUserLoadDataResult}) async {
    LoadDataResult<User> userLoadDataResult = parameterUserLoadDataResult ?? (await getUserUseCase.execute(GetUserParameter()).future(
      parameter: apiRequestManager.addRequestToCancellationPart("get-user").value
    ).map<User>(
      (value) => value.user
    ));
    if (userLoadDataResult.isSuccess) {
      return (bucketLoadDataResult ?? (await showBucketByLoggedUserId())).map<BucketMember>(
        (value) {
          Iterable<BucketMember> bucketMemberIterable = (value is Bucket ? value : (value as ShowBucketByIdResponse).bucket).bucketMemberList.where(
            (bucketMember) => userLoadDataResult.resultIfSuccess!.id == bucketMember.bucketUser.id
          );
          if (bucketMemberIterable.isNotEmpty) {
            return bucketMemberIterable.first;
          }
          throw NotFoundError(message: "Bucket member is not found.");
        }
      );
    }
    // Return failed
    return userLoadDataResult.map((_) => throw UnimplementedError());
  }

  Future<LoadDataResult<List<Cart>>> getSharedCartList({LoadDataResult<BucketMember>? bucketMemberParameterLoadDataResult}) async {
    LoadDataResult<BucketMember> bucketMemberLoadDataResult = bucketMemberParameterLoadDataResult ?? await getBucketMember();
    if (bucketMemberLoadDataResult.isSuccess) {
      return bucketMemberLoadDataResult.map<List<Cart>>((value) => value.bucketCartList);
    }
    if (bucketMemberLoadDataResult.isFailed) {
      dynamic result = bucketMemberLoadDataResult.resultIfFailed!;
      if (result is NotFoundError) {
        if (result.message.toLowerCase().contains("bucket member is not found")) {
          return SuccessLoadDataResult<List<Cart>>(value: []);
        }
      }
    }
    // Return failed
    return bucketMemberLoadDataResult.map((_) => throw UnimplementedError());
  }

  Future<LoadDataResult<User>> getUser() {
    return getUserUseCase.execute(GetUserParameter()).future(
      parameter: apiRequestManager.addRequestToCancellationPart("get-user").value
    ).map<User>(
      (value) => value.user
    );
  }

  void shareCartInfo() async {
    if (_mainSharedCartDelegate != null) {
      _mainSharedCartDelegate!.onUnfocusAllWidget();
      _mainSharedCartDelegate!.onSharedCartInfoLoadingCallback();
      LoadDataResult<ShowBucketByIdResponse> showBucketByIdResponseLoadDataResult = await showBucketByLoggedUserId();
      _mainSharedCartDelegate!.onCartBack();
      if (showBucketByIdResponseLoadDataResult.isSuccess) {
        _mainSharedCartDelegate!.onSharedCartInfoSuccessCallback(showBucketByIdResponseLoadDataResult.resultIfSuccess!);
      } else {
        _mainSharedCartDelegate!.onSharedCartInfoFailedCallback(showBucketByIdResponseLoadDataResult.resultIfFailed);
      }
    }
  }

  void leaveBucket() async {
    if (_mainSharedCartDelegate != null) {
      _mainSharedCartDelegate!.onUnfocusAllWidget();
      _mainSharedCartDelegate!.onLeaveBucketProcessLoadingCallback();
      LoadDataResult<LeaveBucketResponse> leaveBucketResponseLoadDataResult = await leaveBucketUseCase.execute(
        LeaveBucketParameter()
      ).future(
        parameter: apiRequestManager.addRequestToCancellationPart("leave-bucket").value
      );
      _mainSharedCartDelegate!.onCartBack();
      if (leaveBucketResponseLoadDataResult.isSuccess) {
        _mainSharedCartDelegate!.onLeaveBucketProcessSuccessCallback(leaveBucketResponseLoadDataResult.resultIfSuccess!);
      } else {
        _mainSharedCartDelegate!.onLeaveBucketProcessFailedCallback(leaveBucketResponseLoadDataResult.resultIfFailed);
      }
    }
  }

  void destroyBucket() async {
    if (_mainSharedCartDelegate != null) {
      _mainSharedCartDelegate!.onUnfocusAllWidget();
      _mainSharedCartDelegate!.onDestroyBucketProcessLoadingCallback();
      LoadDataResult<DestroyBucketResponse> destroyBucketResponseLoadDataResult = await destroyBucketUseCase.execute(
        DestroyBucketParameter()
      ).future(
        parameter: apiRequestManager.addRequestToCancellationPart("destroy-bucket").value
      );
      _mainSharedCartDelegate!.onCartBack();
      if (destroyBucketResponseLoadDataResult.isSuccess) {
        _mainSharedCartDelegate!.onDestroyBucketProcessSuccessCallback(destroyBucketResponseLoadDataResult.resultIfSuccess!);
      } else {
        _mainSharedCartDelegate!.onDestroyBucketProcessFailedCallback(destroyBucketResponseLoadDataResult.resultIfFailed);
      }
    }
  }

  void approveOrRejectRequestBucket(ApproveOrRejectRequestBucketParameter approveOrRejectRequestBucketParameter) async {
    if (_mainSharedCartDelegate != null) {
      _mainSharedCartDelegate!.onUnfocusAllWidget();
      _mainSharedCartDelegate!.onShowApproveOrRejectRequestBucketProcessLoadingCallback();
      LoadDataResult<ApproveOrRejectRequestBucketResponse> approveOrRejectRequestBucketResponseLoadDataResult = await approveOrRejectRequestBucketUseCase.execute(
        approveOrRejectRequestBucketParameter
      ).future(
        parameter: apiRequestManager.addRequestToCancellationPart("approve-or-reject-request-bucket").value
      );
      _mainSharedCartDelegate!.onCartBack();
      if (approveOrRejectRequestBucketResponseLoadDataResult.isSuccess) {
        _mainSharedCartDelegate!.onApproveOrRejectRequestBucketProcessSuccessCallback(approveOrRejectRequestBucketResponseLoadDataResult.resultIfSuccess!);
      } else {
        _mainSharedCartDelegate!.onShowApproveOrRejectRequestBucketProcessFailedCallback(approveOrRejectRequestBucketResponseLoadDataResult.resultIfFailed);
      }
    }
  }

  void removeMemberBucket(RemoveMemberBucketParameter removeMemberBucketParameter) async {
    if (_mainSharedCartDelegate != null) {
      _mainSharedCartDelegate!.onUnfocusAllWidget();
      _mainSharedCartDelegate!.onShowRemoveMemberRequestBucketProcessLoadingCallback();
      LoadDataResult<RemoveMemberBucketResponse> removeMemberBucketResponseLoadDataResult = await removeMemberBucketUseCase.execute(
        removeMemberBucketParameter
      ).future(
        parameter: apiRequestManager.addRequestToCancellationPart("approve-or-reject-request-bucket").value
      );
      _mainSharedCartDelegate!.onCartBack();
      if (removeMemberBucketResponseLoadDataResult.isSuccess) {
        _mainSharedCartDelegate!.onRemoveMemberRequestBucketProcessSuccessCallback(removeMemberBucketResponseLoadDataResult.resultIfSuccess!);
      } else {
        _mainSharedCartDelegate!.onShowRemoveMemberRequestBucketProcessFailedCallback(removeMemberBucketResponseLoadDataResult.resultIfFailed);
      }
    }
  }

  SharedCartController setMainSharedCartDelegate(MainSharedCartDelegate sharedCartDelegate) {
    _mainSharedCartDelegate = sharedCartDelegate;
    return this;
  }

  void addToWishlist(SupportWishlist supportWishlist) async {
    if (_mainSharedCartDelegate != null) {
      _mainSharedCartDelegate!.onUnfocusAllWidget();
      _mainSharedCartDelegate!.onShowAddToWishlistRequestProcessLoadingCallback();
      LoadDataResult<AddWishlistResponse> addWishlistResponseLoadDataResult = await addWishlistUseCase.execute(
        AddWishlistParameter(supportWishlist: supportWishlist)
      ).future(
        parameter: apiRequestManager.addRequestToCancellationPart('add-to-wishlist').value
      );
      _mainSharedCartDelegate!.onCartBack();
      if (addWishlistResponseLoadDataResult.isSuccess) {
        _mainSharedCartDelegate!.onAddToWishlistRequestProcessSuccessCallback();
      } else {
        _mainSharedCartDelegate!.onShowAddToWishlistRequestProcessFailedCallback(addWishlistResponseLoadDataResult.resultIfFailed);
      }
    }
  }

  void removeCart(Cart cart) async {
    if (_mainSharedCartDelegate != null) {
      _mainSharedCartDelegate!.onUnfocusAllWidget();
      _mainSharedCartDelegate!.onShowRemoveCartRequestProcessLoadingCallback();
      LoadDataResult<RemoveFromCartResponse> removeFromCartResponseLoadDataResult = await removeFromCartUseCase.execute(
        RemoveFromCartParameter(cart: cart, fromSharedCart: true)
      ).future(
        parameter: apiRequestManager.addRequestToCancellationPart('remove-from-cart').value
      );
      _mainSharedCartDelegate!.onCartBack();
      if (removeFromCartResponseLoadDataResult.isSuccess) {
        _mainSharedCartDelegate!.onRemoveCartRequestProcessSuccessCallback(cart);
      } else {
        _mainSharedCartDelegate!.onShowRemoveCartRequestProcessFailedCallback(removeFromCartResponseLoadDataResult.resultIfFailed);
      }
    }
  }

  void createOrder(String bucketId) async {
    if (_mainSharedCartDelegate != null) {
      _mainSharedCartDelegate!.onUnfocusAllWidget();
      _mainSharedCartDelegate!.onShowCheckoutBucketRequestProcessLoadingCallback();
      LoadDataResult<CheckoutBucketResponse> checkoutBucketLoadDataResult = await checkoutBucketUseCase.execute(
        CheckoutBucketParameter(
          bucketId: bucketId
        )
      ).future(
        parameter: apiRequestManager.addRequestToCancellationPart("checkout-bucket").value
      );
      _mainSharedCartDelegate!.onCartBack();
      if (checkoutBucketLoadDataResult.isSuccess) {
        _mainSharedCartDelegate!.onCheckoutBucketRequestProcessSuccessCallback(checkoutBucketLoadDataResult.resultIfSuccess!);
      } else {
        _mainSharedCartDelegate!.onShowCheckoutBucketRequestProcessFailedCallback(checkoutBucketLoadDataResult.resultIfFailed);
      }
    }
  }

  void triggerBucketReady() async {
    if (_mainSharedCartDelegate != null) {
      _mainSharedCartDelegate!.onUnfocusAllWidget();
      _mainSharedCartDelegate!.onShowTriggerBucketReadyProcessLoadingCallback();
      LoadDataResult<TriggerBucketReadyResponse> triggerBucketReadyLoadDataResult = await triggerBucketReadyUseCase.execute(
        TriggerBucketReadyParameter()
      ).future(
        parameter: apiRequestManager.addRequestToCancellationPart("trigger-bucket-ready").value
      );
      _mainSharedCartDelegate!.onCartBack();
      if (triggerBucketReadyLoadDataResult.isSuccess) {
        _mainSharedCartDelegate!.onTriggerBucketReadyProcessSuccessCallback(triggerBucketReadyLoadDataResult.resultIfSuccess!);
      } else {
        _mainSharedCartDelegate!.onShowTriggerBucketReadyProcessFailedCallback(triggerBucketReadyLoadDataResult.resultIfFailed);
      }
    }
  }

  void getSharedCartSummary(String bucketId) async {
    if (_mainSharedCartDelegate != null) {
      _mainSharedCartDelegate!.onShowSharedCartSummaryProcessCallback(IsLoadingLoadDataResult<CartSummary>());
      LoadDataResult<CartSummary> cartSummaryLoadDataResult = await getSharedCartSummaryUseCase.execute(
        SharedCartSummaryParameter(
          bucketId: bucketId
        )
      ).future(
        parameter: apiRequestManager.addRequestToCancellationPart("shared-cart-summary").value
      );
      if (cartSummaryLoadDataResult.isFailedBecauseCancellation) {
        return;
      }
      _mainSharedCartDelegate!.onShowSharedCartSummaryProcessCallback(cartSummaryLoadDataResult);
    }
  }
}

class MainSharedCartDelegate {
  OnUnfocusAllWidget onUnfocusAllWidget;
  _OnCartBack onCartBack;
  _OnShowAddToWishlistRequestProcessLoadingCallback onShowAddToWishlistRequestProcessLoadingCallback;
  _OnAddToWishlistRequestProcessSuccessCallback onAddToWishlistRequestProcessSuccessCallback;
  _OnShowAddToWishlistRequestProcessFailedCallback onShowAddToWishlistRequestProcessFailedCallback;
  _OnShowRemoveCartRequestProcessLoadingCallback onShowRemoveCartRequestProcessLoadingCallback;
  _OnRemoveCartRequestProcessSuccessCallback onRemoveCartRequestProcessSuccessCallback;
  _OnShowRemoveCartRequestProcessFailedCallback onShowRemoveCartRequestProcessFailedCallback;
  _OnShowCheckoutBucketRequestProcessLoadingCallback onShowCheckoutBucketRequestProcessLoadingCallback;
  _OnCheckoutBucketRequestProcessSuccessCallback onCheckoutBucketRequestProcessSuccessCallback;
  _OnShowCheckoutBucketRequestProcessFailedCallback onShowCheckoutBucketRequestProcessFailedCallback;
  _OnShowApproveOrRejectRequestBucketProcessLoadingCallback onShowApproveOrRejectRequestBucketProcessLoadingCallback;
  _OnApproveOrRejectRequestBucketProcessSuccessCallback onApproveOrRejectRequestBucketProcessSuccessCallback;
  _OnShowApproveOrRejectRequestBucketProcessFailedCallback onShowApproveOrRejectRequestBucketProcessFailedCallback;
  _OnShowRemoveMemberRequestBucketProcessLoadingCallback onShowRemoveMemberRequestBucketProcessLoadingCallback;
  _OnRemoveMemberRequestBucketProcessSuccessCallback onRemoveMemberRequestBucketProcessSuccessCallback;
  _OnShowRemoveMemberRequestBucketProcessFailedCallback onShowRemoveMemberRequestBucketProcessFailedCallback;
  _OnShowTriggerBucketReadyProcessLoadingCallback onShowTriggerBucketReadyProcessLoadingCallback;
  _OnTriggerBucketReadyProcessSuccessCallback onTriggerBucketReadyProcessSuccessCallback;
  _OnShowTriggerBucketReadyProcessFailedCallback onShowTriggerBucketReadyProcessFailedCallback;
  _OnShowSharedCartSummaryProcessCallback onShowSharedCartSummaryProcessCallback;
  _OnShareCartInfoProcessLoadingCallback onSharedCartInfoLoadingCallback;
  _OnShareCartInfoProcessSuccessCallback onSharedCartInfoSuccessCallback;
  _OnShareCartInfoProcessFailedCallback onSharedCartInfoFailedCallback;
  _OnDestroyBucketProcessLoadingCallback onDestroyBucketProcessLoadingCallback;
  _OnDestroyBucketProcessSuccessCallback onDestroyBucketProcessSuccessCallback;
  _OnDestroyBucketProcessFailedCallback onDestroyBucketProcessFailedCallback;
  _OnLeaveBucketProcessLoadingCallback onLeaveBucketProcessLoadingCallback;
  _OnLeaveBucketProcessSuccessCallback onLeaveBucketProcessSuccessCallback;
  _OnLeaveBucketProcessFailedCallback onLeaveBucketProcessFailedCallback;

  MainSharedCartDelegate({
    required this.onUnfocusAllWidget,
    required this.onCartBack,
    required this.onShowAddToWishlistRequestProcessLoadingCallback,
    required this.onAddToWishlistRequestProcessSuccessCallback,
    required this.onShowAddToWishlistRequestProcessFailedCallback,
    required this.onShowRemoveCartRequestProcessLoadingCallback,
    required this.onRemoveCartRequestProcessSuccessCallback,
    required this.onShowRemoveCartRequestProcessFailedCallback,
    required this.onShowCheckoutBucketRequestProcessLoadingCallback,
    required this.onCheckoutBucketRequestProcessSuccessCallback,
    required this.onShowCheckoutBucketRequestProcessFailedCallback,
    required this.onShowApproveOrRejectRequestBucketProcessLoadingCallback,
    required this.onApproveOrRejectRequestBucketProcessSuccessCallback,
    required this.onShowApproveOrRejectRequestBucketProcessFailedCallback,
    required this.onShowRemoveMemberRequestBucketProcessLoadingCallback,
    required this.onRemoveMemberRequestBucketProcessSuccessCallback,
    required this.onShowRemoveMemberRequestBucketProcessFailedCallback,
    required this.onShowTriggerBucketReadyProcessLoadingCallback,
    required this.onTriggerBucketReadyProcessSuccessCallback,
    required this.onShowTriggerBucketReadyProcessFailedCallback,
    required this.onShowSharedCartSummaryProcessCallback,
    required this.onSharedCartInfoSuccessCallback,
    required this.onSharedCartInfoFailedCallback,
    required this.onSharedCartInfoLoadingCallback,
    required this.onDestroyBucketProcessLoadingCallback,
    required this.onDestroyBucketProcessSuccessCallback,
    required this.onDestroyBucketProcessFailedCallback,
    required this.onLeaveBucketProcessLoadingCallback,
    required this.onLeaveBucketProcessSuccessCallback,
    required this.onLeaveBucketProcessFailedCallback,
  });
}