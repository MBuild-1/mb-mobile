import '../../domain/entity/bucket/bucket_member.dart';

abstract class AcceptOrDeclineSharedCartMemberParameter {
  BucketMember bucketMember;

  AcceptOrDeclineSharedCartMemberParameter({
    required this.bucketMember
  });
}