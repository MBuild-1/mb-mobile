class DurationString {
  String hoursString;
  String minutesString;
  String secondsString;

  DurationString({
    required this.hoursString,
    required this.minutesString,
    required this.secondsString
  });

  @override
  String toString() {
    return "$hoursString:$minutesString:$secondsString";
  }
}