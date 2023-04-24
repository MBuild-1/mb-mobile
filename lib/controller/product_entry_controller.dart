import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';

import '../domain/entity/componententity/dynamic_item_carousel_directly_component_entity.dart';
import '../domain/entity/componententity/i_component_entity.dart';
import '../domain/entity/product/product_with_condition_paging_parameter.dart';
import '../domain/entity/product/productentry/product_entry.dart';
import '../domain/entity/product/productentry/product_entry_header_content_parameter.dart';
import '../domain/entity/product/productentry/product_entry_header_content_response.dart';
import '../domain/usecase/get_product_entry_header_content_use_case.dart';
import '../domain/usecase/get_product_entry_with_condition_paging_use_case.dart';
import '../misc/controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../misc/error/message_error.dart';
import '../misc/load_data_result.dart';
import '../misc/multi_language_string.dart';
import '../misc/on_observe_load_product_delegate.dart';
import '../misc/paging/pagingresult/paging_data_result.dart';
import 'base_getx_controller.dart';

class ProductEntryController extends BaseGetxController {
  final GetProductEntryWithConditionPagingUseCase getProductEntryWithConditionPagingUseCase;
  final GetProductEntryHeaderContentUseCase getProductEntryHeaderContentUseCase;
  ProductEntryDelegate? _productEntryDelegate;

  ProductEntryController(
    super.controllerManager,
    this.getProductEntryWithConditionPagingUseCase,
    this.getProductEntryHeaderContentUseCase
  );

  IComponentEntity getProductEntryHeader(ProductEntryHeaderContentParameter productEntryHeaderContentParameter) {
    return DynamicItemCarouselDirectlyComponentEntity(
      title: MultiLanguageString(""),
      onDynamicItemAction: (title, description, observer) async {
        observer(title, description, IsLoadingLoadDataResult<ProductEntryHeaderContentResponse>());
        LoadDataResult<ProductEntryHeaderContentResponse> productEntryHeaderContentResponseLoadDataResult = await getProductEntryHeaderContentUseCase.execute(
          productEntryHeaderContentParameter
        ).future(
          parameter: apiRequestManager.addRequestToCancellationPart("product-entry-header").value
        );
        if (productEntryHeaderContentResponseLoadDataResult.isFailedBecauseCancellation) {
          return;
        }
        observer(title, description, productEntryHeaderContentResponseLoadDataResult);
      },
      observeDynamicItemActionStateDirectly: (title, description, itemLoadDataResult, errorProvider) {
        LoadDataResult<ProductEntryHeaderContentResponse> productEntryHeaderContentResponseLoadDataResult = itemLoadDataResult.castFromDynamic<ProductEntryHeaderContentResponse>();
        if (_productEntryDelegate != null) {
          return _productEntryDelegate!.onObserveLoadProductEntryHeaderContentDirectly(
            _OnObserveLoadProductEntryHeaderContentDirectlyParameter(
              productEntryHeaderContentResponseLoadDataResult: productEntryHeaderContentResponseLoadDataResult
            )
          );
        } else {
          throw MessageError(title: "Product Entry delegate must be not null");
        }
      },
    );
  }

  Future<LoadDataResult<PagingDataResult<ProductEntry>>> getProductEntryPaging(ProductWithConditionPagingParameter productWithConditionPagingParameter) {
    return getProductEntryWithConditionPagingUseCase.execute(productWithConditionPagingParameter).future(
      parameter: apiRequestManager.addRequestToCancellationPart("product-entry-paging").value
    );
  }

  void setProductEntryDelegate(ProductEntryDelegate productEntryDelegate) {
    _productEntryDelegate = productEntryDelegate;
  }
}

class ProductEntryDelegate {
  OnObserveLoadProductDelegate onObserveLoadProductDelegate;
  ListItemControllerState Function(_OnObserveLoadProductEntryHeaderContentDirectlyParameter) onObserveLoadProductEntryHeaderContentDirectly;

  ProductEntryDelegate({
    required this.onObserveLoadProductDelegate,
    required this.onObserveLoadProductEntryHeaderContentDirectly,
  });
}

class _OnObserveLoadProductEntryHeaderContentDirectlyParameter {
  LoadDataResult<ProductEntryHeaderContentResponse> productEntryHeaderContentResponseLoadDataResult;

  _OnObserveLoadProductEntryHeaderContentDirectlyParameter({
    required this.productEntryHeaderContentResponseLoadDataResult
  });
}