import 'package:flutter/material.dart';

import 'list_item_controller_state.dart';

class ShimmerContainerListItemControllerState extends ListItemControllerState {
  ListItemControllerState shimmerChildListItemControllerState;

  ShimmerContainerListItemControllerState({
    required this.shimmerChildListItemControllerState
  });
}