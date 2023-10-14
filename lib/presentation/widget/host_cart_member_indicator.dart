import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../domain/entity/bucket/bucket_member.dart';
import '../../domain/entity/bucket/bucket_user.dart';
import '../../misc/constant.dart';

class HostCartMemberIndicator extends StatelessWidget {
  final BucketMember bucketMember;
  final int memberNo;

  const HostCartMemberIndicator({
    super.key,
    required this.bucketMember,
    required this.memberNo
  });

  @override
  Widget build(BuildContext context) {
    BucketUser bucketUser = bucketMember.bucketUser;
    return Wrap(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: Constant.colorDarkBlue),
          ),
          clipBehavior: Clip.antiAlias,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
                child: Text("@${bucketUser.name}", style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold))
              ),
              if (memberNo > 0) ...[
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
                  color: Constant.colorDarkBlue,
                  child: Text("Member #$memberNo".tr, style: const TextStyle(color: Colors.white)),
                )
              ]
            ],
          )
        ),
      ]
    );
  }
}