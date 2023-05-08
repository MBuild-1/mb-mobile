import '../selectcountrieslistitemcontrollerstate/country_list_item_controller_state.dart';

class VerticalCountryListItemControllerState extends CountryListItemControllerState {
  VerticalCountryListItemControllerState({
    required super.country,
    super.onSelectCountry,
    required super.isSelected
  });
}