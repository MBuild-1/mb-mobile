import 'dart:async';

import 'package:flutter/material.dart';

import '../../presentation/widget/material_ignore_pointer.dart';
import 'extended_get_modal_bottom_sheet_route.dart';

class ExtendedGetDialogRoute<T> extends DialogRoute<T> {
  RoutePageBuilderInterceptor? routePageBuilderInterceptor;

  ExtendedGetDialogRoute({
    required super.context,
    required super.builder,
    CapturedThemes? themes,
    super.barrierColor = Colors.black54,
    super.barrierDismissible,
    String? barrierLabel,
    bool useSafeArea = true,
    super.settings,
    super.anchorPoint,
    this.routePageBuilderInterceptor
  });

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    Widget builtWidget = super.buildPage(context, animation, secondaryAnimation);
    return routePageBuilderInterceptor != null ? routePageBuilderInterceptor!(
      builtWidget, context, animation, secondaryAnimation
    ) : ExtendedGetDialogWidget(
      child: builtWidget,
      animation: animation,
      secondaryAnimation: secondaryAnimation
    );
  }
}

class ExtendedGetDialogWidget extends StatefulWidget {
  final Widget child;
  final Animation<double> animation;
  final Animation<double> secondaryAnimation;

  const ExtendedGetDialogWidget({
    Key? key,
    required this.child,
    required this.animation,
    required this.secondaryAnimation
  }) : super(key: key);

  @override
  ExtendedGetDialogWidgetState createState() => ExtendedGetDialogWidgetState();
}

class ExtendedGetDialogWidgetState extends State<ExtendedGetDialogWidget> {
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}