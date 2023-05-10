import 'package:flutter/material.dart';

class BoxBone extends StatelessWidget {
  const BoxBone({
    Key? key,
    this.borderRadius,
    this.width,
    this.height,
    this.color,
    this.child,
    this.shape = BoxShape.rectangle,
    this.padding = EdgeInsets.zero,
  }) : super(key: key);

  final BorderRadius? borderRadius;
  final double? width;
  final double? height;
  final Color? color;
  final Widget? child;
  final BoxShape shape;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: SizedBox(
        width: width,
        height: height,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: color ?? Colors.grey.shade300,
            borderRadius: borderRadius,
            shape: shape,
          ),
          child: child,
        ),
      ),
    );
  }
}
