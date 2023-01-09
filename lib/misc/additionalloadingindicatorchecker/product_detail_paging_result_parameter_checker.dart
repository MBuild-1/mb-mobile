import '../controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../paging/pagingresult/paging_result_with_parameter.dart';
import 'additional_paging_result_parameter_checker.dart';

class ProductDetailPagingResultParameterChecker extends AdditionalPagingResultParameterChecker<int, ListItemControllerState> {
  @override
  PagingResultParameter<ListItemControllerState>? getAdditionalPagingResultParameter(
    AdditionalPagingResultCheckerParameter additionalPagingResultCheckerParameter
  ) {
    return null;
  }
}