import '../../presentation/widget/titleanddescriptionitem/title_and_description_item.dart';
import '../carouselbackground/carousel_background.dart';
import '../carousellistitemtype/carousel_list_item_type.dart';
import 'parameterized_entity_and_list_item_controller_state_mediator_parameter.dart';

class CarouselParameterizedEntityAndListItemControllerStateMediatorParameter extends ParameterizedEntityAndListItemControllerStateMediatorParameter {
  CarouselBackground? carouselBackground;
  TitleInterceptor? titleInterceptor;
  CarouselListItemType? carouselListItemType;
  ParameterizedEntityAndListItemControllerStateMediatorParameter? additionalParameter;

  CarouselParameterizedEntityAndListItemControllerStateMediatorParameter({
    required this.carouselBackground,
    this.titleInterceptor,
    this.carouselListItemType,
    this.additionalParameter
  });
}