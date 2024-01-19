import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';

import '../../misc/constant.dart';
import '../../misc/multi_language_string.dart';

class ModifiedScaffold extends StatelessWidget {
  final bool extendBody;
  final bool extendBodyBehindAppBar;
  final PreferredSizeWidget? appBar;
  final Widget? body;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final FloatingActionButtonAnimator? floatingActionButtonAnimator;
  final List<Widget>? persistentFooterButtons;
  final AlignmentDirectional persistentFooterAlignment;
  final Widget? drawer;
  final DrawerCallback? onDrawerChanged;
  final Widget? endDrawer;
  final DrawerCallback? onEndDrawerChanged;
  final Color? drawerScrimColor;
  final Color? backgroundColor;
  final Widget? bottomNavigationBar;
  final Widget? bottomSheet;
  final bool? resizeToAvoidBottomInset;
  final bool primary;
  final DragStartBehavior drawerDragStartBehavior;
  final double? drawerEdgeDragWidth;
  final bool drawerEnableOpenDragGesture;
  final bool endDrawerEnableOpenDragGesture;
  final String? restorationId;

  const ModifiedScaffold({
    super.key,
    this.appBar,
    this.body,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.floatingActionButtonAnimator,
    this.persistentFooterButtons,
    this.persistentFooterAlignment = AlignmentDirectional.centerEnd,
    this.drawer,
    this.onDrawerChanged,
    this.endDrawer,
    this.onEndDrawerChanged,
    this.bottomNavigationBar,
    this.bottomSheet,
    this.backgroundColor,
    this.resizeToAvoidBottomInset,
    this.primary = true,
    this.drawerDragStartBehavior = DragStartBehavior.start,
    this.extendBody = false,
    this.extendBodyBehindAppBar = false,
    this.drawerScrimColor,
    this.drawerEdgeDragWidth,
    this.drawerEnableOpenDragGesture = true,
    this.endDrawerEnableOpenDragGesture = true,
    this.restorationId
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: ModifiedScaffoldContainer(
        body: body,
      ),
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      floatingActionButtonAnimator: floatingActionButtonAnimator,
      persistentFooterButtons: persistentFooterButtons,
      persistentFooterAlignment: persistentFooterAlignment,
      drawer: drawer,
      onDrawerChanged: onDrawerChanged,
      endDrawer: endDrawer,
      onEndDrawerChanged: onEndDrawerChanged,
      bottomNavigationBar: bottomNavigationBar,
      bottomSheet: bottomSheet,
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      primary: primary,
      drawerDragStartBehavior: drawerDragStartBehavior,
      extendBody: extendBody,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      drawerScrimColor: drawerScrimColor,
      drawerEdgeDragWidth: drawerEdgeDragWidth,
      drawerEnableOpenDragGesture: drawerEnableOpenDragGesture,
      endDrawerEnableOpenDragGesture: endDrawerEnableOpenDragGesture,
      restorationId: restorationId,
    );
  }
}

class ModifiedScaffoldContainer extends StatelessWidget {
  final Widget? body;

  const ModifiedScaffoldContainer({
    super.key,
    required this.body
  });

  @override
  Widget build(BuildContext context) {
    return body != null ? Column(
      children: [
        Expanded(child: body!),
        Builder(
          builder: (context) {
            String environment = Constant.envValueEnvironment;
            if (environment.contains("staging") || environment.contains("local_dev")) {
              Color containerColor = () {
                if (environment.contains("staging")) {
                  return Colors.orange;
                }
                return Constant.colorGrey8;
              }();
              String? text = () {
                if (environment.contains("staging")) {
                  return MultiLanguageString({
                    Constant.textInIdLanguageKey: "Anda berada di mode environment STAGING.",
                    Constant.textEnUsLanguageKey: "You are in STAGING environment mode."
                  }).toEmptyStringNonNull;
                } else if (environment.contains("local_dev")) {
                  return MultiLanguageString({
                    Constant.textInIdLanguageKey: "Anda berada di mode environment LOCAL DEV.",
                    Constant.textEnUsLanguageKey: "You are in LOCAL DEV environment mode."
                  }).toEmptyStringNonNull;
                }
                return null;
              }();
              return Container(
                width: double.infinity,
                color: containerColor,
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Center(
                  child: Text(
                    text.toStringNonNull,
                    style: const TextStyle(color: Colors.white),
                  ),
                )
              );
            }
            return const SizedBox();
          }
        )
      ],
    ) : body!;
  }
}