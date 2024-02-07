import 'package:flutter/material.dart';

import '../duration_string.dart';
import 'countdown_component_data.dart';

abstract class CountdownComponentDelegate {
  CountdownComponentData Function() get countdownComponentData;
  void Function(CountdownComponentData) get onUpdateState;
  Widget Function(DurationString) get onBuildWidget;
}