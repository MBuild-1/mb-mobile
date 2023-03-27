import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';
import 'package:masterbagasi/misc/ext/paging_ext.dart';

import '../domain/entity/homemainmenucomponententity/dynamic_item_carousel_home_main_menu_component_entity.dart';
import '../domain/entity/homemainmenucomponententity/home_main_menu_component_entity.dart';
import '../domain/entity/product/productbrand/product_brand.dart';
import '../domain/entity/product/productbrand/product_brand_detail.dart';
import '../domain/entity/product/productbrand/product_brand_detail_parameter.dart';
import '../domain/entity/product/productbrand/product_brand_list_parameter.dart';
import '../domain/usecase/get_product_brand_detail_use_case.dart';
import '../misc/constant.dart';
import '../misc/entityandlistitemcontrollerstatemediator/horizontal_component_entity_parameterized_entity_and_list_item_controller_state_mediator.dart';
import '../misc/injector.dart';
import '../misc/load_data_result.dart';
import '../misc/multi_language_string.dart';
import 'base_getx_controller.dart';

class ProductBrandDetailController extends BaseGetxController {
  final GetProductBrandDetailUseCase getProductBrandDetailUseCase;

  ProductBrandDetailController(super.controllerManager, this.getProductBrandDetailUseCase);

  Future<LoadDataResult<ProductBrandDetail>> getProductBrandDetail(ProductBrandDetailParameter productBrandDetailParameter) {
    return getProductBrandDetailUseCase.execute(productBrandDetailParameter).future(
      parameter: apiRequestManager.addRequestToCancellationPart("product-brand-detail").value
    );
  }
}