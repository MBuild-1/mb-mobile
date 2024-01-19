import 'package:flutter/material.dart';

import 'modified_scaffold.dart';

class BackgroundAppBarScaffold extends StatelessWidget {
  final ImageProvider backgroundAppBarImage;
  final AppBar appBar;
  final Widget body;
  final bool withModifiedScaffold;

  const BackgroundAppBarScaffold({
    super.key,
    required this.backgroundAppBarImage,
    required this.appBar,
    required this.body,
    this.withModifiedScaffold = true
  });

  @override
  Widget build(BuildContext context) {
    Widget content = Stack(
      children: [
        Container(
          height: kToolbarHeight + MediaQuery.of(context).viewPadding.top,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: backgroundAppBarImage,
              fit: BoxFit.cover
            )
          ),
        ),
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
    ) : Scaffold(
      body: content
    );
  }
}