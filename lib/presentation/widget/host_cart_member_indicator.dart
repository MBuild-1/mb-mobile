import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';

import '../../domain/entity/bucket/bucket_member.dart';
import '../../domain/entity/bucket/bucket_user.dart';
import '../../misc/constant.dart';
import '../../misc/multi_language_string.dart';

class HostCartMemberIndicator extends StatelessWidget {
  final BucketMember bucketMember;
  final int memberNo;
  final bool isMe;

  const HostCartMemberIndicator({
    super.key,
    required this.bucketMember,
    required this.memberNo,
    required this.isMe
  });

  @override
  Widget build(BuildContext context) {
    BucketUser bucketUser = bucketMember.bucketUser;
    String isMeText = isMe ? () {
      MultiLanguageString isMeMultiLanguageString = MultiLanguageString({
        Constant.textEnUsLanguageKey: "Me",
        Constant.textInIdLanguageKey: "Saya"
      });
      return " (${isMeMultiLanguageString.toStringNonNull})";
    }() : "";
    String usernameString = "@${bucketUser.name}$isMeText";
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Tooltip(
            message: usernameString,
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Constant.colorDarkBlue),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Builder(
                    builder: (context) {
                      return Flexible(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
                          child: Text(
                            usernameString,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )
                        ),
                      );
                    }
                  ),
                  if (memberNo > 0) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
                      color: Constant.colorDarkBlue,
                      child: Text("Member #$memberNo".tr, style: const TextStyle(color: Colors.white)),
                    )
                  ]
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}