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
    this.alignment,
  }) : super(key: key);

  final BorderRadiusGeometry? borderRadius;
  final double? width;
  final double? height;
  final Color? color;
  final Widget? child;
  final BoxShape shape;
  final EdgeInsetsGeometry padding;
  final AlignmentGeometry? alignment;

  @override
  Widget build(BuildContext context) {
    final box = Padding(
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
    if(alignment != null){
      return Align(
        alignment: alignment!,
        child: box,
      );
    }
    return box;
  }
}
