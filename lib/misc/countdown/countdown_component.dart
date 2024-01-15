import 'dart:async';

import 'countdown_component_data.dart';

class CountdownComponent {
  CountdownComponentData countdownComponentData;
  Timer Function(CountdownComponentData) onInstantiateTimer;

  Timer? _countdownTimer;
  Timer get countdownTimer => _countdownTimer!;

  CountdownComponent({
    required this.countdownComponentData,
    required this.onInstantiateTimer
  }) {
    _countdownTimer = onInstantiateTimer(countdownComponentData);
  }

  void dispose() {
    countdownTimer.cancel();
  }
}