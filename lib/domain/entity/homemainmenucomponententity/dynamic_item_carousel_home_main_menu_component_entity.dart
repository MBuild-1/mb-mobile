import '../../../misc/load_data_result.dart';
import '../../../misc/multi_language_string.dart';
import '../componententity/i_dynamic_item_carousel_component_entity.dart';
import 'home_main_menu_component_entity.dart';

typedef DynamicItemAction<T> = void Function(MultiLanguageString? title, MultiLanguageString? description, LoadDataResult<T> itemLoadDataResult);
typedef ObserveDynamicItemAction<T> = T Function(MultiLanguageString? title, MultiLanguageString? description, LoadDataResult<T> itemLoadDataResult);

class DynamicItemCarouselHomeMainMenuComponentEntity extends HomeMainMenuComponentEntity implements IDynamicItemCarouselComponentEntity {
  MultiLanguageString? _title;
  MultiLanguageString? _description;
  Future<void> Function(MultiLanguageString? title, MultiLanguageString? description, DynamicItemAction dynamicItemAction) _onDynamicItemAction;
  ObserveDynamicItemAction? _onObserveLoadingDynamicItemActionState;
  ObserveDynamicItemAction _onObserveSuccessDynamicItemActionState;

  DynamicItemCarouselHomeMainMenuComponentEntity({
    MultiLanguageString? title,
    MultiLanguageString? description,
    required Future<void> Function(MultiLanguageString? title, MultiLanguageString? description, DynamicItemAction dynamicItemAction) onDynamicItemAction,
    ObserveDynamicItemAction? onObserveLoadingDynamicItemActionState,
    required ObserveDynamicItemAction onObserveSuccessDynamicItemActionState
  }) : _title = title,
      _description = description,
      _onDynamicItemAction = onDynamicItemAction,
      _onObserveLoadingDynamicItemActionState = onObserveLoadingDynamicItemActionState,
      _onObserveSuccessDynamicItemActionState = onObserveSuccessDynamicItemActionState;

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
  ObserveDynamicItemAction? get onObserveLoadingDynamicItemActionState => _onObserveLoadingDynamicItemActionState;

  @override
  set onObserveLoadingDynamicItemActionState(ObserveDynamicItemAction? value) => _onObserveLoadingDynamicItemActionState = value;

  @override
  ObserveDynamicItemAction get onObserveSuccessDynamicItemActionState => _onObserveSuccessDynamicItemActionState;

  @override
  set onObserveSuccessDynamicItemActionState(ObserveDynamicItemAction value) => _onObserveSuccessDynamicItemActionState = value;
}