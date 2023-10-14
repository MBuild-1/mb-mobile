import '../../../../domain/entity/bucket/bucket.dart';
import '../../../../domain/entity/bucket/bucket_member.dart';
import '../../../../domain/entity/cart/cart.dart';
import '../../../../domain/entity/user/user.dart';
import '../../../acceptordeclinesharedcartmemberparameter/accept_or_decline_shared_cart_member_parameter.dart';
import '../../../errorprovider/error_provider.dart';
import '../../../load_data_result.dart';
import 'cart_container_list_item_controller_state.dart';

class SharedCartContainerListItemControllerState extends CartContainerListItemControllerState {
  LoadDataResult<Bucket> Function() bucketLoadDataResult;
  LoadDataResult<BucketMember> Function() bucketMemberLoadDataResult;
  LoadDataResult<List<Cart>> Function() cartListLoadDataResult;
  LoadDataResult<User> Function() userLoadDataResult;
  void Function(BucketMember) onExpandBucketMemberRequest;
  void Function() onUnExpandBucketMemberRequest;
  BucketMember? Function() onGetBucketMember;
  ErrorProvider Function() onGetErrorProvider;
  void Function(AcceptOrDeclineSharedCartMemberParameter) onAcceptOrDeclineSharedCart;
  void Function(BucketMember) onRemoveSharedCartMember;

  SharedCartContainerListItemControllerState({
    required this.bucketLoadDataResult,
    required this.bucketMemberLoadDataResult,
    required this.cartListLoadDataResult,
    required this.userLoadDataResult,
    required this.onExpandBucketMemberRequest,
    required this.onUnExpandBucketMemberRequest,
    required this.onGetBucketMember,
    required this.onGetErrorProvider,
    required this.onAcceptOrDeclineSharedCart,
    required this.onRemoveSharedCartMember,
    required super.cartListItemControllerStateList,
    required super.onUpdateState,
    required super.onScrollToAdditionalItemsSection,
    required super.onChangeSelected,
    required super.onCartChange,
    required super.cartContainerStateStorageListItemControllerState,
    required super.cartContainerActionListItemControllerState,
    required super.cartContainerInterceptingActionListItemControllerState,
    required super.additionalItemList
  });
}