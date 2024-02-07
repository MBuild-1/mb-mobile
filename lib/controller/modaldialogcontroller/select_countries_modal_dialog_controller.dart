import '../../domain/entity/address/country.dart';
import '../../domain/entity/address/country_list_parameter.dart';
import '../../domain/usecase/get_country_list_use_case.dart';
import '../../misc/load_data_result.dart';
import '../../misc/manager/controller_manager.dart';
import 'modal_dialog_controller.dart';

class SelectCountriesModalDialogController extends ModalDialogController {
  final GetCountryListUseCase getCountryListUseCase;

  SelectCountriesModalDialogController(
    ControllerManager? controllerManager,
    this.getCountryListUseCase
  ) : super(controllerManager);

  Future<LoadDataResult<List<Country>>> getCountryList(CountryListParameter countryListParameter) {
    return getCountryListUseCase.execute(countryListParameter).future(
      parameter: apiRequestManager.addRequestToCancellationPart("country").value
    );
  }
}