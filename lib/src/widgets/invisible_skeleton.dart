import 'package:flutter/material.dart';
import 'package:skeleton_builder/src/widgets/skeletonizer.dart';

class InvisibleSkeleton extends StatelessWidget {
  const InvisibleSkeleton({
    super.key,
    required this.child,
    this.visible = false,
    this.replacement = const ColoredBox(color: Colors.black),
  });

  final bool visible;
  final Widget child;
  final Widget replacement;

  @override
  Widget build(BuildContext context) {
    final isVisible = visible || !Skeletonizer.of(context).loading;
    return isVisible ? child : replacement;
  }
}
