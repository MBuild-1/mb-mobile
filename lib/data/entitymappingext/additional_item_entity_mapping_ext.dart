import 'package:masterbagasi/misc/ext/response_wrapper_ext.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';

import '../../domain/entity/additionalitem/add_additional_item_response.dart';
import '../../domain/entity/additionalitem/additional_item.dart';
import '../../domain/entity/additionalitem/change_additional_item_response.dart';
import '../../domain/entity/additionalitem/remove_additional_item_response.dart';
import '../../domain/entity/additionalitem/with_image_additional_item.dart';
import '../../misc/paging/pagingresult/paging_data_result.dart';
import '../../misc/response_wrapper.dart';

extension AdditionalItemEntityMappingExt on ResponseWrapper {
  List<AdditionalItem> mapFromResponseToAdditionalItemList() {
    return response.map<AdditionalItem>((additionalItemResponse) => ResponseWrapper(additionalItemResponse).mapFromResponseToAdditionalItem()).toList();
  }

  PagingDataResult<AdditionalItem> mapFromResponseToAdditionalItemPaging() {
    return ResponseWrapper(response).mapFromResponseToPagingDataResult(
      (dataResponse) => dataResponse.map<AdditionalItem>(
        (additionalItemResponse) => ResponseWrapper(additionalItemResponse).mapFromResponseToAdditionalItem()
      ).toList()
    );
  }
}

extension AdditionalItemDetailEntityMappingExt on ResponseWrapper {
  AdditionalItem mapFromResponseToAdditionalItem() {
    Map<String, dynamic> responseMap = response as Map<String, dynamic>;
    AdditionalItem resultAdditionalItem = AdditionalItem(
      id: responseMap["id"],
      name: responseMap["name"],
      estimationWeight: ResponseWrapper(responseMap["weight"]).mapFromResponseToDouble()!,
      estimationPrice: ResponseWrapper(responseMap["price"]).mapFromResponseToDouble()!,
      quantity: responseMap["quantity"],
      notes: responseMap["notes"] ?? "",
    );
    if (responseMap.containsKey("image")) {
      dynamic imageUrl = responseMap["image"];
      if (imageUrl is String?) {
        return WithImageAdditionalItem(
          id: resultAdditionalItem.id,
          name: resultAdditionalItem.name,
          estimationWeight: resultAdditionalItem.estimationWeight,
          estimationPrice: resultAdditionalItem.estimationPrice,
          quantity: resultAdditionalItem.quantity,
          notes: resultAdditionalItem.notes,
          imageUrl: responseMap["image"] as String?
        );
      }
    }
    return resultAdditionalItem;
  }
}

extension AddAdditionalItemResponseDetailEntityMappingExt on ResponseWrapper {
  AddAdditionalItemResponse mapFromResponseToAddAdditionalItemResponse() {
    return AddAdditionalItemResponse();
  }
}

extension ChangeAdditionalItemResponseDetailEntityMappingExt on ResponseWrapper {
  ChangeAdditionalItemResponse mapFromResponseToChangeAdditionalItemResponse() {
    return ChangeAdditionalItemResponse();
  }
}

extension RemoveAdditionalItemResponseDetailEntityMappingExt on ResponseWrapper {
  RemoveAdditionalItemResponse mapFromResponseToRemoveAdditionalItemResponse() {
    return RemoveAdditionalItemResponse();
  }
}