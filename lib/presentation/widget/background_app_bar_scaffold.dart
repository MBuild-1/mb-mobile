import 'package:flutter/material.dart';

import '../../misc/backgroundappbarscaffoldtype/background_app_bar_scaffold_type.dart';
import '../../misc/backgroundappbarscaffoldtype/color_background_app_bar_scaffold_type.dart';
import '../../misc/backgroundappbarscaffoldtype/image_background_app_bar_scaffold_type.dart';
import 'modified_scaffold.dart';

class BackgroundAppBarScaffold extends StatelessWidget {
  final BackgroundAppBarScaffoldType backgroundAppBarScaffoldType;
  final AppBar appBar;
  final Widget body;
  final bool withModifiedScaffold;
  final Color? backgroundColor;

  const BackgroundAppBarScaffold({
    super.key,
    required this.backgroundAppBarScaffoldType,
    required this.appBar,
    required this.body,
    this.withModifiedScaffold = true,
    this.backgroundColor
  });

  @override
  Widget build(BuildContext context) {
    Widget content = Stack(
      children: [
        () {
          return Container(
            height: kToolbarHeight + MediaQuery.of(context).viewPadding.top,
            decoration: BoxDecoration(
              color: backgroundAppBarScaffoldType is ColorBackgroundAppBarScaffoldType
                ? (backgroundAppBarScaffoldType as ColorBackgroundAppBarScaffoldType).color
                : null,
              image: backgroundAppBarScaffoldType is ImageBackgroundAppBarScaffoldType
                ? DecorationImage(
                  image: (backgroundAppBarScaffoldType as ImageBackgroundAppBarScaffoldType).backgroundAppBarImage,
                  fit: BoxFit.cover
                )
                : null
            ),
          );
        }(),
        SafeArea(
          bottom: false,
          child: Column(
            children: [
              appBar,
              body
            ]
          )
        ),
      ]
    );
    return withModifiedScaffold ? ModifiedScaffold(
      body: content,
      backgroundColor: backgroundColor,
    ) : Scaffold(
      body: content,
      backgroundColor: backgroundColor
    );
  }
}