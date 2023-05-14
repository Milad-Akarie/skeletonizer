import 'package:flutter/material.dart';

class SkeletonList extends StatelessWidget {
  const SkeletonList({
    Key? key,
    this.itemExtent,
    required this.child,
    this.scrollDirection = Axis.vertical,
    this.itemCount = 20,
    this.protoTypeitem,
    this.padding,
  }) : super(key: key);

  final double? itemExtent;
  final Widget child;
  final Widget? protoTypeitem;
  final Axis scrollDirection;
  final int itemCount;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: padding,
      itemCount: itemCount,
      prototypeItem: protoTypeitem,
      itemExtent: itemExtent,
      scrollDirection: scrollDirection,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, _) => child,
    );
  }

  static SliverMultiBoxAdaptorWidget sliver({
    required Widget child,
    double? itemExtent,
    int itemCount = 10,
    Widget? protoTypeitem,
  }) {
    final delegate = SliverChildBuilderDelegate(
      (context, _) => child,
      childCount: itemCount,
    );
    if (itemExtent != null) {
      return SliverFixedExtentList(
        delegate: delegate,
        itemExtent: itemExtent!,
      );
    } else if (protoTypeitem != null) {
      return SliverPrototypeExtentList(
        delegate: delegate,
        prototypeItem: protoTypeitem!,
      );
    }
    return SliverList(delegate: delegate);
  }
}
