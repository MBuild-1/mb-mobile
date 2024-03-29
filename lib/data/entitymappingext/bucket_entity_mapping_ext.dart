import 'package:masterbagasi/data/entitymappingext/additional_item_entity_mapping_ext.dart';
import 'package:masterbagasi/data/entitymappingext/cart_entity_mapping_ext.dart';
import 'package:masterbagasi/data/entitymappingext/order_entity_mapping_ext.dart';
import 'package:masterbagasi/misc/ext/response_wrapper_ext.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';

import '../../domain/entity/bucket/approveorrejectrequestbucket/approve_or_reject_request_bucket_response.dart';
import '../../domain/entity/bucket/bucket.dart';
import '../../domain/entity/bucket/bucket_member.dart';
import '../../domain/entity/bucket/bucket_user.dart';
import '../../domain/entity/bucket/checkbucket/check_bucket_response.dart';
import '../../domain/entity/bucket/checkoutbucket/checkout_bucket_response.dart';
import '../../domain/entity/bucket/checkoutbucket/checkout_bucket_version_1_point_1_response.dart';
import '../../domain/entity/bucket/createbucket/create_bucket_response.dart';
import '../../domain/entity/bucket/destroybucket/destroy_bucket_response.dart';
import '../../domain/entity/bucket/leavebucket/leave_bucket_response.dart';
import '../../domain/entity/bucket/removememberbucket/remove_member_bucket_response.dart';
import '../../domain/entity/bucket/requestjoinbucket/request_join_bucket_response.dart';
import '../../domain/entity/bucket/showbucketbyid/show_bucket_by_id_response.dart';
import '../../domain/entity/bucket/triggerbucketready/trigger_bucket_ready_response.dart';
import '../../domain/entity/cart/cart.dart';
import '../../misc/response_wrapper.dart';

extension BucketDetailEntityMappingExt on ResponseWrapper {
  CreateBucketResponse mapFromResponseToCreateBucketResponse() {
    return CreateBucketResponse();
  }

  RemoveMemberBucketResponse mapFromResponseToRemoveMemberBucketResponse() {
    return RemoveMemberBucketResponse();
  }

  RequestJoinBucketResponse mapFromResponseToRequestJoinBucketResponse() {
    return RequestJoinBucketResponse();
  }

  ShowBucketByIdResponse mapFromResponseToShowBucketByIdResponse() {
    return ShowBucketByIdResponse(
      bucket: ResponseWrapper(response).mapFromResponseToBucket()
    );
  }

  ApproveOrRejectRequestBucketResponse mapFromResponseToApproveOrRejectRequestBucketResponse() {
    return ApproveOrRejectRequestBucketResponse();
  }

  CheckBucketResponse mapFromResponseToCheckBucketResponse() {
    return CheckBucketResponse(
      bucketId: response
    );
  }

  CheckoutBucketResponse mapFromResponseToCheckoutBucketResponse() {
    return CheckoutBucketResponse(
      order: ResponseWrapper(response).mapFromResponseToSharedCartOrder()
    );
  }

  CheckoutBucketVersion1Point1Response mapFromResponseToCheckoutBucketVersion1Point1Response() {
    dynamic paymentResponse = response["payment"];
    return CheckoutBucketVersion1Point1Response(
      transactionId: paymentResponse["transaction_id"],
      orderId: paymentResponse["order_id"],
      combinedOrderId: paymentResponse["combined_order_id"]
    );
  }


  TriggerBucketReadyResponse mapFromResponseToTriggerBucketReadyResponse() {
    return TriggerBucketReadyResponse();
  }

  DestroyBucketResponse mapFromResponseToDestroyBucketResponse() {
    return DestroyBucketResponse();
  }

  LeaveBucketResponse mapFromResponseToLeaveBucketResponse() {
    return LeaveBucketResponse();
  }

  Bucket mapFromResponseToBucket() {
    return Bucket(
      id: response["id"],
      userId: response["user_id"],
      bucketUsername: response["bucket_username"],
      bucketPassword: response["bucket_password"],
      totalWeight: ResponseWrapper(response["total_weight"]).mapFromResponseToDouble(),
      totalPrice: ResponseWrapper(response["total_price"]).mapFromResponseToDouble(),
      totalMember: ResponseWrapper(response["total_member"]).mapFromResponseToInt()!,
      bucketUser: ResponseWrapper(response["user"]).mapFromResponseToBucketUser(),
      bucketMemberList: response["bucket_list"].map<BucketMember>(
        (bucketRequestResponse) => ResponseWrapper(bucketRequestResponse).mapFromResponseToBucketMember()
      ).toList(),
      bucketMemberRequestList: response["bucket_list_request"].map<BucketMember>(
        (bucketRequestResponse) => ResponseWrapper(bucketRequestResponse).mapFromResponseToBucketMember()
      ).toList(),
    );
  }

  BucketUser mapFromResponseToBucketUser() {
    return BucketUser(
      id: response["id"],
      name: response["name"],
      role: ResponseWrapper(response["role"]).mapFromResponseToInt()!,
      email: (response["email"] as String?).toEmptyStringNonNull
    );
  }

  BucketMember mapFromResponseToBucketMember() {
    bool isRequest = false;
    if (response is Map<String, dynamic>) {
      Map<String, dynamic> responseMap = response as Map<String, dynamic>;
      isRequest = responseMap.containsKey("bucket_cart_list_request");
    }
    return BucketMember(
      id: response["id"],
      bucketId: response["bucket_id"],
      userId: response["user_id"],
      hostBucket: ResponseWrapper(response["host_bucket"]).mapFromResponseToInt()!,
      status: response["status"] != null ? ResponseWrapper(response["status"]).mapFromResponseToInt()! : -1,
      bucketUser: ResponseWrapper(response["user"]).mapFromResponseToBucketUser(),
      bucketCartList: response[isRequest ? "bucket_cart_list_request" : "bucket_cart_list"].map<Cart>(
        (bucketRequestResponse) => ResponseWrapper(bucketRequestResponse).mapFromResponseToCart([], [])
      ).toList(),
      bucketWarehouseAdditionalItemList: response["bucket_warehouse_lists"] != null ? ResponseWrapper(response["bucket_warehouse_lists"]).mapFromResponseToAdditionalItemList() : []
    );
  }
}