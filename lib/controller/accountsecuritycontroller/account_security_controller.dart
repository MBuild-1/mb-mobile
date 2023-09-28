import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';

import '../../domain/entity/componententity/dynamic_item_carousel_directly_component_entity.dart';
import '../../domain/entity/componententity/i_component_entity.dart';
import '../../domain/entity/pin/checkactivepin/check_active_pin_parameter.dart';
import '../../domain/entity/pin/checkactivepin/check_active_pin_response.dart';
import '../../domain/usecase/check_active_pin_use_case.dart';
import '../../misc/controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../../misc/entityandlistitemcontrollerstatemediator/horizontal_component_entity_parameterized_entity_and_list_item_controller_state_mediator.dart';
import '../../misc/error/message_error.dart';
import '../../misc/load_data_result.dart';
import '../../misc/multi_language_string.dart';
import '../base_getx_controller.dart';

class AccountSecurityController extends BaseGetxController {
  AccountSecurityDelegate? _accountSecurityDelegate;
  final CheckActivePinUseCase checkActivePinUseCase;

  AccountSecurityController(
    super.controllerManager,
    this.checkActivePinUseCase
  );

  void setAccountSecurityDelegate(AccountSecurityDelegate accountSecurityDelegate) {
    _accountSecurityDelegate = accountSecurityDelegate;
  }

  IComponentEntity getPinMenuList() {
    RepeatableDynamicItemCarouselAdditionalParameter repeatableDynamicItemCarouselAdditionalParameter = RepeatableDynamicItemCarouselAdditionalParameter();
    return DynamicItemCarouselDirectlyComponentEntity(
      title: MultiLanguageString(""),
      onDynamicItemAction: (title, description, observer) async {
        observer(title, description, IsLoadingLoadDataResult<CheckActivePinResponse>());
        LoadDataResult<CheckActivePinResponse> checkActivePinResponseLoadDataResult = await checkActivePinUseCase.execute(
          CheckActivePinParameter()
        ).future(
          parameter: apiRequestManager.addRequestToCancellationPart("check-active-pin").value
        );
        if (checkActivePinResponseLoadDataResult.isFailedBecauseCancellation) {
          return;
        }
        observer(title, description, checkActivePinResponseLoadDataResult);
      },
      observeDynamicItemActionStateDirectly: (title, description, itemLoadDataResult, errorProvider) {
        LoadDataResult<CheckActivePinResponse> checkActivePinResponseLoadDataResult = itemLoadDataResult.castFromDynamic<CheckActivePinResponse>();
        if (_accountSecurityDelegate != null) {
          return _accountSecurityDelegate!.onObserveCheckActivePinDirectly(
            _OnObserveCheckActivePinDirectlyParameter(
              checkActivePinResponseLoadDataResult: checkActivePinResponseLoadDataResult,
              repeatableDynamicItemCarouselAdditionalParameter: repeatableDynamicItemCarouselAdditionalParameter
            )
          );
        } else {
          throw MessageError(title: "Account security delegate must be not null");
        }
      },
      dynamicItemCarouselAdditionalParameter: repeatableDynamicItemCarouselAdditionalParameter
    );
  }
}

class AccountSecurityDelegate {
  ListItemControllerState Function(_OnObserveCheckActivePinDirectlyParameter) onObserveCheckActivePinDirectly;

  AccountSecurityDelegate({
    required this.onObserveCheckActivePinDirectly
  });
}

class _OnObserveCheckActivePinDirectlyParameter {
  LoadDataResult<CheckActivePinResponse> checkActivePinResponseLoadDataResult;
  RepeatableDynamicItemCarouselAdditionalParameter repeatableDynamicItemCarouselAdditionalParameter;

  _OnObserveCheckActivePinDirectlyParameter({
    required this.checkActivePinResponseLoadDataResult,
    required this.repeatableDynamicItemCarouselAdditionalParameter
  });
}