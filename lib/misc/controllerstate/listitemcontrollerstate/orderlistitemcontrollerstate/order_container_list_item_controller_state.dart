import 'package:masterbagasi/presentation/widget/colorful_chip_tab_bar.dart';

import '../../../../domain/entity/order/combined_order.dart';
import '../../../errorprovider/error_provider.dart';
import '../../../load_data_result.dart';
import '../../../paging/pagingresult/paging_data_result.dart';
import '../list_item_controller_state.dart';

class OrderContainerListItemControllerState extends ListItemControllerState {
  List<CombinedOrder> orderList;
  void Function() onUpdateState;
  void Function(CombinedOrder) onOrderTap;
  void Function(CombinedOrder) onBuyAgainTap;
  void Function(CombinedOrder) onConfirmArrived;
  ColorfulChipTabBarController orderTabColorfulChipTabBarController;
  List<ColorfulChipTabBarData> orderColorfulChipTabBarDataList;
  ErrorProvider errorProvider;
  OrderContainerStateStorageListItemControllerState orderContainerStateStorageListItemControllerState;
  OrderContainerInterceptingActionListItemControllerState orderContainerInterceptingActionListItemControllerState;

  OrderContainerListItemControllerState({
    required this.orderList,
    required this.onUpdateState,
    required this.onOrderTap,
    required this.onBuyAgainTap,
    required this.onConfirmArrived,
    required this.orderTabColorfulChipTabBarController,
    required this.orderColorfulChipTabBarDataList,
    required this.errorProvider,
    required this.orderContainerStateStorageListItemControllerState,
    required this.orderContainerInterceptingActionListItemControllerState
  });
}

abstract class OrderContainerStateStorageListItemControllerState extends ListItemControllerState {}

abstract class OrderContainerInterceptingActionListItemControllerState extends ListItemControllerState {
  void Function(LoadDataResult<PagingDataResult<CombinedOrder>>)? get onRefreshCombinedOrderPagingDataResult;
}