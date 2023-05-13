import 'package:flutter/material.dart';

class SkeletonGrid extends StatelessWidget {
  const SkeletonGrid({
    Key? key,
    required this.gridDelegate,
    required this.child,
    this.scrollDirection = Axis.vertical,
    this.itemCount = 20,
    this.padding,
  }) : super(key: key);

  final Widget child;
  final Axis scrollDirection;
  final int itemCount;
  final EdgeInsetsGeometry? padding;
  final SliverGridDelegate gridDelegate;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: padding,
      itemCount: itemCount,
      gridDelegate: gridDelegate,
      scrollDirection: scrollDirection,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, _) => child,
    );
  }
}
