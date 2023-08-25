import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/rx_ext.dart';

import '../../domain/entity/address/country.dart';
import '../../domain/entity/cargo/cargo.dart';
import '../../domain/entity/cargo/cargo_list_parameter.dart';
import '../../domain/entity/delivery/country_delivery_review_based_country_parameter.dart';
import '../../domain/entity/delivery/country_delivery_review_response.dart';
import '../../domain/usecase/check_rates_for_various_countries_use_case.dart';
import '../../domain/usecase/get_country_delivery_review_use_case.dart';
import '../../misc/load_data_result.dart';
import '../../misc/manager/controller_manager.dart';
import 'modal_dialog_controller.dart';

typedef _OnGetSelectedCountry = Country? Function();

class CheckRatesForVariousCountriesModalDialogController extends ModalDialogController {
  final CheckRatesForVariousCountriesUseCase checkRatesForVariousCountriesUseCase;
  final GetCountryDeliveryReviewUseCase getCountryDeliveryReviewUseCase;

  LoadDataResult<List<Cargo>> _cargoLoadDataResult = NoLoadDataResult<List<Cargo>>();
  LoadDataResult<CountryDeliveryReviewResponse> _countryDeliveryReviewLoadDataResult = NoLoadDataResult<CountryDeliveryReviewResponse>();
  late Rx<LoadDataResultWrapper<List<Cargo>>> cargoLoadDataResultWrapperRx;
  late Rx<LoadDataResultWrapper<CountryDeliveryReviewResponse>> countryDeliveryReviewLoadDataResultWrapperRx;
  late Rx<CheckRatesForVariousCountriesResult> checkRatesForVariousCountriesResultRx;

  CartDelegate? _cartDelegate;

  CheckRatesForVariousCountriesModalDialogController(
    ControllerManager? controllerManager,
    this.checkRatesForVariousCountriesUseCase,
    this.getCountryDeliveryReviewUseCase
  ) : super(controllerManager) {
    cargoLoadDataResultWrapperRx = LoadDataResultWrapper<List<Cargo>>(_cargoLoadDataResult).obs;
    countryDeliveryReviewLoadDataResultWrapperRx = LoadDataResultWrapper<CountryDeliveryReviewResponse>(_countryDeliveryReviewLoadDataResult).obs;
    checkRatesForVariousCountriesResultRx = CheckRatesForVariousCountriesResult(
      cargoLoadDataResult: _cargoLoadDataResult,
      countryDeliveryReviewLoadDataResult: _countryDeliveryReviewLoadDataResult
    ).obs;
  }

  void loadCargo() async {
    if (_cartDelegate != null) {
      Country? selectedCountry = _cartDelegate!.onGetSelectedCountry();
      if (selectedCountry != null) {
        _cargoLoadDataResult = IsLoadingLoadDataResult<List<Cargo>>();
        _updateCheckRatesForVariousCountriesState();
        _cargoLoadDataResult = await checkRatesForVariousCountriesUseCase.execute(
          CargoListParameter(zoneId: selectedCountry.zoneId)
        ).future(
          parameter: apiRequestManager.addRequestToCancellationPart("cargo").value
        );
        _updateCheckRatesForVariousCountriesState();
      }
    }
  }

  void loadCountryDeliveryReview() async {
    if (_cartDelegate != null) {
      Country? selectedCountry = _cartDelegate!.onGetSelectedCountry();
      if (selectedCountry != null) {
        _countryDeliveryReviewLoadDataResult = IsLoadingLoadDataResult<CountryDeliveryReviewResponse>();
        _updateCheckRatesForVariousCountriesState();
        _countryDeliveryReviewLoadDataResult = await getCountryDeliveryReviewUseCase.execute(
          CountryDeliveryReviewBasedCountryParameter(countryId: selectedCountry.id)
        ).future(
          parameter: apiRequestManager.addRequestToCancellationPart("country-delivery-review").value
        );
        _updateCheckRatesForVariousCountriesState();
      }
    }
  }

  void _updateCheckRatesForVariousCountriesState() {
    cargoLoadDataResultWrapperRx.valueFromLast(
      (value) => LoadDataResultWrapper<List<Cargo>>(_cargoLoadDataResult)
    );
    countryDeliveryReviewLoadDataResultWrapperRx.valueFromLast(
      (value) => LoadDataResultWrapper<CountryDeliveryReviewResponse>(_countryDeliveryReviewLoadDataResult)
    );
    checkRatesForVariousCountriesResultRx.valueFromLast(
      (value) => CheckRatesForVariousCountriesResult(
        cargoLoadDataResult: _cargoLoadDataResult,
        countryDeliveryReviewLoadDataResult: _countryDeliveryReviewLoadDataResult
      )
    );
    update();
  }

  CheckRatesForVariousCountriesModalDialogController setCartDelegate(CartDelegate cartDelegate) {
    _cartDelegate = cartDelegate;
    return this;
  }
}

class CartDelegate {
  _OnGetSelectedCountry onGetSelectedCountry;

  CartDelegate({
    required this.onGetSelectedCountry
  });
}

class CheckRatesForVariousCountriesResult {
  LoadDataResult<List<Cargo>> cargoLoadDataResult;
  LoadDataResult<CountryDeliveryReviewResponse> countryDeliveryReviewLoadDataResult;

  CheckRatesForVariousCountriesResult({
    required this.cargoLoadDataResult,
    required this.countryDeliveryReviewLoadDataResult
  });
}