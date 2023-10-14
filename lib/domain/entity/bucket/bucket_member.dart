import '../cart/cart.dart';
import 'bucket_user.dart';

class BucketMember {
  String id;
  String bucketId;
  String userId;
  int hostBucket;
  BucketUser bucketUser;
  List<Cart> bucketCartList;

  BucketMember({
    required this.id,
    required this.bucketId,
    required this.userId,
    required this.hostBucket,
    required this.bucketUser,
    required this.bucketCartList
  });
}