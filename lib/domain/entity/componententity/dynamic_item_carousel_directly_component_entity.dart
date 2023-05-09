import '../../../misc/multi_language_string.dart';
import '../homemainmenucomponententity/dynamic_item_carousel_home_main_menu_component_entity.dart';
import 'i_dynamic_item_carousel_directly_component_entity.dart';

class DynamicItemCarouselDirectlyComponentEntity<T> implements IDynamicItemCarouselDirectlyComponentEntity<T> {
  MultiLanguageString? _title;
  MultiLanguageString? _description;
  Future<void> Function(MultiLanguageString? title, MultiLanguageString? description, DynamicItemAction dynamicItemAction) _onDynamicItemAction;
  ObserveDynamicItemActionDirectly? _onObserveDynamicItemActionStateDirectly;

  DynamicItemCarouselDirectlyComponentEntity({
    MultiLanguageString? title,
    MultiLanguageString? description,
    required Future<void> Function(MultiLanguageString? title, MultiLanguageString? description, DynamicItemAction dynamicItemAction) onDynamicItemAction,
    ObserveDynamicItemActionDirectly? observeDynamicItemActionStateDirectly,
  }) : _title = title,
      _description = description,
      _onDynamicItemAction = onDynamicItemAction,
      _onObserveDynamicItemActionStateDirectly = observeDynamicItemActionStateDirectly;

  @override
  MultiLanguageString? get title => _title;

  @override
  set title(MultiLanguageString? value) => _title = value;

  @override
  MultiLanguageString? get description => _description;

  @override
  set description(MultiLanguageString? value) => _description = value;

  @override
  Future<void> Function(MultiLanguageString? title, MultiLanguageString? description, DynamicItemAction dynamicItemAction) get onDynamicItemAction => _onDynamicItemAction;

  @override
  set onDynamicItemAction(Function(MultiLanguageString? title, MultiLanguageString? description, DynamicItemAction dynamicItemAction) value) => _onDynamicItemAction = onDynamicItemAction;

  @override
  ObserveDynamicItemActionDirectly? get onObserveDynamicItemActionStateDirectly => _onObserveDynamicItemActionStateDirectly;

  @override
  set onObserveDynamicItemActionStateDirectly(ObserveDynamicItemActionDirectly? value) => _onObserveDynamicItemActionStateDirectly = value;
}