import 'package:masterbagasi/misc/ext/future_ext.dart';

import '../domain/entity/address/address.dart';
import '../domain/entity/address/current_selected_address_parameter.dart';
import '../domain/entity/cart/cart.dart';
import '../domain/entity/cart/cart_paging_parameter.dart';
import '../domain/usecase/get_current_selected_address_use_case.dart';
import '../domain/usecase/get_my_cart_use_case.dart';
import '../misc/load_data_result.dart';
import '../misc/paging/pagingresult/paging_data_result.dart';
import 'base_getx_controller.dart';

class DeliveryController extends BaseGetxController {
  final GetMyCartUseCase getMyCartUseCase;
  final GetCurrentSelectedAddressUseCase getCurrentSelectedAddressUseCase;

  DeliveryController(
    super.controllerManager,
    this.getMyCartUseCase,
    this.getCurrentSelectedAddressUseCase
  );

  Future<LoadDataResult<PagingDataResult<Cart>>> getDeliveryCartPaging(CartPagingParameter cartPagingParameter) {
    return getMyCartUseCase.execute(cartPagingParameter).future(
      parameter: apiRequestManager.addRequestToCancellationPart("cart").value
    );
  }

  Future<LoadDataResult<Address>> getCurrentSelectedAddress(CurrentSelectedAddressParameter currentSelectedAddressParameter) {
    return getCurrentSelectedAddressUseCase.execute(currentSelectedAddressParameter).future(
      parameter: apiRequestManager.addRequestToCancellationPart("cart").value
    ).map<Address>((currentSelectedAddressResponse) {
      return currentSelectedAddressResponse.address;
    });
  }
}