import 'package:flutter/material.dart';

class SkeletonList extends StatelessWidget {
  const SkeletonList({
    Key? key,
    this.itemExtent,
    required this.child,
    this.scrollDirection = Axis.vertical,
    this.itemCount = 20,
    this.padding,
  }) : super(key: key);

  final double? itemExtent;
  final Widget child;
  final Axis scrollDirection;
  final int itemCount;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: padding,
      itemCount: itemCount,
      itemExtent: itemExtent,
      scrollDirection: scrollDirection,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, _) => child,
    );
  }
}
