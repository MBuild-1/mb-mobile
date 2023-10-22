import 'package:flutter/material.dart';

import 'list_item_controller_state.dart';

typedef WidgetSubstitution = Widget Function(BuildContext context, int index);
typedef WidgetSubstitutionWithInjection = Widget Function(BuildContext context, int index, List<Widget>);
typedef OnInjectListItemControllerState = List<ListItemControllerState> Function();

class WidgetSubstitutionListItemControllerState extends ListItemControllerState {
  WidgetSubstitution widgetSubstitution;

  WidgetSubstitutionListItemControllerState({
    required this.widgetSubstitution
  });
}

class WidgetSubstitutionWithInjectionListItemControllerState extends ListItemControllerState {
  OnInjectListItemControllerState? onInjectListItemControllerState;
  WidgetSubstitutionWithInjection widgetSubstitutionWithInjection;

  WidgetSubstitutionWithInjectionListItemControllerState({
    required this.widgetSubstitutionWithInjection,
    this.onInjectListItemControllerState,
  });
}