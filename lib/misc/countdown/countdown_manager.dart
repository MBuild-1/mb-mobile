import 'countdown_component.dart';

class CountdownManager {
  List<CountdownComponent> countdownComponentList;

  CountdownManager({
    required this.countdownComponentList
  });

  void dispose() {
    for (var countdownComponent in countdownComponentList) {
      countdownComponent.dispose();
    }
    countdownComponentList.clear();
  }
}