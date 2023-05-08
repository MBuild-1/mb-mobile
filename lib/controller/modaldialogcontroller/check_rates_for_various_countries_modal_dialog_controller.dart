import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/rx_ext.dart';

import '../../domain/entity/cargo/cargo.dart';
import '../../domain/entity/cargo/cargo_list_parameter.dart';
import '../../domain/usecase/check_rates_for_various_countries_use_case.dart';
import '../../misc/load_data_result.dart';
import '../../misc/manager/controller_manager.dart';
import 'modal_dialog_controller.dart';

class CheckRatesForVariousCountriesModalDialogController extends ModalDialogController {
  final CheckRatesForVariousCountriesUseCase checkRatesForVariousCountriesUseCase;

  LoadDataResult<List<Cargo>> _cargoLoadDataResult = NoLoadDataResult<List<Cargo>>();
  late Rx<LoadDataResultWrapper<List<Cargo>>> cargoLoadDataResultWrapperRx;
  bool _hasInitCartSummary = false;

  CheckRatesForVariousCountriesModalDialogController(
    ControllerManager? controllerManager,
    this.checkRatesForVariousCountriesUseCase
  ) : super(controllerManager) {
    cargoLoadDataResultWrapperRx = LoadDataResultWrapper<List<Cargo>>(_cargoLoadDataResult).obs;
  }
}