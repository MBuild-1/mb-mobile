import '../../../misc/load_data_result.dart';
import '../../../misc/multi_language_string.dart';
import 'home_main_menu_component_entity.dart';

typedef DynamicItemAction<T> = void Function(MultiLanguageString? title, MultiLanguageString? description, LoadDataResult<T> itemLoadDataResult);
typedef ObserveDynamicItemAction<T> = T Function(MultiLanguageString? title, MultiLanguageString? description, LoadDataResult<T> itemLoadDataResult);

class DynamicItemCarouselHomeMainMenuComponentEntity extends HomeMainMenuComponentEntity {
  MultiLanguageString? title;
  MultiLanguageString? description;
  Future<void> Function(MultiLanguageString? title, MultiLanguageString? description, DynamicItemAction dynamicItemAction) onDynamicItemAction;
  ObserveDynamicItemAction? onObserveLoadingDynamicItemActionState;
  ObserveDynamicItemAction onObserveSuccessDynamicItemActionState;

  DynamicItemCarouselHomeMainMenuComponentEntity({
    this.title,
    this.description,
    required this.onDynamicItemAction,
    this.onObserveLoadingDynamicItemActionState,
    required this.onObserveSuccessDynamicItemActionState
  });
}