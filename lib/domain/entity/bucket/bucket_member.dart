import '../additionalitem/additional_item.dart';
import '../cart/cart.dart';
import 'bucket_user.dart';

class BucketMember {
  String id;
  String bucketId;
  String userId;
  int hostBucket;
  BucketUser bucketUser;
  List<Cart> bucketCartList;
  List<AdditionalItem> bucketWarehouseAdditionalItemList;
  int status;

  BucketMember({
    required this.id,
    required this.bucketId,
    required this.userId,
    required this.hostBucket,
    required this.bucketUser,
    required this.bucketCartList,
    required this.bucketWarehouseAdditionalItemList,
    required this.status
  });
}