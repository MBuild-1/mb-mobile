import 'configuration/configure_countdown_component.dart';
import 'countdown_component_data_and_delegate.dart';

class GetCountdownComponentDataAction {
  void Function(ConfigureCountdownComponent) onConfigureCountdownComponentToSummaryValue;
  void Function(List<CountdownComponentDataAndDelegate>) onGetCountdownComponentDataAndDelegateList;

  GetCountdownComponentDataAction({
    required this.onConfigureCountdownComponentToSummaryValue,
    required this.onGetCountdownComponentDataAndDelegateList
  });
}