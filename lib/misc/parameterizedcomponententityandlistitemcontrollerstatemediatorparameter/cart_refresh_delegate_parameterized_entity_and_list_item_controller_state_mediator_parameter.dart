import '../entityandlistitemcontrollerstatemediator/horizontal_component_entity_parameterized_entity_and_list_item_controller_state_mediator.dart';
import 'parameterized_entity_and_list_item_controller_state_mediator_parameter.dart';

class CartRefreshDelegateParameterizedEntityAndListItemControllerStateMediatorParameter extends ParameterizedEntityAndListItemControllerStateMediatorParameter {
  void Function(RepeatableDynamicItemCarouselAdditionalParameter) onGetRepeatableDynamicItemCarouselAdditionalParameter;

  CartRefreshDelegateParameterizedEntityAndListItemControllerStateMediatorParameter({
    required this.onGetRepeatableDynamicItemCarouselAdditionalParameter
  });
}