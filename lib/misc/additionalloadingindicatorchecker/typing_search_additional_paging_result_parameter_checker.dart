import '../controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/no_content_list_item_controller_state.dart';
import '../paging/pagingresult/paging_result_with_parameter.dart';
import 'additional_paging_result_parameter_checker.dart';

class TypingSearchAdditionalPagingResultParameterChecker extends AdditionalPagingResultParameterChecker<int, ListItemControllerState> {
  @override
  PagingResultParameter<ListItemControllerState>? getAdditionalPagingResultParameter(AdditionalPagingResultCheckerParameter<int, ListItemControllerState> additionalPagingResultCheckerParameter) {
    return PagingResultParameter<ListItemControllerState>(
      additionalItemList: [
        NoContentListItemControllerState()
      ],
      showOriginalLoaderIndicator: false
    );
  }
}