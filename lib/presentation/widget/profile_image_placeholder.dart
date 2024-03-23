import 'package:flutter/material.dart';

class ProfileImagePlaceholder extends StatelessWidget {
  final double diameter;
  final Color backgroundColor;
  final bool withShadow;

  const ProfileImagePlaceholder({
    Key? key,
    required this.diameter,
    this.backgroundColor = Colors.white,
    this.withShadow = false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget circleAvatar = CircleAvatar(
      backgroundColor: backgroundColor,
      radius: diameter,
      child: Icon(
        Icons.person_outline,
        color: Theme.of(context).colorScheme.primary,
        size: diameter - 10
      ),
    );
    return withShadow ? Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            blurRadius: 2,
            spreadRadius: 1.5,
            color: Colors.black.withOpacity(0.5)
          )
        ],
        shape: BoxShape.circle
      ),
      child: circleAvatar
    ) : circleAvatar;
  }
}