import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../misc/countdown/countdown_component_data.dart';
import '../../misc/countdown/countdown_component_delegate.dart';
import '../../misc/duration_string.dart';
import '../../misc/string_util.dart';

class CountdownIndicator extends StatefulWidget {
  final CountdownComponentDelegate countdownComponentDelegate;
  final Widget Function(DurationString)? onUpdateWidget;

  const CountdownIndicator({
    super.key,
    required this.countdownComponentDelegate,
    this.onUpdateWidget,
  });

  @override
  State<CountdownIndicator> createState() => _CountdownIndicatorState();
}

class _CountdownIndicatorState extends State<CountdownIndicator> {
  CountdownComponentData? _countdownComponentData;
  String _countdownIndicatorKey = "";

  @override
  void initState() {
    super.initState();
    _countdownComponentData = widget.countdownComponentDelegate.countdownComponentData();
    _changeOnUpdateStateValue(
      (countdownComponentData) {
        _countdownComponentData = countdownComponentData;
        setState(() {});
      },
      generateKey: true
    );
  }

  void _checkIsDefaultCountdownComponentDelegate(void Function(DefaultCountdownComponentDelegate) isDefaultCountdownComponentDelegate) {
    CountdownComponentDelegate countdownComponentDelegate = widget.countdownComponentDelegate;
    if (countdownComponentDelegate is DefaultCountdownComponentDelegate) {
      isDefaultCountdownComponentDelegate(countdownComponentDelegate);
    }
  }

  void _changeOnUpdateStateValue(void Function(CountdownComponentData)? onUpdateState, {bool generateKey = false}) {
    _checkIsDefaultCountdownComponentDelegate((defaultCountdownComponentDelegate) {
      if (generateKey) {
        String newKey = "";
        Iterable<String> keyStringIterables = defaultCountdownComponentDelegate._onUpdateState.keys;
        String countdownIndicatorKeyText(int number) {
          return "countdown-indicator-$number";
        }
        if (keyStringIterables.isEmpty) {
          newKey = countdownIndicatorKeyText(1);
        } else {
          int i = 1;
          while (true) {
            bool isEmpty = keyStringIterables.where((value) => value.contains(i.toString())).isEmpty;
            if (isEmpty) {
              newKey = countdownIndicatorKeyText(i);
              break;
            }
            i++;
          }
        }
        _countdownIndicatorKey = newKey;
      }
      defaultCountdownComponentDelegate._onUpdateState[_countdownIndicatorKey] = onUpdateState;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_countdownComponentData == null) {
      return Container();
    }
    CountdownComponentDelegate countdownComponentDelegate = widget.countdownComponentDelegate;
    return countdownComponentDelegate.onBuildWidget(
      StringUtil.toDurationStringFromMilliSeconds(_countdownComponentData!.milliseconds)
    );
  }

  @override
  void dispose() {
    _changeOnUpdateStateValue(null);
    super.dispose();
  }
}

class DefaultCountdownComponentDelegate extends CountdownComponentDelegate {
  CountdownComponentData Function()? _countdownComponentData;
  final Map<String, void Function(CountdownComponentData)?> _onUpdateState = {};
  final Widget Function(DurationString)? _onBuildWidget;
  dynamic tag;

  DefaultCountdownComponentDelegate({
    CountdownComponentData Function()? countdownComponentData,
    Widget Function(DurationString)? onBuildWidget,
    this.tag
  }) : _onBuildWidget = onBuildWidget;

  @override
  CountdownComponentData Function() get countdownComponentData => () {
    if (_countdownComponentData != null) {
      return _countdownComponentData!();
    }
    throw UnimplementedError();
  };

  set countdownComponentData(CountdownComponentData Function()? value) {
    _countdownComponentData = value;
  }

  @override
  void Function(CountdownComponentData) get onUpdateState => (countdownComponentData) {
    for (var onUpdateStateValue in _onUpdateState.entries) {
      if (onUpdateStateValue.value != null) {
        onUpdateStateValue.value!(countdownComponentData);
      }
    }
  };

  @override
  Widget Function(DurationString) get onBuildWidget => (durationString) {
    if (_onBuildWidget != null) {
      return _onBuildWidget!(durationString);
    }
    Widget timeTextWidget(String timeString) {
      return Text(
        timeString,
        style: const TextStyle(
          fontSize: 35,
          fontWeight: FontWeight.bold
        ),
      );
    }
    Widget timeDescriptionTextWidget(String timeString) {
      return Text(
        timeString,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold
        ),
      );
    }
    Widget dotTextWidget() {
      return Column(
        children: [
          timeTextWidget(" : ")
        ]
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            timeTextWidget(durationString.hoursString),
            timeDescriptionTextWidget("Hours".tr)
          ],
        ),
        dotTextWidget(),
        Column(
          children: [
            timeTextWidget(durationString.minutesString),
            timeDescriptionTextWidget("Minutes".tr)
          ],
        ),
        dotTextWidget(),
        Column(
          children: [
            timeTextWidget(durationString.secondsString),
            timeDescriptionTextWidget("Seconds".tr)
          ],
        )
      ]
    );
  };
}

class DefaultCountdownComponentDelegateTagData {
  String tagString;
  int countdownValue;
  DateTime expiredDateTime;
  void Function()? onRefresh;

  DefaultCountdownComponentDelegateTagData({
    required this.tagString,
    required this.countdownValue,
    required this.expiredDateTime,
    this.onRefresh
  });
}