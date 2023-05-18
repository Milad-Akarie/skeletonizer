import 'package:flutter/material.dart';

class FixedExtentSliverHeader extends StatelessWidget {
  const FixedExtentSliverHeader({
    Key? key,
    required this.maxExtent,
    this.child,
  }) : super(key: key);
  final double maxExtent;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      delegate: _FixedExtentSliverHeaderDelegate(
        child: child ?? const SizedBox(),
        extent: maxExtent,
      ),
    );
  }
}

class _FixedExtentSliverHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double extent;

  _FixedExtentSliverHeaderDelegate({
    required this.child,
    required this.extent,
  });

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => extent;

  @override
  double get minExtent => 0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
