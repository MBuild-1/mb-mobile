import 'package:flutter/material.dart';

class ExtendedWillPopScope extends StatefulWidget {
  final WillPopCallback? onWillPop;
  final Widget child;

  const ExtendedWillPopScope({
    super.key,
    required this.onWillPop,
    required this.child,
  });

  @override
  State<ExtendedWillPopScope> createState() => _ExtendedWillPopScopeState();
}

class _ExtendedWillPopScopeState extends State<ExtendedWillPopScope> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: null,
      child: widget.child
    );
  }
}