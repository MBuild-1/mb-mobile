import '../../../misc/multi_language_string.dart';
import 'home_main_menu_component_entity.dart';

class ItemCarouselHomeMainMenuComponentEntity<T> extends HomeMainMenuComponentEntity {
  MultiLanguageString? title;
  MultiLanguageString? description;
  List<T> item;

  ItemCarouselHomeMainMenuComponentEntity({
    this.title,
    this.description,
    required this.item
  });
}