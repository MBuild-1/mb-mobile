import '../duration_string.dart';
import '../string_util.dart';

class CountdownComponentData {
  late DurationString _lastDurationString;
  DurationString get _currentDurationString => StringUtil.toDurationStringFromMilliSeconds(milliseconds);
  int milliseconds;

  void checkLastAndCurrentDurationStringEquality(void Function() onIsNotEqual) {
    if (_lastDurationString.toString() != _currentDurationString.toString()) {
      onIsNotEqual();
      _lastDurationString = _currentDurationString;
    }
  }

  CountdownComponentData({
    required this.milliseconds
  }) {
    _lastDurationString = _currentDurationString;
  }
}