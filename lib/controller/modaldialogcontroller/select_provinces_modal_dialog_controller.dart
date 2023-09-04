import '../../domain/entity/province/province_map.dart';
import '../../domain/entity/province/province_map_list_parameter.dart';
import '../../domain/usecase/get_province_map_use_case.dart';
import '../../misc/load_data_result.dart';
import '../../misc/manager/controller_manager.dart';
import 'modal_dialog_controller.dart';

class SelectProvincesModalDialogController extends ModalDialogController {
  final GetProvinceMapUseCase getProvinceMapUseCase;

  SelectProvincesModalDialogController(
    ControllerManager? controllerManager,
    this.getProvinceMapUseCase
  ) : super(controllerManager);

  Future<LoadDataResult<List<ProvinceMap>>> getProvinceList(ProvinceMapListParameter provinceMapListParameter) {
    return getProvinceMapUseCase.execute(provinceMapListParameter).future(
      parameter: apiRequestManager.addRequestToCancellationPart("province").value
    );
  }
}