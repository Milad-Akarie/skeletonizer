import 'package:flutter/material.dart';

class SkeletonPageView extends StatefulWidget {
  const SkeletonPageView({
    Key? key,
    required this.child,
    this.scrollDirection = Axis.horizontal,
    this.itemCount = 5,
    this.padding,
    this.padEnds = true,
    this.viewportFraction = 1.0,
  }) : super(key: key);

  final Widget child;
  final Axis scrollDirection;
  final int itemCount;
  final EdgeInsetsGeometry? padding;
  final double viewportFraction;
  final bool padEnds;

  @override
  State<SkeletonPageView> createState() => _SkeletonPageViewState();
}

class _SkeletonPageViewState extends State<SkeletonPageView> {
  late final _pageController = PageController(viewportFraction: widget.viewportFraction);


  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      itemCount: widget.itemCount,
      controller: _pageController,
      padEnds: widget.padEnds,
      scrollDirection: widget.scrollDirection,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, _) => widget.child,
    );
  }
}
