import '../cart/cart.dart';
import 'bucket_member.dart';
import 'bucket_user.dart';

class Bucket {
  String id;
  String userId;
  String bucketUsername;
  String bucketPassword;
  double? totalWeight;
  double? totalPrice;
  int totalMember;
  BucketUser bucketUser;
  List<BucketMember> bucketMemberList;
  List<BucketMember> bucketMemberRequestList;

  Bucket({
    required this.id,
    required this.userId,
    required this.bucketUsername,
    required this.bucketPassword,
    required this.totalWeight,
    required this.totalPrice,
    required this.totalMember,
    required this.bucketUser,
    required this.bucketMemberList,
    required this.bucketMemberRequestList
  });
}